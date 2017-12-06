//
//  WriteOrderViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"
#import "receivePlaceModel.h"

@interface WriteOrderViewController : BaseViewContrlloer
@property (nonatomic ,strong)receivePlaceModel * placeModel;

@property (nonatomic ,strong)NSMutableArray * ImageArray;

@property (nonatomic ,strong)NSMutableArray * goodIdaArray;

@property (nonatomic ,assign) CGFloat totalPrice;

@property (nonatomic, assign) CGFloat totalIntegral;

@property (nonatomic ,assign)NSInteger type;//1:立即兑换；2:购物车

@property (nonatomic ,assign)NSInteger count;

@property (nonatomic ,assign)NSInteger shopCarNumber;
//从哪儿进入的
@property (nonatomic ,assign)NSInteger shopCartype;

@property (nonatomic, assign) NSInteger cartId;
///供应商区分平台或其他
@property (nonatomic, strong) NSString *vendor;

@end
