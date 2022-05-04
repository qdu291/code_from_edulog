provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "aws" {
  alias   = "karrostech_usw1"
  profile = "${var.karrosprofile}"
  #profile = "${var.profile_karrostech}"
  region = "us-west-1"
}
provider "aws" {
  alias   = "karrostech_usw2"
  profile = "${var.karrosprofile}"
  #profile = "${var.profile_karrostech}"
  region = "us-west-2"
}

provider "aws" {
  alias   = "karrostech_use2"
  profile = "${var.karrosprofile}"
  #profile = "${var.profile_karrostech}"
  region = "us-east-2"
}

provider "aws" {
  alias   = "karrostech_southeast1"
  profile = "${var.karrosprofile}"
  #profile = "${var.profile_karrostech}"
  region = "ap-southeast-1"
}