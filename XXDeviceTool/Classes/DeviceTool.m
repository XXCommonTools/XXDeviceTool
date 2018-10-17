//
//  DeviceTool.m
//  SuperStudy2
//
//  Created by xby on 2016/11/1.
//  Copyright © 2016年 wanxue. All rights reserved.
//

#import "DeviceTool.h"
#import <sys/sysctl.h>
#import <sys/mount.h>

@interface DeviceTool ()


///设备型号
@property (copy,nonatomic,readwrite) NSString *deviceModel;
///设备的UUID
@property (copy,nonatomic,readwrite) NSString *uuid;

@property (copy,nonatomic) NSString *xxKeyChainService;
@property (copy,nonatomic) NSString *xxKeyChainAccount;



@end


@implementation DeviceTool

#pragma mark - life cycle
- (void)dealloc {

#ifdef DEBUG
    
    NSLog(@"%s",__func__);
    
#endif
}
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static DeviceTool *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[DeviceTool alloc] init];
    });
    return sharedInstance;
}
#pragma mark - private
- (void)saveUUIDToKeyChain:(NSString *)uuid service:(NSString *)service account:(NSString *)account {
    
    BOOL flag = [SSKeychain setPassword:uuid forService:service account:account];
    if (flag) {
        
#ifdef DEBUG
        
        NSLog(@"保存uuid 到钥匙链成功");
#endif
        
    } else {
        
#ifdef DEBUG
        
        NSLog(@"保存uuid到钥匙链失败");
#endif
    }
}
#pragma mark - public
/// 删除UUID
- (void)removeUUID {

    self.uuid = nil;
    [SSKeychain deletePasswordForService:self.xxKeyChainService account:self.xxKeyChainAccount];
}
- (void)setUpUUID:(NSString *)uuid {

    if (uuid.length > 0) {
        
        self.uuid = uuid;
        //保存到钥匙链中和沙盒中
        [self saveUUIDToKeyChain:uuid service:self.xxKeyChainService account:self.xxKeyChainAccount];
    }
}
#pragma mark - getters and setters
- (NSString *)uuid {

    if (!_uuid) {
        
        //去钥匙链中获取uuid
        NSString *keyChainUUID = [SSKeychain passwordForService:self.xxKeyChainService account:self.xxKeyChainAccount];
        if (keyChainUUID) {
            
            _uuid = keyChainUUID;
            
        } else {
            
            //获取 uuid 存到沙盒
            NSString *systemUUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
            _uuid = systemUUID;
            [self saveUUIDToKeyChain:systemUUID service:self.xxKeyChainService account:self.xxKeyChainAccount];
        }
    }
    return _uuid;
}
- (CGFloat)availableDiskSize {

    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace / 1024.0f / 1024.0f;
}
- (NSString *)xxKeyChainService {
    
    if (!_xxKeyChainService) {
        
        _xxKeyChainService = @"XXDeviceKeyChainUUID";
    }
    return _xxKeyChainService;
}
- (NSString *)xxKeyChainAccount {
    
    if (!_xxKeyChainAccount) {
        
        NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
        NSString *bundleId = dict[@"CFBundleIdentifier"];
        NSString *xxKeyChainAccount = [NSString stringWithFormat:@"XXKeyChainAccount_%@",bundleId];
        
        _xxKeyChainAccount = xxKeyChainAccount;
    }
    return _xxKeyChainAccount;
}
- (NSString *)deviceModel {
    
    if (!_deviceModel) {
        
        int mib[2];
        size_t len;
        char *machine;
        
        mib[0] = CTL_HW;
        mib[1] = HW_MACHINE;
        sysctl(mib, 2, NULL, &len, NULL, 0);
        machine = malloc(len);
        sysctl(mib, 2, machine, &len, NULL, 0);
        
        NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
        free(machine);
        
        // iPhone
        if ([platform isEqualToString:@"iPhone1,1"]) {
            
            _deviceModel = @"iPhone2G";
            
        } else if ([platform isEqualToString:@"iPhone1,2"]) {
            
            _deviceModel = @"iPhone3G";
            
        } else if ([platform isEqualToString:@"iPhone2,1"]) {
            
            _deviceModel = @"iPhone3GS";
            
        } else if ([platform isEqualToString:@"iPhone3,1"]) {
            
            _deviceModel = @"iPhone4";
            
        } else if ([platform isEqualToString:@"iPhone3,2"]) {
            
            _deviceModel = @"iPhone4";
            
        } else if ([platform isEqualToString:@"iPhone3,3"]) {
            
            _deviceModel = @"iPhone4";
            
        } else if ([platform isEqualToString:@"iPhone4,1"]) {
            
            _deviceModel = @"iPhone4S";
            
        } else if ([platform isEqualToString:@"iPhone5,1"]) {
            
            _deviceModel = @"iPhone5";
            
        } else if ([platform isEqualToString:@"iPhone5,2"]) {
            
            _deviceModel = @"iPhone5";
            
        } else if ([platform isEqualToString:@"iPhone5,3"]) {
            
            _deviceModel = @"iPhone5c";
            
        } else if ([platform isEqualToString:@"iPhone5,4"]) {
            
            _deviceModel = @"iPhone5c";
            
        } else if ([platform isEqualToString:@"iPhone6,1"]) {
            
            _deviceModel = @"iPhone5s";
            
        } else if ([platform isEqualToString:@"iPhone6,2"]) {
            
            _deviceModel = @"iPhone5s";
            
        } else if ([platform isEqualToString:@"iPhone7,2"]) {
            
            _deviceModel = @"iPhone6";
            
        } else if ([platform isEqualToString:@"iPhone7,1"]) {
            
            _deviceModel = @"iPhone6Plus";
            
        } else if ([platform isEqualToString:@"iPhone8,1"]) {
            
            _deviceModel = @"iPhone6s";
            
        } else if ([platform isEqualToString:@"iPhone8,2"]) {
            
            _deviceModel = @"iPhone6sPlus";
            
        } else if ([platform isEqualToString:@"iPhone8,3"]) {
            
            _deviceModel = @"iPhoneSE";
            
        } else if ([platform isEqualToString:@"iPhone8,4"]) {
            
            _deviceModel = @"iPhoneSE";
            
        } else if ([platform isEqualToString:@"iPhone9,1"]) {
            
            _deviceModel = @"iPhone7";
            
        } else if ([platform isEqualToString:@"iPhone9,2"]) {
            
            _deviceModel = @"iPhone7Plus";
            
        } else if ([platform isEqualToString:@"iPhone10,1"]) {
            
            _deviceModel = @"iPhone8";
            
        } else if ([platform isEqualToString:@"iPhone10,4"]) {
            
            _deviceModel = @"iPhone8";
            
        } else if ([platform isEqualToString:@"iPhone10,2"]) {
            
            _deviceModel = @"iPhone8Plus";
            
        } else if ([platform isEqualToString:@"iPhone10,5"]) {
            
            _deviceModel = @"iPhone8Plus";
            
        } else if ([platform isEqualToString:@"iPhone10,3"]) {
            
            _deviceModel = @"iPhoneX";
            
        } else if ([platform isEqualToString:@"iPhone10,6"]) {
            
            _deviceModel = @"iPhoneX";
            
        } else if ([platform isEqualToString:@"iPhone11,2"]) {
            
            _deviceModel = @"iPhoneXS";
            
        } else if ([platform isEqualToString:@"iPhone11,4"]) {
            
            _deviceModel = @"iPhoneXS Max";
            
        } else if ([platform isEqualToString:@"iPhone11,6"]) {
            
            _deviceModel = @"iPhoneXS Max";
            
        } else if ([platform isEqualToString:@"iPhone11,8"]) {
            
            _deviceModel = @"iPhoneXR";
            
        } else if ([platform isEqualToString:@"iPod1,1"]) {
            
            //iPod Touch
            _deviceModel = @"iPodTouch";
            
        } else if ([platform isEqualToString:@"iPod2,1"]) {
            
            _deviceModel = @"iPodTouch2G";
            
        } else if ([platform isEqualToString:@"iPod3,1"]) {
            
            _deviceModel = @"iPodTouch3G";
            
        } else if ([platform isEqualToString:@"iPod4,1"]) {
            
            _deviceModel = @"iPodTouch4G";
            
        } else if ([platform isEqualToString:@"iPod5,1"]) {
            
            _deviceModel = @"iPodTouch5G";
            
        } else if ([platform isEqualToString:@"iPod7,1"]) {
            
            _deviceModel = @"iPodTouch6G";
            
        } else if ([platform isEqualToString:@"iPad1,1"]) {
            
            //iPad
            _deviceModel = @"iPad";
            
        } else if ([platform isEqualToString:@"iPad2,1"]) {
            
            _deviceModel = @"iPad2";
            
        } else if ([platform isEqualToString:@"iPad2,2"]) {
            
            _deviceModel = @"iPad2";
            
        } else if ([platform isEqualToString:@"iPad2,3"]) {
            
            _deviceModel = @"iPad2";
            
        } else if ([platform isEqualToString:@"iPad2,4"]) {
            
            _deviceModel = @"iPad2";
            
        } else if ([platform isEqualToString:@"iPad3,1"]) {
            
            _deviceModel = @"iPad3";
            
        } else if ([platform isEqualToString:@"iPad3,2"]) {
            
            _deviceModel = @"iPad3";
            
        } else if ([platform isEqualToString:@"iPad3,3"]) {
            
            _deviceModel = @"iPad3";
            
        } else if ([platform isEqualToString:@"iPad3,4"]) {
            
            _deviceModel = @"iPad4";
            
        } else if ([platform isEqualToString:@"iPad3,5"]) {
            
            _deviceModel = @"iPad4";
            
        }  else if ([platform isEqualToString:@"iPad3,6"]) {
            
            _deviceModel = @"iPad4";
            
        } else if ([platform isEqualToString:@"iPad4,1"]) {
            
            //iPad Air
            _deviceModel = @"iPadAir";
            
        } else if ([platform isEqualToString:@"iPad4,2"]) {
            
            _deviceModel = @"iPadAir";
            
        } else if ([platform isEqualToString:@"iPad4,3"]) {
            
            _deviceModel = @"iPadAir";
            
        } else if ([platform isEqualToString:@"iPad5,3"]) {
            
            _deviceModel = @"iPadAir2";
            
        } else if ([platform isEqualToString:@"iPad5,4"]) {
            
            _deviceModel = @"iPadAir2";
            
        } else if ([platform isEqualToString:@"iPad6,7"] || [platform isEqualToString:@"iPad6,8"]) {
            
            _deviceModel = @"iPad Pro 12.9-inch";
            
        } else if ([platform isEqualToString:@"iPad6,3"] || [platform isEqualToString:@"iPad6,4"]) {
            
            _deviceModel = @"iPad Pro iPad 9.7-inch";
            
        } else if ([platform isEqualToString:@"iPad6,11"] || [platform isEqualToString:@"iPad6,12"]) {
            
            _deviceModel = @"iPad 5";
            
        } else if ([platform isEqualToString:@"iPad7,1"] || [platform isEqualToString:@"iPad7,2"]) {
            
            _deviceModel = @"iPad Pro 12.9-inch 2";
        
        }  if ([platform isEqualToString:@"iPad7,3"] || [platform isEqualToString:@"iPad7,4"]) {
            
            _deviceModel = @"iPad Pro 10.5-inch";
        
        }else if ([platform isEqualToString:@"iPad2,5"]) {
            
            //iPad mini
            _deviceModel = @"iPadmini1G";
            
        } else if ([platform isEqualToString:@"iPad2,6"]) {
            
            
            _deviceModel = @"iPadmini1G";
            
        } else if ([platform isEqualToString:@"iPad2,7"]) {
            
            _deviceModel = @"iPadmini1G";
            
        } else if ([platform isEqualToString:@"iPad4,4"]) {
            
            _deviceModel = @"iPadmini2";
            
        } else if ([platform isEqualToString:@"iPad4,5"]) {
            
            _deviceModel = @"iPadmini2";
            
        } else if ([platform isEqualToString:@"iPad4,6"]) {
            
            _deviceModel = @"iPadmini2";
            
        } else if ([platform isEqualToString:@"iPad4,7"]) {
            
            _deviceModel = @"iPadmini3";
            
        } else if ([platform isEqualToString:@"iPad4,8"]) {
            
            _deviceModel = @"iPadmini3";
            
        } else if ([platform isEqualToString:@"iPad4,9"]) {
            
            _deviceModel = @"iPadmini3";
            
        } else if ([platform isEqualToString:@"iPad5,1"]) {
            
            _deviceModel = @"iPadmini4";
            
        } else if ([platform isEqualToString:@"iPad5,2"]) {
            
            _deviceModel = @"iPadmini4";
            
        } else if ([platform isEqualToString:@"i386"]) {
            
            _deviceModel = @"iPhoneSimulator";
            
        } else if ([platform isEqualToString:@"x86_64"]) {
            
            _deviceModel = @"iPhoneSimulator";
            
        } else {
            
            _deviceModel = [UIDevice currentDevice].localizedModel;
        }
    }
    return _deviceModel;
}



@end
