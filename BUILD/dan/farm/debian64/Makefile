PORT = 2226
DIR = $(shell pwd)
MACHINE = $(notdir $(DIR))

all: disk $(MACHINE) settings
disk:
	VBoxManage createvdi -filename $(DIR)/disk -size 5120
$(MACHINE):
	VBoxManage createvm -name $(MACHINE) -settingsfile $(DIR)/machine.xml
always:
settings: always
	VBoxManage registervm $(DIR)/machine.xml
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/Protocol  TCP
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/GuestPort 22
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/HostPort  $(PORT)
clean:; rm -rf disk machine.xml
