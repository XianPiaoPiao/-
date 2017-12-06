//
//  CoverDetailViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BaseViewContrlloer.h"
typedef enum {
    ENUM_orderBy=1,//
    ENUM_orderBy_price =2,//
    ENUM_orderBy_salenumber =3,//
  }ENUM_orderByParams;
@interface HDCoverDetailViewController : BaseViewContrlloer
@property (nonatomic ,strong)NSString * idName;
@end
