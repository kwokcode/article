```
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NetTypeUnknown,
    NetType2G,
    NetType3G,
    NetType4G,
} NetDetailType;

@interface XHSystemInfo : NSObject


#pragma mark - 硬件

/**
 是否是真机 (YES：真机；NO:模拟器)
 
 @return 是否是真机
 */
+ (BOOL)BDADdeviceString;

/**
 获取当前设备可用内存(单位：MB）
 
 @param type 返回字符串类型(1:eg 12.34MB; 2:eg 12.345678; 3:eg 12.34)
 @return 可用内存字符串
 */
+ (NSString *)availableMemoryWithType:(int)type;

/**
 获取当前任务所占用的内存（单位：MB）
 
 @return 浮点型字符串
 */
+ (NSString *)usedMemory;

/**
 cpu类型
 
 @return cpu类型
 */
+ (NSString *)getCPUType;

/**
 设备总内存（单位：MB）
 
 @return 浮点型字符串(eg:12.34MB)
 */
+ (NSString *)getTotalMemoryBytes;

/**
 获取设备PPI
 
 @return 设备PPI
 */
+ (NSInteger)getIOSPPI;

#pragma mark - 系统

/**
 获取系统
 
 @return 系统信息
 */
+ (NSString *)deviceString;


/**
 获取广告标识
 
 @return IDFA
 */
+ (NSString *)getIDFA;

/**
 获取系统版本号
 
 @return 系统版本号
 */
+ (float)getIOSVersion;

#pragma mark - 网络

/**
 获取设备当前网络IP地址
 
 @param preferIPv4 是否是IPv4
 @return 网络IP地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

/**
 获取当前具体的蜂窝网络类型
 
 @return 具体的蜂窝网络类型
 */
+ (NetDetailType)getCurrentNetDetailType;

/**
 获取运营商
 
 @return 获取运营商名字
 */
+ (NSString *)getCarrier;
```
```
#import "XHSystemInfo.h"
#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#import <mach/mach.h>
#import <UIKit/UIKit.h>

//获取ip地址相关
#import <AdSupport/AdSupport.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation XHSystemInfo {
    
    uint32_t _iBytes;
    uint32_t _oBytes;
    uint32_t _allFlow;
    uint32_t _wifiIBytes;
    uint32_t _wifiOBytes;
    uint32_t _wifiFlow;
    uint32_t _wwanIBytes;
    uint32_t _wwanOBytes;
    uint32_t _wwanFlow;
}
#pragma mark - 硬件

// 是否是真机 (YES：真机；NO:模拟器)
+ (BOOL )BDADdeviceString {
    if ([[XHSystemInfo deviceString] isEqualToString:@"iPhone Simulator"]) {
        return NO;
    }
    return YES;
}

// 获取当前设备可用内存(单位：MB）
+ (NSString *)availableMemoryWithType:(int)type {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return @"";
    }
    NSString *tempStr=@"未知";
    if(type==1){
        tempStr=[NSString stringWithFormat:@"%.2fMB",((vm_page_size *vmStats.free_count) / 1000.0) / 1000.0];
    }else if(type==2){
        tempStr=[NSString stringWithFormat:@"%f",((vm_page_size *vmStats.free_count) / 1000.0) / 1000.0];
    }else{
        tempStr=[NSString stringWithFormat:@"%.2f",((vm_page_size *vmStats.free_count) / 1000.0) / 1000.0];
    }
    return tempStr;
}

// 获取当前任务所占用的内存（单位：MB）
+ (NSString *)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return @"";
    }
    NSString *tempStr=[NSString stringWithFormat:@"%f",taskInfo.resident_size / 1000.0 / 1024.0];
    return tempStr ;
}

//cpu类型
+ (NSString*)getCPUType {
    NSString *cpu;
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    cpu=[NSString stringWithFormat:@"0x%x,0x%x",type,subtype];
    return cpu;
    
}

//设备总内存
+ (NSString *)getTotalMemoryBytes {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_PHYSMEM};
    sysctl(mib, 2, &results, &size, NULL, 0);
    NSString *tempStr=[NSString stringWithFormat:@"%.2fMB",results / 1000.0 / 1000.0];
    return tempStr;
}


// 获取设备PPI
+ (NSInteger)getIOSPPI {
    
    int mib[2]={CTL_HW,HW_MACHINE};
    size_t len;
    char *machine;
    
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    BOOL isMini = NO;
    if ([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] || [platform isEqualToString:@"iPad4,6"]){
        isMini = YES;
    }
    NSInteger scale = [UIScreen mainScreen].scale;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 163 * scale;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (isMini) {
            return 163 * scale;
        } else {
            return 132 * scale;
        }
    } else {
        return 163 * scale;
    }
}

#pragma mark - 系统
//获取系统
+ (NSString*)deviceString {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICESTRING"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"DEVICESTRING"];
    } else {
        NSString *platform = [self getDeviceString];
        [[NSUserDefaults standardUserDefaults]  setObject:platform forKey:@"DEVICESTRING"];
        return platform;
    }
}

/**
 获取广告标识
 */
+ (NSString *)getIDFA {
    NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adid;
}


// 获取系统版本号
+ (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - 网络
/**
 获取设备当前网络IP地址
 */

+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}


// 获取当前具体的蜂窝网络类型
+ (NetDetailType)getCurrentNetDetailType; {
    
    NetDetailType netconnType;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentStatus;
    if (@available(iOS 12.0, *)) {
        NSDictionary *technologyDict = info.serviceCurrentRadioAccessTechnology;
        currentStatus = [[technologyDict allValues] firstObject];
    } else {
        currentStatus = info.currentRadioAccessTechnology;
    }
    
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = NetType2G; // GPRS
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = NetType2G; // 2.75G EDGE
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        netconnType = NetType3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        netconnType = NetType3G;  // 3.5G HSDPA
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        netconnType = NetType3G; // 3.5G HSUPA
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        netconnType = NetType2G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        netconnType = NetType3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        netconnType = NetType3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        netconnType = NetType3G;
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        netconnType = NetType4G; // HRPD
    }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        netconnType = NetType4G;
    }else {
        netconnType = NetTypeUnknown;
    }
    
    return netconnType;
}

/** 获取运营商 */
+ (NSString *)getCarrier{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier;
    if (@available(iOS 12, *)) {
        NSDictionary *carrierDict = info.serviceSubscriberCellularProviders;
        carrier = [carrierDict.allValues firstObject];
    }else {
        carrier = [info subscriberCellularProvider];
    }
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        mobile = @"无运营商";
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
}


#pragma mark - private

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            [ipAddress substringWithRange:resultRange];
            //输出结果
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses {
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSString *)getDeviceString {
    int mib[2]={CTL_HW,HW_MACHINE};
    size_t len;
    char *machine;
    
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone Xs";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone Xs Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone Xs Max";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro (10.5-inch)";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad mini (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad mini (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad mini (A1455)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3 (A1601)";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4 (A1550)";
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro 10.5";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro 10.5";
    
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}


@end

```
