//
//  CoverDetailViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
typedef enum {
    ENUM_orderBy=1,//开始
    ENUM_orderBy_price =2,//停止
    ENUM_orderBy_salenumber =3,//暂停
  }ENUM_orderByParams;
@interface CoverDetailViewController : BaseViewContrlloer
@property (nonatomic ,strong)NSString * idName;
@property (nonatomic ,strong)NSString * className;

@end
