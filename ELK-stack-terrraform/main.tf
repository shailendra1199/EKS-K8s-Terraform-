
# data "template_file" "userdata" {
#   template = file("./userdata.yaml")
# }

resource "aws_key_pair" "webkeypair" {
  key_name   = #key-name
  public_key = #key

}


data "aws_vpc" "main" {
  id = #vpcid
}
#creating security-group 

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "webserver security group"
  vpc_id      = data.aws_vpc.main.id

  #inbound traffic via localhostip and allowing http and ssh 
  ingress = [
    {
      description      = "http inbound"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = [#publcip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false


    },

    {
      description      = "elasticsearch port"
      from_port        = 9200
      to_port          = 9200
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false

    },

    {
      description      = "kibana port"
      from_port        = 5601
      to_port          = 5601
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false


    },

    {
      description      = "logstash port"
      from_port        = 5043
      to_port          = 5044
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false

    },

    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [#publicip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false

    }
  ]
  #outbound traffic allow all
  egress = [

    { description      = "outgoing traffic "
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false

    }

  ]
}

#creating AWS-INSTANCE With attach security group 

resource "aws_instance" "web01" {
  ami                    = "ami-09d56f8956ab235b3"
  instance_type          = "m4.large"
  key_name               = aws_key_pair.webkeypair.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  #   user_data              = data.template_file.userdata.rendered
  #   using local-exec provisoner 

  # provisioner "local-exec" {
  #   command = "echo ${self.private_ip} >> private_ips.txt"
  # }
  #   connection {
  #       type        = "ssh"
  #       user        = "ec2-user"
  #       host        = "${self.public_ip}"
  #       private_key = "${file("/Users/shailendrasinghgaur/.ssh/id_rsa")}"

  #   }
  # provisioner "remote-exec" {
  #       inline = [
  #           "echo ${self.private_ip} >> /home/ec2-user/private_ips.txt"
  #   ]
  # }
  #/Users/shailendrasinghgaur/Helm-charK8s/terraform-provider-aws/examples/eks-getting-started/elk-terraform
  #source KIBANA file 
  provisioner "file" {
    source      = #sourcepath
    destination = "/tmp/kibana.yaml"

  }
  provisioner "file" {
    source      =  #sourcepath
    destination = "/tmp/apache.conf"

  }
  provisioner "file" {
    source      =  #sourcepath
    destination = "/tmp/installelk.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installelk.sh",
      "sudo /tmp/installelk.sh"


    ]
}
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(#private-keypath)

    }


}

#output publicip of webserver
output "publicip" {
  value = aws_instance.web01.public_ip

}





