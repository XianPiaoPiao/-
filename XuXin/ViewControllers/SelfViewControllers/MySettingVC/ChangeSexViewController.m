//
//  ChangeSexViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/23.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ChangeSexViewController.h"

@implementation ChangeSexViewController{
    NSMutableArray * _dataArray;
    UITableView * _tabView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self creatNavgaionBar];
    [self creatUI];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
}
-(void)creatNavgaionBar{
  
        [self addNavgationTitle:@"选择性别"];
         [self addBackBarButtonItem];
    
  }
-(void)returnSettingVC{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    NSArray * array = @[@"男",@"女"];
    for (int i = 0; i <2; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 74 + i * 41, ScreenW, 40)];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = buttonTag + i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
    }
}
-(void)selectSex:(UIButton *)sender{
    if (sender.tag == buttonTag) {
        
        [self showSex:0];
      
    } else if (sender.tag == buttonTag + 1){
        

        [self showSex:1];
    }
    
}

-(void)showSex:(NSInteger)sex{
    //上传数据
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    BOOL ret;
    
    if (sex == 1) {
        
        ret = YES;
    }else{
        ret = NO;

    }
    
    param[@"sex"] =[NSString stringWithFormat:@"%d",ret];
    
    [weakSelf POST:updateUserUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            
            [User defalutManager].sex = sex;
            
            [self showStaus:@"修改性别成功"];
            //设置小矩形背景颜色
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        }

    } failure:^(NSError *error) {
        
    }];
        
  }

@end
