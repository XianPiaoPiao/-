//
//  HaiduiArchiverTools.h
//  XuXin
//
//  Created by xuxin on 16/9/18.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HaiduiArchiverTools : NSObject
//归档的工具方法
+ (void)archiverObject:(id)object ByKey:(NSString *)key
              WithPath:(NSString *)path;

+ (id)unarchiverObjectByKey:(NSString *)key
                   WithPath:(NSString *)path;
@end
