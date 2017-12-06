//
//  VoucherModel.h
//  XuXin
//
//  Created by xian on 2017/11/7.
//  Copyright © 2017年 xienashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoucherModel : NSObject
/* "card_name":"OYB0000101",
 "id":150319,
 "num":318,
 "value":100*/
@property (nonatomic, copy) NSString *card_name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL selected;
@end
