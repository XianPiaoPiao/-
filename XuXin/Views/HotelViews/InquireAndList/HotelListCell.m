//
//  HotelListCell.m
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import "HotelListCell.h"

@interface HotelListCell()
///酒店照片
@property (weak, nonatomic) IBOutlet UIImageView *hotelIcon;
/**
 酒店名称
 */
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
/**
 酒店评分
 */
@property (nonatomic, strong) IBOutlet UILabel *scoreLbl;
/**
 酒店类型
 */
@property (nonatomic, strong) IBOutlet UILabel *kindLbl;
/**
 点评数量
 */
@property (nonatomic, strong) IBOutlet UILabel *reviewCountLbl;
/**
 距离、地区
 */
@property (nonatomic, strong) IBOutlet UILabel *distanceLbl;
/**
 最新预定
 */
@property (nonatomic, strong) IBOutlet UILabel *latestBookLbl;
/**
 最低价
 */
@property (nonatomic, strong) IBOutlet UILabel *lowPriceLbl;
@end

@implementation HotelListCell

+(instancetype)initWithTbView:(UITableView *)tbView{
    static NSString *identifier = @"HotelListCell";
    HotelListCell *cell = [tbView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)showData:(id)data{
    
}

+(CGFloat)getHeight{
    return 124;
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
