//
//  DBConfig.h
//  ZJInternetHospital
//
//  Created by czc on 2019/7/23.
//  Copyright © 2019 zjjk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,DBMode) {
    /**
     *  生产环境
     */
    DBModeDis = 1,
    /**
     *  开发环境
     */
    DBModeDev = 2,
    /**
     *  测试库
     */
    DBModeTest = 3
};

typedef NS_ENUM(NSUInteger,GlIpType) {
    /**
     *  正式库地址
     */
    IpTypeDis = 1,
    /**
     *  开发地址
     */
    IpTypeDev = 2,
    /**
     *  测试地址
     */
    IpTypeTest = 3,
    /**
     *  自定义地址
     */
    IpTypeCustom = 4,
    
};

typedef enum : NSUInteger {
    Build_DB_Default,
    Build_DB_Debug,
    Build_DB_Release,
} XMZJDBConfigBuildConfig;

@interface DBConfig : NSObject
+ (DBConfig *)sharedInstance;
+ (DBConfig *)sharedInstance:(XMZJDBConfigBuildConfig)buildConfiguration;

@property (nonatomic,readonly) DBMode           dbMode;//数据库代码
@property (nonatomic,readonly) GlIpType         ipType;//接口代码
@property (nonatomic,readonly) NSString         *dbModeName;//获取数据库名字
@property (nonatomic,readonly) NSString         *ipTypeName;//获取接口类型名字

/**
 切换数据库环境
 
 @param dbMode 数据库模式
 */
- (void)switchDBByDBMode:(DBMode)dbMode;

@end

NS_ASSUME_NONNULL_END
