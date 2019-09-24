//
//  DBConfig.m
//  ZJInternetHospital
//
//  Created by czc on 2019/7/23.
//  Copyright © 2019 zjjk. All rights reserved.
//

#import "DBConfig.h"
#import "LKDBHelper.h"
static XMZJDBConfigBuildConfig buildConfig;

@interface DBConfig ()
@property (nonatomic)      DBMode           dbMode;//数据库代码
@property (nonatomic)      GlIpType         ipType;//接口代码
@property (nonatomic,copy) NSString         *dbModeName;//获取数据库名字
@property (nonatomic,copy) NSString         *ipTypeName;//获取接口类型名字
@end

@implementation DBConfig

+ (DBConfig *)sharedInstance:(XMZJDBConfigBuildConfig)buildConfiguration {
    buildConfig = buildConfiguration;
    return [DBConfig sharedInstance];
}

+ (DBConfig *)sharedInstance {
    static DBConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSInteger dbMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dbMode"] integerValue];
        if (buildConfig == Build_DB_Default) {
#ifdef DEBUG
            //DEBUG版本默认是测试库
            if (dbMode == 0) {
                dbMode = DBModeTest;
            }
#else
            dbMode = DBModeDis;
            [[NSUserDefaults standardUserDefaults] setValue:@(IpTypeDis) forKey:@"GlIPType"];
            
#endif
        }else if (buildConfig == Build_DB_Debug) {
            //DEBUG版本默认是测试库
            if (dbMode == 0) {
                dbMode = DBModeTest;
            }
        }else {
            dbMode = DBModeDis;
            [[NSUserDefaults standardUserDefaults] setValue:@(IpTypeDis) forKey:@"GlIPType"];
        }
        [self switchDBByDBMode:dbMode];
    }
    return self;
}

//切换数据库环境
- (void)switchDBByDBMode:(DBMode)dbMode {
    [[NSUserDefaults standardUserDefaults] setInteger:dbMode forKey:@"dbMode"];
    _dbMode = dbMode;
    NSString *dbName = [NSString stringWithFormat:@"%@_DB.db",self.dbModeName];
    [[NSObject getUsingLKDBHelper] setDBName:dbName];
    NSString* filePath = [LKDBUtils getPathForDocuments:dbName inDir:@"db"];
    NSLog(@"--------------------\n\n\n\n%@\n\n\n\n--------------------",filePath);
}

//获取数据库名字
- (NSString *)dbModeName {
    switch (_dbMode) {
        case DBModeDis:
            _dbModeName = @"Dis";
            break;
        case DBModeDev:
            _dbModeName = @"Dev";
            break;
        case DBModeTest:
            _dbModeName = @"Test";
            break;
        default:
            _dbModeName = @"Dis";
            break;
    }
    return _dbModeName;
}

- (NSString *)ipTypeName {
    if (_ipTypeName) return _ipTypeName;
    switch (self.ipType) {
        case IpTypeDis:
            _ipTypeName = @"正式库";
            break;
        case IpTypeDev:
            _ipTypeName = @"开发库";
            break;
        case IpTypeTest:
            _ipTypeName = @"测试库";
            break;
        case IpTypeCustom:
            _ipTypeName = @"自定义";
            break;
        default:
            _ipTypeName = @"正式库";
            break;
    }
    return _ipTypeName;
}

- (GlIpType)ipType {
    if (_ipType ==0) {
        _ipType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GlIPType"] integerValue];
        if (_ipType==0) {
            if (self.dbMode == DBModeDis) {
                _ipType = IpTypeDis;
                [[NSUserDefaults standardUserDefaults] setValue:@(IpTypeDis) forKey:@"GlIPType"];
            }else {
                _ipType = IpTypeTest;
                [[NSUserDefaults standardUserDefaults] setValue:@(IpTypeTest) forKey:@"GlIPType"];
            }
        }
    }
    return _ipType;
}

@end
