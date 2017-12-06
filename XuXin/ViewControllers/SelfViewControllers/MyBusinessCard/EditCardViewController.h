//
//  EditCardViewController.h
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface EditCardViewController : BaseViewContrlloer
///1:编辑状态;0:阅读状态;2:修改状态
@property (nonatomic, assign) NSInteger editType;
@property (nonatomic, copy) NSString *cardId;
@end
