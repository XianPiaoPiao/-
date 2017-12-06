//
//  LMWordViewController.h
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"

@class LMWordView;

@interface LMWordViewController : BaseViewContrlloer

@property (nonatomic, strong) LMWordView *textView;

- (NSString *)exportHTML;

@property (nonatomic, copy) NSNumber *edittype;

@property (nonatomic, copy) NSString *contentDetail;

@end
