//
//  SelectBankCardController.m
//  XuXin
//
//  Created by xuxin on 16/11/2.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SelectBankCardController.h"
#import "SelectBankCardCell.h"
#import "AddBankCardViewController.h"
NSString * const selectBankCardInderfier = @"SelectBankCardCell";
@interface SelectBankCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation SelectBankCardController{
    UITableView * _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyBankCard) name:@"addCard" object:nil];
    [self creatNavgationBar];
    //数据请求
    [self requestCardData];
    
    [self creatUI];
    
}
#pragma mark --通知方法
-(void)refreshMyBankCard{
    
    [self requestCardData];
}
-(void)creatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, screenH - 10) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [_tableView registerNib:[UINib nibWithNibName:@"SelectBankCardCell" bundle:nil] forCellReuseIdentifier:selectBankCardInderfier];
 }
#pragma mark ----银行列表
-(void)requestCardData{
    
    __weak typeof(self)weakself = self;
    [weakself POST:myBindBankListUrl parameters:nil success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[MyBankModel class] json:array];
            self.dataArray = [NSMutableArray arrayWithArray:modelArray];
            if (array.count < 1) {
                
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30, screenH / 2 - 60 , ScreenW - 60, 60)];
                label.numberOfLines = 0;
                label.text = @"你还没有绑定任何银行卡,点击右上角绑定银行卡";
                label.font = [UIFont systemFontOfSize:15];
                label.backgroundColor = [UIColor colorWithHexString:BackColor];
                label.textAlignment = 1;
                [self.view addSubview:label];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
  }
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"选择提款账号"];
 
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];

    btn.frame =  CGRectMake(0, 0, 25, 25);
    btn.tintColor = [UIColor colorWithHexString:MainColor];
    
    [btn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchDown];
    [btn setImage:[UIImage imageNamed:@"addBankCard"] forState:UIControlStateNormal];
    UIBarButtonItem * barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem= barBtn;
    
    [self addBackBarButtonItem];
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)addBankCard{
    
    AddBankCardViewController * addBankCardVC =[[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:selectBankCardInderfier forIndexPath:indexPath];
    MyBankModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBankModel * model = self.dataArray[indexPath.row];
    self.block(model);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
