PORT = 2226
DIR = $(shell pwd)
MACHINE = $(notdir $(DIR))
ISO = debian-40r7-amd64-businesscard.iso

all: $(ISO) disk $(MACHINE) settings 
start:; VBoxManage startvm $(MACHINE)
$(ISO):
	wget http://cdimage.debian.org/debian-cd/4.0_r7/amd64/iso-cd/$(ISO)
disk:
	VBoxManage createvdi -filename $(DIR)/disk -size 5120
$(MACHINE):
	VBoxManage createvm -name $(MACHINE) -settingsfile $(DIR)/machine.xml
	VBoxManage modifyvm debian64 -hda $(DIR)/disk
	VBoxManage registervm $(DIR)/machine.xml
always:
settings: always
	VBoxManage modifyvm debian64 \
		-boot1 dvd \
		-boot2 disk \
		-hwvirtex on \
		-memory 1024 \
		-dvd $(DIR)/$(ISO)
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/Protocol  TCP
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/GuestPort 22
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/HostPort  $(PORT)
clean:; rm -rf disk machine.xml
show:; VBoxManage showvminfo debian64
