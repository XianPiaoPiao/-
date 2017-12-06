//
//  User.h
//  XuXin
//
//  Created by xuxin on 16/9/13.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
//选择商家的ID
@property (nonatomic ,copy)NSString * selectedShop;
//消息
@property (nonatomic ,assign)NSInteger bage;
//选择城市的ID
@property (nonatomic ,copy)NSString * selectedCityID;

@property (nonatomic ,copy)NSString * selectedCityName;

//选择商品ID
@property (nonatomic,copy)NSString * selectedGoodsID;
//选择类型
@property (nonatomic,assign)NSInteger  selectedType;

//购物车数量
@property (nonatomic,copy)NSString * id;

@property (nonatomic, assign) NSInteger user_sum;

@property (nonatomic, assign) NSInteger userrefs_num;

@property (nonatomic, assign) NSInteger ig_order;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger myorder;

@property (nonatomic, assign) CGFloat preDeposit;

@property (nonatomic, assign) CGFloat balance;

@property (nonatomic, assign) NSInteger ig_count;

@property (nonatomic, assign) NSInteger redPacket;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger ref_red_sum;

@property (nonatomic, assign) long long  birthday;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, assign) NSInteger shopcart;

@property (nonatomic, assign) NSInteger favs_store;

@property (nonatomic, assign) NSInteger faceorder;

@property (nonatomic, assign) NSInteger favs_goods;

@property (nonatomic, copy) NSString * photo;

@property (nonatomic, assign) NSInteger tuanorder;

@property (nonatomic ,copy)NSString * selfLocation;

@property (nonatomic ,strong)CLLocation * userLocation;

@property (nonatomic ,assign)NSInteger lineShopCart;

@property (nonatomic, copy) NSString *ucard;

+(instancetype)defalutManager;

@end
