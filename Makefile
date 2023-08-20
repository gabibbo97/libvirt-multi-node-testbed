IMAGE_NAME ?= debian-12

TF_IMAGE_ARGS ?= -var image_name='$(IMAGE_NAME)' -var image_url=''

TF_ARGS += $(TF_IMAGE_ARGS)
TF_ARGS += $(TF_EXTRA_ARGS)

ifndef NO_UEFI
# Check where the OVMF image is
OVMF_PATH := $(shell \
	if [ -f /usr/share/OVMF/OVMF_CODE.fd ]; then \
		echo /usr/share/OVMF/OVMF_CODE.fd; \
	fi \
)
ifneq ($(OVMF_PATH),)
TF_ARGS += -var uefi_firmware='$(OVMF_PATH)'
endif
endif

ifdef SINGLE_NODE
	TF_NODES_ARGS := -var 'nodes=["node1"]'
else ifdef DUAL_NODE
	TF_NODES_ARGS := -var 'nodes=["node1","node2"]'
else ifdef TRI_NODE
	TF_NODES_ARGS := -var 'nodes=["node1","node2","node3"]'
else ifdef PENTA_NODE
	TF_NODES_ARGS := -var 'nodes=["node1","node2","node3","node4","node5"]'
endif

.PHONY: up
up: init
	terraform apply -auto-approve $(TF_NODES_ARGS) $(TF_ARGS)

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
	terraform plan $(TF_NODES_ARGS) $(TF_ARGS)

.PHONY: restart
restart:
	terraform apply -auto-approve -var nodes='[]' $(TF_ARGS)
	$(MAKE) up

.PHONY: ssh-%
ssh-%:
	$(eval NODE_NAME := $(subst ssh-,,$@))
	@sh outputs/ssh_script.sh $(NODE_NAME)
