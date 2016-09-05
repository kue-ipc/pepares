# udevil 設定

標準では FAT32 の USBメモリ のみに対応している。FAT32 以外のフォーマットに対応する場合は、追加の設定が必要になる。

## exFAT
exFAT に対応する場合、下記を追加する。

```
$ sudo apt-get install exfat-fuse exfat-utils
```

## HPS+
HPS+ に対応する場合、下記を追加する。

```
$ sudo apt-get install hfsprogs
```

設定ファイル: /etc/udevil/udevil.conf

vfat 以外に対応する場合は、必要に応じて設定を行うこと。
ファイルシステムによっては追加のパッケージも必要。

## NTFS

TODO

## ext2/3/4

TODO
