//
//  HotelNavView.h
//  TableDemo
//
//  Created by 沈鑫 on 2018/2/2.
//  Copyright © 2018年 沈鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HotelNavViewDelegate
- (void)clickNavViewButton:(NSString *)string;
@end
@interface HotelNavView : UIView
@property (nonatomic, assign) id <HotelNavViewDelegate> delegate;
@end
