//
//  AllStoresGoodsController.m
//  hidui
//
//  Created by xuxin on 17/1/17.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AllStoresGoodsController.h"
#import "StoresGoodsCellTableViewCell.h"
#import "GroupGoodsMOdel.h"
#import "OnlineGoodsModel.h"
#import "ShopsGoodsBaseController.h"
NSString * const allGoodsInDertifier = @"StoresGoodsCellTableViewCell";
@interface AllStoresGoodsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)UITableView * tableView;

@end

@implementation AllStoresGoodsController

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [MTA trackPageViewBegin:@"AllStoresGoodsController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"AllStoresGoodsController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self creatNavgationBar];

    [self creatTableView];
    
    //加载数据
    [self firstLoad];
  
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"全部商品"];
    
    [self addBackBarButtonItem];
    
    self.navigationController.navigationBarHidden = NO;
}
-(void)firstLoad{
    //初始化page
    _page = 0;
    [_tableView.mj_header beginRefreshing];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"StoresGoodsCellTableViewCell" bundle:nil] forCellReuseIdentifier:allGoodsInDertifier];
    //上拉下载
    __weak typeof(self)weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.tableView.mj_footer.hidden = YES;

        weakself.page = 0;
        [weakself requestData:weakself.page];
        
    }];
    //下拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestData:weakself.page];
        
    }];
}
-(void)requestData:(NSInteger )page{
    
    if (_moreGoodsType == 1) {
        _requestUrl = moreGoodsListUrl;
    }else{
        _requestUrl = storeCommonAndGroupGoodsUrl;
    }
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    if (_moreGoodsType == 1) {
        
        param[@"goodsId"] = _goodsId;

    }else{
        
        param[@"storeId"] = _storeId;
        
        param[@"type"] = [NSString stringWithFormat:@"%ld",_type];

    }
    
    param[@"currentPage"]  = [NSString stringWithFormat:@"%ld",page];
    
    [self POST:weakself.requestUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        NSString * code = responseObject[@"code"];
        if ([str intValue] == 1) {
            
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            NSArray * array = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:array];
            [weakself.dataArray addObjectsFromArray:modelArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tableView reloadData];
            });
        }
 
        weakself.tableView.mj_footer.hidden = NO;
        weakself.tableView.mj_header.hidden = NO;
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
       
        if (weakself.dataArray.count < 5) {
            
            weakself.tableView.mj_footer.hidden = YES;
        }
        
        if ([code integerValue] == 7030) {
            
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }

    } failure:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];

    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoresGoodsCellTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:allGoodsInDertifier forIndexPath:indexPath];
    ONLINEgoodsModel * model = self.dataArray[indexPath.row];
    cell.onlineGoodsModel = model;
    return cell;
    
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ONLINEgoodsModel * model = self.dataArray[indexPath.row];
    ShopsGoodsBaseController * shopGoodsVC =[[ShopsGoodsBaseController alloc] init];
    //线下
    shopGoodsVC.goodsType = _type;
    
    shopGoodsVC.goodsId = model.id;
    
    [self.navigationController pushViewController:shopGoodsVC animated:YES];
    
}
@end
