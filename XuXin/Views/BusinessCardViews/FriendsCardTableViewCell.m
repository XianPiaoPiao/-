//
//  FriendsCardTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/9/23.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "FriendsCardTableViewCell.h"
#import "BusinessCardModel.h"

@implementation FriendsCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(BusinessCardModel *)model{
    
    self.nameLabel.text = model.username;
    self.jobLabel.text = model.job;
    self.addressLabel.text = model.company;
    
    UILabel *wordL = [UILabel new];
    NSString *str = [model.username substringToIndex:1];
    wordL.text = str;
    wordL.font = [UIFont systemFontOfSize:24.0];
    wordL.textAlignment = NSTextAlignmentCenter;
    wordL.layer.cornerRadius = 55/2.0;
    wordL.layer.masksToBounds = YES;
    [self.headImgView addSubview:wordL];
    wordL.backgroundColor = [UIColor whiteColor];
    [wordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
