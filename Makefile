IMAGE ?= debian-12

ifneq ($(IMAGE),)
TF_IMAGE_ARGS := -var image_name='$(IMAGE)' -var image_url=''
endif

TF_ARGS += $(TF_IMAGE_ARGS)
ifdef SINGLE_NODE
	TF_ARGS += -var 'nodes=["node1"]'
else ifdef DUAL_NODE
	TF_ARGS += -var 'nodes=["node1","node2"]'
else ifdef TRI_NODE
	TF_ARGS += -var 'nodes=["node1","node2","node3"]'
else ifdef PENTA_NODE
	TF_ARGS += -var 'nodes=["node1","node2","node3","node4","node5"]'
endif
TF_ARGS += $(TF_EXTRA_ARGS)

.PHONY: up
up: init
	terraform apply -auto-approve $(TF_ARGS)

.PHONY: down
down:
	terraform destroy -auto-approve

.PHONY: init
init:
# Enable KSM
	echo 1 | sudo tee /sys/kernel/mm/ksm/run
# Init terraform
	terraform init -upgrade

.PHONY: plan
plan: init
	terraform plan $(TF_ARGS)

.PHONY: restart
restart:
	terraform apply -auto-approve -var nodes='[]' $(TF_IMAGE_ARGS)
	$(MAKE) up

.PHONY: ssh-%
ssh-%:
	$(eval NODE_NAME := $(subst ssh-,,$@))
	@sh outputs/ssh_script.sh $(NODE_NAME)
