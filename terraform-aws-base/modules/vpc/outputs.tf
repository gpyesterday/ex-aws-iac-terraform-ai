VPC 모듈의 출력 값을 정의하는 `outputs.tf` 파일의 내용을 생성하겠습니다.

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = aws_subnet.this.*.id
}