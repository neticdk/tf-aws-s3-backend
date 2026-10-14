# Netic AWS Terraform S3/DynamoDB Backend

## Supported Terraform Versions

Terraform >= 1.15, AWS provider ~> 6.0

## Usage

```hcl
module "tf_s3_backend" {
  source = "github.com/neticdk/tf-aws-s3-backend?ref=v2.0.0"

  bootstrap         = 1
  operator_role_arn = "arn:aws:iam::123456789012:role/operator-role"
  bucket            = "my-terraform-backend-bucket"
  key               = "terraform.tfstate"
}
```

## State Locking

Terraform >= 1.10 supports S3 native state locking, and DynamoDB based locking
is deprecated. The bucket policy grants the operator role access to the
`<key>.tflock` lock file, so configure the backend with `use_lockfile`:

```hcl
terraform {
  backend "s3" {
    bucket       = "my-terraform-backend-bucket"
    key          = "terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

To keep using (or migrate away from) DynamoDB locking, set `dynamodb_table`
and the lock table is created as before.

<!---BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK--->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bootstrap | Whether to initialize the backend or not | `number` | `0` | no |
| bucket | Name of S3 bucket | `string` | n/a | yes |
| bucket\_lifecycle\_enabled | Enable/disable bucket lifecycle | `bool` | `true` | no |
| bucket\_lifecycle\_expiration\_days | Days to keep noncurrent versions before expiration | `number` | `90` | no |
| bucket\_logging | Target bucket to use for logging | `list(map(any))` | `[]` | no |
| dynamodb\_table | Name of DynamoDB table used for state locking. Set to null to rely on S3 native locking (use\_lockfile) only | `string` | `null` | no |
| key | Name of S3 key | `string` | n/a | yes |
| operator\_role\_arn | ARN of role to use for running terraform | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| operator\_role\_arn | n/a |

<!---END OF PRE-COMMIT-TERRAFORM DOCS HOOK--->

# Copyright
Copyright (c) 2019 Netic A/S. All rights reserved.

# License
MIT Licened. See LICENSE for full details.

