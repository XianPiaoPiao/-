//
//  ShopListModel.m
//  XuXin
//
//  Created by xuxin on 16/9/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopListModel


+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [Result class]};
}
@end





@implementation Result

+ (NSDictionary *)objectClassInArray{
    return @{@"childs" : [Childs class]};
}

@end


@implementation Childs

+ (NSDictionary *)objectClassInArray{
    
    return @{@"childs" : [ChildsChilds class]};
}

@end


@implementation ParentParent

@end


@implementation ChildsChilds

@end


@implementation Parent

@end


