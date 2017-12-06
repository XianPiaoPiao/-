//
//  InputView.h
//  Voucher
//
//  Created by xuxin on 16/8/26.
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^searchButtonClickedBlock)(NSString *);

@interface InputView : UIView
/** 从xib初始化 输入框，但是还没有设置frame*/
+ (instancetype)loadInputView;
/** 进行 一些设置*/
-(void)setTitle:(NSString *)title placeHolder:(NSString *)placeHolder hasSearchButton:(BOOL)hasSearch;

@property (nonatomic,copy) searchButtonClickedBlock searchBlock;

@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@end
