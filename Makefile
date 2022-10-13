TF_APPLY_ARGS :=
ifeq ($(SINGLE_NODE),y)
	TF_APPLY_ARGS += -var 'nodes=["node1"]'
endif

.PHONY: up
up: init
	echo 1 | sudo tee /sys/kernel/mm/ksm/run > /dev/null
	terraform apply -auto-approve $(TF_APPLY_ARGS)

.PHONY: down
down:
	terraform destroy -auto-approve

.PHONY: init
init:
	terraform init -upgrade

.PHONY: restart
restart:
	terraform apply -auto-approve -var nodes='[]'
	$(MAKE) up
