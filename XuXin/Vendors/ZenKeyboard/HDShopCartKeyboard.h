//
//  ZenKeyboard.h
//  ZenKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEYBOARD_NUMERIC_KEY_WIDTH self.frame.size.width/3


#define KEYBOARD_NUMERIC_KEY_HEIGHT 53

@protocol HDShopCartKeyboard <NSObject>

- (void)numericKeyDidPressed:(int)key;
- (void)backspaceKeyDidPressed;

@end

@interface HDShopCartKeyboard : UIView

@property (nonatomic, assign) UITextField *textField;

@end
