//
//  ChooseLocationView.h

//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLocationView : UIView

@property (nonatomic, copy) NSString *address;
@property (nonatomic,strong) NSMutableArray * dataSouce;
@property (nonatomic,strong) NSArray * dataSouce1;
@property (nonatomic,strong) NSArray * dataSouce2;
@property (nonatomic ,strong)    UITableView * tabbleView;

//声明一个block
@property (nonatomic, copy) void(^chooseAddressFinish)();

@end
