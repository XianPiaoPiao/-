//
//  SelfCardTableViewCell.m
//  XuXin
//
//  Created by xian on 2017/9/27.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SelfCardTableViewCell.h"
#import "BusinessCardModel.h"

@implementation SelfCardTableViewCell

+(CGFloat)heightForSelfCardCell{
    return 95.0;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
        
    }
    return self;
}

- (void)initUI{
    CGFloat centerW = ScreenW/2.0;
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_offset(@75);
    }];
    
    [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headImgView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.createLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.size.sizeOffset(CGSizeMake(150, 30));
    }];
    
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-28);
        make.size.sizeOffset(CGSizeMake(9, 16));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.top.equalTo(self.headImgView.mas_top);
        make.height.mas_offset(@25);
        make.width.mas_offset(@(centerW-95));
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImgView.mas_right).offset(10);
        make.bottom.equalTo(self.headImgView.mas_bottom);
        make.height.mas_offset(@25);
        make.width.mas_offset(@(centerW-95));
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(centerW/2.0-15, 75));
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(centerW/2.0-15, 75));
        make.left.equalTo(self.codeButton.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    
    
}

- (void)setIsExit:(BOOL)isExit{
    
    if (isExit) {
        self.nameLabel.hidden = NO;
        self.jobLabel.hidden = NO;
        self.codeButton.hidden = NO;
        self.shareButton.hidden = NO;
        
        self.createLbl.hidden = YES;
        self.nextImgView.hidden = YES;
        _wordL.hidden = NO;
        [_headImgView setImage:[UIImage imageNamed:@"i_background"]];
        
    } else {
        self.nameLabel.hidden = YES;
        self.jobLabel.hidden = YES;
        self.codeButton.hidden = YES;
        self.shareButton.hidden = YES;
        
        self.createLbl.hidden = NO;
        self.nextImgView.hidden = NO;
        
        
        _wordL.text = @"";
        _wordL.hidden = YES;
        [_headImgView setImage:[UIImage imageNamed:@"my_default"]];
      
    }
    
}

- (void)setModel:(BusinessCardModel *)model{
    self.nameLabel.text = model.username;
    self.jobLabel.text = model.job;
    NSString *str = [self.nameLabel.text substringToIndex:1];
    _wordL.text = str;

}

- (UILabel *)createLbl{
    if (!_createLbl) {
        _createLbl = [UILabel new];
        _createLbl.text = @"创建我的名片";
        _createLbl.font = [UIFont systemFontOfSize:14.0f];
        _createLbl.textColor = [UIColor colorWithHexString:WordColor];
        [self addSubview:_createLbl];
    }
    return _createLbl;
}

- (UIImageView *)nextImgView{
    if (!_nextImgView) {
        _nextImgView = [UIImageView new];
        _nextImgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my_arrow"]];
        [self addSubview:_nextImgView];
    }
    return _nextImgView;
}

- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [UIImageView new];
        _headImgView.layer.cornerRadius = 2;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_headImgView setImage:[UIImage imageNamed:@"my_default"]];//
        [self addSubview:_headImgView];
    }
    return _headImgView;
}

- (UILabel *)wordL{
    if (!_wordL) {
        //第一个字
        _wordL = [UILabel new];
        _wordL.font = [UIFont systemFontOfSize:24.0];
        _wordL.textAlignment = NSTextAlignmentCenter;
        _wordL.layer.cornerRadius = 55/2.0;
        _wordL.layer.masksToBounds = YES;
        [self.headImgView addSubview:_wordL];
        _wordL.backgroundColor = [UIColor whiteColor];
    }
    return _wordL;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor colorWithHexString:WordColor];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)jobLabel{
    if (!_jobLabel) {
        _jobLabel = [UILabel new];
        _jobLabel.font = [UIFont systemFontOfSize:14.0f];
        _jobLabel.textColor = [UIColor colorWithHexString:WordColor];
        [self addSubview:_jobLabel];
    }
    return _jobLabel;
}

- (UIButton *)codeButton{
    if (!_codeButton) {
        _codeButton = [UIButton new];
        [_codeButton setImage:[UIImage imageNamed:@"qr_code_icon"] forState:UIControlStateNormal];
        [_codeButton setTitle:@"名片二维码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_codeButton setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [self addSubview:_codeButton];
    }
    return _codeButton;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton new];
        [_shareButton setImage:[UIImage imageNamed:@"home_share"] forState:UIControlStateNormal];
        [_shareButton setTitle:@"发名片" forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_shareButton setImagePositionWithType:SSImagePositionTypeTop spacing:5];
        [self addSubview:_shareButton];
    }
    return _shareButton;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
