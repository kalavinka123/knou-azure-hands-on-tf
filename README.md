# knou-azure-hands-on-tf

## 시작하기 전에

1. prerequites.txt 내용 확인하기
- Terraform 인스톨
- AZ CLI 인스톨
- 구독 아이디 변수 설정
- (선택사항) postgresql 인스톨

2. variables.tf 값 설정하기.
- 암호 설정
- xxxx 로 되어있는 부분을 고유한 이름으로 바꾸기
- 그 외 값 설정

## 실행 방법
```
cd knou-azure-hands-on-tf/ 

### Terraform 프로젝트 초기화하기
terraform init

### 에러가 없음을 확인하기
terraform validate
terraform plan

### Azure 에 리소스 생성
terraform apply --auto-approve

### 리소스 삭제시
terraform destroy --auto-approve
```