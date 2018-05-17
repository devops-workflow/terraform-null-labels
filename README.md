[![CircleCI](https://circleci.com/gh/devops-workflow/terraform-null-labels.svg?style=svg)](https://circleci.com/gh/devops-workflow/terraform-null-labels)

# terraform-null-labels

Terraform module to provide consistent label names and tags for resources.

This is similar to [label](https://registry.terraform.io/modules/devops-workflow/label/local) except:
- This accepts a list of names, instead of a string. And returns lists.
- This uses null-resource instead of locals. This was required to be able to use count.

The goal is to keep [label](https://registry.terraform.io/modules/devops-workflow/label/local) and [labels](https://registry.terraform.io/modules/devops-workflow/labels/null) in sync and update both at the same time for any changes. Where this is possible.

A single name format will not solve every use case, so multiple variants are returned and there is a few options to affect how they get build. The general name convention is `{organization}-{environment}-{name}-{attributes}`. `Name` is required, the other 3 can be turned on/off individually. The delimiter (`-`) can be changed

All [devops-workflow](https://registry.terraform.io/modules/devops-workflow) modules will eventually use this or [label](https://registry.terraform.io/modules/devops-workflow/label/local).

**NOTE:** `null` refers to this using [null_resource](https://www.terraform.io/docs/configuration/locals.html)

Terraform registry: https://registry.terraform.io/modules/devops-workflow/labels/null

## Usage:

#### Basic Example

```hcl
module "names" {
  source        = "devops-workflow/labels/null"
  version       = "0.0.1"
  names         = ["name1", "name2"]
  environment   = "qa"
}
```
This will create 2 `id` with the values of `qa-name1` and `qa-name2`

#### S3 Example

```hcl
variable "names" {
  default = ["data1", "data2"]
}

module "s3-name" {
  source        = "devops-workflow/labels/null"
  version       = "0.0.1"
  names         = "${var.names}"
  environment   = "qa"
  organization  = "corp"
  namespace-org = "true"
}
```
This will create 2 `id` with the values of `corp-qa-data1` and `corp-qa-data2`

Now reference `labels` outputs to create the S3 buckets

```hcl
resource "aws_s3_bucket" "data" {
  count   = "${length(var.names)}"
  bucket  = "${element(module.s3-name.id, count.index)}"
}
```

#### All Variables Example
Using in a module and exposing all settings to upstream caller.

```hcl
module "labels" {
  source        = "devops-workflow/labels/null"
  version       = "0.0.1"
  organization  = "${var.organization}"
  names         = "${var.names}"
  namespace-env = "${var.namespace-env}"
  namespace-org = "${var.namespace-org}"
  environment   = "${var.environment}"
  delimiter     = "${var.delimiter}"
  attributes    = "${var.attributes}"
  tags          = "${var.tags}"
}
```
