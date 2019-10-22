# Runtime api 类

/** 
 * Creates a new class and metaclass.
 * 
 * @param superclass The class to use as the new class's superclass, or \c Nil to create a new root class.
 * @param name The string to use as the new class's name. The string will be copied.
 * @param extraBytes The number of bytes to allocate for indexed ivars at the end of 
 *  the class and metaclass objects. This should usually be \c 0.
 * 
 * @return The new class, or Nil if the class could not be created (for example, the desired name is already in use).
 * 
 * @note You can get a pointer to the new metaclass by calling \c object_getClass(newClass).
 * @note To create a new class, start by calling \c objc_allocateClassPair. 
 *  Then set the class's attributes with functions like \c class_addMethod and \c class_addIvar.
 *  When you are done building the class, call \c objc_registerClassPair. The new class is now ready for use.
 * @note Instance methods and instance variables should be added to the class itself. 
 *  Class methods should be added to the metaclass.
 */
动态创建一个类（参数：父类，类名，额外的内存）
OBJC_EXPORT Class _Nullable
objc_allocateClassPair(Class _Nullable superclass, const char * _Nonnull name, size_t extraBytes) 
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);


/** 
 * Registers a class that was allocated using \c objc_allocateClassPair.
 * 
 * @param cls The class you want to register.
 */
 注册一个类（要在类注册之前添加成员变量）
OBJC_EXPORT void
objc_registerClassPair(Class _Nonnull cls) 
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);

void objc_registerClassPair(Class cls) 

销毁一个类
void objc_disposeClassPair(Class cls)

获取isa指向的Class
Class object_getClass(id obj)

设置isa指向的Class
Class object_setClass(id obj, Class cls)

判断一个OC对象是否为Class
BOOL object_isClass(id obj)

判断一个Class是否为元类
BOOL class_isMetaClass(Class cls)

获取父类
Class class_getSuperclass(Class cls)
