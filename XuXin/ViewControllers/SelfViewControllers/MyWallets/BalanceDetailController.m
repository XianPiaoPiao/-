//
//  BalanceDetailController.m
//  hidui
//
//  Created by xuxin on 17/1/19.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BalanceDetailController.h"
#import "GradeDetailTableViewCell.h"
#import "BalanceDetailModel.h"
#import "LeftScreenController.h"


NSString * const balanceDtailIndertifer = @"GradeDetailTableViewCell";

@interface BalanceDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger page;

//筛选条件
@property (nonatomic ,copy)NSString * buyerUserName;

@property (nonatomic ,copy)NSString * orderSn;

@property (nonatomic ,assign)NSInteger  beginTime;

@property (nonatomic ,assign)NSInteger  endTime;

@property (nonatomic ,assign)NSInteger  income;

//左视图
@property (nonatomic ,strong)LeftScreenController * leftVC;
//阴影
@property (nonatomic ,strong)UIView * tapView;

@property (nonatomic ,strong)UITableView * blanceTableView;

@end

@implementation BalanceDetailController{
    
    UILabel * _numberGradeLabel;
    
    GradeDetailTableViewCell * _GradeDetailCell;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


-(LeftScreenController *)leftVC{
    if (!_leftVC) {
        
        _leftVC = [[LeftScreenController alloc] init];
        
        _leftVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, screenH);
        //阴影
        _tapView =[[UIView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW  , screenH)];
        _tapView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer * hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLeftView)];
        [_tapView addGestureRecognizer:hideGesture];
        
        _tapView.alpha = 0.5;
        //
        UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeftView:)];
        [_leftVC.view addGestureRecognizer:recognizer];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:_tapView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.leftVC.view];
        
    }
    return _leftVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional
    [self creatTableView];
    
    [self creatNavgationBar];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    //
    [self firstLoad];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)firstLoad{
    
    
    _page = 0;
    
    _blanceTableView.mj_footer.hidden = YES;

    [_blanceTableView.mj_header beginRefreshing];
    
}
//数据请求
-(void)requestBalanceDetailVC:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld", page];
    
    if (_beginTime > 0 && _endTime > 0) {
        
        param[@"beginTime"] =[NSString stringWithFormat:@"%ld", _beginTime];
        
        param[@"endTime"] =[NSString stringWithFormat:@"%ld", _endTime];
    }
    param[@"operationType"] = _buyerUserName;
    
    param[@"info"] = _orderSn;
    
    param [@"moneyType"] = [NSString stringWithFormat:@"%ld",_income];
    
    [weakself POST:balanceListUrl parameters:param success:^(id responseObject) {

        NSString * str = responseObject[@"isSucc"];
        NSString * code = responseObject[@"code"];
        if ([str intValue] == 1) {
            
        NSArray * array = responseObject[@"result"][@"plogs"];
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[BalanceDetailModel class] json:array];
            
                [weakself.dataArray addObjectsFromArray:modelArray];
            
         
        }
        if ([code integerValue] == 7030) {
            
            [weakself.blanceTableView.mj_footer endRefreshingWithNoMoreData];
            
        }else if ([code integerValue] == 7230){
            
            [self .dataArray removeAllObjects];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.blanceTableView reloadData];
            
            
        });
        [weakself.blanceTableView.mj_header endRefreshing];
        [weakself.blanceTableView.mj_footer endRefreshing];
        weakself.blanceTableView.mj_footer.hidden = NO;
    
        
        if (weakself.dataArray.count < 10) {
            
            weakself.blanceTableView.mj_footer.hidden = YES;
        }
        
     
        
    } failure:^(NSError *error) {
        
        [_blanceTableView.mj_header endRefreshing];
        [_blanceTableView.mj_footer endRefreshing];
        
        
    }];
    
    
}
-(void)creatNavgationBar{
   
        [self addNavgationTitle:@"余额明细"];
    
        [self addBackBarButtonItem];
    
    
    UIButton * barButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //让按钮所有内容水平向左
    
    barButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    barButton.selected = NO;
    //设置按钮的标题
    [barButton setTitle:@"筛选" forState:UIControlStateNormal];
    
    //设置按钮背景
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f);
    [barButton setImageEdgeInsets:insets];//Offset
    
    //设置target -action
    [barButton addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchDown];
    //创建uibarButtonItem
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    //判断是否在左侧
    
    self.navigationItem.rightBarButtonItem = barButtonItem;

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
    [_blanceTableView registerNib:[UINib nibWithNibName:@"GradeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:balanceDtailIndertifer];
    
    //上拉下载
    __weak typeof(self)weakself = self;
    _blanceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
 
        weakself.page = 0;

        [self requestBalanceDetailVC:weakself.page];
        
    }];
    //下拉加载
    _blanceTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page ++;
        [weakself requestBalanceDetailVC:weakself.page];
        
    }];
    
    //创建头视图
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 118)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f29800"];
    UILabel * curentGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 22, 100, 20)];
  
    curentGradeLabel.text = @"当前余额";
   
    [curentGradeLabel setTextColor:[UIColor whiteColor]];
    [headerView addSubview:curentGradeLabel];
    
    _numberGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, ScreenW -30, 70)];
    [_numberGradeLabel setTextColor:[UIColor whiteColor]];
    [_numberGradeLabel setFont:[UIFont systemFontOfSize:28]];
    
    _numberGradeLabel.text =[NSString stringWithFormat:@"%.2f",[User defalutManager].balance];
    
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
  

    if (self.dataArray.count > 0) {
        
        
       BalanceDetailModel * model = self.dataArray[indexPath.section];
        
       return [_GradeDetailCell getBalanceCellHeight:model];
        
    }else{
        
        return 0;
    }
   
        
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    _GradeDetailCell = [tableView dequeueReusableCellWithIdentifier:balanceDtailIndertifer   forIndexPath:indexPath];
  
    BalanceDetailModel * model = self.dataArray[indexPath.section];
    _GradeDetailCell.balanceModel = model;
  
    if (indexPath.section%2 == 1) {
        
        _GradeDetailCell.contentView.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        _GradeDetailCell.contentView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
    }
    return _GradeDetailCell;
}
#pragma mark ---隐藏左视图
-(void)hideLeftView{
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.leftVC.view.frame = CGRectMake(ScreenW + 40, 0, ScreenW, screenH);
        
        
    } completion:^(BOOL finished) {
        
        _tapView.frame = CGRectMake(ScreenW + 40, 0, ScreenW, screenH);
        
    }];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}
