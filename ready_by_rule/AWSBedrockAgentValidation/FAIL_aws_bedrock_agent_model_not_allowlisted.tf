# Policy: AWSBedrockAgentValidation
# Resource type: aws_bedrockagent_agent
# Checked attribute path: foundation_model
# Expected by latest provider docs: FAIL because the agent uses a documented foundation model string that is outside the current governance allowlist.

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "fail_bedrock_agent_model" {
  name = "bedrock-agent-fail-model-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "bedrock.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_bedrockagent_agent" "fail_bedrock_agent_model" {
  agent_name              = "fail-bedrock-agent-model"
  agent_resource_role_arn = aws_iam_role.fail_bedrock_agent_model.arn
  foundation_model        = "anthropic.claude-v2" # FIX: provider example model remains doc-aligned and does not match the current governance allowlist prefixes
  instruction             = "This Bedrock agent uses a documented foundation model identifier that is not present in the current governance allowlist."
}
