//
//  SearchCovertGoodsViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/28.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SearchCovertGoodsViewController.h"
#import "CovertDetailTableViewCell.h"
#import "ConvertGoodsCellModel.h"
#import "CovertGoodsViewController.h"
NSString  *const  covertDetailSSinderfier = @"CovertDetailTableViewCell.h";

@interface SearchCovertGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)UITableView * covertGoodTbleView;
@end

@implementation SearchCovertGoodsViewController{
    
    EasySearchBar * _searchBar;
    
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"SearchCovertGoodsViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"SearchCovertGoodsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化页数
    _page = 0;
    
    [self creatNavgationBar];
    
    [self creatUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
   
    [self addBackBarButtonItem];
    
    _searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(50, 26+self.StatusBarHeight, ScreenW - 80, 32)];
    _searchBar.searchField.backgroundColor = [UIColor colorWithHexString:BackColor];
    _searchBar.searchField.placeholder = @"输入商品名相关信息";
    _searchBar.searchField.delegate = self;
    [_searchBar.searchField becomeFirstResponder];
    self.navigationItem.titleView = _searchBar;
    
}
-(void)creatUI{
    
    //创建tableview
    _covertGoodTbleView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, screenH -64-self.StatusBarHeight-self.TabbarHeight) style:UITableViewStylePlain];
    _covertGoodTbleView.separatorStyle = NO;
    [self.view addSubview:_covertGoodTbleView];
    

    _covertGoodTbleView.delegate = self;
    _covertGoodTbleView.dataSource =self;
    [_covertGoodTbleView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:covertDetailSSinderfier];

    //上拉下载
    __weak typeof(self)weakself = self;
    _covertGoodTbleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        [weakself requestDataWithPage:weakself.page];
        
    }];
    //下拉加载
    _covertGoodTbleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page ++;
        [weakself requestDataWithPage:weakself.page];
        //加载全部分类数据
        
    }];
    
    //搜索不到商品
    CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.text = @"没有该商品";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"shangpin_kong@2x"]];
    [self.view addSubview:_nullImageView];
    [self.view addSubview:_nullLabel];
}



#pragma --数据请求
-(void)requestDataWithPage:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"name"] = _searchBar.searchField.text;
    param[@"orderBy"] = @"1";
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld",page];
    
    [weakself.httpManager POST:integralGoodsUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _nullLabel.hidden= YES;
        _nullImageView.hidden = YES;
        weakself.covertGoodTbleView.hidden = NO;
        NSString * str = responseObject[@"isSucc"];
        NSString * code = responseObject[@"code"];
        if ([str intValue] == 1) {
          
            weakself.covertGoodTbleView.frame = CGRectMake(0, 64, ScreenW, screenH );
            NSArray * array = responseObject[@"result"];
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            
            NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[ConvertGoodsCellModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:shoplistArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.covertGoodTbleView reloadData];
            });
            
        }
        [weakself.covertGoodTbleView.mj_header endRefreshing];
        [weakself.covertGoodTbleView.mj_footer endRefreshing];
        weakself.covertGoodTbleView.mj_footer.hidden = NO;
        weakself.covertGoodTbleView.mj_header.hidden = NO;
      
        if ([code integerValue] == 7230) {
            
            [weakself.dataArray removeAllObjects];

            weakself.covertGoodTbleView.hidden = YES;
            
            _nullImageView.hidden = NO;
            _nullLabel.hidden = NO;
            _nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 20);
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 60, ScreenW, 20);

        }else if ([code integerValue] == 7030){
            
            [weakself.covertGoodTbleView.mj_footer endRefreshingWithNoMoreData];
        }
     
        if (self.dataArray.count < 5) {
            
            weakself.covertGoodTbleView.mj_footer.hidden = YES;
        }
    
     
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakself.covertGoodTbleView.mj_header endRefreshing];
        [weakself.covertGoodTbleView.mj_footer endRefreshing];

    }];
 
}

#pragma mark -- tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:covertDetailSSinderfier forIndexPath:indexPath];
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    cell.convertModel = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",model.id];
    CovertGoodsViewController * intergralVC = [[CovertGoodsViewController alloc] init];
    [self.navigationController pushViewController:intergralVC animated:YES];
    
}
//收起键盘
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [_searchBar.searchField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    

    _page = 0;
    
    [_covertGoodTbleView.mj_header beginRefreshing];
    
    [_searchBar.searchField resignFirstResponder];
    
    return YES;
}

@end
