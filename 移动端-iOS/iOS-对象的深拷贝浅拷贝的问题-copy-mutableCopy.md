# 记录一个比较坑爹的初级问题
关于iOS 对象的深拷贝浅拷贝的问题
```
    NSDictionary * dict = [NSDictionary new];
    
    NSMutableDictionary * muDict = [NSMutableDictionary dictionary];
    
    
    NSDictionary * dictWithDictFromDict = [NSDictionary dictionaryWithDictionary:dict];
    NSMutableDictionary * mDictWithDictFromDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSDictionary * dictWithDictFromMuDict = [NSDictionary dictionaryWithDictionary:muDict];
    NSMutableDictionary * muDictWithMDictFromMuDict = [NSMutableDictionary dictionaryWithDictionary:muDict];
    
    NSDictionary * dictCopy = [dict copy];
    NSMutableDictionary * dictMCopy = [dict mutableCopy];
    
    NSDictionary * muDictCopy = [muDict copy];
    NSMutableArray * muDictMCopy = [muDict mutableCopy];
    
    NSLog(@"\n dict \t\t\t\t= %p\n muDict \t\t\t\t= %p\n dictWithDictFromDict \t\t\t\t= %p\n mDictWithDictFromDict \t\t\t\t= %p\n dictWithDictFromMuDict \t\t\t\t= %p\n muDictWithMDictFromMuDict \t\t\t\t= %p\n dictCopy \t\t\t\t= %p\n dictMCopy \t\t\t\t= %p\n muDictCopy \t\t\t\t= %p\n muDictMCopy \t\t\t\t= %p\n ",dict,muDict,dictWithDictFromDict,mDictWithDictFromDict,dictWithDictFromMuDict,muDictWithMDictFromMuDict,dictCopy,dictMCopy,muDictCopy,muDictMCopy);
    
   dict 				= 0x600003fa80b0
 muDict 				= 0x600003deef80
 dictWithDictFromDict 				= 0x600003fa80b0
 mDictWithDictFromDict 				= 0x600003def100
 dictWithDictFromMuDict 				= 0x600003def000
 muDictWithMDictFromMuDict 				= 0x600003deeee0
 dictCopy 				= 0x600003fa80b0
 dictMCopy 				= 0x600003deeea0
 muDictCopy 				= 0x600003deee80
 muDictMCopy 				= 0x600003deee60
```

![image.png](https://upload-images.jianshu.io/upload_images/15063932-ae8a7bcb3eede16e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

copy和mutableCopy



|   | copy | mutableCopy |
| --- | --- | --- |
| NSString |  NSString 浅拷贝|NSMutableString深拷贝 |
| NSMutableString |  NSString深拷贝 |  NSMutableString深拷贝 |
| NSArray |  NSArray浅拷贝 |  NSMutableArray深拷贝 |
| NSMutableArray |  NSArray深拷贝 |  NSMutableArray深拷贝 |
| NSDictionary |  NSDictionary浅拷贝 |  NSMutableDictionary深拷贝 |
| NSMutableDictionary |  NSDictionary深拷贝 |  NSMutableDictionary深拷贝 |
