# Pepares 簡易ペーパーレス会議システム

## システム要件
* サポートするハードウェアとOS
    * Paspberry Pi 2 Model B または Paspberry Pi 3 Model B
    * Raspbien Jessie
* 動作するであろう環境
    * UNIX/Linux 環境
    * Ruby 2.1 以上

## Raspberry Pi の設定

### Rasbieanの設定

* GUIを無効にし、CUIにする。
* 必要に応じてプロキシを設定する。(apt-get、git、および gem がプロキシ経由でアクセス可能であること)
* 有線LAN経由でインターネットにアクセスできるようにする。(セットアップ後は有線LANは不要)

### 必要なパッケージのインストール

```
$ sudo apt-get install ruby bundler udevil zlib1g-dev
```

### WiFi AP 設定

参照: [WiFi AP 設定](docs/wifiap.md)

### udevil 設定

参照: [udevil 設定](docs/udevil.md)

## Pepares のインストールと設定

### インストール

インストールは pi ユーザで行う。

`git clone` または、ダウンロードした zip ファイルを展開する。

```
$ git clone https://github.com/kue-ipc/pepares.git
```

`bundle install` で必要なライブラリを入手する。

```
$ cd pepares
$ bundle install --path=vendor/bundle --without=development
```

### 動作確認

アセットファイルのプリコンパイル後に、サーバーをテスト実行する。

```
$ RACK_ENV=production bundle exec rake assets:precompile
$ RACK_ENV=production bundle exec rake server
```

### サービス登録

TODO
