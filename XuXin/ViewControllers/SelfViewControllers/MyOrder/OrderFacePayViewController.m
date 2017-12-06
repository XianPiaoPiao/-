//
//  OrderFacePayViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OrderFacePayViewController.h"
#import "FacePayOrderTableViewCell.h"
#import "MyOrderDetailViewController.h"
#import "CovertOrderViewController.h"
#import "FaceToFaceOrderModel.h"
NSString * const facePayTableViwIndertifer = @"FacePayOrderTableViewCell";
@interface OrderFacePayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger stusus;
@property (nonatomic ,strong)UITableView * tableView;
@end

@implementation OrderFacePayViewController{
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray  = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self creatTableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus) name:@"AlipaySucess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderStatus) name:@"weixinSucess" object:nil];
    
    //删除订单后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshing) name:@"cancelOrderOK" object:nil];

    
    [self firstLoad];

}
-(void)freshing{
    
    [_tableView.mj_header beginRefreshing];

}
-(void)changeOrderStatus{
    
    //已支付状态
    _stusus = 1;
    [self requetData:_page];
    
}
-(void)creatTableView{
    
    _tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH -105) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 5;
    _tableView.sectionFooterHeight = 5;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FacePayOrderTableViewCell" bundle:nil] forCellReuseIdentifier:facePayTableViwIndertifer];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    __weak typeof(self)weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        weakself.tableView.mj_footer.hidden = YES;
        [weakself requetData:weakself.page];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page++;

        [weakself requetData:weakself.page];
    }];
}

-(void)firstLoad{
    //初始化page
    _page = 0;
    [_tableView.mj_header beginRefreshing];
}
#pragma mark --- 数据请求
-(void)requetData:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"nextPage"]=[NSString stringWithFormat:@"%ld",(long)page];
    param[@"orderType"]= @"1";
    
    [self.httpManager POST:orderListUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int i = [responseObject[@"code"] intValue];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            weakself.tableView.hidden = NO;
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[FaceToFaceOrderModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tableView reloadData];
                
            });
            
        }
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        weakself.tableView.mj_footer.hidden = NO;
        
        if(i == 7030){
            
            //没有更多数据
         [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else if (i == 7230){
            //没有数据
            
            //订单为空
            weakself.tableView.hidden  = YES;
            CGFloat imageW = 120;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageW)];
            UILabel * label  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH/ 2.0f, ScreenW, 20)];
            label.text = @"你还没有任何订单";
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = 1;
            
            imageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 80);
            [imageView setImage:[UIImage imageNamed:@"dingdan_kong@2x"]];
            [weakself.view addSubview:imageView];
            [weakself.view addSubview:label];
            
        }
        //小于5条数据
        if (weakself.dataArray.count < 5) {
            //数据全部请求完毕
            weakself.tableView.mj_footer.hidden = YES;
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
    }];


}

#pragma mark ----tableViewDeleage
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
    
    FacePayOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:facePayTableViwIndertifer forIndexPath:indexPath];
    FaceToFaceOrderModel * model = self.dataArray[indexPath.section];
    //微信支付宝支付成功AAP端处理
    if (indexPath.section == 0) {
        if (_stusus == 1) {
            
        cell.commontStatedLabel.text = @"已支付";

        }
    }
    
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FaceToFaceOrderModel * model = self.dataArray[indexPath.section];

    CovertOrderViewController * orderDtailVC =[[CovertOrderViewController alloc] init];
    
    orderDtailVC.idName =[NSString stringWithFormat:@"%ld", (long)model.orderId];
    [self.navigationController pushViewController:orderDtailVC animated:YES];
}
#pragma mark --移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
