# Policy: CloudServiceControlPolicy
# Resource type: all
# Checked attribute path: node_name substring matching
# Expected: FAIL because the resource type includes the blocked service substring kms.
# FIX: Added FAIL coverage for the cloud service control policy.

provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "blocked_kms_service" {
  description = "KMS key used to trigger the blocked-service policy branch"
}
