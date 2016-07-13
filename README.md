# Pepares 簡易ペーパーレス会議システム

## システム要件
* サポートするハードウェアとOS
    * Paspberry Pi 2 Model B または Paspberry Pi 3 Model B
    * Raspbien Jessie
* 動作するであろうと環境
    * UNIX/Linux 環境
    * Ruby 2.1 以上

## Raspberry Pi の設定

### Rasbieanの設定

* GUIを無効にし、CUIにする。

### 必要なパッケージのインストール

```
sudo apt-get install ruby bundler udevil zlib1g-dev
bundle install --path=vendor/bundle --without=development
```

### WiFiルーター化

TODO

### udevil の設定

設定ファイル: /etc/udevil/udevil.conf

vfat 以外に対応する場合は、必要に応じて設定を行うこと。
ファイルシステムによっては追加のパッケージも必要。

## 動作方法

```
RACK_ENV=production budle exec rake assets:precompile
RACK_ENV=production budle exec rake server
```
