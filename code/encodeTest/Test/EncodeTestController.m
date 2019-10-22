//
//ViewController.m
//Test
//
//Created by  steveKwok on 2019/10/22.
//Copyright © 2019 steveKwok. All rights reserved.
//

#import "EncodeTestController.h"

@interface EncodeTestController ()

@end

@implementation EncodeTestController

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

@end
