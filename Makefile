ifeq ($(BINDPLANE_LICENSE),)
$(error BINDPLANE_LICENSE is not set in the environment)
endif

.PHONY: start
start:
	bash bindplane/start.sh

.PHONY: stop
stop:
	bash bindplane/stop.sh

.PHONY: delete
delete:
	bash bindplane/delete.sh

