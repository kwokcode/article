# 一个NSObject 对象占用多少内存 16字节
1.系统给了16字节的内存，但是在64位的机器下只是用了8个字节
```
   NSObject * obj = [[NSObject alloc]init];
        // Class's ivar size rounded up to a pointer-size boundary. 返回的是成员变量所占用的大小 创建给了16个字节，但是自己用了8个
        原因
        size_t instanceSize(size_t extraBytes) {
            size_t size = alignedInstanceSize() + extraBytes;
            // CF框架需要所有对象大小最少是16字节
            // CF requires all objects be at least 16 bytes.
            if (size < 16) size = 16;
            return size;
        }
        
        NSLog(@"%zd",class_getInstanceSize([NSObject class])); 8
        
        
        NSLog(@"%zd", malloc_size((__bridge const void *)obj));16
        
```
