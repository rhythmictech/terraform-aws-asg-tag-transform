# terraform-asg-tag-transform
Data-only module that transforms a tag map as used by most AWS resources into a list of tags as required by `aws_autoscaling_group`

## Example Usage
### Propagate All:
```terraform
locals {
  tags = {
    owner = "Jane Doe"
    key2  = "value2"
  }
}

resource "aws_launch_configuration" "example" {
  name_prefix          = "example-"
  image_id             = "ami-xxxxxxxx"
  instance_type        = "t3.micro"
}

module "example_asg_tags" {
  source  = "github.com/rhythmictech/terraform-asg-tag-transform?ref=0.1.0"
  tag_map = merge(
    "${local.tags}",
    {
      Name = "example-asg"
    }
  )
}

resource "aws_autoscaling_group" "example" {
  name_prefix          = "example-"
  max_size             = 1
  min_size             = 1
  launch_configuration = "${aws_launch_configuration.example.name}"
  tags                 = "${module.example_asg_tags.tag_list}"
}
```

### Mixed Propagation:
```terraform
locals {
  tags = {
    owner = "Jane Doe"
    key2  = "value2"
  }
}

resource "aws_launch_configuration" "example" {
  name_prefix          = "example-"
  image_id             = "ami-xxxxxxxx"
  instance_type        = "t3.micro"
}

module "example_asg_tags_propagated" {
  source  = "github.com/rhythmictech/terraform-asg-tag-transform?ref=0.1.0"
  tag_map = "${local.tags}"
}

module "example_asg_tags_not_propagated" {
  source  = "github.com/rhythmictech/terraform-asg-tag-transform?ref=0.1.0"
  propagate_at_launch = false
  tag_map = {
    Name = "example-asg"
  }
}

resource "aws_autoscaling_group" "example" {
  name_prefix          = "example-"
  max_size             = 1
  min_size             = 1
  launch_configuration = "${aws_launch_configuration.example.name}"
  
  tags = concat(
    "${module.example_asg_tags_propagated.tag_list}",
    "${module.example_asg_tags_not_propagated.tag_list}"
  )
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| tag\_map | Map of tags in format used by most AWS resources (`{key = "value"}`) | map(string) | none | yes |
| propagate\_at\_launch | Whether ASG tags should propagate to instances | bool | `true` | no |

## Outputs
| Name | Description |
|------|-------------|
| tag\_list | List of tag maps in format required by `aws_autoscaling_group` |
