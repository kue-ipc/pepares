# Raspberry Pi 設定

Pepares をインストールする Raspberry Pi の各種設定について記載する。

## OS インストール

Raspbian Jessie をインストールする。

## 初期設定

最低限、GUIの設定ツール「Raspberry Pi の設定」で下記設定を行う。

* ブートをGUIにする。
* 有線LANでインターネットと通信できるようにする。
* pi ユーザのパスワードを設定する。
* ホスト名を適当な名前(piなど)に設定する。

また、必要に応じて下記設定も行う。

* SSH 有効にする。
* ロケールを設定する。
* タイムゾーンを設定する。
* キーボードを設定する。

なお、ロケールを日本語にした場合、フォントがないため文字化けする。必要に応じて日本語フォント(fonts-ipaexfont等)をインストールする。

## プロキシ設定

インターネットアクセスにプロキシが必要な場合は apt-get および git、gem にてインターネットにアクセスできるように設定する。

/etc/apt/apt.conf.d/80proxy
```
Acquire {
  ftp::Proxy "http://proxy.example.jp:8080/";
  http::Proxy "http://proxy.example.jp:8080/";
  https::Proxy "http://proxy.example.jp:8080/";
};
```
/etc/envrionment
```
http_proxy=http://proxy.example.jp:8080/
https_proxy=http://proxy.example.jp:8080/
ftp_proxy=http://proxy.example.jp:8080/
no_proxy="localhost,127.0.0.1,.example.jp,.pepares.local,pepares,pi"
HTTP_PROXY=http://proxy.example.jp:8080/
HTTPS_PROXY=http://proxy.example.jp:8080/
FTP_PROXY=http://proxy.example.jp:8080/
NO_PROXY="localhost,127.0.0.1,.example.jp,.pepares.local,pepares,pi"
```

## 時刻合わせ

直接、インターネット上のNTPサーバーにアクセス出来ない場合は、内部のNTPサーバーを指定する。

/etc/ntp.conf
```
server ntp.example.jp iburst
```
## アップデート

プロキシ及び時刻合わせ終了後に、アップデートを実施し、再起動しておく。

```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo reboot
```
