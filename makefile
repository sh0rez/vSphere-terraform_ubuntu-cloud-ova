all: infra ns

infra:
	terraform apply -target=module.infra -auto-approve

ns: infra
	terraform apply -target=module.ns -auto-approve

destroy:
	terraform destroy -auto-approve
