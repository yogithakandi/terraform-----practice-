provider "aws" {
  
}




###Event Bridge

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda logging policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name   = "my_lambda_function_eventbridge"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.12"
  timeout         = 900
  memory_size     = 128

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}
# EventBridge Rule (CloudWatch Event Rule)
resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "lambda_event_rule"
  description         = "Triggers Lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.my_lambda.arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
}

#cloudwatch log

resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "lambda_cloudwatch_logs_policy"
  description = "Additional CloudWatch log permissions for Lambda"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}
###attach iam role 

resource "aws_iam_role_policy_attachment" "attach_lambda_cloudwatch" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
}


