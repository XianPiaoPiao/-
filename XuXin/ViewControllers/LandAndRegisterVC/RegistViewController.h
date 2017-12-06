//
//  RegistViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface RegistViewController : BaseViewContrlloer

@property (nonatomic ,copy)NSString * requestUrl;
@property (nonatomic ,assign)CodeType type;
@property (nonatomic ,copy)NSString * bankCardId;

@property (nonatomic ,strong)NSMutableDictionary * param;


@end
