variable "tag_map" {
  description = "Map of tags in format used by most AWS resources"
  type = map(string)
}

variable "propagate_at_launch" {
  description = "Whether ASG tags should propagate to instances"
  type = bool
  default = true
}

locals {
  # list of tag keys
  keys   = keys(var.tag_map)
  # list of tag values
  values = values(var.tag_map)
}
