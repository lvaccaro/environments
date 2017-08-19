# Bitcoin Core wallet on Raspberry Pi

Tutorial to install and manage bitcoin with Bitcoin Core wallet on Raspberry Pi 2.

The main focus is run and manage a secure wallet with some backup procedures. 
The first choice is based on which kind of bitcoin node run:
- Full-node: store locally the bitcoin blockchain.
- Prune-node: use a small amount of memory without store the entire blockchain.

This chooice has a big impact on wallet management:
- Full-node: enable me to import new wallet and rescan the local blockchain.
- Prune-node: I need to resync the blockchain. I show some technics that could help to save space and time.

Raspberry Pi 2 hardware has limited computational/memory resources and I use a cheap 16Gb SD card for this project.
So I don't need a full-node to only manage my wallet. Moreover I don't want to wait the entire block validation process from genesis block.

In this tutorial I describe each steps that I follow to run a bitcoin Prune-node, from an empty SDcard to an ready-to-work bitcoin wallet, and some best-practices.

External resourses:
- A really cool full-node guide to install a Full-node on Raspberry is available at http://raspnode.com/diyBitcoin.html : . Raspnode guide explains how to install and setup a full-node peer with an external usb memory stick to store the blockchain.
- A nice tutorial to run a Bitcoin Prune-node on Raspberry 3 without wallet and gui: https://www.reddit.com/r/Bitcoin/comments/5yubg0/run_a_014_fullnode_on_raspberrypi3_prunedless/
- A usefull guide to Set up Full Bitcoin Node on Raspberry Pi 3 with Ease, at https://freedomnode.com/blog/51/how-to-set-up-full-bitcoin-node-on-raspberry-pi-3-with-ease#h-start-the-node-automatically
- Some extra open discussion about "Pruned wallet" are available at: 
- https://github.com/bitcoin/bitcoin/issues/8497
- https://github.com/bitcoin/bitcoin/issues/9409

### Download RASPBIAN
1. Download the latest "RASPBIAN STRETCH LITE" version, link : https://www.raspberrypi.org/downloads/raspbian/
2. check the SHA-256 code on the website with the downloaded package 
```
$ shasum -a 256 2017-08-16-raspbian-stretch-lite.zip 
```

### Install on the SD card
1. Verify Disk (before unmounting) will display the BSD name as /dev/disk2s1.
```
$ df
/dev/disk2s1     31099904      4736  31095168     1%       0          0  100%   /Volumes/NO NAME
```
2. unmount the disk: 
```
$ diskutil unmount "/Volumes/NO NAME"
```
3. install image
```
$ unzip 2017-08-16-raspbian-stretch-lite.zip
$ sudo dd bs=1m if=2017-08-16-raspbian-stretch-lite.img of=/dev/rdisk2 conv=sync
```
Where rdiskn: is the disk number of your SD Card. ‘Verify Disk' (before unmounting) will display the BSD name as /dev/disk1s2.

4. umount the disk:
```
$ diskutil unmount "/Volumes/boot"
```



### Start Raspberry
Plug the SDcard on your Raspberry and turn on. After the boot, I can configure the basic system.
1. default user/password: pi/raspberry
2. change user/password
3. update the system:
``` 
$ apt-get update
$ apt-get dist-upgrade
``` 
4. config the system: 
``` 
$ sudo raspi-config
``` 

