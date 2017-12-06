//
//  MoreRecordController.m
//  XuXin
//
//  Created by xuxin on 16/11/21.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MoreRecordController.h"
#import "CovertRecordTableViewCell.h"
NSString * const convertRecordIndertifier = @"CovertRecordTableViewCell";

@interface MoreRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * convertDataArray;

@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)UITableView * tableView;
@end

@implementation MoreRecordController{
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
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
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
    
    param[@"id"] =[User defalutManager].selectedGoodsID;
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",page];
    
    [weakself POST:convertInfoUrl parameters:param success:^(id responseObject) {
        int i = [responseObject[@"code"] intValue];
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            if (page == 0) {
                [weakself.convertDataArray removeAllObjects];
            }
            NSArray * array2 = responseObject[@"result"];
            NSArray * modelArray2 = [NSArray yy_modelArrayWithClass:[Exchangerecord class] json:array2];
            
            [weakself.convertDataArray addObjectsFromArray:modelArray2];
        }
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        weakself.tableView.mj_header.hidden = NO;
        weakself.tableView.mj_footer.hidden = NO;
        //处理加载数据完成情况
        if(i == 7030){
            
            //没有更多数据
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            //没有数据
        }else if (i == 7230){
            
            [weakself.convertDataArray removeAllObjects];
            
        }
        //小于5条数据
        if (weakself.convertDataArray.count < 5) {
            //数据全部请求完毕
            weakself.tableView.mj_footer.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
        });
        

    } failure:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];

    }];
   
}
-(void)creatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"CovertRecordTableViewCell" bundle:nil] forCellReuseIdentifier:convertRecordIndertifier];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
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
-(void)creatNavgationbar{
    
    [self addNavgationTitle:@"更多兑换记录"];
    
    [self addBackBarButtonItem];
}
-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CovertRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:convertRecordIndertifier    forIndexPath:indexPath];
    Exchangerecord * model = self.convertDataArray[indexPath.row];
    cell.recordModel = model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.convertDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
@end
