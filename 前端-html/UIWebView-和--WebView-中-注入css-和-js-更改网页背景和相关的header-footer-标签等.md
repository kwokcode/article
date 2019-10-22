# 前言:
一个奇怪的业务场景，引发的技术调研,和一个第三方的服务在合作,但是给的html网页中有一些东西不能直接嵌套到iOS的页面中,所以选择调研一下,将调研的东西写出来.

###WebView注入
对于Hybrid App来说，向WebView里面注入JS（CSS也是通过JS代码的方式注入），是太常见的一件事情了，注入就是最常见的native to js的通信方式.

- iOS
```
[self.webView stringByEvaluatingJavaScriptFromString:jsStr];
```
- 安卓
```
webView.loadUrl("javascript:" + jsStr);
```

那么接下来就简单的说一下iOS的注入
一般来说iOS 是在如下的位置进行js 的代码的注入
-(void)webViewDidFinishLoad:(UIWebView *)webView
好了话不多直接上代码吧
```
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 1 打印html 的代码
    {
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSLog(@"html = %@",html);
    }
    
    //2 注入css 代码
    {
        // 2.1 将新建的css 代码写在r上
        NSString *javascriptWithCSSString = @"var style = document.createElement('style'); style.innerHTML = '.xhfooter{height: 40px;background-color: #ff0;}'; document.head.appendChild(style)";
        // 2.2 执行
        [webView stringByEvaluatingJavaScriptFromString:javascriptWithCSSString];
    }
    // 3 获取页面标题
    {
        NSString *string = @"document.title";
        [webView stringByEvaluatingJavaScriptFromString:string];
    }
    // ---------------------根据标签去除相关的标签----------------
    //4.去掉页面header
    {
        //移除头部的导航栏
        NSString *jsStr = @"var header = document.getElementsByTagName(\"header\")[0]; header.parentNode.removeChild(header);";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    // 去掉footer一栏
    {
        NSString *jsStr = @"var footer = document.getElementsByClassName(\"footer\")[0]; footer.parentNode.removeChild(footer);";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    // 去掉最底下的一块区域
    {
        NSString *jsStr = @"var footerBtn = document.getElementsByClassName(\"footer-btn-fix\")[0]; footerBtn.parentNode.removeChild(footerBtn);";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    // ---------------------根据标签替换相关的标签----------------
    {
        // 替换之前的标签 footer
        NSString *jsStr = @"var footer = document.getElementsByClassName(\"footer\")[0]; var newnode=document.createElement(\"pfooter\"); newnode.innerHTML='<div style=\" height: 40px;background-color: #f00;\">  </div>'; footer.parentNode.appendChild(newnode); footer.parentNode.replaceChild(newnode,footer);";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    // 实用新注入的css 替换标签
    {
        // 替换之前的标签 footer
        NSString *jsStr = @"var footer = document.getElementsByClassName(\"footer\")[0]; var newnode=document.createElement(\"pfooter\"); newnode.innerHTML='<div class = \"xhfooter\">  </div>'; footer.parentNode.appendChild(newnode); footer.parentNode.replaceChild(newnode,footer);";
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    }
    
}
```
安卓的相关逻辑
```
public void onPageFinished(WebView webView, String s) {
                super.onPageFinished(webView, s);
                {
                	String js = "javascript:(function() { " +
                        "var footer = document.getElementsByClassName('footer')[0];" +
                        "footer.parentNode.removeChild(footer);})()";
                         webView.loadUrl(js);
                }

            }
```
js思路就是获取获取dom节点进行操作，如何获取dom元素相关内容文档如下：
   我们通过Document对象至少有三种方式获取DOM元素，分别为：
- document.getElementById();  
- document.getElementsByTagName();
- document.getELementsByClassName();



####document.getElementById():根据页面标签的唯一id来获取，返回的是一个对象，自然可以调用对象的方法，例如：children。

####document.getElementsByTagName():看到elements就知道这个获取的是多个对象，所以返回的是对象的集合，哪怕只有一个一个对象，也会返回长度为1的数组，只能通过索引返回对象调用对象的方法。
####document.getELementsByClassName('xxx'):这个跟上面一个类似，返回的也是数组，但是需要注意的是，它会返回所有包含xxx或者只有xxx的标签的数组。
