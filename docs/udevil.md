# udevil 設定

標準では VFAT(FAT16/FAT32) の USBメモリ のみに対応している。VFAT 以外のフォーマットに対応する場合は、追加の設定が必要になる。

## パッケージの追加

### exFAT

```
$ sudo apt-get install exfat-fuse
```

### HPS+

```
$ sudo apt-get install hfsplus
```

## 設定

udevil の設定ファイル `/etc/udevil/udevil.conf` に必要なフォーマットを追加する。下記は exFAT を追加する場合である。

/etc/udevil/udevil.conf
```
# 既存の行の最後に `, exfat` を追加
allowed_types = $KNOWN_FILESYSTEMS, file, exfat
# default_options_* のところに、exfat 用のオプションを追加
default_options_exfat     = nosuid, noexec, nodev, noatime, nonempty, fmask=0133, dmask=0022, uid=$UID, gid=$GID, utf8
```
