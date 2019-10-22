# Mac shell 实现全局代理
1.我用的是
![png.png](https://upload-images.jianshu.io/upload_images/15063932-633a30a5174baeb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


我是用的shadowsockets 我的http配置如下：

![Screen Shot 2018-11-23 at 1.40.16 PM.png](https://upload-images.jianshu.io/upload_images/15063932-f89afded8d5c4fa5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在Termianl中输入 
设置命令行的全局代理

``` shell
export http_proxy="http://127.0.0.1:1087"
export https_proxy="http://127.0.0.1:1087"
```
注意一点在Terminal 的生命周期中这个全局代理是有用的，一旦关闭了当前的Terminal，或者重新开一个那么就要重新运行上面的命令了
