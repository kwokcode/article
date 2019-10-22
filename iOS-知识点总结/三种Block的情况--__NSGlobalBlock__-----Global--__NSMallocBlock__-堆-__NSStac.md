block 分类 - 内存

三种Block的情况 
__NSGlobalBlock__ -- Global 放在数据段
__NSMallocBlock__ 堆     放在堆上
__NSStackBlock__ 栈      放在栈上（拷贝 copy 之后就到堆上面去了），容易被系统回收 在ARC 的情况下一般就直接拷贝到堆上去了

![block内存图.jpg](https://upload-images.jianshu.io/upload_images/15063932-b04d7fceb2ae8eed.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

命令行使用的命令 xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc -fobjc-arc -fobjc-runtime=ios-9.0.0 main.m
1. 作为函数返回block
# block
```
// 封装了block执行逻辑的函数  void *fp  impl.FuncPtr 就是执行的的函数
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
我
            NSLog((NSString *)&__NSConstantStringImpl__var_folders_2r__m13fp2x2n9dvlr8d68yry500000gn_T_main_c60393_mi_0);
        }

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
}
__main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_impl_0 { // c++
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  // 这里会自动生成传入的参数 变量的捕获captuer  
  //局部变量 auto 值传递  auto 和 static 指针传递 不同 
  //全局变量 不能捕获到 要直接访问
  //例如
    int num;
    int *count;
  // 构造函数（类似于OC的init方法），返回结构体对象、对应的是析构函数
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

// 定义block变量
        void (*block)(void) = &__main_block_impl_0(
        __main_block_func_0,&__main_block_desc_0_DATA);

        // 执行block内部的代码
        block->FuncPtr(block);
```
三种Block的情况 
__NSGlobalBlock__ -- Global 放在数据段
__NSMallocBlock__ 堆     放在堆上
__NSStackBlock__ 栈      放在栈上（拷贝 copy 之后就到堆上面去了），容易被系统回收 


```
#import <Foundation/Foundation.h>


void globalBlock(){
    // 没有访问auto 的变量的
    // __NSGlobalBlock__：__NSGlobalBlock ： NSBlock：NSObject
    void(^block)(void) = ^{
        NSLog(@"%s",__FUNCTION__);
    };
    NSLog(@"[block class] == %@",[block class]);
    NSLog(@"[[block class] superclass] == %@",[[block class] superclass]);
    NSLog(@"[[[block class] superclass] superclass] == %@",[[[block class] superclass] superclass]);
    NSLog(@"[[[[block class] superclass] superclass] superclass] == %@",[[[[block class] superclass] superclass] superclass]);
}
void stackBlock(){
    //访问auto变量 所以是stackBlock 超出了作用域会自动销毁 栈上面由操作系统生成和销毁
    // __NSStackBlock__ : __NSStackBlock : NSBlock : NSObject
    NSString * text = @"112";
    void(^block)(void) = ^{
        NSLog(@"%s == %@",__FUNCTION__,text);
    };
    NSLog(@"[block class] == %@",[block class]);
    NSLog(@"[[block class] superclass] == %@",[[block class] superclass]);
    NSLog(@"[[[block class] superclass] superclass] == %@",[[[block class] superclass] superclass]);
    NSLog(@"[[[[block class] superclass] superclass] superclass] == %@",[[[[block class] superclass] superclass] superclass]);
}
void mallocBlock(){
    // __NSMallocBlock__ : __NSMallocBlock : NSBlock : NSObject
    //访问auto变量 所以是stackBlock 超出了作用域会自动销毁 stackBlock 进行一次copy 那么就到堆上面，使用的时候建议使用对内存上
    NSString * text = @"112";
    void(^block)(void) = [^{
        NSLog(@"%s == %@",__FUNCTION__,text);
    } copy];
    NSLog(@"[block class] == %@",[block class]);
    NSLog(@"[[block class] superclass] == %@",[[block class] superclass]);
    NSLog(@"[[[block class] superclass] superclass] == %@",[[[block class] superclass] superclass]);
    NSLog(@"[[[[block class] superclass] superclass] superclass] == %@",[[[[block class] superclass] superclass] superclass]);
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 需要关闭arc 使用MRC
        globalBlock();
        NSLog(@"------------");
        stackBlock();
        NSLog(@"------------");
        mallocBlock();
        
    }
    return 0;
}
```

栈 拷贝到 堆上的步骤



**对象类型的auto变量**
当block内部访问了对象类型的auto变量时
如果block是在栈上，将不会对auto变量产生强引用

如果block被拷贝到堆上
会调用block内部的copy函数
copy函数内部会调用_Block_object_assign函数
_Block_object_assign函数会根据auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用

如果block从堆上移除
会调用block内部的dispose函数
dispose函数内部会调用_Block_object_dispose函数
_Block_object_dispose函数会自动释放引用的auto变量（release）


**被__block修饰的对象类型**
当__block变量在栈上时，不会对指向的对象产生强引用

当__block变量被copy到堆时
会调用__block变量内部的copy函数
copy函数内部会调用_Block_object_assign函数
_Block_object_assign函数会根据所指向对象的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用（注意：这里仅限于ARC时会retain，MRC时不会retain）

如果__block变量从堆上移除
会调用__block变量内部的dispose函数
dispose函数内部会调用_Block_object_dispose函数
_Block_object_dispose函数会自动释放指向的对象（release）

```
#import <Foundation/Foundation.h>
#import "XHModel.h"
typedef void (^XHBlock) (void);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        XHModel __block  *model = [[XHModel alloc] init];
        
        
        XHBlock block = [^{
            NSLog(@"%p", model);
        } copy];
        
        block();
    }
    return 0;
}

#import <Foundation/Foundation.h>

@interface XHModel : NSObject

@end

#import "XHModel.h"

@implementation XHModel
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end
```
![__block.png](https://upload-images.jianshu.io/upload_images/15063932-5ef0e96e578d7e75.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