#pragma mark ---显示左视图
-(void)showLeftView{
    
    __weak typeof(self)weakeself = self;

    self.leftVC.block = ^(NSInteger  income,NSString * buyerUserName,NSString *orderSn ,NSInteger  beginTime,NSInteger endTime ){
        
        weakeself.income = income;
        weakeself.buyerUserName = buyerUserName;
        weakeself.orderSn = orderSn;
        weakeself.beginTime = beginTime;
        weakeself.endTime = endTime;
        
        [weakeself hideLeftView];
        
        [weakeself.blanceTableView.mj_header beginRefreshing];
        
    };
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.leftVC.view.frame = CGRectMake(40, 0, ScreenW  , screenH);
        
    } completion:^(BOOL finished) {
        
        _tapView.frame = CGRectMake(0, 0, ScreenW , screenH);
        
    }];
    
    
}
#pragma mark ----滑动手势
-(void)swipeLeftView:(UIPanGestureRecognizer *)pan{
    // 获取当前手势偏移量
    CGPoint curP = [pan translationInView:self.leftVC.view];
    
    // 视图X方向偏移
    CGFloat totalX = 0 ;
    
    totalX = totalX + curP.x;
    
    //  self.leftVC.view.frame =  CGRectMake(totalX , 0, SCREENWIDTH   , SCREENHEIGHT);
    
    if (totalX > ScreenW/2.0f) {
        
        [self hideLeftView];
        
    }else{
        
        [self showLeftView];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
