# Netic AWS Terraform S3/DynamoDB Backend

## Supported Terraform Versions

Terraform 0.12

## Usage

```hcl
module "tf_s3_backend" {
  source = "github.com/neticdk/tf-aws-s3-backend"

  bootstrap         = 1
  operator_role_arn = "arn:aws:iam::123456789012:role/operator-role"
  bucket            = "my-terraform-backend-bucket"
  dynamodb_table    = "my-terraform-dynamodb-lock-table"
  key               = "terraform.tfstate"
}
```

<!---BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK--->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bootstrap | Whether to initialize the backend or not | string | `"0"` | no |
| bucket | Name of S3 bucket | string | n/a | yes |
| bucket\_lifecycle\_enabled | Enable/disable bucket lifecycle | string | `"true"` | no |
| bucket\_lifecycle\_expiration\_days | Days to keep noncurrent versions before expiration | string | `"90"` | no |
| bucket\_versioning\_enabled | Enable/disable bucket versioning | string | `"true"` | no |
| dynamodb\_table | Name of DynamoDB table | string | n/a | yes |
| key | Name of S3 key | string | n/a | yes |
| operator\_role\_arn | ARN of role to use for running terraform | string | n/a | yes |
| tags | A map of tags to add to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| operator\_role\_arn |  |

<!---END OF PRE-COMMIT-TERRAFORM DOCS HOOK--->

# Copyright
Copyright (c) 2019 Netic A/S. All rights reserved.

# License
MIT Licened. See LICENSE for full details.

