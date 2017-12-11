## Lightning test
My first test on lightning network project.

Based on [c-lightning](https://github.com/ElementsProject/lightning) repository.



Check lightning peer status
```
$ ./lightning-cli getinfo 
{ "id" : "0208157cc09a4521490902f174d03b4120903ddfd4539d7fcffac33630c685e912", "port" : 9735, "address" : 
	[  ], "version" : "v0.5.2-2016-11-21-1245-g4452e3f3", "blockheight" : 1254544 }
```
Get new address on lightning
```
# Returns an address <address>
$ ./lightning-cli newaddr  
{ "address" : "2MtLBVxxbrirBuQzWqdiR1VSdwiQkSPDnXn" }
```
Send money to lightning address
```
# Returns a transaction id <txid>
$ bitcoin-cli -testnet sendtoaddress 2MtLBVxxbrirBuQzWqdiR1VSdwiQkSPDnXn 6   
950aeb91418fa7da25d6cccc7ce872274d260c8025a2c6c6795a845c5c2f1ffb
```
Get transaction
```
# Retrieves the raw transaction <rawtx>
$ bitcoin-cli -testnet getrawtransaction 950aeb91418fa7da25d6cccc7ce872274d260c8025a2c6c6795a845c5c2f1ffb true
0200000003040d9d922d26111a7b51b6e1bf200d42369689211ab7716da82e8b58106c1c83260000006b4830450221008dacd3c44388ee39a30bdb59adb4b73e246f6ca8e9ff15e6db8d815f12ff29e802204da919108166eead7f1f7c71e7af4b3dc10282a03c2195cbbc17a601ac5fab80012103f86aafa3479d2f3425dcf233d2589abfb1ee461927fd78565b74e38b90de2861feffffff43d4db2a40cdc1ef45de2843242104ccc72cfee9db0e6f71de3879c2f6958423000000006b483045022100e863c82b75cb588d7688edc63fd7806797e4b5e19b2e6fc47fc2e25ffeb3e526022018924542107ddb0dfe3440bae50a05c1a703a5d46eea935615f3d488964987220121029cebae63e3b368c13d6f75eecd8d19e81306a816892722f6d0ea1222e4741d5ffeffffff66a2d706dd4ec1f69be4a8e298430eb1121b788ffef8dfdaaeeccb367ff03350010000006b483045022100a42a826fe3a1220ae4439ad6fd00b062076bdcda6313546f95b4ef882994b0b80220689d19f038013a3066dc9aadd5f6f262da925b3b5734d464ed226ff105d48267012103e2c502fb80ae2b6e340e31914a2993550ac7a311e9857c9f45a5f0af15799b22feffffff02e8d35c00000000001976a9142708d3d662d3273e03ec19f9e0add8b8b58abbb188ac0046c3230000000017a9140be820e5f16023b09c5578248d9852b26f8843fc875b241300
```

Add funds to current node
```
# Notifies `lightningd` that there are now funds available:
$ ./lightning-cli addfunds 0200000003040d9d922d26111a7b51b6e1bf200d42369689211ab7716da82e8b58106c1c83260000006b4830450221008dacd3c44388ee39a30bdb59adb4b73e246f6ca8e9ff15e6db8d815f12ff29e802204da919108166eead7f1f7c71e7af4b3dc10282a03c2195cbbc17a601ac5fab80012103f86aafa3479d2f3425dcf233d2589abfb1ee461927fd78565b74e38b90de2861feffffff43d4db2a40cdc1ef45de2843242104ccc72cfee9db0e6f71de3879c2f6958423000000006b483045022100e863c82b75cb588d7688edc63fd7806797e4b5e19b2e6fc47fc2e25ffeb3e526022018924542107ddb0dfe3440bae50a05c1a703a5d46eea935615f3d488964987220121029cebae63e3b368c13d6f75eecd8d19e81306a816892722f6d0ea1222e4741d5ffeffffff66a2d706dd4ec1f69be4a8e298430eb1121b788ffef8dfdaaeeccb367ff03350010000006b483045022100a42a826fe3a1220ae4439ad6fd00b062076bdcda6313546f95b4ef882994b0b80220689d19f038013a3066dc9aadd5f6f262da925b3b5734d464ed226ff105d48267012103e2c502fb80ae2b6e340e31914a2993550ac7a311e9857c9f45a5f0af15799b22feffffff02e8d35c00000000001976a9142708d3d662d3273e03ec19f9e0add8b8b58abbb188ac0046c3230000000017a9140be820e5f16023b09c5578248d9852b26f8843fc875b241300
{ "outputs" : 1, "satoshis" : 600000000 }
```
Check fund on current node
```
$ ./lightning-cli listfunds
{ "outputs" : 
	[ 
		{ "txid" : "fb1f2f5c5c845a79c6c6a225800c264d2772e87cccccd625daa78f4191eb0a95", "output" : 1, "value" : 600000000 } ] }
```
Connect to another lightning node
```
# lightning-cli connect <node_id> <ip> [<port>]
$ ./lightning-cli connect 031a31a755cd79971cc7de5d80f4e1030f9d86dde05b98cca31ef858f21cf08c82 52.166.5.175 9735
{ "id" : "031a31a755cd79971cc7de5d80f4e1030f9d86dde05b98cca31ef858f21cf08c82" }
```

Open and add funds to channel
```
# lightning-cli connect <node_id> <amount>
$ ./lightning-cli fundchannel 031a31a755cd79971cc7de5d80f4e1030f9d86dde05b98cca31ef858f21cf08c82 10000
{ "tx" : "02000000000101fb1f2f5c5c845a79c6c6a225800c264d2772e87cccccd625daa78f4191eb0a950100000017160014bc18dc613de54606284a5154a05c3d740e061004ffffffff021027000000000000220020fb8076ab4a307c809657b5a986923d9bf0af43317329bf91f1daaa3ca7e5cde8b51dc32300000000160014c8d76f33fd29062a37b699027e41994615c1a6fe0247304402200d00a62418eff15be762580e2dc28562c5b1a9c28337e151203ee6f071b49c9702201ae24eccb646d6d26a41d887a07eae9c5c59fbc37a8a050734b64da4934e1225012103e0b38ef1d50e5abfe342638f5087b64006b7698dfc14b27f7607f60c5e2585ff00000000" }
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
      "peerid": "031a31a755cd79971cc7de5d80f4e1030f9d86dde05b98cca31ef858f21cf08c82",
      "connected": true,
      "owner": "lightning_channeld",
      "channel": "1254545:153:0",
      "msatoshi_to_us": 10000000,
      "msatoshi_total": 10000000
    }
  ]
}
```