//
//  AddressTableViewCell.h
//  TestDemo
//
//  Created by liu on 16/10/13.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressItemModel;

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, strong) AddressItemModel *itemlModel;

-(void)initUI:(AddressItemModel *)itemlModel;
@end
