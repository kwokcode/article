# Flutter环境问题:Requested 'Requested 'libusbmuxd >= 1.1.0' but version of libusbmuxd is 1.0.10

## 遇到这个这个问题有时候感觉很懵逼的，但是这个的含义就是环境已经升级了但是自己的还是老版本

reinstall libimobiledevice

==> Reinstalling libimobiledevice

==> Cloning https://git.libimobiledevice.org/libimobiledevice.git

Updating /Users/yulekwok/Library/Caches/Homebrew/libimobiledevice--git

==> Checking out branch master

Already on 'master'

Your branch is up to date with 'origin/master'.

HEAD is now at 92c5462 idevicebackup2: Fix scan_directory() for platforms not having d_type in struct dirent

==> ./autogen.sh

Last 15 lines from /Users/yulekwok/Library/Logs/Homebrew/libimobiledevice/01.autogen.sh:

checking dynamic linker characteristics... darwin18.2.0 dyld

checking how to hardcode library paths into programs... immediate

checking for pkg-config... /usr/local/opt/pkg-config/bin/pkg-config

checking pkg-config is at least version 0.9.0... yes

checking for libusbmuxd >= 1.1.0... no

configure: error: Package requirements (libusbmuxd >= 1.1.0) were not met:

Requested 'libusbmuxd >= 1.1.0' but version of libusbmuxd is 1.0.10

Consider adjusting the PKG_CONFIG_PATH environment variable if you

installed software in a non-standard prefix.

Alternatively, you may set the environment variables libusbmuxd_CFLAGS

and libusbmuxd_LIBS to avoid the need to call pkg-config.

See the pkg-config man page for more details.

READ THIS: https://docs.brew.sh/Troubleshooting

### 最后就是如何解决这个libimobiledevice更新的问题我们可以通过下面的方法进行安装libimobiledevice:

``` shell

brew update

brew uninstall --ignore-dependencies libimobiledevice

brew uninstall --ignore-dependencies usbmuxd

brew install --HEAD usbmuxd

brew unlink usbmuxd

brew link usbmuxd

brew install --HEAD libimobiledevice

```

```shell

yulekwoks-MacBook-Pro:~ yulekwok$ brew update

Already up-to-date.

yulekwok$ brew uninstall --ignore-dependencies libimobiledevice

Uninstalling /usr/local/Cellar/libimobiledevice/HEAD-fb71aee_2... (67 files, 1013.7KB)

yulekwoks-MacBook-Pro:~ yulekwok$ brew uninstall --ignore-dependencies usbmuxd

Uninstalling /usr/local/Cellar/usbmuxd/1.0.10_1... (13 files, 120KB)

yulekwoks-MacBook-Pro:~ yulekwok$ brew install --HEAD usbmuxd

Updating Homebrew...

==> Cloning https://git.sukimashita.com/libusbmuxd.git

Cloning into '/Users/yulekwok/Library/Caches/Homebrew/usbmuxd--git'...

==> Checking out branch master

Already on 'master'

Your branch is up to date with 'origin/master'.

==> ./autogen.sh

==> ./configure --disable-silent-rules --prefix=/usr/local/Cellar/usbmuxd/HEAD-9

==> make install

🍺  /usr/local/Cellar/usbmuxd/HEAD-9db5747_1: 13 files, 138.6KB, built in 50 seconds

yulekwoks-MacBook-Pro:~ yulekwok$ brew unlink usbmuxd

Unlinking /usr/local/Cellar/usbmuxd/HEAD-9db5747_1... 7 symlinks removed

yulekwoks-MacBook-Pro:~ yulekwok$ brew link usbmuxd

Linking /usr/local/Cellar/usbmuxd/HEAD-9db5747_1... 7 symlinks created

yulekwoks-MacBook-Pro:~ yulekwok$ brew install --HEAD libimobiledevice

Updating Homebrew...

==> Cloning https://git.libimobiledevice.org/libimobiledevice.git

Updating /Users/yulekwok/Library/Caches/Homebrew/libimobiledevice--git

==> Checking out branch master

Already on 'master'

Your branch is up to date with 'origin/master'.

HEAD is now at 92c5462 idevicebackup2: Fix scan_directory() for platforms not having d_type in struct dirent

==> ./autogen.sh

==> ./configure --disable-silent-rules --prefix=/usr/local/Cellar/libimobiledevi

==> make install

🍺  /usr/local/Cellar/libimobiledevice/HEAD-92c5462_3: 67 files, 1MB, built in 54 seconds

```

#以上便是解决方法的code
