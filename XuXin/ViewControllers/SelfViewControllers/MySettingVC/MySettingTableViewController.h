//
//  MySettingTableViewController.h
//  XuXin
//
//  Created by xuxin on 16/8/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^saveImageBlock)(NSString * path);
@interface MySettingTableViewController : UITableViewController

@property (nonatomic ,strong)AFHTTPSessionManager * httpManager;
@property (nonatomic ,copy)saveImageBlock block;
@end
