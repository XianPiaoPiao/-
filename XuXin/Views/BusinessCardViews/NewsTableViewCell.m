//
//  NewsTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _bgView.layer.cornerRadius = 1;
    _bgView.layer.masksToBounds = YES;
    
    _imgView.layer.cornerRadius = 1;
    _imgView.layer.masksToBounds = YES;
    
    _dateLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _dateLabel.layer.cornerRadius = 9;
    _dateLabel.layer.masksToBounds = YES;
}

- (void)setType:(NSInteger)type{
    if (type == 1) {
        _delBtn = [UIButton new];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_delBtn setTitleColor:[UIColor colorWithHexString:WordDeepColor] forState:UIControlStateNormal];
        _delBtn.layer.cornerRadius = 10;
        _delBtn.layer.masksToBounds = YES;
        _delBtn.layer.borderColor = [[UIColor colorWithHexString:WordDeepColor] CGColor];
        _delBtn.layer.borderWidth = 1.0f;
        [self.bgView addSubview:_delBtn];
        
        [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.centerY.equalTo(_nextRLabel.mas_centerY);
            make.size.sizeOffset(CGSizeMake(50, 20));
        }];
        
        _nextRLabel.hidden = NO;
    } else if (type == 0) {
        _nextRLabel.hidden = YES;
        _delBtn.hidden = YES;
        
        _nextLeftLabel = [UILabel new];
        _nextLeftLabel.text = @"查看详情";
        _nextLeftLabel.font = [UIFont systemFontOfSize:12.0f];
        _nextLeftLabel.textColor = [UIColor colorWithHexString:WordDeepColor];
        [self.bgView addSubview:_nextLeftLabel];
        
        [_nextLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.centerY.equalTo(_nextRLabel.mas_centerY);
            make.size.sizeOffset(CGSizeMake(50, 20));
        }];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
