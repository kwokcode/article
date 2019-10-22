# mac 使用brew 安装Python
1. 安装brew 
``` shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2. brew 下载python 
``` shell
brew install python3
```

3. 因为mac 的Xcode 需要使用python2 所以不能将mac上的python2删除所以需要制作相关的alias（别名），打开terminal 然后 
```shell
vim .bash_profile
``` 
输入 i 然后将下面的粘贴进去
``` shell
alias python2='/System/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7'
alias python3='/usr/local/Cellar/python/3.7.3/bin/python3.7'
alias python=python3
```
```shell
source .bash_profile
``` 
键入python 显示的是python3
```shell
python
Python 3.7.3 (default, Mar 27 2019, 09:23:39) 
[Clang 10.0.0 (clang-1000.11.45.5)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>
``` 
键入python2 显示的是python2
```shell
python2
Python 2.7.10 (default, Oct  6 2017, 22:29:07) 
[GCC 4.2.1 Compatible Apple LLVM 9.0.0 (clang-900.0.31)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>
```
到此为止已经大功告成
