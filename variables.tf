/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "bootstrap" {
  description = "Whether to initialize the backend or not"
  default     = 0
}

variable "operator_role_arn" {
  description = "ARN of role to use for running terraform"
}

variable "bucket" {
  description = "Name of S3 bucket"
}

variable "key" {
  description = "Name of S3 key"
}

variable "bucket_versioning_enabled" {
  description = "Enable/disable bucket versioning"
  default     = true
}

variable "bucket_lifecycle_enabled" {
  description = "Enable/disable bucket lifecycle"
  default     = true
}

variable "bucket_lifecycle_expiration_days" {
  description = "Days to keep noncurrent versions before expiration"
  default     = 90
}

variable "bucket_logging" {
  description = "Target bucket to use for logging"
  type        = list(map)
  default     = []
}

variable "dynamodb_table" {
  description = "Name of DynamoDB table"
}
