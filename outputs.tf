output "tag_list" {
  description = "List of tag maps in format required by aws_autoscaling_group"
  value       = "${data.null_data_source.tag_list.*.outputs}"
}
