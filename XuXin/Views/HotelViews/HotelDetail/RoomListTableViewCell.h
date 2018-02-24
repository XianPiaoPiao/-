//
//  RoomListTableViewCell.h
//  HotelUIDemo
//
//  Created by xian on 2018/1/27.
//  Copyright © 2018年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListTableViewCell : UITableViewCell

/**
 房间类型
 */
@property (nonatomic, strong) UILabel *nameLbl;

/**
 付款类型
 */
@property (nonatomic, strong) UILabel *payTypeLbl;

/**
 预定满意度
 */
@property (nonatomic, strong) UILabel *satisfactionLbl;

/**
 价格
 */
@property (nonatomic, strong) UILabel *priceLbl;

/**
 预定按钮
 */
@property (nonatomic, strong) UIButton *orderBtn;
@end
