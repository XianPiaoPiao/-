//
//  OrderConvertViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OrderConvertViewController.h"
#import "ConvertOrderTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "ConvertOrderModel.h"
NSString * const covertOrderIndertifier = @"ConvertOrderTableViewCell";
@interface OrderConvertViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,strong)UITableView * tableView;
@end

@implementation OrderConvertViewController{
    
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];

    }
    return _dataArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus) name:@"AlipaySucess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus) name:@"weixinSucess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFreshing) name:@"sureReceive" object:nil];
    //删除订单后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFreshing) name:@"cancelOrderOK" object:nil];
    
    [self creatTableView];
    
    [self firstLoad];
    
    
}
#pragma mark --支付成功通知
-(void)changeOrderStatus{
    
    //已支付状态
    _status = 1;
    
    //初始化page
    _page = 0;
    
    [_tableView.mj_header beginRefreshing];
}
#pragma mark --- 确认收货通知
-(void)begainFreshing{
    
    [_tableView.mj_header beginRefreshing];
}
-(void)firstLoad{
    
    //初始化page
     _page = 0;
    [_tableView.mj_header beginRefreshing];
}

-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH -105) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //设置tableView的setion距离
    _tableView.sectionFooterHeight = 5;
    _tableView.sectionHeaderHeight = 5;
    [_tableView registerNib:[UINib nibWithNibName:@"ConvertOrderTableViewCell" bundle:nil] forCellReuseIdentifier:covertOrderIndertifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    __weak typeof(self)weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        weakself.tableView.mj_footer.hidden = YES;
        [weakself requestData: weakself.page];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page++;

        [weakself requestData: weakself.page];
    }];
}
#pragma mark --- 数据请求
-(void)requestData:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"nextPage"]=[NSString stringWithFormat:@"%ld",(long)page];
    param[@"orderType"]= @"2";
    
    [self POST:orderListUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        //状态码，我也是服了
        int i = [responseObject[@"code"] intValue];
        if ([str intValue] == 1) {
            
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            weakself.tableView.hidden = NO;
            
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertOrderModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:modelArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tableView reloadData];
                
            });
            
        }
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        weakself.tableView.mj_footer.hidden = NO;
        weakself.tableView.mj_header.hidden = NO;
        
        if(i == 7030){
            
            //没有更多数据
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else if (i == 7230){
            //没有数据
            
            weakself.tableView.hidden = YES;
            CGFloat imageW = 120;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageW)];
            UILabel * label  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH/ 2.0f , ScreenW, 20)];
            label.text = @"你还没有任何订单";
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = 1;
            
            imageView.center = CGPointMake(ScreenW/2.0f , screenH/2.0f - 80);
            [imageView setImage:[UIImage imageNamed:@"dingdan_kong@2x"]];
            [weakself.view addSubview:imageView];
            [weakself.view addSubview:label];
        }
        

        //小于5条数据
        if (weakself.dataArray.count < 5) {
            //数据全部请求完毕
            weakself.tableView.mj_footer.hidden = YES;
        }


    } failure:^(NSError *error) {
        //将自增的page减下来
        if(weakself.page > 1){
            weakself.page--;
        }
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark ---tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvertOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:covertOrderIndertifier forIndexPath:indexPath];
  
    ConvertOrderModel * model = self.dataArray[indexPath.section];
    //微信支付宝支付成功AAP端处理
    if (indexPath.section == 0) {
        
        if (_status == 1) {
            
         cell.orderStateLabel.text = @"待发货";
            
        }
    }
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 190;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    MyOrderDetailViewController * covertVC = [[MyOrderDetailViewController alloc] init];
    ConvertOrderModel * model = self.dataArray[indexPath.section];
    
    covertVC.requestUrl = integralOrderDetailUrl;
    
    covertVC.goodID = [NSString stringWithFormat:@"%ld",(long)model.orderId];
    [self.navigationController pushViewController:covertVC animated:YES];
}
#pragma mark --移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
