//
//  ChangeBirthDayViewContrlloer.m
//  XuXin
//
//  Created by xuxin on 16/9/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ChangeBirthDayViewContrlloer.h"


@implementation ChangeBirthDayViewContrlloer{
  

}
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnSettingVC) name:@"return" object:nil];
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    STPickerDate *datePicker = [[STPickerDate alloc]initWithDelegate:self];
    [datePicker show];
    [self creatNavgationBar];
    
}
-(void)creatNavgationBar{
    [self addNavgationTitle:@"选择生日"];
    [self addBackBarButtonItem];
}
-(void)returnSettingVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *text = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
 
    [self showBirthDay:text];

}
-(void)showBirthDay:(NSString *) timeStr{
    //上传数据
    __weak typeof(self)weakSelf = self;
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate * date = [formatter dateFromString:timeStr];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    NSString * timeSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"birthday"] = timeSp;
    [weakSelf POST:updateUserUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [User defalutManager].birthday = (long)[date timeIntervalSince1970];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshingUI" object:nil];
            
            // 2秒钟之后隐藏HUD
            [self showStaus:@"修改生日成功"];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
