# object_getClass 和 [obj class]的区别
object_getClass(obj)返回的是obj中的isa指针
[obj class]则分两种情况：
1. 当obj为实例对象时，[obj  class]中class是实例方法：- (Class)class，返回的obj对象中的isa指针；
2. 当obj为类对象（包括元类和根类以及根元类）时，调用的是类方法：+ (Class)class，返回的结果为其本身。


这是iOS OC中的三种类
1. instance 实例对象
2. class 对象 类对象
3. meta-class 元类对象

instance 实例对象，通过类alloc出来的对象，每次产生的instance对象都是新的 intance 在内存保存的都是属性成员变量和isa，因为所有的类都是继承的nsobject 所以需要都有isa指针
## 1. instance（存储信息）
1. isa 经过 进行位运算 得到的地址是类对象的地址
```
class_rw_t* data() {
    return (class_rw_t *)(bits & FAST_DATA_MASK); //需要进行&才能获得最终的地址
}
```
2. 其他的成员变量
```
struct objc_class : objc_object {
    Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
```
##2. 关于类对象 (存储信息） class

1. 类对象的isa （指向了元类 meta-class）
2. superclass 指针
3. 类的属性信息 （@property） 
4. 类的对象方法 instance method
5. 类的协议信息 protocol 
6. 类的的成员变量 ivar
```
struct class_rw_t {
    // Be warned that Symbolication knows the layout of this structure.
    uint32_t flags;
    uint32_t version;

    // 只读的表格
    const class_ro_t *ro;

    method_array_t methods; // 方法列表
    property_array_t properties; // 属性列表
    protocol_array_t protocols; // 协议列表

    Class firstSubclass;
    Class nextSiblingClass;

    char *demangledName;
}
```
##3. 关于元类对象 (存储信息）meta-class 元类
每个类在内存中有且只有一个meta-class对象。 meta-class对象和class对象的内存结构是一样的，但是用途不一样，meta-class对象和class对象的内存结构是一样的，所以meta-class中也有类的属性信息，类的对象方法信息等成员变量，但是其中的值可能是空的。
1. isa 指针 meta-class对象的isa指向基类的meta-class对象
2. superclass 指针
3. 类方法







