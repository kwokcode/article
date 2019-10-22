1. 直接打开AppStore 其中将1098628542替换成自己的appid
http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1098628542&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8
效果如下 
![image.png](https://upload-images.jianshu.io/upload_images/15063932-5653c7937cbad118.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 直接打开写文件的位置 其中将1098628542替换成自己的appid
if (@available(iOS 10.0, *)) {
https://itunes.apple.com/app/id1098628542?action=write-review&mt=8
 }
效果如下
![image.png](https://upload-images.jianshu.io/upload_images/15063932-02d9ca646e5be345.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3. 直接在手机上显示评论，注意测试的情况下不能点击，一旦上线审核通过之后就可以点击
#import <StoreKit/StoreKit.h>
if (@available(iOS 10.3, *)) {
                [SKStoreReviewController requestReview];
 }
[SKStoreReviewController requestReview];
效果如下
![image.png](https://upload-images.jianshu.io/upload_images/15063932-b5ef2a0b0baf1369.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


