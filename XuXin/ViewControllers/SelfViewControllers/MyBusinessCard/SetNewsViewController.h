//
//  SetNewsViewController.h
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetNewsViewController : UIViewController

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger editType;

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic, assign) NSInteger newsType;

@property (nonatomic, copy) NSString *ccId;

@property (nonatomic, copy) NSString *titleContent;

@property (nonatomic, copy) NSString *logoUrlPath;

@property (nonatomic, copy) NSString *logoId;


@end