### Work remotely in the same net
Raspberry default configuration has SSH service disable. So to enable and work successfully from remote workstation, we need to setup the system.
1. enable ssh:
``` 
$ sudo raspi-config -> 5 Interfacing Options -> P2 SSH -> Enable
Reboot automatically at the exit of the program.
``` 
2. suggest to use Mosh (https://mosh.org) a remote terminal application that allows roaming, supports intermittent connectivity, and provides intelligent local echo and line editing of user keystrokes.
``` 
$ sudo apt-get install mosh
``` 
3. find raspberry ip in your local-net: (there are many methods)
``` 
$ sudo nmap -O 192.168.1.0/24
``` 

### Download Bitcoin:
Download from github and choose the latest release version (suggest the latest stable version)
``` 
$ git clone https://github.com/bitcoin/bitcoin.git
$ cd ./bitcoin
$ git tag -l
$ git checkout tags/<tag_name>
``` 

### Install Bitcoin pre-requisites
Before install bitcoin we have to satisfy the requirements. We need the wallet-compatibility in order to create and manage addresses.
The official installation guide is available at : https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
1. install essential tools
``` 
$ sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
``` 
2. install only needed libboost packages
``` 
$ sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
``` 
3. install miniupnpc may be used for UPnP port mapping
``` 
$ sudo apt-get install libminiupnpc-dev
``` 
4. download and compile Berkley DB 4.8
``` 
$ wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
$ tar -xzvf db-4.8.30.NC.tar.gz
$ cd db-4.8.30.NC/build_unix/
$ ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/opt/db4/
$ make
$ sudo make install
``` 



### Install Bitcoin:
The official installation guide is available at : https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
```
$ ./autogen.sh
$ ./configure CPPFLAGS="-I/opt/db4/include -O2" LDFLAGS="-L/opt/db4/lib"
$ make
$ sudo make install
```

### Run Bitcoin:
The default bitcoin configuration run a full-node with listen option enabled by default.
So my configuration is a "Pruned node" with some strict resources, the following options: 
- Blind the node to don't receive connection from outside
```
-listen=0
```
- Change the amount of local memory in Mb used for validation process. Increase cache equals more validation speed. Decrease cache is needed for strict resources device.
```
-dbcache=100
```
- Prune node: specify the amount of memory in Mb used to store the blockchain (>550Mb)
```
-prune=2000
```
- not check signatures up to the given block
```
-assumevalid=<block>
```
- the start command
```
$ bitcoind -listen=0 -dbcache=100 -prune=2000 -printtoconsole
```


### Create wallet and deposit bitcoin

### Export your wallet file

### Restoring your wallet file

### Bitcoin Backup
This is the most critical one. A good tutorial of all best practices is available at : https://en.bitcoin.it/wiki/Backingup_your_wallet.
The script in "Automated backups using Cron, Bash and GNU/Linux" section allow to backup, gpg encrypting, and store remotely.
1. To start automatically the backup ( for example each day ), put this script on cron:
```
$ cd /usr/local/bin/ && chown root:root backupwallet.sh && chmod 755 backupwallet.sh
$ sudo vim /etc/crontab
...
00 0    * * *   root    /usr/local/bin/backupwallet.sh
```
2. I also use Git for my encrypted wallet.dat file and store remotely on github/bitbucket.
3. Other solution to increase security/backups:
	- Cold wallets: Paper Wallets and Offline USB Sticks
	- Hardware wallets: Ledger / Trezor
	- Multisignature wallets
	- ....
  
 
 
### Raspberry Diagnostic
My current raspberry version 2 has only 1Gb RAM and I have to monitor the RAM usage in order to avoid RAM saturation.
Moreover, network monitor allows me to keep track of data traffic used to synchronise the blockchain.
1. monitor process and resources with htop
2. monitor network (current and daily traffic) with vnstat
3. monitor temperatures/ram/disk with the follow script:
```
#!/bin/bash
# -------------------------------------------------------
cpu=$(</sys/class/thermal/thermal_zone0/temp)
echo "$(date) @ $(hostname)"
echo "-------------------------------------------"
echo "GPU => $(/opt/vc/bin/vcgencmd measure_temp)"
echo "CPU => $((cpu/1000))'C"
clock=$(cut -d "=" -f 2 <<< `/opt/vc/bin/vcgencmd measure_clock arm`)
echo "CLOCK => $((clock/1000000))Mhz"
volt=$(cut -d "=" -f 2 <<< `/opt/vc/bin/vcgencmd measure_volts core`)
echo "VOLT  => $volt"
echo "MEMORY =>"
echo "$(free -t -m -h)"
echo "DISK =>"
echo "$(df -h | head -n 2)"
echo "VNSTAT =>"
echo "$(vnstat)"
```


### Access your Raspberry Pi Globally Using Tor
At 3 point, I have enabled the SSH service, but I can establish a SSH connection only for clients of the same network.
Onion Router allows me to access my raspberry remotely from anywhere.
Indeed, I don't need to discover manually the IP of my raspberry, with Onion domain I connect to the provided hostname also in the same network.
The procedure is explain at: https://www.khalidalnajjar.com/access-your-raspberry-pi-globally-using-tor/
1. on Raspberry: install & config Tor
```
$ sudo apt-get install tor
$ sudo vim /etc/tor/torrc
....
HiddenServiceDir /var/lib/tor/ssh_hidden_service/
HiddenServicePort 22 127.0.0.1:22
$ sudo service tor restart
```
2. on Raspberry: get the hostname : something.onion
```
$ sudo cat /var/lib/tor/ssh_hidden_service/hostname 
```
3. on Client: Install tor and connect proxy
```
$ sudo apt-get install tor connect-proxy
```
4. on Client: configure ssh to use tor as proxy whenever we ssh to something.onion
```
$ vim ~/.ssh/config
...
Host *.onion
        ProxyCommand connect -R remote -5 -S 127.0.0.1:9050 %h %p
        ForwardX11 yes
```
5. on Client: connection    
```
$ ssh pi@cf345hny2qzgzk1z.onion
```
        
