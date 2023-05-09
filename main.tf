/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

terraform {
  required_providers {
    cosign = {
      source = "chainguard-dev/cosign"
    }
    apko = {
      source = "chainguard-dev/apko"
    }
  }
}

variable "target_repository" {
  description = "The docker repo into which the image and attestations should be published."
}

provider "apko" {
  extra_repositories = ["https://packages.wolfi.dev/os"]
  extra_keyring      = ["https://packages.wolfi.dev/os/wolfi-signing.rsa.pub"]
  default_archs      = ["x86_64", "aarch64"]
  extra_packages     = ["wolfi-baselayout"]
}

module "image" {
  source  = "github.com/chainguard-dev/terraform-publisher-apko//"

  target_repository = var.target_repository
  config = file("${path.module}/apko.yaml")
}

# TODO(mattmoor): Tag the resulting image.

output "image_ref" {
  value = module.image.image_ref
}
