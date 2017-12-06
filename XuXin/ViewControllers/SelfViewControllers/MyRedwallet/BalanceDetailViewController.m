//
//  BalanceDetailViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BalanceDetailViewController.h"
#import "GradeDetailTableViewCell.h"
#import "BalanceDetailModel.h"
#import "SupendDetailModel.h"
#import "PointDetailModel.h"
NSString * const gradeDtailIndertifer = @"GradeDetailTableViewCell";
@interface BalanceDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation BalanceDetailViewController{
    
    UITableView * _blanceTableView;
    UILabel * _numberGradeLabel;
    GradeDetailTableViewCell * _GradeDetailCell;
    
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
    [self creatTableView];
    [self creatNavgationBar];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    //
    [self firstLoad];
}
-(void)firstLoad{
    
   [self.view addSubview:[EaseLoadingView defalutManager]];
    [[EaseLoadingView defalutManager] startLoading];
    
    [self requestBalanceDetailVC];
}
//数据请求
-(void)requestBalanceDetailVC{
    
    __weak typeof(self)weakself = self;
    [weakself POST:self.requestUrl parameters:nil success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            if (_payType == 1) {
                
                _numberGradeLabel.text =[NSString stringWithFormat:@"%.2f",[User defalutManager].preDeposit];
                NSArray * array = responseObject[@"result"][@"slogs"];
                
                NSArray * modelArray = [NSArray yy_modelArrayWithClass:[SupendDetailModel class] json:array];
                self.dataArray = [NSMutableArray arrayWithArray:modelArray];
                
            }else if (_payType ==2){
                
                _numberGradeLabel.text = [NSString stringWithFormat:@"%.2f",[User defalutManager].balance];
                NSArray * array = responseObject[@"result"][@"plogs"];
                NSArray * modelArray = [NSArray yy_modelArrayWithClass:[BalanceDetailModel class] json:array];
                self.dataArray = [NSMutableArray arrayWithArray:modelArray];
            }else{
                
                _numberGradeLabel.text = [NSString stringWithFormat:@"%ld",(long)[User defalutManager].integral];
                NSArray * array = responseObject[@"result"][@"ilogs"];
                NSArray * modelArray = [NSArray yy_modelArrayWithClass:[PointDetailModel class] json:array];
                self.dataArray = [NSMutableArray arrayWithArray:modelArray];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_blanceTableView reloadData];
            });
        }

    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        

    }];
    

}
-(void)creatNavgationBar{
    if (_payType == 1) {
        
        [self addNavgationTitle:@"预充值明细"];
        [self addBackBarButtonItem];
    }else if (_payType == 2){
        [self addNavgationTitle:@"余额明细"];
        [self addBackBarButtonItem];
    }else if (_payType == 3){
        [self addNavgationTitle:@"积分明细"];
        [self addBackBarButtonItem];
    }
    
}

-(void)creatTableView{
    
    _blanceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_blanceTableView];
    _blanceTableView.separatorStyle = NO;
    _blanceTableView.delegate = self;
    _blanceTableView.dataSource = self;
    _blanceTableView.sectionFooterHeight = 0.01;
    _blanceTableView.sectionHeaderHeight = 0.01;
    //注册
    [_blanceTableView registerNib:[UINib nibWithNibName:@"GradeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:gradeDtailIndertifer];
    //创建头视图
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 118)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f29800"];
     UILabel * curentGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 22, 100, 20)];
    if (_payType == 1) {
        
        curentGradeLabel.text = @"当前预充值";

    }else if (_payType == 2){
        
        curentGradeLabel.text = @"当前余额";

    }else if (_payType == 3){
        
        curentGradeLabel.text = @"当前积分";

    }
    [curentGradeLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:curentGradeLabel];
    
    _numberGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, ScreenW -30, 70)];
    [_numberGradeLabel setTextColor:[UIColor whiteColor]];
    [_numberGradeLabel setFont:[UIFont systemFontOfSize:28]];
    [headerView addSubview:_numberGradeLabel];
    
    _blanceTableView.tableHeaderView = headerView;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 39;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 39)];
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
        headerLabel.text = @"明细";
        headerLabel.font = [UIFont systemFontOfSize:15];
        headerLabel.textColor = [UIColor blackColor];
        [bgView addSubview:headerLabel];
        return bgView;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_payType == 1) {
        
        SupendDetailModel * model = self.dataArray[indexPath.section];
        
        return [_GradeDetailCell getSupendCellHeight:model];
        
    }else if (_payType == 2){
        BalanceDetailModel * model = self.dataArray[indexPath.section];
        return [_GradeDetailCell getBalanceCellHeight:model];
        
    }else{
        
        PointDetailModel * model = self.dataArray[indexPath.section];
        return   [_GradeDetailCell getPointCellHeight:model];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    _GradeDetailCell = [tableView dequeueReusableCellWithIdentifier:gradeDtailIndertifer   forIndexPath:indexPath];
    if (_payType == 1) {
        
        SupendDetailModel * model = self.dataArray[indexPath.section];
    
        _GradeDetailCell.supendModel = model;
        
    }else if (_payType == 2){
        BalanceDetailModel * model = self.dataArray[indexPath.section];
        _GradeDetailCell.balanceModel = model;
    }else{
        PointDetailModel * model = self.dataArray[indexPath.section];
        _GradeDetailCell.pointModel = model;
    }
   
    if (indexPath.section%2 == 1) {
        
        _GradeDetailCell.contentView.backgroundColor = [UIColor whiteColor];

    }else{
        
        _GradeDetailCell.contentView.backgroundColor = [UIColor colorWithHexString:BackColor];

    }
          return _GradeDetailCell;
}
@end
