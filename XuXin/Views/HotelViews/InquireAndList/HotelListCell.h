//
//  HotelListCell.h
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelListCell : UITableViewCell

/**
 初始化cell
 
 @param tbView 列表
 @return cell
 */
+(instancetype)initWithTbView:(UITableView *)tbView;

/**
 绑定数据
 
 @param data 数据源
 */
-(void)showData:(id)data;

/**
 cell高度
 
 @return 高度
 */
+(CGFloat)getHeight;

@end
