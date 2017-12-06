//
//  AllCommnetsController.m
//  XuXin
//
//  Created by xuxin on 17/3/27.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "AllCommnetsController.h"
#import "UserCommentsCell.h"
#import "UserCommentsModel.h"
NSString * const userAllComentsInderfier = @"UserCommentsCell";

@interface AllCommnetsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView * tableView;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger page;
@end

@implementation AllCommnetsController{
    UserCommentsCell * _cell;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self creatTableView];
    
    //初始化
    [self firstLoading];
    
}
-(void)firstLoading{
    
    _page = 0;

    [_tableView.mj_header beginRefreshing];
    
}
-(void)requestData:(NSInteger)page{
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    if (_type == 1) {
        
        param[@"goodsId"] = _storeId;
        
    }else{
        
        param[@"storeId"] = _storeId;

    }
    param[@"currentPage"] = [NSString stringWithFormat:@"%ld",_page];
    
    [weakself POST:weakself.requestUrl parameters:param success:^(id responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        
        NSString * str= responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            
            if (_page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[UserCommentsModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:modelArray];
        }
 
        weakself.tableView.mj_footer.hidden = NO;
        weakself.tableView.mj_header.hidden = NO;
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        if (weakself.dataArray.count < 5) {
            
            weakself.tableView.mj_footer.hidden = YES;
        }
        
        if (code == 7030) {
            
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
            
        });
        
        
    } failure:^(NSError *error) {
        
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self addNavgationTitle:@"全部评论"];
    
    [self addBackBarButtonItem];
    
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"UserCommentsCell" bundle:nil] forCellReuseIdentifier:userAllComentsInderfier];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell =[tableView dequeueReusableCellWithIdentifier:userAllComentsInderfier forIndexPath:indexPath];
    UserCommentsModel * model =  self.dataArray [indexPath.row];
    _cell.commentsModel = model;
    
    return _cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCommentsModel * model = self.dataArray[indexPath.row];
    
    return  [_cell getPointCellHeight:model];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
@end
