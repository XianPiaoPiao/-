//
//  UserCommentController.m
//  XuXin
//
//  Created by xuxin on 16/12/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "UserCommentController.h"
#import "HaiDuiTextView.h"

@interface UserCommentController ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation UserCommentController{
    UITextField * _titleField;
    HaiDuiTextView * _contentField;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"UserCommentController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"UserCommentController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgatonBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self settingUI];
}
-(void)creatNavgatonBar{
    
    self.navigationController.navigationBarHidden = NO;
    [self addBackBarButtonItem];
    [self addNavgationTitle:@"用户反馈"];
}
-(void)settingUI{
    
     _titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74+self.StatusBarHeight, ScreenW  -20, 40)];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor colorWithHexString:WordDeepColor];
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"标题" attributes:dict];
    [_titleField setAttributedPlaceholder:attribute];
    
   
    _titleField.layer.cornerRadius = 4;
    _titleField.font = [UIFont systemFontOfSize:15];
    _titleField.layer.borderWidth = 1;
    _titleField.layer.borderColor = [UIColor colorWithHexString:WordDeepColor].CGColor;
    
    UIView * letfView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_titleField setLeftViewMode:UITextFieldViewModeAlways];
    
    [_titleField setLeftView: letfView];
    
    [self.view addSubview:_titleField];
    
    _contentField = [[HaiDuiTextView alloc] initWithFrame:CGRectMake(10, 124+self.StatusBarHeight, ScreenW - 20, screenH - 200-self.TabbarHeight)];
    _contentField.textColor = [UIColor colorWithHexString:WordDeepColor];
    _contentField.layer.cornerRadius = 4;
    
   // _contentField.delegate = self;
    _contentField.myPlaceholder=@"请输入你宝贵的意见和建议（800字以内）";
    
    //2.设置提醒文字颜色
    
    _contentField.myPlaceholderColor= [UIColor lightGrayColor];
    
    _contentField.layer.borderWidth = 1;
    _contentField.layer.borderColor = [UIColor colorWithHexString:WordDeepColor].CGColor;
   
    _contentField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_contentField];
    
//    //
//    UILabel * commenntLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, screenH - 120, ScreenW - 20, 60)];
//    commenntLabel.numberOfLines = 0;
//    commenntLabel.font = [UIFont systemFontOfSize:15];
//    commenntLabel.text = @"    感谢你对我们提出的宝贵的意见和建议，你留下的任何信息都有将有助于我们更加出色";
//    [self.view addSubview:commenntLabel];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, screenH - 50 - self.TabbarHeight, ScreenW - 20, 40)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"提交反馈" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20;
    btn.backgroundColor =[UIColor colorWithHexString:MainColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchDown];
    
}

-(void)uploadData{
    
    
    if (_contentField.text.length > 0 && _titleField.text.length > 0) {
        [self creatIndortor];

        [self sendRequestData];

    }else{
        
        [self showStaus:@"请填写内容"];
    }
}

-(void)sendRequestData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"title"] = _titleField.text;
    dic[@"opinion"] = _contentField.text;
    
    [weakself POST:save_feedback_userUrl parameters:dic success:^(id responseObject) {
        
        [self timerStop];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] ==1) {
            
            [weakself showStaus:@"提交成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismissWithDelay:1];
                
                [weakself.navigationController popViewControllerAnimated:YES];
            });
            
            
        }
        

    } failure:^(NSError *error) {
        
        [weakself timerStop];
        
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

@end
