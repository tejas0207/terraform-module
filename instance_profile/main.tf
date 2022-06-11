resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "${var.role_name}-policy"
  description = " A S3 readonly policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
    name       = "${var.role_name}-attachment"
    roles      = [aws_iam_role.role.name]
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.role.name
}