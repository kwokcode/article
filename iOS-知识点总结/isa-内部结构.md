从arm64架构开始，对isa进行了优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息

```
union isa_t 
{
    Class cls;
    uintptr_t bits;//64位
struct {
        uintptr_t nonpointer        : 1; //0，代表普通的指针，存储着Class、Meta-Class对象的内存地址1，代表优化过，使用位域存储更多的信息
        uintptr_t has_assoc         : 1;//是否有设置过关联对象，如果没有，释放时会更快
        uintptr_t has_cxx_dtor      : 1;//是否有C++的析构函数（.cxx_destruct），如果没有，释放时会更快
        uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000//存储着Class、Meta-Class对象的内存地址信息 所以类对象和元类对象的后面3位都是0
        uintptr_t magic             : 6;//用于在调试时分辨对象是否未完成初始化
        uintptr_t weakly_referenced : 1;//是否有被弱引用指向过，如果没有，释放时会更快
        uintptr_t deallocating      : 1;//对象是否正在释放
        uintptr_t has_sidetable_rc  : 1;//里面存储的值是引用计数器减1
        uintptr_t extra_rc          : 19;//引用计数器是否过大无法存储在isa中
如果为1，那么引用计数会存储在一个叫SideTable的类的属性中
    };
```
