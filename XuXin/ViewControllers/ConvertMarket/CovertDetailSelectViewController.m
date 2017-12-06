//
//  CovertDetailSelectViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertDetailSelectViewController.h"

@interface CovertDetailSelectViewController ()

@end

@implementation CovertDetailSelectViewController{
    UITextField * _lowPriceField;
    UITextField * _highPriceField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    
    [self initTabBar];
}
-(void)creatUI{

    self.navigationController.navigationBarHidden = YES;
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"筛选";
    titleLabel.center = CGPointMake((ScreenW +40) /2.0f, 42+self.StatusBarHeight);
    [bgView addSubview:titleLabel];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 80, 30)];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:8];
    [returnButton setImage:[UIImage imageNamed:@"fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:returnButton];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];

//
    //分割线
    UIView * sepereteView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+self.StatusBarHeight, ScreenW, 2)];
    sepereteView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:sepereteView];
    
    UILabel * anymoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85+self.StatusBarHeight, 80, 20)];
    anymoreLabel.text = @"自定义区间";
    anymoreLabel.font = [UIFont systemFontOfSize:15];
    anymoreLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:anymoreLabel];
    
    CGFloat textfiedW = 100;
    CGFloat textfieldH = 40;
    CGFloat  margin = 60;
    _lowPriceField = [[UITextField alloc] initWithFrame:CGRectMake(10 , 120+self.StatusBarHeight, textfiedW, textfieldH)];
    

    _lowPriceField.font = [UIFont systemFontOfSize:15];
    _lowPriceField.placeholder = @"最低价格";
    _lowPriceField.layer.borderWidth = 1;
    _lowPriceField.layer.cornerRadius = 3;
    _lowPriceField.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
    [_lowPriceField setKeyboardType:UIKeyboardTypeNumberPad];

    [self.view addSubview:_lowPriceField];
    
    _highPriceField = [[UITextField alloc] initWithFrame:CGRectMake(textfiedW + margin + 10 , 120+self.StatusBarHeight, textfiedW, textfieldH)];
     _highPriceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _highPriceField.font = [UIFont systemFontOfSize:15];
    _highPriceField.layer.cornerRadius = 3;
    _highPriceField.layer.borderWidth = 1;
    _highPriceField.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
    [_highPriceField setKeyboardType:UIKeyboardTypeNumberPad];
    _highPriceField.placeholder = @"最高价格";
    [self.view addSubview:_highPriceField];
    
    //线
    UIView * stringVIew = [[UIView alloc] initWithFrame:CGRectMake(_lowPriceField.frame.origin.x + textfiedW, 140+self.StatusBarHeight, margin, 1)];
    stringVIew.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:stringVIew];
    
}
-(void)returnAction:(UIButton *)sender{

     [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:nil];
    
}

-(void)initTabBar{
    
    NSArray * array = @[@"重置",@"确定"];
    for (int i = 0; i < 2; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * (ScreenW - 40)/2.0f, screenH - 50-self.TabbarHeight, ScreenW/2.0f, 50)];
        [self.view addSubview:btn];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = buttonTag + i;
        [btn addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchDown];
        if (i == 1) {
            btn.backgroundColor = [UIColor colorWithHexString:MainColor];
        }
    }
}
-(void)doSomething:(UIButton *)sender{
    if (sender.tag == buttonTag) {
        //清零
        _lowPriceField.text = @"";
        _highPriceField.text = @"";
        
    }else{
        if (!_lowPriceField.text) {
            
            [self showStaus:@"请输入最低价"];
            
        }else if(!_highPriceField.text){
            
            [self showStaus:@"请输入最高价"];

        }else if ([_highPriceField.text integerValue] < [_lowPriceField.text integerValue]){
            
            [self showStaus:@"输入最高价必须大于最低价"];

        }
        else{
            
            self.priceBlock(_lowPriceField.text,_highPriceField.text);

        }
    }
}
@end
