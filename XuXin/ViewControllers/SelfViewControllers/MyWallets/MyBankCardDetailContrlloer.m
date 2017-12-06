//
//  MyBankCardDetailContrlloer.m
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyBankCardDetailContrlloer.h"
#import "MyBankCardCell.h"
#import "RegistViewController.h"
NSString * const myBankDetailIndertifer = @"MyBankCardCell";
@interface MyBankCardDetailContrlloer ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyBankCardDetailContrlloer{
    UITableView * _tableView;
}
-(MyBankModel *)dataArray{
    if (!_model) {
        _model = [[MyBankModel alloc] init];
    }
    return _model;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     //
 
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatNavgationBar];
    
    [self creatUI];
}
-(void)refreshing{
    
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self addNavgationTitle:@"账号详情"];
    
    [self addBackBarButtonItem];
    
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 1;
    _tableView.sectionHeaderHeight = 4;
    [_tableView registerNib:[UINib nibWithNibName:@"MyBankCardCell" bundle:nil] forCellReuseIdentifier:myBankDetailIndertifer];
 
    [self.view addSubview:_tableView];
    //解除绑定
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10, screenH - 60, ScreenW - 20, 50)];
    [button setTitle:@"解除绑定" forState:UIControlStateNormal];
    button.layer.cornerRadius = 25;
    button.titleLabel.textAlignment = 1;
    button.backgroundColor = [UIColor colorWithHexString:MainColor];
    [button addTarget:self action:@selector(unblindBankAction) forControlEvents:UIControlEventTouchDown];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:myBankDetailIndertifer];
    cell.nextImageView.hidden = YES;
    cell.selectionStyle = NO;
    cell.model = _model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
//解除绑定银行卡
-(void)unblindBankAction{
    
    RegistViewController * verifyCodeVC = [[RegistViewController alloc] init];
    verifyCodeVC.requestUrl = unbindBankCardUrl;
    verifyCodeVC.type = 5;
    verifyCodeVC.bankCardId = [NSString stringWithFormat:@"%ld",_model.id];
    [self.navigationController pushViewController:verifyCodeVC animated:YES];
    
}
@end
