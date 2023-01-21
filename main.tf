/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

locals {
  tags = {
    Terraform = "true"
  }
}

// KMS Key
resource "aws_kms_key" "tf_enc_key" {
  count = var.bootstrap

  description             = "Global Terraform state encryption key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(var.tags, local.tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_id" "kms" {
  count = var.bootstrap

  keepers = {
    key_id = aws_kms_key.tf_enc_key[count.index].key_id
    arn    = aws_kms_key.tf_enc_key[count.index].arn
  }

  byte_length = 8
}

// KMW Key alias
resource "aws_kms_alias" "tf_enc_key" {
  count = var.bootstrap

  name          = "alias/tf-state-${random_id.kms[count.index].dec}"
  target_key_id = random_id.kms[count.index].keepers.key_id
}

// S3 Bucket
resource "aws_s3_bucket" "terraform_state" {
  count = var.bootstrap

  bucket = var.bucket

  tags = merge(var.tags, local.tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_logging" "terraform_state" {
  for_each = var.bootstrap > 0 ? var.bucket_logging : {}

  bucket = aws_s3_bucket.terraform_state[0].id
  target_bucket = each.value.target_bucket
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  count = var.bootstrap

  bucket = aws_s3_bucket.terraform_state[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = random_id.kms[count.index].keepers.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  count = var.bootstrap

  bucket = aws_s3_bucket.terraform_state[count.index].id
  versioning_configuration {
    status = var.bucket_lifecycle_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_acl" "terraform_state" {
  count = var.bootstrap

  bucket = aws_s3_bucket.terraform_state[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  count = var.bootstrap
  bucket = aws_s3_bucket.terraform_state[count.index].id

  rule {
    id = "expired"
    status = var.bucket_lifecycle_enabled ? "Enabled" : "Disabled"
    noncurrent_version_expiration {
      noncurrent_days = var.bucket_lifecycle_expiration_days
    }
  }
}




// S3 Bucket Policy
data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid = "TerraformStateListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    principals {
      type = "AWS"

      identifiers = [var.operator_role_arn]
    }

    resources = [join("", aws_s3_bucket.terraform_state[*].arn)]
  }

  statement {
    sid = "TerraformStateManageObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    principals {
      type = "AWS"

      identifiers = [var.operator_role_arn]
    }

    resources = [
      "${join("", aws_s3_bucket.terraform_state[*].arn)}/${var.key}",
      "${join("", aws_s3_bucket.terraform_state[*].arn)}/env:/*/${var.key}",
    ]
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  count = var.bootstrap

  bucket = aws_s3_bucket.terraform_state[count.index].id
  policy = data.aws_iam_policy_document.terraform_state.json
}

// DynamoDB
resource "aws_dynamodb_table" "terraform_statelock" {
  count = var.bootstrap

  name           = var.dynamodb_table
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, local.tags)

  lifecycle {
    prevent_destroy = true
  }
}
