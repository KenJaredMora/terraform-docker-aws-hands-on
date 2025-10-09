# Usage:
#   DOCKERHUB_USERNAME=xxx DOCKERHUB_TOKEN=yyy make docker-login
#   make docker-build IMAGE=kenyon/nginx-hands-on:latest
#   make docker-push  IMAGE=kenyon/nginx-hands-on:latest

IMAGE ?= $(shell echo $$IMAGE)

docker-login:
	@echo "$$DOCKERHUB_TOKEN" | docker login -u "$$DOCKERHUB_USERNAME" --password-stdin

docker-build:
	@if [ -z "$(IMAGE)" ]; then echo "set IMAGE=repo:tag"; exit 1; fi
	docker build -t $(IMAGE) ./docker

docker-push:
	@if [ -z "$(IMAGE)" ]; then echo "set IMAGE=repo:tag"; exit 1; fi
	docker push $(IMAGE)

tf-init:
	terraform init

tf-plan:
	terraform plan -out tfplan

tf-apply:
	terraform apply -auto-approve tfplan

tf-destroy:
	terraform destroy -auto-approve
