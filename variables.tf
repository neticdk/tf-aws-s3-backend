/*
 * Copyright (c) 2019 Netic A/S. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map
  default     = {}
}

variable "bootstrap" {
  description = "Whether to initialize the backend or not"
  type        = number
  default     = 0
}

variable "operator_role_arn" {
  description = "ARN of role to use for running terraform"
  type        = string
}

variable "bucket" {
  description = "Name of S3 bucket"
  type        = string
}

variable "key" {
  description = "Name of S3 key"
  type        = string
}

variable "bucket_lifecycle_enabled" {
  description = "Enable/disable bucket lifecycle"
  type        = bool
  default     = true
}

variable "bucket_lifecycle_expiration_days" {
  description = "Days to keep noncurrent versions before expiration"
  type        = number
  default     = 90
}

variable "bucket_logging" {
  description = "Target bucket to use for logging"
  type        = list(map(any))
  default     = []
}

variable "dynamodb_table" {
  description = "Name of DynamoDB table"
  type        = string
}
