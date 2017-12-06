//
//  VoucherViewController2.m
//  Voucher
//
//  Copyright © 2016年 UninhibitedSoul. All rights reserved.
//

#import "VoucherViewController2.h"
#import "UIButton+SSEdgeInsets.h"
#import "PriceSortedViewController.h"
#import "userListCouponModel.h"
#import "QueuingUpCell.h"
#import "CompletionQueueCell.h"
#import "AlreadyExchangeCell.h"
#import "AlreadyGetMoneyCell.h"
@interface VoucherViewController2 ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * _tableView;
    UIButton * _button1;
    UIButton * _button2;
    
}
@property (nonatomic,copy) NSString * button1title;
@property (nonatomic,assign) BOOL hasButtonSelected;
@property (nonatomic ,strong)NSMutableArray * couponArray;
@property (nonatomic ,copy)NSString * priceValue;
@property (nonatomic ,assign)NSInteger selectsStatus;
@property (nonatomic ,assign)NSInteger page;
@end
NSString  * const tableViewCellIdentifier = @"cell";
NSString  * const tableViewCellIdentifier1 = @"CompletionQueueCell";
NSString  * const tableViewCellIdentifier2 = @"QueuingUpCell";
NSString  * const tableViewCellIdentifier3 = @"AlreadyExchangeCell";
NSString  * const tableViewCellIdentifier4 = @"AlreadyGetMoneyCell";


@implementation VoucherViewController2{
    UIImageView * _couponImageView;
    UILabel * _nullLabel;
    PriceSortedViewController * _priceSortedVC;
}
-(NSMutableArray *)couponArray{
    if (!_couponArray) {
        _couponArray = [[NSMutableArray alloc] init];
    }
    return _couponArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformData:) name:@"priceValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transfornStatusData:) name:@"status" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstLoad) name:@"addCouponSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapTheView) name:@"tapTheView" object:nil];
    
    [self creatUI];
    
    [self addChildrenController];
    
  
    
    [self firstLoad];
}

-(void)addChildrenController{
    _priceSortedVC = [[PriceSortedViewController alloc]init];
    _priceSortedVC.view.frame = CGRectMake(0, -screenH, ScreenW, 0);
    [self addChildViewController:_priceSortedVC];
    
    [self.view addSubview:_priceSortedVC.view];
}

-(void)firstLoad{
    //初始化page
    _page = 0;

    [_tableView.mj_header beginRefreshing];
    
}
#pragma mark ---通知方法
-(void)transformData:(NSNotification *)cation{
    
    _button1.selected = NO;
    _selectsStatus = 10;
    _priceValue = cation.userInfo[@"textOne"];
    
    [_button1 setTitle:_priceValue forState:UIControlStateNormal];
    
    [self firstLoad];
    
}
-(void)transfornStatusData:(NSNotification *)cation{
    
    _button2.selected = YES;
    _selectsStatus = 10;
    
    NSString * str = cation.userInfo[@"textOne"];
    _couponStaus = str;;
    
    if ([str intValue] == 0) {
        
        [_button2 setTitle:@"全部" forState:UIControlStateNormal];
    }else if ([str intValue] == 1){
        [_button2 setTitle:@"排队中" forState:UIControlStateNormal];

    }else if ([str intValue] ==2){
        [_button2 setTitle:@"已完成" forState:UIControlStateNormal];

    }else if ([str intValue] ==3){
        [_button2 setTitle:@"已兑换" forState:UIControlStateNormal];

    }else if ([str intValue] ==4){
        [_button2 setTitle:@"已领现" forState:UIControlStateNormal];

    }
    [self firstLoad];
    
}
-(void)tapTheView{
    
    [self packUp:_button1];
    [self packUp:_button2];
    
    if (_button1.selected == YES) {
        _button1.selected = NO;
        
    }else if (_button2.selected == YES){
        _button2.selected = NO;
        
    }
}
#pragma mark ---- 数据请求
-(void)requestCouponData:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    if (_priceValue != nil ) {
        
        param[@"value"] = _priceValue;

    }
    if (_couponStaus != nil){
        
        param[@"statusValue"] = _couponStaus;

    }
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    
    
    [weakself POST:userListCouponUrl parameters:param success:^(id responseObject) {
        //
        _tableView.hidden = NO;
        _tableView.mj_footer.hidden = NO;
        
        _couponImageView.hidden = YES;
        _nullLabel.hidden = YES;
        
        int i= [responseObject[@"code"] intValue];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            if (page == 0) {
                
                [self.couponArray removeAllObjects];
            }
            NSArray * array = responseObject[@"result"][@"coupon"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[userListCouponModel class] json:array];
            
            [weakself.couponArray addObjectsFromArray:modelArray];
            
        }
        
        
        if(i == 7030){
            
            //没有更多数据
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else if (i == 7230){
            //没有数据
            [self.couponArray removeAllObjects];
            _nullLabel.hidden = NO;
            _couponImageView.hidden = NO;
            _tableView.hidden = YES;
            //购物车为空
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 60, ScreenW, 20);
            _couponImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 20);
            
        }
        //小于5条数据
        if (self.couponArray.count < 5) {
            //数据全部请求完毕
            _tableView.mj_footer.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
        });
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];

}
-(NSString *)button1title{
    if (!_button1title) {
        
        _button1title = @"面值排序";
    }
    return _button1title;
    
}

