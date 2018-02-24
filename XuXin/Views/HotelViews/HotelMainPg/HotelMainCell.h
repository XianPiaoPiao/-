//
//  HotelMainCell.h
//  XuXin
//
//  Created by xian on 2018/2/2.
//  Copyright © 2018年 xienashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelMainCell : UITableViewCell

/**
 初始化列表

 @param tableView 列表
 @return cell
 */
+ (instancetype)initWithTableView:(UITableView *)tableView;
/**
 绑定数据

 @param data 数据源
 */
- (void)showData:(id)data;
/**
 计算collectionView动态高度

 @param data 数据源
 @return 高度
 */
+ (CGFloat)getHeight:(id)data;
@end
