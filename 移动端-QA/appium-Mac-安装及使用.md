# appium Mac 安装及使用
##1、xcode（需要OS X版本支持）：
下载对应版本的Xcode（支持对应手机系统），解压，拖入应用程序。
xcode[下载地址](https://developer.apple.com/download/more/)
安装java 环境
下载文件： [jdk-8u141-macosx-x64.dmg](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

##2、安装appium：
    2.1安装homebrew：homebrew 简称brew，是Mac OSX上的软件包管理工具，能在Mac中方便的安装软件或者卸载软件，可以说Homebrew就是mac下的apt-get、yum等神器。
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    2.2 安装libimobiledevice：libimobiledevice 是一个跨平台的软件库，支持 iPhone®, iPod Touch®, iPad® and Apple TV® 等设备的通讯协议。不依赖任何已有的私有库，不需要越狱。应用软件可以通过这个开发包轻松访问设备的文件系统、获取设备信息，备份和恢复设备，管理 SpringBoard 图标，管理已安装应用，获取通讯录、日程、备注和书签等信息，使用 libgpod 同步音乐和视频。
        $ brew install libimobiledevice --HEAD
    2.3 安装carthage：carthage 使用于 Swift 语言编写，只支持动态框架，只支持 iOS8+的Cocoa依赖管理工具。

        $ brew install carthage

    2.4安装node：node是安装npm的前置条件。

        $ brew install node

    2.5安装npm：npm是一个NodeJS包管理和分发工具，已经成为了非官方的发布Node模块（包）的标准。

        $ brew install npm

    2.6安装cnpm：国内直接用npm下载安装会有好多网络问题，安装淘宝的cnpm要比npm好用，https://npm.taobao.org/
        $ npm install -g cnpm --registry=https://registry.npm.taobao.org

    2.7安装ios-deploy：ios-deploy是一个使用命令行安装ios app到连接的设备的工具，原理是根据os x命令行工程调用系统底层函数，获取连接的设备、查询/安装/卸载app。

        $ cnpm install -g ios-deploy

    2.8安装xcpretty: xcpretty是用于对xcodebuild的输出进行格式化。并包含输出report功能。

        $ gem install xcpretty

    2.9安装appium，appium-doctor

    $ cnpm install -g appium

    $ cnpm install -g appium-doctor

    2.10 使用appium-doctor检查appium环境
        终端输入：appium-doctor
        
        
##WebDriverAgent安装步骤
    1.WebDriverAgent进行clone 
    git clone  https://github.com/facebook/WebDriverAgent.git
    2.Getting Started
        ./Scripts/bootstrap.sh
    
    cd  /Applications/AppiumDesktop.app/Contents/Resources/app/node_modules/appium/node_modules/appium-xcuitest-driver/WebDriverAgent
    目录在appium安装目录下，具体路径参照自己的路径，可以通过find命令查找
 
    2.在当前目录下执行脚本
    sh ./Scripts/bootstrap.sh
 
    3.编译WebDriverAgent.xcodeproj
    打开当前目录下的WebDriverAgent.xcodeproj文件（工程文件在第1步的目录下）
 
    注意：build时需要指定一个Development team，可以用个人Apple ID账号，生成个人证书和team（在Xcode->Preferences->Account中配置）
 
    PROJECT->WebDriverAgent、TARGETS->WebDriverAgentLib和
![image.png](https://upload-images.jianshu.io/upload_images/15063932-9424d5799a156e5f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

WebDriverAgentRunner的Signing使用个人的证书和Team（画黑色横线的部分）




备注
```shell
echo 'export PATH="/usr/local/opt/openssl/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="/usr/local/opt/icu4c/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="/usr/local/opt/icu4c/sbin:$PATH"' >> ~/.bash_profile
echo 'export ANDROID_HOME=/Users/yulekwok/Library/Android/sdk' >> ~/.bash_profile
echo 'export PATH=${PATH}:${ANDROID_HOME}/tools' >> ~/.bash_profile
echo 'export PATH=${PATH}:${ANDROID_HOME}/platform-tools' >> ~/.bash_profile
echo 'export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home' >> ~/.bash_profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
echo 'export CLASS_PATH=$JAVA_HOME/lib' >> ~/.bash_profile
echo 'export PATH=${PATH}:/usr/local/Cellar/python/3.7.0/Frameworks/Python.framework/Versions/3.7/bin' >> ~/.bash_profile
alias python="/usr/local/Cellar/python/3.7.0/Frameworks/Python.framework/Versions/3.7/bin/python3.7"' >> ~/.bash_profile
echo 'export GRADLE_HOME=/Users/yulekwok/Documents/MacDev/gradle/gradle-4.6' >> ~/.bash_profile
echo 'export PATH=${PATH}:${GRADLE_HOME}/bin' >> ~/.bash_profile
```
备注：这是2018年为部门同事写的，之前没有发布，如果有问题请联系我。
