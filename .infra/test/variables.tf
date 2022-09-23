variable "project_tag_name" {
  description = "The name of the project"
  type        = string
  default     = "iac-learning-track-level-1"
}

variable "availability_zone" {
  description = "The AWS availability zone to provision resources"
  type        = string
  default     = "us-east-1a"
}