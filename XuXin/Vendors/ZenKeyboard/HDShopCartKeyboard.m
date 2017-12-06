//
//  ZenKeyboard.m
//  ZenKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import "HDShopCartKeyboard.h"
#define kMaxNumber                       100000

@interface HDShopCartKeyboard()

@property (nonatomic,assign) id<UITextInput> textInputDelegate;

@end;

@implementation HDShopCartKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame]; 
    if (self) {        
        UIImageView *keyboardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KeyboardBackgroundTextured"]];
        
        UIImageView *keyboardGridLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KeyboardNumericEntryViewGridLinesTextured"]];
        keyboardGridLines.frame = CGRectMake(0, 0, frame.size.width , 216);

      //  keyboardGridLines.frame = CGRectMake(0, 0, 600, self.frame.size.height);
       // UIImageView *keyboardShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KeyboardTopShadow"]];
        
        [self addSubview:keyboardBackground];
        [self addSubview:keyboardGridLines];
        [self addSubview:[self addNumericKeyWithTitle:@"1" frame:CGRectMake(0, 1, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"2" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, 1, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"3" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, 1, KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"4" frame:CGRectMake(0, KEYBOARD_NUMERIC_KEY_HEIGHT + 2, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"5" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT + 2, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"6" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, KEYBOARD_NUMERIC_KEY_HEIGHT + 2, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"7" frame:CGRectMake(0, KEYBOARD_NUMERIC_KEY_HEIGHT * 2 + 3, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"8" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT * 2 + 3, KEYBOARD_NUMERIC_KEY_WIDTH , KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"9" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, KEYBOARD_NUMERIC_KEY_HEIGHT * 2 + 3, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"完成" frame:CGRectMake(0, KEYBOARD_NUMERIC_KEY_HEIGHT * 3 + 4, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:@"0" frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT * 3 + 4, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addBackspaceKeyWithFrame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, KEYBOARD_NUMERIC_KEY_HEIGHT * 3 + 4, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
    }
    
    return self;
}

- (UIButton *)addNumericKeyWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:28.0]];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = 1;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"KeyboardNumericEntryKeyTextured"];
    UIImage *buttonPressedImage = [UIImage imageNamed:@"KeyboardNumericEntryKeyPressedTextured"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(pressNumericKey:) forControlEvents:UIControlEventTouchUpInside];
    if ([title isEqualToString:@"完成"]) {
        button.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return button;
}

- (UIButton *)addBackspaceKeyWithFrame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    UIImage *buttonImage = [UIImage imageNamed:@"RturnKeyBorad"];
    UIImage *image = [UIImage imageNamed:@"RturnKeyBorad"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((buttonImage.size.width - image.size.width) / 2, (buttonImage.size.height - image.size.height) / 2, image.size.width, image.size.height)];
    
    imgView.image = image;
    [button setImage:buttonImage forState:UIControlStateNormal];

    [button addTarget:self action:@selector(pressBackspaceKey) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    _textField.inputView = self;
    self.textInputDelegate = _textField;
}

- (void)pressNumericKey:(UIButton *)button {
    NSString *keyText = button.titleLabel.text;
    int key = -1;
    //收起键盘
 
    
    if ([@"完成" isEqualToString:keyText]) {
        key = 10;
    } else {
        key = [keyText intValue];
    }
        
    NSRange dot = [_textField.text rangeOfString:@"."];
    
    switch (key) {
        case 10:
        
          //  [self removeFromSuperview];
            [self.textField endEditing:YES];
            break;
        default:
            if (kMaxNumber <= [[NSString stringWithFormat:@"%@%d", _textField.text, key] doubleValue]) {
                _textField.text = [NSString stringWithFormat:@"%d", kMaxNumber];
            } else if ([@"0.00" isEqualToString:_textField.text]) {
                _textField.text = [NSString stringWithFormat:@"%d", key];
            } else if (dot.location == NSNotFound || _textField.text.length <= dot.location + 2) {
                [self.textInputDelegate insertText:[NSString stringWithFormat:@"%d", key]];
            }
            
            break;
    }
}

- (void)pressBackspaceKey {
    
    if ([@"0." isEqualToString:_textField.text]) {
        _textField.text = @"";
        
        return;
    } else {
        [self.textInputDelegate deleteBackward];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
