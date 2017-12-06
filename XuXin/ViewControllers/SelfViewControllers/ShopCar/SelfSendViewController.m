//
//  SelfSendViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SelfSendViewController.h"
#import "SelfSendTableViewCell.h"
NSString * selfSendTableViewInderfier= @"SelfSendTableViewCell";
@interface SelfSendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign)NSInteger lastCellIndex;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation SelfSendViewController{
    UITableView * _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"SelfSendViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"SelfSendViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatTableView];
    [self requestData];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
}
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    [weakself POST:nearPickupCentersUrl parameters:nil success:^(id responseObject) {
        
        NSArray * array = responseObject[@"result"];
        weakself.dataArray = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
   
}
-(void)creatTableView{
    
   _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView registerNib:[UINib nibWithNibName:@"SelfSendTableViewCell" bundle:nil] forCellReuseIdentifier:selfSendTableViewInderfier];
    _tableView.separatorStyle = NO;
    //创建headerView
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 330, ScreenW, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    //创建分割线
  //  UIView * sepereateView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 1)];
  //  sepereateView.backgroundColor = [UIColor colorWithHexString:BackColor];
   // [headerView addSubview:sepereateView];
    
    UILabel * nameLbel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, 40)];
    [nameLbel setText:@"注: 请你选择离你最近的自提点"];
    [nameLbel setTextColor:[UIColor grayColor]];
    [nameLbel setFont:[UIFont systemFontOfSize:15]];
    [headerView addSubview:nameLbel];
    [self.view addSubview:headerView];
    //创建确定按钮
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 400, ScreenW - 20, 50)];
    sureBtn.layer.cornerRadius = 25;
    sureBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureSendPalce) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sureBtn];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"自提点"];
    [self addBackBarButtonItem];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelfSendTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:selfSendTableViewInderfier forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row][@"address"];
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
#pragma mark ---cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelfSendTableViewCell * lastSelectedcell =  (SelfSendTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastCellIndex -1 inSection:0]];
    //未被点击
    [lastSelectedcell.selectImageState setImage:[UIImage imageNamed:@"icon_money_check_off@2x"]];
    
   

    SelfSendTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.isSelect = YES;
    
    //点击
    [cell.selectImageState setImage:[UIImage imageNamed:@"exchange_selected@3x"]];
    
    self.lastCellIndex = indexPath.row + 1;
}
#pragma mark ---确定
-(void)sureSendPalce{
  
    if (self.lastCellIndex > 0) {
        
        self.block(self.dataArray[self.lastCellIndex -1][@"id"],self.dataArray[self.lastCellIndex -1][@"address"]);
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self showStaus:@"请选择自提点"];
    }
}
@end
