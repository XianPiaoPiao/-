//
//  MyBankCardViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "MyBankCardCell.h"
#import "AddBankCardViewController.h"
#import "MyBankModel.h"
#import "MyBankCardDetailContrlloer.h"

NSString * const myBankCardIndertifer = @"MyBankCardCell";
@interface MyBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation MyBankCardViewController{
    UITableView * _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView
    self.edgesForExtendedLayout=UIRectEdgeNone;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyBankCard) name:@"addCard" object:nil];
      //删除银行卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyBankCard) name:@"deleteBankOK" object:nil];
    //数据请求
    [self firstLoad];
    //背景颜色
    
    [self creatUI];
    
    [self creatNavgationBar];
    
}
-(void)firstLoad{
    
    //开始动画
    [[EaseLoadingView defalutManager] startLoading];
    [self.view addSubview:[EaseLoadingView defalutManager]];
    
    [self requestCardData];

}
-(void)creatNavgationBar{
 
    [self addNavgationTitle:@"我的提款账号"];
    [self addBackBarButtonItem];
}
//
-(void)refreshMyBankCard{
    
    [self requestCardData];
    
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestCardData{
    
    __weak typeof(self)weakself = self;
    
    [weakself POST:myBindBankListUrl parameters:nil success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];

        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[MyBankModel class] json:array];
            self.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
            });
            
        }

    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
    }];
 
}
-(void)creatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 4;
    _tableView.sectionHeaderHeight = 4;
    [_tableView registerNib:[UINib nibWithNibName:@"MyBankCardCell" bundle:nil] forCellReuseIdentifier:myBankCardIndertifer];
    
   
    [self.view addSubview:_tableView];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    footerView.backgroundColor = [UIColor colorWithHexString:BackColor];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10,  40, ScreenW -20, 50)];
    btn.layer.cornerRadius = 25;
    [btn setTitle:@"添加提款账号" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [btn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:btn];
    _tableView.tableFooterView = footerView;

    
}

//添加银行卡
-(void)addBankCard{
    
    AddBankCardViewController * addCardVC =[[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addCardVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:myBankCardIndertifer];
    cell.selectionStyle = NO;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    MyBankModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyBankModel * model = self.dataArray[indexPath.row];
    
    MyBankCardDetailContrlloer * detailVC = [[MyBankCardDetailContrlloer alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark --移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
