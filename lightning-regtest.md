c-lightning on regtest
===

My first test on lightning network project on Bitcoin regtest

Based on [c-lightning](https://github.com/ElementsProject/lightning) repository.


## Run bitcoin regtest
My regtest network connect to another regtest peernode 52.166.5.175.
Configuration file .bitcoin/bitcoin.conf :
```shell
daemon = 1
regtest = 1
listen = 1
bind = 0.0.0.0
rpcpassword=<mypassword>
rpcuser=<myuser>
connect=52.166.5.175:19000
```
Run bitcoind and wait to sync
```shell
bitcoind
```

## Run lightning daemon
```shell
$  ./lightningd/lightningd --network=regtest --log-level=debug
```
Check lightning peer status
```shell
$ ./lightning-cli getinfo 
{ "id" : "0335e8abfd8f39e9d19dfa029a2582b097964f1a4e429d29281da2953110a49935", "port" : 9735, "address" : 
	[  ], "version" : "v0.5.2-2016-11-21-1477-gfdbf2f41-dirty", "blockheight" : 10954 }
```

## Opening a channel on the regtest

Get new address on lightning
```
# Returns an address <address>
$ ./lightning-cli newaddr  
{ "address" : "2N8d8wTEh7m2AV4JruGscDiBeyMGdFo1tdp" }
```
Send money to lightning address
```
# Returns a transaction id <txid>
$ bitcoin-cli sendtoaddress 2N8d8wTEh7m2AV4JruGscDiBeyMGdFo1tdp 0.3
b2c3952b33e72c3a7f27e12370d60aadb34bcabec5db612729b1c296056bde4d
```
Get transaction hex ( prepend option true to see tx info and number of confirms).
```
# Retrieves the raw transaction <rawtx>
$ bitcoin-cli getrawtransaction b2c3952b33e72c3a7f27e12370d60aadb34bcabec5db612729b1c296056bde4d true
0200000001a599205f537209b484f727381fd628e0effca393a6e9ae589ce8515d7081bc14000000006a473044022010c07c0a2704369957b789aa62748211245ccf184832232208d2e92fe1211fe202200f5f7710189dd6e806f8220dfc9dc565adb0aa9461bde66675e36b70246dd084012103db305a7e6058c128aabbdc9ff0224a990b87bb172fc0503fc788b339b7e24dd7feffffff0280c3c9010000000017a914a8aed2c95248ff9aae688aa27eb6046095de772f87000c2c04000000001976a914d9680a611bb9fdd72e0e7f7cd66d606740c6221c88acbd2a0000
```

Add funds to current node
```shell
# Notifies `lightningd` that there are now funds available:
$ ./lightning-cli addfunds 0200000001a599205f537209b484f727381fd628e0effca393a6e9ae589ce8515d7081bc14000000006a473044022010c07c0a2704369957b789aa62748211245ccf184832232208d2e92fe1211fe202200f5f7710189dd6e806f8220dfc9dc565adb0aa9461bde66675e36b70246dd084012103db305a7e6058c128aabbdc9ff0224a990b87bb172fc0503fc788b339b7e24dd7feffffff0280c3c9010000000017a914a8aed2c95248ff9aae688aa27eb6046095de772f87000c2c04000000001976a914d9680a611bb9fdd72e0e7f7cd66d606740c6221c88acbd2a0000
{ "outputs" : 1, "satoshis" : 30000000 }
```
Check funds on current node
```shell
$ ./lightning-cli listfunds
{ "outputs" : 
	[ 
		{ "txid" : "b2c3952b33e72c3a7f27e12370d60aadb34bcabec5db612729b1c296056bde4d", "output" : 1, "value" : 30000000 } ] }
```

Connect to another lightning node in the same bitcoin network
```shell
# lightning-cli connect <node_id> <ip> [<port>]
$ ./lightning-cli connect 031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e 52.166.5.175 9735
{ "id" : "031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e" }
```

Check connection status: it should be GOSSIPING.
```shell
./lightning-cli getpeers | jq
{
  "peers": [
    {
      "state": "GOSSIPING",
      "peerid": "031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e",
      "netaddr": [
        "52.166.5.175:9735"
      ],
      "connected": true,
      "owner": "lightning_gossipd"
    }
  ]
}
```

Open the channel
```shell
# lightning-cli fundchannel <node_id> <amount>
$ ./lightning-cli fundchannel 031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e 10000
"Owning subdaemon lightning_openingd died (33792)"
```

Error from lightning console log:
```shell
lightningd(8021): Connected json input
lightningd(8021): No fee estimate for Normal: basing on default fee rate
lightning_gossipd(8029): TRACE: req: type WIRE_GOSSIPCTL_RELEASE_PEER len 35
lightning_gossipd(8029): REPLY WIRE_GOSSIPCTL_RELEASE_PEER_REPLY with 2 fds
lightningd(8021): peer 031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e: state: UNINITIALIZED -> OPENINGD
lightning_openingd(8370): pid 8370, msgfd 18
lightningd(8021): No fee estimate for Immediate: basing on default fee rate
lightning_openingd(8370): TRACE: First per_commit_point = 032a3b3af7c6834cd21127ada205bd1c3a10a04307ef9b6b1b2022588895bda464
lightning_openingd(8370): TRACE: Read decrypt 00218291cec75be01148c3dbcc940ad226cdc59b3b2ae202c533ffc8933bd0fe29090000000000000222ffffffffffffffff0000000000000064000000000000000000000001000601e30351f4de3c90625bfd5a065e93fc9a6c9b37c41170f81c2fde226e6fd02b13df1402f9c38b1ae32002706a2e02ee47bced7655a129fbbf29758bd53109f8f9773725031f9c1295158fb3813717969a0c5344ba210eef2300ace2a8a41d3ee8ec839c98024bfa3cf6df1fa99481f52d96dcb6b63dd1bda0ba549ffd27cc1721aedf7eb303024604c28b214a926dd4f576a728fa0e0416f301a30906d8c91bbaff1d1f8fa5d1037bca0c74654055eb75b2c53d113d35918f2dbca3c8bc3299ec31b495cd05c801
lightning_openingd: Fatal signal 6
0x55e40817e324 crashdump
	common/subdaemon.c:30
0x7f341318102f ???
	???:0
0x7f3413180fcf ???
	???:0
0x7f34131823f9 ???
	???:0
0x55e40819e720 call_error
	ccan/ccan/tal/tal.c:98
0x55e40819e8e8 check_bounds
	ccan/ccan/tal/tal.c:170
0x55e40819e90f to_tal_hdr
	ccan/ccan/tal/tal.c:178
0x55e40819f8c7 tal_len
	ccan/ccan/tal/tal.c:664
0x55e40817d95d output_better
	common/permute_tx.c:101
0x55e40817da50 find_best_out
	common/permute_tx.c:118
0x55e40817dab4 permute_outputs
	common/permute_tx.c:133
0x55e40817bbab initial_commit_tx
	common/initial_commit_tx.c:160
0x55e40817b5c2 initial_channel_tx
	common/initial_channel.c:91
0x55e408175f69 funder_channel
	openingd/opening.c:426
0x55e4081772b3 main
	openingd/opening.c:807
0x7f341316e2b0 ???
	???:0
0x55e408174fa9 ???
	???:0
0xffffffffffffffff ???
	???:0
lightning_openingd(8370): TRACE: backtrace: common/subdaemon.c:33 (crashdump) 0x55e40817e34a
lightning_openingd(8370): TRACE: backtrace: (null):0 ((null)) 0x7f341318102f
lightning_openingd(8370): TRACE: backtrace: (null):0 ((null)) 0x7f3413180fcf
lightning_openingd(8370): TRACE: backtrace: (null):0 ((null)) 0x7f34131823f9
lightning_openingd(8370): TRACE: backtrace: ccan/ccan/tal/tal.c:98 (call_error) 0x55e40819e720
lightning_openingd(8370): TRACE: backtrace: ccan/ccan/tal/tal.c:170 (check_bounds) 0x55e40819e8e8
lightning_openingd(8370): TRACE: backtrace: ccan/ccan/tal/tal.c:178 (to_tal_hdr) 0x55e40819e90f
lightning_openingd(8370): TRACE: backtrace: ccan/ccan/tal/tal.c:664 (tal_len) 0x55e40819f8c7
lightning_openingd(8370): TRACE: backtrace: common/permute_tx.c:101 (output_better) 0x55e40817d95d
lightning_openingd(8370): TRACE: backtrace: common/permute_tx.c:118 (find_best_out) 0x55e40817da50
lightning_openingd(8370): TRACE: backtrace: common/permute_tx.c:133 (permute_outputs) 0x55e40817dab4
lightning_openingd(8370): TRACE: backtrace: common/initial_commit_tx.c:160 (initial_commit_tx) 0x55e40817bbab
lightning_openingd(8370): TRACE: backtrace: common/initial_channel.c:91 (initial_channel_tx) 0x55e40817b5c2
lightning_openingd(8370): TRACE: backtrace: openingd/opening.c:426 (funder_channel) 0x55e408175f69
lightning_openingd(8370): TRACE: backtrace: openingd/opening.c:807 (main) 0x55e4081772b3
lightning_openingd(8370): TRACE: backtrace: (null):0 ((null)) 0x7f341316e2b0
lightning_openingd(8370): TRACE: backtrace: (null):0 ((null)) 0x55e408174fa9
lightning_openingd(8370): TRACE: backtrace: (null):0 ((null)) 0xffffffffffffffff
lightning_openingd(8370): STATUS_FAIL_INTERNAL_ERROR: FATAL SIGNAL 6
lightning_openingd(8370): Status closed, but not exited. Killing
lightningd(8021): peer 031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e: Peer transient failure in OPENINGD: Owning subdaemon lightning_openingd died (9)
lightningd(8021): peer 031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e: Only reached state OPENINGD: forgetting
lightningd(8021):jcon fd 14: Failing: Owning subdaemon lightning_openingd died (9)
lightning_gossipd(8029): TRACE: Forgetting remote peer 031578cd392640c74da2061d26587515e2e67e940ac6c9a100f0b4d28d4617172e
lightningd(8021):jcon fd 14: Closing (No such file or directory)
```
