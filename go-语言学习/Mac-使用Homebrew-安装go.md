1. Mac 使用Homebrew 安装go （如果不知道如何使用Homebrew 请参照[链接](https://www.jianshu.com/p/b821a8d1d8dc)）

```
brew install go 
```
2. 配置golang的相关环境变量
默认go 安装的文件地址是 /usr/local/Cellar/go/
```
open /usr/local/Cellar/go/
然后看一下自己的libexec在什么地方然后记录下整体的地址 我的地址是
/usr/local/Cellar/go/1.12.3/libexec
```
3. 将go的配置写入环境
```
vim .bash_profile
```
将下面内容添加进上面的文件
```
#GO
#GOROOT
export GOROOT=/usr/local/Cellar/go/1.12.3/libexec
#GOPATH
export GOPATH=$HOME/Documents/code/go
#Bin
export PATH=${PATH}:$GOPATH/bin
```
####注 GOPATH 可以根据自己的喜好进行放置 我是放置在了文稿下面的code中的go
写完之后如下
![go bash.png](https://upload-images.jianshu.io/upload_images/15063932-d36e3df8087ba035.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



4. 使用source 进行生效
``` 
source .bash_profile
```
5. 使用 go env 看看go环境是否安装成功
![go env.png](https://upload-images.jianshu.io/upload_images/15063932-bb5fb000fe685877.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

到此 go环境就已经安装OK
