resource "aws_instance" "dev_server" {
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t2.micro"

  tags = {
    Name = "dev-server"
  }
}

resource "aws_security_group" "dev_server" {
  name        = "dev-server"
  description = "Allow incoming traffic for dev-server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }
}

resource "aws_ebs_volume" "dev_server" {
  availability_zone = "${aws_instance.dev_server.availability_zone}"
  size              = 8
}

resource "aws_volume_attachment" "dev_server" {
  device_name = "/dev/sdf"
  volume_id   = "${aws_ebs_volume.dev_server.id}"
  instance_id = "${aws_instance.dev_server.id}"
}

resource "aws_iam_instance_profile" "dev_server" {
  name = "dev_server_profile"
  role = aws_iam_role.dev_server.name
}

resource "aws_iam_role" "dev_server" {
  name = "dev_server_role"
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

resource "aws_iam_role_policy" "dev_server" {
  name = "dev_server_policy"
  role = aws_iam_role.dev_server.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dev_server" {
  role = aws_iam_role.dev_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "dev_server_ec2" {
  role = aws_iam_role.dev_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}