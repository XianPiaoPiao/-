//
//  GoodsLIstViewController.h
//  XuXin
//
//  Created by xuxin on 16/10/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface GoodsLIstViewController : BaseViewContrlloer
@property (nonatomic ,strong)NSMutableArray * goodsModelArray;
@property (nonatomic ,assign)NSInteger goodsType;
@property (nonatomic ,assign)NSInteger  goodsCount;
//从哪儿进入
@property (nonatomic ,assign)NSInteger shopCarType;

@property (nonatomic ,assign)CGFloat goodsPirce;

@end
