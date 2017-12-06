//
//  User.m
//  XuXin
//
//  Created by xuxin on 16/9/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "User.h"

@implementation User
+(instancetype)defalutManager{
    static User * user = nil;

    static dispatch_once_t onceToken = 0 ;
    dispatch_once(&onceToken, ^{
        if (!user) {
            user = [[User alloc] initPrivate];
       
        }
    });
    return user;
}
-(instancetype)init{
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];

}

-(instancetype)initPrivate{
    if (self = [super init]) {
        
        self.selectedCityID = @"4524461";
        self.selectedCityName = @"重庆市";
        
    }
    return self;
}
@end
