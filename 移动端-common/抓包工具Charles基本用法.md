# 抓包工具Charles基本用法

###前沿：
发现了一款有趣的app，发现是https，导致不能看到其数据结构和加密方式是不是很捉急呢？？？
    本人做移动端开发已经有5年的历史，那么在平时的开发中有没有好用的抓包软件呢？有的，那就是Charles（本人说一声抱歉，无论是开发iOS还是Android 都是一直使用的mac 所以我仅仅是介绍一下mac 的工具）

Charles是一款Http代理服务器和Http监视器，当移动端在无线网连接中按要求设置好代理服务器，使所有对网络的请求都经过Charles客户端来转发时，Charles可以监控这个客户端各个程序所有连接互联网的Http通信。注：本人自己实践抓http /https 协议，socket我没有抓过。
    
一、安装Charles客户端
打开浏览器访问Charles官网 [链接](https://www.charlesproxy.com/)，下载相应系统的Charles安装包，然后一键安装即可。
![青花瓷官网](https://upload-images.jianshu.io/upload_images/15063932-d6fed3bf53867c98.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


当然您也可以下载我曾经使用的版本（建议您支持正版）[破解版本下载链接](https://pan.baidu.com/s/1CgQqYjHSdFhH8EKTxb61Yg )密码:mxhb

Charles提供两种查看封包的页签，一个是Structure，另一个是Sequence，Structure用来将访问请求按访问的域名分类，Sequence用来将请求按访问的时间排序。任何程序都可以在Charles中的Structure窗口中看到访问的域名。
#目录
1.1 Charles主要的功能
1.2 将 Charles 设置成系统代理
1.3 过滤网络请求
1.4 模拟慢速网络
1.5 修改网络请求内容
1.6 修改服务器返回内容
1.7 抓取手机App网络请求


###1.1Charles主要的功能
1.截取Http、Https网络请求内容

2.支持修改网络请求参数，方便调试

3.支持网络请求的截取 并动态修改

![主要的功能](https://upload-images.jianshu.io/upload_images/15063932-a807228c6181fa7f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###1.2将 Charles 设置成系统代理
我们在调试移动APP时，需要抓取APP发送的数据包，首先进行设置，Proxy -> Proxy Settings默认端口是8888，根据实际情况可修改（建议不要更改，因为在工作中会有很多人需要链接您的电脑）。
![代理设置](https://upload-images.jianshu.io/upload_images/15063932-6db2aadba6663977.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![端口号](https://upload-images.jianshu.io/upload_images/15063932-e35206bf567e18a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

进行https的抓包
- 1.  在mac上安装证书 
help -> SSL Proxying -> install Charles Root Certificate 
![在mac上安装证书 ](https://upload-images.jianshu.io/upload_images/15063932-a1f5ef89bb9f87b4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- 2.  在keychain上进行证书信任，打开keychain 点击🔍 键入keychain
![keychain](https://upload-images.jianshu.io/upload_images/15063932-541464e3901f2f75.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- 3.  在keychain中 点击login->Certificates,右击（两个手指头点下），进行任意来源信任
![login->Certificates](https://upload-images.jianshu.io/upload_images/15063932-bc4582f67e9d3bf1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![任意来源信任](https://upload-images.jianshu.io/upload_images/15063932-5b766a4282389d0f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 4. 导出证书导出p.12文件 
![p.12](https://upload-images.jianshu.io/upload_images/15063932-41196bd73d730f68.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 5.通过airdrop 或者其他方式安装到手机上，注意这还没有完，需要在settig general->about->Certificate Trust Settings 进行证书的信任开启，否则不能抓https
![安装描述文件](https://upload-images.jianshu.io/upload_images/15063932-4d60c3edf6d9a25f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![settig general->about->Certificate Trust Settings](https://upload-images.jianshu.io/upload_images/15063932-bc064ad6ebd27262.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 6. 在手机上设置相关的代理，主要此时需要关闭自己的vpn，否则没有办法抓包
![手机上设置相关的代理](https://upload-images.jianshu.io/upload_images/15063932-501789c3cf4669a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

现在大功告成了吗？如果抓http的包早已经大功告成，但是如果抓https的还有一步呢 
- 7. Proxy->SLL Proxy Settings 
![填写host](https://upload-images.jianshu.io/upload_images/15063932-f9f57df08150aaaf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###1.3 过滤网络请求
- 1. 在Filter 栏中填入需要过滤出来的关键字（可模糊搜索）
![过滤网络请求](https://upload-images.jianshu.io/upload_images/15063932-df7672dc71296e19.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 2. focus 仅仅是关注自己关注的
![focus](https://upload-images.jianshu.io/upload_images/15063932-f0ee6e76ae754588.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![focus2](https://upload-images.jianshu.io/upload_images/15063932-52bf59de524ba569.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




###1.4 模拟慢速网络
在 Charles 的菜单上，选择Proxy ->Throttle Setting->Enable Throttling
如果我们只想模拟指定网站的慢速网络，可以再勾选上图中的 “Only for selected hosts” 项即可。
![Throttling](https://upload-images.jianshu.io/upload_images/15063932-34657f72c5879433.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###1.5 修改网络请求内容
![修改网络请求内容](https://upload-images.jianshu.io/upload_images/15063932-6d4d4aacb50f7892.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###1.6 修改服务器返回内容
首先 要保证是开启请求断点是打开的
选择要修改的接口内容 ，勾选Breakpoints
打开青花瓷切换成结构页面,切换成Structure
![修改服务器返回内容](https://upload-images.jianshu.io/upload_images/15063932-f3bd48f9c705f5d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![修改服务器返回内容2](https://upload-images.jianshu.io/upload_images/15063932-afc8b99445ab2603.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



###1.7 抓取相关的数据
![抓取相关的数据](https://upload-images.jianshu.io/upload_images/15063932-1f0a5c490513592f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![抓取相关的数据2](https://upload-images.jianshu.io/upload_images/15063932-5306900b831b1de4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
