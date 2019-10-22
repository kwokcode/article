autorelease 的内部使用的双向链表
class AutoreleasePoolPage 
{
// 内存是4096
    magic_t const magic;
    id *next;
    pthread_t const thread;
    AutoreleasePoolPage * const parent;
    AutoreleasePoolPage *child;
    uint32_t const depth;
    uint32_t hiwat;

     id * begin() {
        return (id *) ((uint8_t *)this+sizeof(*this));// 起始地址加上自己
    }

    id * end() {
        return (id *) ((uint8_t *)this+SIZE);
    }

    push POOL_BOUNDARY 
    

}
