//
//  MessageListModel.h
//  XuXin
//
//  Created by xuxin on 17/3/1.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject
@property (nonatomic ,copy)NSString * content;
@property (nonatomic ,copy)NSString * fromUserId;

@property (nonatomic ,copy)NSString * fromUserName;
@property (nonatomic ,copy)NSString * id;

@property (nonatomic ,copy)NSString * parentId;

@property (nonatomic ,assign)NSInteger  reply_status;

@property (nonatomic ,assign)NSInteger  status;

@property (nonatomic ,copy)NSString * title;

@property (nonatomic ,copy)NSString * toUserId;

@property (nonatomic ,copy)NSString * toUserName;

@property (nonatomic ,assign)NSInteger  type;

@property (nonatomic , assign)NSInteger addTime;

@end