- (void)creatUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW/2.0f, 39)];
    [_button1 setBackgroundColor:[UIColor whiteColor]];
    [_button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
    _button1.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_button1 setTitle:@"面值排序" forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:@"icon-bottom-arrow-off@2x"] forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:@"xiala_shang@3x"] forState:UIControlStateSelected];
    
    //    设置Button图文位置
    [_button1 setImagePositionWithType:SSImagePositionTypeRight spacing:20];
    
    
    [_button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _button1.tag = buttonTag;
    
    [self.view addSubview:_button1];
    
    _button2 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW/2.0f, KNAV_TOOL_HEIGHT, ScreenW/2.0f, 39)];
    [_button2 setBackgroundColor:[UIColor whiteColor]];
    [_button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
    _button2.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_button2 setTitle:@"状态" forState:UIControlStateNormal];
    [_button2 setImage:[UIImage imageNamed:@"icon-bottom-arrow-off@2x"] forState:UIControlStateNormal];
    [_button2 setImage:[UIImage imageNamed:@"xiala_shang@3x"] forState:UIControlStateSelected];
    
    [_button2 setImagePositionWithType:SSImagePositionTypeRight spacing:40];
    
    [_button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _button2.tag = buttonTag + 1;
    
    [self.view addSubview:_button2];
    
  
    //    tabview
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105+self.StatusBarHeight, ScreenW, screenH - 105) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    隐藏tableView的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 99;
    
    [self.view addSubview:_tableView];
    __weak typeof(self)weakself = self;
    //上拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        _tableView.mj_footer.hidden = YES;
        [weakself requestCouponData:weakself.page];

    }];
    //下拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestCouponData:weakself.page];
    
    }];
    
    //    注册cell
    //
    [_tableView registerNib:[UINib nibWithNibName:@"CompletionQueueCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableViewCellIdentifier1];
    
    [_tableView registerNib:[UINib nibWithNibName:@"QueuingUpCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableViewCellIdentifier2];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AlreadyExchangeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableViewCellIdentifier3];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AlreadyGetMoneyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableViewCellIdentifier4];
    
    _tableView.backgroundColor = UIColorFromHexValue(0xefefef);
    //
    
    CGFloat imageW = 120;
    _couponImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
     _nullLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, 20)];
    _nullLabel.text = @"你还没有更多兑换券";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_couponImageView setImage:[UIImage imageNamed:@"duihuanquan_kong"]];
    [self.view addSubview:_couponImageView];
    [self.view addSubview:_nullLabel];

}

- (void)buttonClicked:(UIButton *)button{
    
    if (button.tag == buttonTag) {
        //        button2被点击
        if((_button1.selected == NO) && (_button2.selected == NO)){
            
//            Button1已经展开，现在点击button2，Button1应该收起来，button2展开
     //   [self packUp:_button1];
            
        [self packDown:_button1];
            
        }else if (_button1.selected == YES && _button2.selected == NO){
//            button2已经展开，现在点击button2应该收起来
            [self packUp:_button1];
            
        }else if (_button1.selected == NO && _button2.selected == YES){
            
            [self packUp:_button2];
            [self packDown:_button1];
        }
        
        
    }else {
        // button1被点击
        
        if((_button2.selected == NO) && (_button1.selected == NO)){//            Button2已经展开，现在点击button1，Button2应该收起来，button1展开
            [self packDown:_button2];
            
        }else if (_button1.selected == YES && _button2.selected ==NO){
            //button1已经展开，现在点击button1应该收起来
            [self packUp:_button1];
            [self packDown:_button2];
            
        }else if (_button1.selected == NO && _button2.selected == YES){
            
            [self packUp:_button2];
        }
     
        
    }
    
    
}
//MARK:收起下拉菜单
- (void)packUp:(UIButton *)button{
    
  //  PriceSortedViewController * priceSortedVC = self.childViewControllers.lastObject;
    _priceSortedVC.view.clipsToBounds = YES;
    _priceSortedVC.view.frame = CGRectMake(0, -screenH, ScreenW, 0);

    button.selected = NO;
    
}
//MARK:放下下拉菜单
- (void)packDown:(UIButton *)button{
    //        放下去

    
    if (button.frame.origin.x > 0 ) {
        //            button2点击了
        _priceSortedVC.theTypeOfCollection = TheTypeOfCollectionTwo;
        
    }else{
        //            button1点击了
        _priceSortedVC.theTypeOfCollection = TheTypeOfCollectionOne;
    }
 
    _priceSortedVC.view.frame = CGRectMake(0, CGRectGetMinY(_tableView.frame), ScreenW, screenH - CGRectGetMinY(_tableView.frame));

    
    
    button.selected = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.couponArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    userListCouponModel * model = self.couponArray[indexPath.row];

    if (model.isQueue ==1) {
        //排队中
        CompletionQueueCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier1 forIndexPath:indexPath];
        cell.model = model;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     
        return cell;
    }else if (model.isQueue == 2 ){
        //排队完成

        QueuingUpCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier2 forIndexPath:indexPath];
        cell.model = model;

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else if (model.isQueue == 3){
        
        //已兑换
        AlreadyExchangeCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier3 forIndexPath:indexPath];
        cell.model = model;

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

        
    }else{
        
        //已领现
        AlreadyGetMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier4 forIndexPath:indexPath];
        cell.model = model;

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
}
#pragma mark ---移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)packUpButton{
    
    [self packUp:_button2];
    
    [self packUp:_button1];
    
}



@end
