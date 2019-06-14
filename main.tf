terraform {
  required_version = ">= 0.12"
}

data "null_data_source" "tag_list" {
  count = length(local.keys)
  
  inputs = {
    key                 = local.keys[count.index]
    value               = local.values[count.index]
    propagate_at_launch = var.propagate_at_launch
  }
}
