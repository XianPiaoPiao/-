//
//  NewsTableViewCell.h
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextRLabel;

//根据type展示自己的还是好友的
@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, strong) UILabel *nextLeftLabel;

@property (nonatomic, assign) NSInteger type;//1:自己；2:好友

@end
