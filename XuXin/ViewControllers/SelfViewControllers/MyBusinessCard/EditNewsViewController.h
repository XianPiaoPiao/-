//
//  EditNewsViewController.h
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface EditNewsViewController : BaseViewContrlloer

///1:编辑状态;0:阅读状态;2:修改状态
@property (nonatomic, assign) NSInteger editType;
///1:自己;0:好友
@property (nonatomic ,assign)NSInteger  type;
/// 介绍：个人0还是公司1
@property (nonatomic, assign) NSInteger intrType;
///Introduction
@property (nonatomic, assign) NSInteger introductionType;

@property (nonatomic ,copy)NSString * ccId;//如果是修改，本来的ID

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic, copy) NSString *contentDetail;

@property (nonatomic, copy) NSString *logoId;

@property (nonatomic, copy) NSString *titleContent;

@property (nonatomic, copy) NSString *logoUrlPath;

@end
