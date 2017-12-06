//
//  ShopListModel.h
//  XuXin
//
//  Created by xuxin on 16/9/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Result,Childs,ParentParent,ChildsChilds,Parent;
@interface ShopListModel : NSObject


@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSArray<Result *> *result;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) BOOL isSucc;


@end

@interface Result : NSObject

@property (nonatomic, strong) NSArray<Childs *> *childs;

@property (nonatomic, assign) BOOL common;

@property (nonatomic, assign) BOOL deleteStatus;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *parent;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) NSInteger sequence;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *firstChar;

@end

@interface Childs : NSObject

@property (nonatomic, strong) NSArray<ChildsChilds *> *childs;

@property (nonatomic, assign) BOOL common;

@property (nonatomic, assign) BOOL deleteStatus;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) ParentParent *parent;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) NSInteger sequence;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *firstChar;

@end

@interface ParentParent : NSObject

@property (nonatomic, copy) NSString *$ref;

@end

@interface ChildsChilds : NSObject

@property (nonatomic, strong) NSArray *childs;

@property (nonatomic, assign) BOOL common;

@property (nonatomic, assign) BOOL deleteStatus;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, strong) Parent *parent;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) NSInteger sequence;

@property (nonatomic, assign) long long addTime;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *firstChar;

@end

@interface Parent : NSObject

@property (nonatomic, copy) NSString *$ref;

@end

