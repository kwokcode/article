# iOS中提供了一个叫做@encode的指令，可以将具体的类型表示成字符串编码

苹果官网的[链接地址](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)
To assist the runtime system, the compiler encodes the return and argument types for each method in a character string and associates the string with the method selector. The coding scheme it uses is also useful in other contexts and so is made publicly available with the @encode() compiler directive. When given a type specification, @encode() returns a string encoding that type. The type can be a basic type such as an int, a pointer, a tagged structure or union, or a class name—any type, in fact, that can be used as an argument to the C sizeof() operator.

为了帮助运行时系统，编译器将每个方法的返回和参数类型编码为字符串，并将该字符串与方法选择器关联。 它使用的编码方案在其他上下文中也很有用，因此可以通过@encode（）编译器指令公开使用。 给定类型说明后，@ encode（）返回编码该类型的字符串。 该类型可以是基本类型，例如int，指针，带标签的结构或联合或类名-实际上可以用作C sizeof（）运算符的参数的任何类型。
```
char *buf1 = @encode(int **);
char *buf2 = @encode(struct key);
char *buf3 = @encode(Rectangle);
```



| Code | Meaning |
| --- | --- | 
| c | A char |  
| i | An int |  
| s | A short |  
| l |  A long, l is treated as a 32-bit quantity on 64-bit programs.|
| q | A long long  |
| C | An unsigned char |
| I | An unsigned int |
| S | An unsigned short |
| L | An unsigned long |
| Q | An unsigned long long |
| f | A float |
| d | A double |
| B | A C++ bool or a C99 _Bool |
| v | A void |
| * | A character string (char *) |
| @ | An object (whether statically typed or typed id) |
| # | A class object (Class) |
| : | A method selector (SEL) |
| [array type] | An array |
| {name=type...} | A structure |
| (name=type...) | A union |
| bnum | A bit field of num bits |
| ^type | A pointer to type |
| ? | An unknown type (among other things, this code is used for function pointers) |


## Important: Objective-C does not support the long double type. @encode(long double) returns d, which is the same encoding as for double.
## 重要：Objective-C不支持long double类型。 @encode（long double）返回d，该编码与double相同。

```
- (void)viewDidLoad {
    [super viewDidLoad];
    #define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ## __VA_ARGS__] UTF8String]);
    NSString *format = @"\t";
    NSLog(@"@encode(char)%@ %s", format, @encode(char));
    NSLog(@"@encode(int)%@ %s", format, @encode(int));
    NSLog(@"@encode(long)%@ %s", format, @encode(long));
    NSLog(@"@encode(long long)%@ %s", format, @encode(long long));
    NSLog(@"@encode(unsigned char)%@ %s", format, @encode(unsigned char));
    NSLog(@"@encode(unsigned int)%@ %s", format, @encode(unsigned int));
    NSLog(@"@encode(unsigned short)%@ %s", format, @encode(unsigned short));
    NSLog(@"@encode(unsigned long)%@ %s", format, @encode(unsigned long));
    NSLog(@"@encode(unsigned long long)%@ %s", format, @encode(unsigned long long));
    NSLog(@"@encode(float)%@ %s", format, @encode(float));
    NSLog(@"@encode(float *)%@ %s", format, @encode(float *));
    NSLog(@"@encode(double)%@ %s", format, @encode(double));
    NSLog(@"@encode(double *)%@ %s", format, @encode(double *));
    NSLog(@"@encode(BOOL)%@ %s", format, @encode(BOOL));
    NSLog(@"@encode(void)%@ %s", format, @encode(void));
    NSLog(@"@encode(void *)%@ %s", format, @encode(void *));
    NSLog(@"@encode(char *)%@ %s", format, @encode(char *));
    NSLog(@"@encode(NSObject)%@ %s", format, @encode(NSObject));
    NSLog(@"@encode(NSObject *)%@ %s", format, @encode(NSObject *));
    NSLog(@"@encode([NSObject class])%@ %s", format, @encode(typeof([NSObject class])));
    NSLog(@"@encode(SEL)%@ %s", format, @encode(typeof(@selector(viewDidLoad))));
    int intArray[3] = { 0, 0, 0 };
    NSLog(@"@encode(intArray)%@ %s", format, @encode(typeof(intArray)));
    float floatArray[3] = { 0.1f, 0.2f, 0.3f };
    NSLog(@"@encode(floatArray)%@ %s", format, @encode(typeof(floatArray)));
    typedef struct _struct {
        short a;
        long long b;
        unsigned long long c;
        double *d;
    } Struct;
    NSLog(@"@encode(Struct)%@ %s", format, @encode(typeof(Struct)));
    //    @interface NSError : NSObject <NSCopying, format,NSSecureCoding> {
    //        @private
    //        void *_reserved;
    //        NSInteger _code;
    //        NSString *_domain;
    //        NSDictionary *_userInfo;
    //    }
    NSLog(@"@encode(NSError)%@ %s", format, @encode(NSError));
    NSLog(@"@encode(NSError ** )%@ %s", format, @encode(typeof(NSError **)));
}
```
打印结果 
```
@encode(char)	 c
@encode(int)	 i
@encode(long)	 q
@encode(long long)	 q
@encode(unsigned char)	 C
@encode(unsigned int)	 I
@encode(unsigned short)	 S
@encode(unsigned long)	 Q
@encode(unsigned long long)	 Q
@encode(float)	 f
@encode(float *)	 ^f
@encode(double)	 d
@encode(double *)	 ^d
@encode(BOOL)	 B
@encode(void)	 v
@encode(void *)	 ^v
@encode(char *)	 *
@encode(NSObject)	 {NSObject=#}
@encode(NSObject *)	 @
@encode([NSObject class])	 #
@encode(SEL)	 :
@encode(intArray)	 [3i]
@encode(floatArray)	 [3f]
@encode(Struct)	 {_struct=sqQ^d}
@encode(NSError)	 {NSError=#^vq@@}
@encode(NSError ** )	 ^@
```

### 注意 在longlong 和 long 中和苹果官方给的不同 都是 q 不是 l,在unsigned longlong 和unsigned long 中和苹果官方给的不同 都是 Q 不是 L 
这是苹果的官网给的解释,由于在工作中用不到,所以我也没有细看
数组的类型代码括在方括号内； 数组中元素的数量是在括号之后，数组类型之前指定的。 例如，由12个指向浮点数的指针组成的数组将编码为：[12^f]

在括号内指定结构，在括号内指定并集。 首先列出结构标签，然后依次列出等号和结构字段的代码。 例如结构

```
typedef struct example {
    id   anObject;
    char *aString;
    int  anInt;
} Example;

{example=@*i}
```
The same encoding results whether the defined type name (Example) or the structure tag (example) is passed to @encode(). The encoding for a structure pointer carries the same amount of information about the structure’s fields:

^{example=@*i}
However, another level of indirection removes the internal type specification:

^^{example}
Objects are treated like structures. For example, passing the NSObject class name to @encode() yields this encoding:

{NSObject=#}
The NSObject class declares just one instance variable, isa, of type Class.

Note that although the @encode() directive doesn’t return them, the runtime system uses the additional encodings listed in Table 6-2 for type qualifiers when they’re used to declare methods in a protocol.
6-2

| Code | Meaning |
| --- | --- | 
| r | const |  
| n | in |  
| N | inout |  
| o | out |  
| O | bycopy |  
| bycopy | byref |  
| V | oneway |  