
性能从高到低排序
os_unfair_lock iOS //10 之后才可以使用
OSSpinLock // iOS10 之后不建议使用
dispatch_semaphore // 我个人比较喜欢使用
pthread_mutex // 我个人比较喜欢使用
dispatch_queue(DISPATCH_QUEUE_SERIAL)
NSLock // 封装  pthread_mutex
NSCondition 
pthread_mutex(recursive) // 递归锁
NSRecursiveLock
NSConditionLock
@synchronized 可以直接在GNU 里面看相关的代码

陆陆续续会更新相关的锁的知识
