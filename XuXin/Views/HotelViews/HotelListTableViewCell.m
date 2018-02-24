//
//  HotelListTableViewCell.m
//  HotelUIDemo
//
//  Created by xian on 2018/1/27.
//  Copyright © 2018年 xian. All rights reserved.
//

#import "HotelListTableViewCell.h"
#import "Masonry.h"

@implementation HotelListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(200, 300));
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImgView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(10);
    }];
    
    
}

- (UIImageView *)mainImgView {
    if (!_mainImgView) {
        _mainImgView = [[UIImageView alloc] init];
        [self addSubview:_mainImgView];
    }
    return _mainImgView;
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:_nameLbl];
    }
    return _nameLbl;
}

- (UILabel *)scoreLbl {
    if (!_scoreLbl) {
        _scoreLbl = [[UILabel alloc] init];
        _scoreLbl.font = [UIFont systemFontOfSize:14.0f];
        _scoreLbl.textColor = [UIColor blueColor];
        [self addSubview:_scoreLbl];
    }
    return _scoreLbl;
}

- (UILabel *)kindLbl {
    if (!_kindLbl) {
        _kindLbl = [[UILabel alloc] init];
        _kindLbl.font = [UIFont systemFontOfSize:14.0f];
        _kindLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_kindLbl];
    }
    return _kindLbl;
}

- (UILabel *)reviewCountLbl {
    if (!_reviewCountLbl) {
        _reviewCountLbl = [[UILabel alloc] init];
        _reviewCountLbl.font = [UIFont systemFontOfSize:14.0f];
        _reviewCountLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_reviewCountLbl];
    }
    return _reviewCountLbl;
}

- (UILabel *)distanceLbl {
    if (!_distanceLbl) {
        _distanceLbl = [[UILabel alloc] init];
        _distanceLbl.font = [UIFont systemFontOfSize:14.0f];
        _distanceLbl.textColor = [UIColor lightGrayColor];
        [self addSubview:_distanceLbl];
    }
    return _distanceLbl;
}

- (UILabel *)latestBookLbl {
    if (!_latestBookLbl) {
        _latestBookLbl = [[UILabel alloc] init];
        [self addSubview:_latestBookLbl];
    }
    return _latestBookLbl;
}

- (UILabel *)lowPriceLbl {
    if (!_lowPriceLbl) {
        _lowPriceLbl = [[UILabel alloc] init];
        [self addSubview:_lowPriceLbl];
    }
    return _lowPriceLbl;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
