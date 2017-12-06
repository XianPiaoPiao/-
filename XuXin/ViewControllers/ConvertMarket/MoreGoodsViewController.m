//
//  MoreGoodsViewController.m
//  XuXin
//
//  Created by xuxin on 16/11/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MoreGoodsViewController.h"
#import "CovertDetailTableViewCell.h"
#import "ConvertVCViewController.h"
#import "ConvertGoodsCellModel.h"
NSString * const convertDetailCellIndertifier = @"CovertDetailTableViewCell";
@interface MoreGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * convertDataArray;
@property (nonatomic ,assign)NSInteger page;
@end

@implementation MoreGoodsViewController{
    UITableView * _tableView;

}

-(NSMutableArray *)convertDataArray{
    if (!_convertDataArray) {
        _convertDataArray = [[NSMutableArray alloc] init];
    }
    return _convertDataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"MoreGoodsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MTA trackPageViewEnd:@"MoreGoodsViewController"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    //初始化页面
    _page = 0;
    
    [self creatNavgationbar];
    
    [self creatUI];
    
    [self firstLoad];
}
-(void)firstLoad{
    
    [_tableView.mj_header beginRefreshing];
}

-(void)requestData:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"integralGoodsClassId"] =[NSString stringWithFormat:@"%ld",_ig_goodsClassId];
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    
    [weakself POST:moreExchangeGoodsUrl parameters:param success:^(id responseObject) {
        int i = [responseObject[@"code"] intValue];
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            if (page == 0) {
                
           [weakself.convertDataArray removeAllObjects];
                
            }
            NSArray * array2 = responseObject[@"result"];
            NSArray * modelArray2 = [NSArray yy_modelArrayWithClass:[Recommendgoods class] json:array2];
            
            [weakself.convertDataArray addObjectsFromArray:modelArray2];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_header.hidden = NO;
        _tableView.mj_footer.hidden = NO;
        //处理加载数据完成情况
        if(i == 7030){
            
            //没有更多数据
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            //没有数据
        }else if (i == 7230){
            
            [self.convertDataArray removeAllObjects];
            
        }
        //小于5条数据
        if (self.convertDataArray.count < 5) {
            //数据全部请求完毕
            _tableView.mj_footer.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });

    } failure:^(NSError *error) {

    }];
  }
-(void)creatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _tableView.separatorStyle = NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:convertDetailCellIndertifier];
    __weak typeof(self)weakself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _tableView.mj_footer.hidden = YES;
        weakself.page = 0;
        [self requestData:weakself.page];
        
    }];
    //下拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestData:weakself.page];
    }];
    
}
-(void)creatNavgationbar{
    
    [self addNavgationTitle:@"更多兑换商品"];
    [self addBackBarButtonItem];
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:convertDetailCellIndertifier    forIndexPath:indexPath];
    Recommendgoods * model = self.convertDataArray[indexPath.row];
    cell.goodsModel = model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.convertDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvertGoodsCellModel * model = self.convertDataArray[indexPath.row];
    [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",model.id];
    
    ConvertVCViewController * goodsVC = [[ConvertVCViewController alloc] init];
    goodsVC.model = model;
    [self.navigationController pushViewController:goodsVC animated:YES];
    
}
@end
