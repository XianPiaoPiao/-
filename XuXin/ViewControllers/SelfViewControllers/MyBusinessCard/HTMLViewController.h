//
//  HTMLViewController.h
//  SimpleWord
//
//  Created by Chenly on 16/8/23.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "BaseViewContrlloer.h"

@interface HTMLViewController : BaseViewContrlloer

@property (nonatomic, copy) NSString *HTMLString;

@property (nonatomic, strong) UIWebView *webView;

@end
