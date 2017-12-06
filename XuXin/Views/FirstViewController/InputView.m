//
//  InputView.m
//  Voucher
//
//  Created by xuxin 16/8/26.
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "InputView.h"

@interface InputView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theTextFieldMarginToRightConstant;
@property (weak, nonatomic) IBOutlet UIButton *serchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grayViewHight;

@end
@implementation InputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)loadInputView{
    
   return  [[NSBundle mainBundle]loadNibNamed:@"InputView" owner:nil options:nil].lastObject;
    
}
- (void)setTitle:(NSString *)title placeHolder:(NSString *)placeHolder hasSearchButton:(BOOL)hasSearch{
    
//    设置灰色杠杠 的高度
    self.grayViewHight.constant = 56.0f * ScreenScale;
//    切圆角
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
    
    self.titleLabel.text = title;
    _textFiled.placeholder = placeHolder;
    if (!hasSearch) {
        self.theTextFieldMarginToRightConstant.constant = 0;
        
        [self.serchButton removeFromSuperview];
        
    }
    
    
}
- (IBAction)searchButtonClicked:(id)sender {
    
    searchButtonClickedBlock searchBlk = self.searchBlock;
    if (searchBlk) {
        searchBlk(self.textFiled.text);
    }
    
    
}

@end
