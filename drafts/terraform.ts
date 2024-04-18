provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "ppht-terraform-remote-state-955831509488"
    key            = "ecs/content-sync/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock"
  }
}

data "aws_caller_identity" "current_account" {}

data "sops_file" "sops" {
  source_file = "${path.cwd}/secrets.sops.json"
}

data "aws_region" "this" {}

module "content_sync" {
  source         = "../module"
  environment    = "development"
  app_name       = "content-sync"
  app_name_short = "cs"

  secrets_manager_values = {
    for k, v in data.sops_file.sops.data : upper(k) => v
  }

  container_image     = "outcomehealth-oh-docker-local.jfrog.io/cs:672fa51"
  remote_state_bucket = "ppht-terraform-remote-state-${data.aws_caller_identity.current_account.account_id}"

  user_data_config = {
    default = {
      environment = "development"
      app_name    = "content-sync"
      swap_size   = 0
    }
    docker = {
      docker_disk = "/dev/xvdcz"
    }
    td_agent = {
      s3_bucket = "ppht-config-${data.aws_caller_identity.current_account.account_id}"
      s3_path   = "cs/td-agent.conf"
    }
  }

  filebeat_config_url = "s3://ppht-config-${data.aws_caller_identity.current_account.account_id}/cs/filebeat.yml"
  filebeat_environment = {
    ENVIRONMENT  = "development",
    LOGSTASH_URL = "logstash-development.shared.company.io:5044",
  }
}