# WiFi AP設定手順

## 無線LANの固定IP化

/etc/dhcpcd.conf
```
interface wlan0
static ip_address=10.200.1.1/24
```

/etc/networks/interfaces
```
allow-hotplug wlan0
iface wlan0 inet manual
#    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

## APホスト化

hostapd のインストールとサービス設定

```
$ sudo apt-get install hostapd
$ sudo systemctl enable hostapd.service
```

新規作成
/etc/hostapd/hostapd.conf
```
interface=wlan0
driver=nl80211

country_code=JP
ieee80211d=1

ssid=pepares
channel=6
hw_mode=g

wpa=2
wpa_passphrase=XXXXXXXXX

macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0

ieee80211n=1
wmm_enabled=1

wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
```

ssidがSSID、wpa_passphraseがパスフレーズになるため、書き換えること。

/etc/default/hostapd
```
DAEMON_CONF="/etc/hostapd/hostapd.conf"
```

## DNS兼DHCPサーバ

```
$ sudo apt-get install dnsmasq
```

/etc/dnsmasq.conf
```
no-dhcp-interface=eth0
domain=pepares.local
dhcp-range=10.200.1.10,10.200.1.200,12h
```

/etc/hosts
```
10.200.1.1     pi pi.pepares.local
```
