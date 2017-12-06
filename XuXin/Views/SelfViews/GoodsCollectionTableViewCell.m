//
//  GoodsCollectionTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GoodsCollectionTableViewCell.h"

@implementation GoodsCollectionTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.shopImageView.layer.masksToBounds = YES;
    self.shopImageView.layer.cornerRadius = 6;
    
}

-(void)setShopModel:(StoreCollectionsModel *)ShopModel{
    
    _ShopModel = ShopModel;
    _shopNameLabel.text = ShopModel.store_name;
    _addressLabel.text = ShopModel.store_address;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:ShopModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    _starsView.hidden = YES;
//    _starsView.starValue = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        
        if (selected) {
            
            // 编辑状态去掉渲染
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.backgroundView.backgroundColor = [UIColor whiteColor];
            
            // 左边选择按钮去掉渲染背景
            UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
            
            view.backgroundColor = [UIColor whiteColor];
            self.selectedBackgroundView = view;
            
        }
    }
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        
                        img.image = [UIImage imageNamed:@"icon_order_noactiv@2x"];
                    }
                }
            }
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    
                    if (self.selected) {
                        //
                    img.image=[UIImage imageNamed:@"dingdan_chenggong@3x"];
                    
                    }else
                    {
                        img.image=[UIImage imageNamed:@"icon_order_noactiv@2x"];
                    }
                }
            }
        }
    }
    
}
@end
