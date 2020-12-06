
provider "aws" {
  access_key = ""
  secret_key = ""
  region     = var.aws_region
}
data "archive_file" "sample_function" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda.zip"
}

resource "aws_iam_role" "iam_role_lambda" {
  name = "iam_role_lambda"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": "sts:AssumeRole",
		"Principal": { 
            "Service": "lambda.amazonaws.com" 
        },
		"Effect": "Allow",
		"Sid": "" } ]
}
EOF
}

resource "aws_lambda_function" "greet_function" {
  filename      = "${data.archive_file.sample_function.output_path}"
  function_name = "CloudArchitecture"
  role          = "${aws_iam_role.iam_role_lambda.arn}"
  handler       = "greet_lambda.lambda_handler"
  runtime       = "python3.6"
  memory_size   = 128
  timeout       = 30
  environment {
    variables = {
      greeting = "Hello there!"
    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "CloudArchitecture"
  retention_in_days = 7
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.iam_role_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
