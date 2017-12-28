# Lightning test
My first test on lightning network project on Bitcoin testnet

Based on [c-lightning](https://github.com/ElementsProject/lightning) repository.


## Run daemons
Run bitcoin daemon
```
$ bitcoind -daemon -testnet -estimate-fee
```
Run lightning daemon
```
$  ./lightningd/lightningd --network=testnet --log-level=debug
```
Check lightning peer status
```
$ ./lightning-cli getinfo 
{ "id" : "0208157cc09a4521490902f174d03b4120903ddfd4539d7fcffac33630c685e912", "port" : 9735, "address" : 
	[  ], "version" : "v0.5.2-2016-11-21-1245-g4452e3f3", "blockheight" : 1254544 }
```

## Opening a channel on the Bitcoin testnet

Get new address on lightning
```
# Returns an address <address>
$ ./lightning-cli newaddr  
{ "address" : "2NFrZSkMS8xmRQcH1ogoo7bWjN4PqzJdwy4" }
```
Send money to lightning address
```
# Returns a transaction id <txid>
$ bitcoin-cli -testnet sendtoaddress 2NFrZSkMS8xmRQcH1ogoo7bWjN4PqzJdwy4 1  
61ff70f6b367398eea1737ccf177857d2f058bf8712b808fc454252b3e594d7f
```
Get transaction hex ( prepend option true to see tx info and number of confirms)
```
# Retrieves the raw transaction <rawtx>
$ bitcoin-cli -testnet getrawtransaction 61ff70f6b367398eea1737ccf177857d2f058bf8712b808fc454252b3e594d7f true
020000000262fc9259f61069c39cb3e85a32323c1dd6d659bbe812136f1b4c7399d24ba713000000006b483045022100f761fb45590dfc1cb144f4cd90fa5e2569d1669d3ebe977dd99a44e8cd98a2d5022078597539ba65f7f542e51ec050c59d5136a32a8181d4212afb128de51683831c012103f86aafa3479d2f3425dcf233d2589abfb1ee461927fd78565b74e38b90de2861fefffffff98f9b1ec4ae34c741965247aafa81c134e3789981819581f0faf3d0bf598197000000006b483045022100f751a94506ec5ac8fe4bc057377f61968bd64e48836a5c308fb84c7f5452335f02206549e708854f97c56c9a33072f6283402be7248ed40e8e6be6b68e628c08a6b001210294bf8304f39ff2fc9ef78e9069c85995be9150d7998f3d03503a87fb6bf37603feffffff0200e1f5050000000017a914f801913376264e68579e8b9542e0ba381cbffe208708813600000000001976a9149a5c923de5b044e9b9e53e0a3f9f4b77c703e59988ac1f2c1300
```

Add funds to current node
```
# Notifies `lightningd` that there are now funds available:
$ ./lightning-cli addfunds 020000000262fc9259f61069c39cb3e85a32323c1dd6d659bbe812136f1b4c7399d24ba713000000006b483045022100f761fb45590dfc1cb144f4cd90fa5e2569d1669d3ebe977dd99a44e8cd98a2d5022078597539ba65f7f542e51ec050c59d5136a32a8181d4212afb128de51683831c012103f86aafa3479d2f3425dcf233d2589abfb1ee461927fd78565b74e38b90de2861fefffffff98f9b1ec4ae34c741965247aafa81c134e3789981819581f0faf3d0bf598197000000006b483045022100f751a94506ec5ac8fe4bc057377f61968bd64e48836a5c308fb84c7f5452335f02206549e708854f97c56c9a33072f6283402be7248ed40e8e6be6b68e628c08a6b001210294bf8304f39ff2fc9ef78e9069c85995be9150d7998f3d03503a87fb6bf37603feffffff0200e1f5050000000017a914f801913376264e68579e8b9542e0ba381cbffe208708813600000000001976a9149a5c923de5b044e9b9e53e0a3f9f4b77c703e59988ac1f2c1300
{ "outputs" : 1, "satoshis" : 100000000 }
```
Check funds on current node
```
$ ./lightning-cli listfunds
{ "outputs" : 
	[ 
		{ "txid" : "61ff70f6b367398eea1737ccf177857d2f058bf8712b808fc454252b3e594d7f", "output" : 1, "value" : 100000000 } ] }
```

Connect to another lightning node
```
# lightning-cli connect <node_id> <ip> [<port>]
$ ./lightning-cli connect 02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d 52.166.5.175 9735
{ "id" : "02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d" }
```

Open the channel
```
# lightning-cli fundchannel <node_id> <amount>
$ ./lightning-cli fundchannel 02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d 10000
{ "tx" : "02000000000101f98f9b1ec4ae34c741965247aafa81c134e3789981819581f0faf3d0bf5981970100000017160014a600071ea318fcf58bb069df20d98a2ec759ccdfffffffff0210270000000000002200207d07a53e071a6abdb04eb389965e76da42527e2fe85a071ec31e66fd532a7d7b3eb9f50500000000160014bf9bec2a2f280f32cc529719a9a3627c7245b56402483045022100a5a1b1fcc85585e276a778d47385147f37506e72aa3e95c5bae534a391d6b47b022021e7131ed61aef4869eb291e5bbbf71f2292305cbdb837a0f43ef7cce62911b7012103859e35c17a1d42e91ffc076ff1294667aa2df8935a2eb412d05b3bf687be5da200000000" }
```
Check the opening channel and wait 6 confirmations
```
$ ./lightning-cli getpeers | jq
{
  "peers": [
    {
      "state": "CHANNELD_AWAITING_LOCKIN",
      "netaddr": [
        "52.166.5.175:9735"
      ],
      "peerid": "02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d",
      "connected": true,
      "owner": "lightning_channeld",
      "channel": "1256481:58:0/1",
      "msatoshi_to_us": 10000000,
      "msatoshi_total": 10000000
    }
  ]
}
```
After 6 confirmations
```
$ ./lightning-cli getchannels | jq
{
  "channels": [
    {
      "source": "03c5066855d9cbd372c26f7ff96bb80e77796ce1c6dd1e058e6707ab262bb3f599",
      "destination": "02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d",
      "short_id": "1256481:58:0/1",
      "flags": 1,
      "active": true,
      "last_update": 0,
      "base_fee_millisatoshi": 1,
      "fee_per_millionth": 10,
      "delay": 6
    }
  ]
}
```
## Build invoice and send payments
Build invoice on Peer 2
```
$ ./lightning-cli invoice 10000 label2 description2
{ "rhash" : "6dee059d54f8c8852fcb080f3990220853bdd14a006896516db5509c80d0273c", "expiry_time" : 1514481538, "bolt11" : "lntb100n1pdy2xtjpp5dhhqt825lryg2t7tpq8nnypzppfmm522qp5fv5tdk4gfeqxsyu7qdq5v3jhxcmjd9c8g6t0dceqcqpx5tt0su530qn5czpshrmqhrsaxjkkkdtmyesc5k2nmpq3khpyz48zduxajnx2keakvjyc2ywa875xuy3f7fzsmt3ufke7vfswn8ffeeqppyvzj2" }
```
Retrieve invoice info on Peer 2
```
$ ./lightning-cli listinvoice
[ 
 { "label" : "label2", "rhash" : "6dee059d54f8c8852fcb080f3990220853bdd14a006896516db5509c80d0273c", "msatoshi" : 10000, "complete" : false, "expiry_time" : 1514481538 } ]
```
Send the payment on Peer 1 to Peer 2
```
# route=$(cli/lightning-cli getroute <recipient_id> <amount> 1 | jq --raw-output .route -)
# cli/lightning-cli sendpay "$route" <rhash>
route=$(./lightning-cli getroute 02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d 10000 1 | jq --raw-output .route -)
./lightning-cli sendpay "$route" 6dee059d54f8c8852fcb080f3990220853bdd14a006896516db5509c80d0273c
```
Error log on Peer 1 lightning server, loop message: "Can't send commit: waiting for revoke_and_ack"
```
...
lightningd(18685): Sending 10000 over 1 hops to deliver 10000
lightning_channeld(21170): TRACE: NEW:: HTLC LOCAL 0 = SENT_ADD_HTLC/RCVD_ADD_HTLC 
lightning_channeld(21170): TRACE: Adding HTLC 0 msat=10000 cltv=1256495 gave 0
lightning_channeld(21170): REPLY WIRE_CHANNEL_OFFER_HTLC_REPLY with 0 fds
lightning_channeld(21170): TRACE: peer_out WIRE_UPDATE_ADD_HTLC
lightning_channeld(21170): TRACE: Trying commit
lightning_channeld(21170): TRACE: htlc 0: SENT_ADD_HTLC->SENT_ADD_COMMIT
lightning_channeld(21170): TRACE: htlc added REMOTE: local -10000 remote +0
lightning_channeld(21170): TRACE: sending_commit: HTLC LOCAL 0 = SENT_ADD_COMMIT/RCVD_ADD_COMMIT 
lightning_channeld(21170): TRACE: Derived key 0383a1febbfebf729a8a00a0b3956be0a3682d140f4ee85cb41312857ef5581e91 from basepoint 02e91567aac63641ae482cc87761ec3267da816c7d127c8988ded8fa9417eb752c, point 02837fddd8bf83bce764abfb495816bd587fd5259d32518560d6a08c3f6b9321ed
lightning_channeld(21170): TRACE: Creating commit_sig signature 1 304402202496ef6172c9fe1e385369d94879ba093b0c92a0c6b9eae53579e9f151f06b3102200d2b990fc368b0eb17eb3c5c12c94f081762dbd787a59cc81db8f24cca87bce6 for tx 02000000014f706284857908e2ec100bc7bb484b138e30ab7022562a8311cc08a599153a35000000000039775d80014e26000000000000160014b48a11c30eb2233f936f24d93ab04a6e56a892611d91a720 wscript 52210221c97c8b3f7bf5448f5694ed4c4f551646d08a759e01d1d82ed67a22dd1081cd21025732ea2e6b592f1b3fea2d79b3282035e5e19a4965ac5d7781308dde9b57ec8d52ae key 0221c97c8b3f7bf5448f5694ed4c4f551646d08a759e01d1d82ed67a22dd1081cd
lightning_channeld(21170): TRACE: Sending commit_sig: HTLC LOCAL 0 = SENT_ADD_COMMIT/RCVD_ADD_COMMIT 
lightning_channeld(21170): TRACE: Telling master we're about to commit...
lightning_channeld(21170): TRACE: Sending master 1020
lightning_channeld(21170): UPDATE WIRE_CHANNEL_SENDING_COMMITSIG
lightningd(18685): peer 02bc09758d79de380e30644df6ddfd4f4a6e56dd138217d4db866dc7aa346cfe8d: HTLC out 0 SENT_ADD_HTLC->SENT_ADD_COMMIT
lightning_channeld(21170): TRACE: ... , awaiting 1120
lightning_channeld(21170): TRACE: Got it!
lightning_channeld(21170): TRACE: Sending commit_sig with 0 htlc sigs
lightning_channeld(21170): TRACE: peer_out WIRE_COMMITMENT_SIGNED
lightning_channeld(21170): TRACE: Can't send commit: waiting for revoke_and_ack
lightning_channeld(21170): TRACE: Can't send commit: waiting for revoke_and_ack
...
```
