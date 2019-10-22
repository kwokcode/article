#  isMemberOfClass  isKindOfClass
```
@implementation NSObject

- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}

- (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}


+ (BOOL)isMemberOfClass:(Class)cls {

// 优先获取元类
    return object_getClass((id)self) == cls;
}


+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
}
@end
```
