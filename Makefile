.PHONY: up
up: init
	echo 1 | sudo tee /sys/kernel/mm/ksm/run > /dev/null
	terraform apply -auto-approve

.PHONY: down
down:
	terraform destroy -auto-approve

.PHONY: init
init:
	terraform init 

.PHONY: restart
restart:
	terraform apply -auto-approve -var nodes='[]'
	$(MAKE) up
