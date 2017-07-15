//
//  DeviceTool.h
//  SuperStudy2
//
//  Created by xby on 2016/11/1.
//  Copyright © 2016年 wanxue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain/SSKeychain.h>

/**
 获取设备信息工具类
 */
@interface DeviceTool : NSObject

+ (instancetype)sharedInstance;

///设备型号
@property (copy,nonatomic,readonly) NSString *deviceModel;
///设备的UUID
@property (copy,nonatomic,readonly) NSString *uuid;
/// 设备可用容量 单位 M
@property (assign,nonatomic,readonly) CGFloat availableDiskSize;


/**
 初始化UUID，该方法主要是为了升级的时候以前已经设置过了需要获取以前的UUID，一般不用

 @param uuid uuid
 */
- (void)setUpUUID:(NSString *)uuid;
/// 删除UUID
- (void)removeUUID;

@end
