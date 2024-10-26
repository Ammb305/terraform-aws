resource "aws_instance" "TerraformEC2" {
  count = length(var.ec2_names)
  ami           = data.aws_ami.ubuntu_22_04.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg_id]
  subnet_id     = var.subnets[count.index]
  associate_public_ip_address = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y apache2 git

# Fetch instance metadata
export META_INST_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
export META_INST_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
export META_INST_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create index.html
cat <<EOL > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @import url('https://fonts.googleapis.com/css?family=Open+Sans&display=swap');
        html { position: relative; overflow-x: hidden !important; }
        * { box-sizing: border-box; }
        body { font-family: 'Open Sans', sans-serif; color: #324e63; }
        .wrapper { width: 100%; min-height: 90vh; padding: 50px 20px; display: flex; }
        .instance-card { width: 100%; min-height: 380px; margin: auto; box-shadow: 12px 12px 2px 1px rgba(13, 28, 39, 0.4); background: #fff; border-radius: 15px; border: thin groove #9c83ff; max-width: 500px; position: relative; }
        .instance-card__cnt { margin-top: 35px; text-align: center; padding: 0 20px; padding-bottom: 40px; transition: all .3s; }
        .instance-card__name { font-weight: 700; font-size: 24px; color: #6944ff; margin-bottom: 15px; }
        .instance-card-inf__item { padding: 10px 35px; min-width: 150px; }
        .instance-card-inf__title { font-weight: 700; font-size: 27px; color: #324e63; }
        .instance-card-inf__txt { font-weight: 500; margin-top: 7px; }
    </style>
    <title>Amazon EC2 Status</title>
</head>
<body>
    <div class="wrapper">
        <div class="instance-card">
            <div class="instance-card__cnt">
                <div class="instance-card__name">Your EC2 Instance is running!</div>
                <div class="instance-card-inf">
                    <div class="instance-card-inf__item">
                        <div class="instance-card-inf__txt">Instance Id</div>
                        <div class="instance-card-inf__title">$META_INST_ID</div>
                    </div>
                    <div class="instance-card-inf__item">
                        <div class="instance-card-inf__txt">Instance Type</div>
                        <div class="instance-card-inf__title">$META_INST_TYPE</div>
                    </div>
                    <div class="instance-card-inf__item">
                        <div class="instance-card-inf__txt">Availability zone</div>
                        <div class="instance-card-inf__title">$META_INST_AZ</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
EOL

# Start the Apache service
sudo systemctl start apache2
sudo systemctl enable apache2
EOF

  tags = {
    Name = var.ec2_names[count.index]
  }
}
