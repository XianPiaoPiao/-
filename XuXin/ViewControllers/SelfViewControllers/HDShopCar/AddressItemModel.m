//
//  AddressItemModel.m

//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.//
//

#import "AddressItemModel.h"

@implementation AddressItemModel

+(instancetype)initWithName:(NSString *)name andId:(NSString *)ID isSelected:(BOOL)isSelected{
    
    AddressItemModel *itemModel = [[AddressItemModel alloc]init];
    
    itemModel.name = name;
    itemModel.areaId = ID;
    itemModel.isSelected = isSelected;
    
    return itemModel;
    

}

@end
