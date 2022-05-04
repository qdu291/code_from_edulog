variable "name" {
  type = string
}

variable "assume_role_policy" {
  type = any
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "inline_policy" {
  type = list(object({
    name   = string
    policy = any
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}