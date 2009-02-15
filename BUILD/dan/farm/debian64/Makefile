# debian 64:
# apt-get install openssh-server

PORT = 2226
DIR = $(shell pwd)
MACHINE = $(notdir $(DIR))
ISO = debian-40r7-amd64-businesscard.iso

all: $(ISO) disk $(MACHINE) settings 
start:; VBoxManage -nologo startvm $(MACHINE) -type vrdp
poweroff:; VBoxManage controlvm $(MACHINE) poweroff
$(ISO):
	wget http://cdimage.debian.org/debian-cd/4.0_r7/amd64/iso-cd/$(ISO)
disk:
	VBoxManage createhd -filename $(DIR)/disk -size 5120 -register
$(MACHINE):
	rm -f machine.xml
	VBoxManage createvm -name $(MACHINE) -settingsfile $(DIR)/machine.xml
	VBoxManage registervm $(DIR)/machine.xml
	VBoxManage modifyvm debian64 -hda $(DIR)/disk
always:
mount-cd:; VBoxManage modifyvm debian64 -dvd $(DIR)/$(ISO)
umount-cd:; VBoxManage modifyvm debian64 -dvd none
settings: always
	VBoxManage modifyvm debian64 \
		-boot1 dvd \
		-boot2 disk \
		-hwvirtex on \
		-ioapic on \
		-vrdp on \
		-vrdpport 3390 \
		-vrdpauthtype null \
		-memory 1024 \
		-nic1 nat \
		-dvd $(DIR)/$(ISO)
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/Protocol  TCP
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/GuestPort 22
	VBoxManage setextradata $(MACHINE) VBoxInternal/Devices/pcnet/0/LUN#0/Config/guestssh/HostPort  $(PORT)
clean:; rm -rf machine.xml
veryclean:; rm -rf disk
show:; VBoxManage showvminfo debian64
state:; VBoxManage showvminfo debian64 |grep State:
