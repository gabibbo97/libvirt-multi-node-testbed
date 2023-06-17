TF_APPLY_ARGS :=
ifdef SINGLE_NODE
	TF_APPLY_ARGS += -var 'nodes=["node1"]'
else ifdef DUAL_NODE
	TF_APPLY_ARGS += -var 'nodes=["node1","node2"]'
else ifdef TRI_NODE
	TF_APPLY_ARGS += -var 'nodes=["node1","node2","node3"]'
else ifdef PENTA_NODE
	TF_APPLY_ARGS += -var 'nodes=["node1","node2","node3","node4","node5"]'
endif

.PHONY: up
up: init
# Enable KSM
	echo 1 | sudo tee /sys/kernel/mm/ksm/run > /dev/null
# Apply
	terraform apply -auto-approve $(TF_APPLY_ARGS)

.PHONY: down
down:
	terraform destroy -auto-approve

.PHONY: init
init:
	terraform init -upgrade

.PHONY: plan
plan: init
	terraform plan

.PHONY: restart
restart:
	terraform apply -auto-approve -var nodes='[]'
	$(MAKE) up
