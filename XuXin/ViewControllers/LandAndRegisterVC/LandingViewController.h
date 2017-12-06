//
//  LandingViewController.h
//  登陆界面
//
//

#import <UIKit/UIKit.h>
#import "BaseViewContrlloer.h"

typedef void (^ReturnTextBlock)(NSString *showText);
@interface LandingViewController : BaseViewContrlloer

@property (nonatomic ,copy)ReturnTextBlock returnTexBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
