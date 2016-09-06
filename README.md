# Pepares 簡易ペーパーレス会議システム

## システム要件
* サポートするハードウェアとOS
    * Paspberry Pi 2 Model B または Paspberry Pi 3 Model B
    * raspbian Jessie
* 動作するであろう環境
    * UNIX/Linux 環境
    * Ruby 2.1 以上

## Raspberry Pi の設定

### Rasbieanの設定

* GUIを無効にし、CUIにする。
* 必要に応じてプロキシを設定する。(apt-get、git、および gem がプロキシ経由でアクセス可能であること)
* 有線LAN経由でインターネットにアクセスできるようにする。(セットアップ後は有線LANは不要)

### 必要なパッケージのインストール

Ruby および udevil 等をインストールする。

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

`http://ホスト名:9292/` にアクセスし、動作を確認する。

### サービス登録

TODO

### 設定

設定ファイルはまだ用意出来ていない。それぞれのソースを直接変更する必要がある。

ユーザ名とパスワードは`configu.ru`の下記部分を修正する。デフォルトは共に'pepares'になっている。また、コメントアウトで向こうにすることも可能。
```
use Rack::Auth::Basic do |username, password|
  username == 'pepares' && password == 'pepares'
end
```
