# terraform-aws-base

이 디렉터리는 Terraform을 사용해 AWS 인프라를 선언적으로 구성하기 위한 기본 템플릿입니다. 주로 VPC를 생성하는 모듈을 포함하며, 확장과 환경별 커스터마이징이 용이하도록 구조화되어 있습니다.

## 요약 (간단 계약)
- 입력: `env/*.tfvars`에 정의된 환경 변수, AWS 크레덴셜 및 필요한 권한
- 출력: VPC ID, Subnet IDs 등 `outputs.tf`에 정의된 출력값
- 성공 기준: `terraform apply` 후 리소스가 AWS 콘솔에 정상 생성되고 `terraform output`으로 주요 값 확인

## 디렉터리 구조

```
terraform-aws-base/
├── modules/
│   └── vpc/                # VPC 모듈 (main.tf, variables.tf, outputs.tf)
├── env/
│   └── dev.tfvars          # 개발 환경 변수 파일(예시)
├── backend.tf              # 원격 상태(예: S3, DynamoDB) 설정
├── providers.tf            # AWS provider 설정
├── main.tf                 # 루트 모듈 구성
├── variables.tf            # 루트 수준 변수
├── outputs.tf              # 루트 수준 출력값
├── versions.tf             # Terraform 및 provider 버전 제약
└── README.md               # 이 문서
```

## 시작하기 (Prerequisites)

1. Terraform 설치 (권장: Terraform CLI 최신 안정 버전)
   - https://www.terraform.io/downloads
2. AWS 자격증명 설정
   - 로컬: `~/.aws/credentials` 또는 환경변수(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_PROFILE)
   - 또는 AWS SSO/EC2 역할 사용
3. (선택) 원격 상태를 사용하려면 `backend.tf`를 적절히 구성하고 S3 버킷/권한을 준비하세요.

## 빠른 사용법

1) 레포지토리(또는 폴더)로 이동

```bash
cd terraform-aws-base
```

2) 초기화

```bash
terraform init
```

3) (선택) 작업공간 사용

```bash
terraform workspace new dev || terraform workspace select dev
```

4) 변수 파일을 지정해 플랜 생성

```bash
terraform plan -var-file="env/dev.tfvars"
```

5) 적용

```bash
terraform apply -var-file="env/dev.tfvars"
```

6) 삭제

```bash
terraform destroy -var-file="env/dev.tfvars"
```

## 변수 및 환경
- 루트 레벨 변수는 `variables.tf`에, 환경별 값은 `env/dev.tfvars`처럼 파일로 분리합니다.
- 민감한 값(시크릿)은 버전관리에서 제외하고 환경 변수 또는 비밀 관리자(예: AWS Secrets Manager)를 사용하세요.

예: `env/dev.tfvars` (이미 존재)

### 주요 변수 (루트)

- `region` (string) — AWS 리전. 기본값: `us-east-1`
- `vpc_cidr` (string) — VPC CIDR 블록. 기본값: `10.0.0.0/16`
- `availability_zones` (list(string)) — 사용할 AZ 목록. 기본값: `["us-east-1a", "us-east-1b", "us-east-1c"]`

### VPC 모듈 변수(`modules/vpc/variables.tf`)

- `vpc_cidr` (string) — VPC CIDR 블록. 기본값: `10.0.0.0/16`
- `availability_zones` (list(string)) — AZ 목록. 기본값: `["us-east-1a", "us-east-1b", "us-east-1c"]`
- `vpc_name` (string) — VPC 이름. 기본값: `my-vpc`

### env/dev.tfvars 예시 및 주의사항

프로젝트에 포함된 `env/dev.tfvars` 파일은 환경별 값을 정의합니다. 현재 파일의 키는 대문자로 되어 있을 수 있는데, Terraform 변수 이름은 소문자(정의한 변수 이름)와 일치해야 합니다. 예를 들어 루트 변수명이 `vpc_cidr`이면 `dev.tfvars`에서도 `vpc_cidr = "10.0.0.0/16"`처럼 소문자 키를 사용해야 합니다.

권장 `env/dev.tfvars` 예시:

```hcl
region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_name = "dev-vpc"
```

파일을 적용할 때는 다음처럼 `-var-file` 옵션으로 지정하세요:

```bash
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"
```

필요하면 제가 리포지토리에 있는 `env/dev.tfvars` 파일을 소문자 키로 자동 교정해 드릴 수 있습니다. 원하시면 알려주세요.

## 모듈: VPC
- `modules/vpc`는 VPC, 서브넷, 라우팅 테이블 등 네트워크 리소스를 생성합니다.
- 커스터마이징 포인트는 `modules/vpc/variables.tf`에 주석으로 설명되어 있습니다.

## 검증 및 문제해결
- 구문/구성 검증:

```bash
terraform validate
```

- 실제 상태와 계획 비교:

```bash
terraform plan -var-file="env/dev.tfvars"
```

- 원격 상태 문제: `terraform init -reconfigure` 또는 `terraform state pull`로 상태 확인

## 보안 및 권한
- 최소 권한 원칙을 따르세요. 이 프로젝트는 VPC 및 네트워크 관련 권한(예: ec2:CreateVpc 등)을 필요로 합니다.
- AWS 크레덴셜은 절대 리포지토리에 커밋하지 마세요.

## 추가 개선 아이디어
- 모듈에 대한 더 많은 예시와 테스트(Terraform Compliance, Terratest)를 추가
- CI 파이프라인(예: GitHub Actions)에서 `terraform fmt`, `terraform validate`, `plan` 자동화

## 라이선스
MIT 라이선스

---

필요하면 이 README에 환경별(qa/prod) 사용 예시, 백엔드 S3/DynamoDB 설정 예제, 또는 GitHub Actions CI 예시를 추가해드리겠습니다.