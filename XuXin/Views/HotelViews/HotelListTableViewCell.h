//
//  HotelListTableViewCell.h
//  HotelUIDemo
//
//  Created by xian on 2018/1/27.
//  Copyright © 2018年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelListTableViewCell : UITableViewCell


/**
 酒店主图
 */
@property (nonatomic, strong) UIImageView *mainImgView;
/**
 酒店名称
 */
@property (nonatomic, strong) UILabel *nameLbl;
/**
 酒店评分
 */
@property (nonatomic, strong) UILabel *scoreLbl;
/**
 酒店类型
 */
@property (nonatomic, strong) UILabel *kindLbl;
/**
 点评数量
 */
@property (nonatomic, strong) UILabel *reviewCountLbl;
/**
 距离、地区
 */
@property (nonatomic, strong) UILabel *distanceLbl;
/**
 最新预定
 */
@property (nonatomic, strong) UILabel *latestBookLbl;
/**
 最低价
 */
@property (nonatomic, strong) UILabel *lowPriceLbl;
@end
