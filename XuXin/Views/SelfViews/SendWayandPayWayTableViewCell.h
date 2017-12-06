//
//  SendWayandPayWayTableViewCell.h
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendWayandPayWayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sendPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selfSendBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendWayBtn;
@property (weak, nonatomic) IBOutlet UILabel *payType;

@end
