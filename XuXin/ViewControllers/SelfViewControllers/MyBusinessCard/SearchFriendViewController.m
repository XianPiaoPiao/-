//
//  SearchFriendViewController.m
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "FriendsCardTableViewCell.h"
#import "BusinessCardModel.h"
#import "CardDetailViewController.h"

@interface SearchFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)UITableView * friendTableView;

@end

@implementation SearchFriendViewController{
    EasySearchBar * _searchBar;
    
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    _searchBar.searchField.placeholder = @"搜索姓名、公司、职务、电话号码";
    _searchBar.searchField.delegate = self;
    [_searchBar.searchField becomeFirstResponder];
    self.navigationItem.titleView = _searchBar;
    
}
-(void)creatUI{
    
    //创建tableview
    _friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, screenH -KNAV_TOOL_HEIGHT) style:UITableViewStylePlain];
    _friendTableView.separatorStyle = NO;
    [self.view addSubview:_friendTableView];
    
    
    _friendTableView.delegate = self;
    _friendTableView.dataSource =self;
    [_friendTableView registerNib:[UINib nibWithNibName:@"FriendsCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendsCardTableViewCell"];
    
    //上拉下载
    __weak typeof(self)weakself = self;
    _friendTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        [weakself requestDataWithPage:weakself.page];
        
    }];
    //下拉加载
    _friendTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page ++;
        [weakself requestDataWithPage:weakself.page];
        //加载全部分类数据
        
    }];
    
    //搜索不到商品
    CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.text = @"没有该用户";
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"no_good_friends"]];
    [self.view addSubview:_nullImageView];
    [self.view addSubview:_nullLabel];
}



#pragma --数据请求
-(void)requestDataWithPage:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"content"] = _searchBar.searchField.text;
    param[@"page"] =[NSString stringWithFormat:@"%ld",page];
    param[@"type"] = @(0);
    [weakself.httpManager POST:findUserCardByConditionUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _nullLabel.hidden= YES;
        _nullImageView.hidden = YES;
        weakself.friendTableView.hidden = NO;
        NSString * str = responseObject[@"isSucc"];
        NSString * code = responseObject[@"code"];
        if ([str intValue] == 1) {
            
            weakself.friendTableView.frame = CGRectMake(0, 64, ScreenW, screenH );
            NSArray * array = responseObject[@"result"];
            if (page == 0) {
                
                [weakself.dataArray removeAllObjects];
            }
            
            NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[BusinessCardModel class] json:array];
            
            [weakself.dataArray addObjectsFromArray:shoplistArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.friendTableView reloadData];
            });
            
        }
        [weakself.friendTableView.mj_header endRefreshing];
        [weakself.friendTableView.mj_footer endRefreshing];
        weakself.friendTableView.mj_footer.hidden = NO;
        weakself.friendTableView.mj_header.hidden = NO;
        
        if ([code integerValue] == 7230) {
            
            [weakself.dataArray removeAllObjects];
            
            weakself.friendTableView.hidden = YES;
            
            _nullImageView.hidden = NO;
            _nullLabel.hidden = NO;
            _nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 20);
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 60, ScreenW, 20);
            
        }else if ([code integerValue] == 7030){
            
            [weakself.friendTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.dataArray.count < 5) {
            
            weakself.friendTableView.mj_footer.hidden = YES;
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakself.friendTableView.mj_header endRefreshing];
        [weakself.friendTableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark -- tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendsCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCardTableViewCell" forIndexPath:indexPath];
    BusinessCardModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessCardModel * model = self.dataArray[indexPath.row];
    CardDetailViewController * cardDetailVC = [[CardDetailViewController alloc] init];
    cardDetailVC.userCardId = model.id;
    cardDetailVC.isFriend = NO;
    cardDetailVC.type = friendType;
    [self.navigationController pushViewController:cardDetailVC animated:YES];
    
}
//收起键盘
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [_searchBar.searchField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    _page = 0;
    
    [_friendTableView.mj_header beginRefreshing];
    
    [_searchBar.searchField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
