all: infra ns openshift

infra:
	terraform apply -target=module.infra -auto-approve

ns: infra
	terraform apply -target=module.ns -auto-approve

openshift: ns
	terraform apply -target=module.openshift -auto-approve

osd:
	terraform destroy -target=module.openshift -auto-approve

destroy:
	terraform destroy -auto-approve
