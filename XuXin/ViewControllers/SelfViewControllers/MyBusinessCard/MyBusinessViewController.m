//
//  MyBusinessViewController.m
//  XuXin
//
//  Created by xian on 2017/9/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyBusinessViewController.h"
#import "CardHeaderView.h"
#import "FriendsCardTableViewCell.h"
#import "SelfCardTableViewCell.h"
#import "MsgListViewController.h"
#import "CardDetailViewController.h"
#import "CardQrCodeViewController.h"
#import "EditCardViewController.h"
#import "SearchFriendViewController.h"

#import "BusinessCardModel.h"
//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

@interface MyBusinessViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL _isExits;//是否已创建名片
    
}

@property (nonatomic, strong) UITableView *cardTableView;
@property (nonatomic, strong) UITableView *searchTableView;

///好友数组
@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic ,assign)NSInteger page;

@property (nonatomic, strong) BusinessCardModel *cardModel;
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation MyBusinessViewController{
    EasySearchBar  * searchBar;
    UIView *bgView;
    UIImageView *  nullGoodsImageView;
    UILabel * nullGoodsLabel;
}

- (BusinessCardModel *)cardModel{
    if (!_cardModel) {
        _cardModel = [[BusinessCardModel alloc] init];
    }
    return _cardModel;
}

-(NSMutableArray *)friendsArray{
    if (!_friendsArray) {
        
        _friendsArray = [[NSMutableArray alloc] init];
    }
    return _friendsArray;
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [MTA trackPageViewBegin:@"MyBusinessViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MyBusinessViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavigationBar];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _isExits = NO;
    _page = 0;
    _isSearch = NO;
    
    [self createUI];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeUserCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeFriendNumber" object:nil];
    
}

-(void)creatNavigationBar{
    self.navigationController.navigationBarHidden = YES;
    
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    //返回
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    
    [navBgView addSubview:returnButton];
   
    UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 36, 32+self.StatusBarHeight, 22, 22)];
    [navBgView addSubview:addBtn];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addFriend"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchDown];
    
    searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(61, 26+self.StatusBarHeight, ScreenW - 112, 32)];
    searchBar.easySearchBarPlaceholder = @"搜索姓名、公司、职务、电话号码";
    searchBar.searchField.delegate = self;
    [navBgView addSubview:searchBar];
    
}

- (void)createUI{
    if (!_cardTableView) {
        _cardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH) style:UITableViewStyleGrouped];
        _cardTableView.dataSource = self;
        _cardTableView.delegate = self;
        [self.view addSubview:_cardTableView];
    }
    
    self.cardTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_cardTableView registerNib:[UINib nibWithNibName:@"FriendsCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendsCardTableViewCell"];
    [_cardTableView registerClass:NSClassFromString(@"SelfCardTableViewCell") forCellReuseIdentifier:@"SelfCardTableViewCell"];
    [_cardTableView registerClass:NSClassFromString(@"CardHeaderView") forHeaderFooterViewReuseIdentifier:@"CardHeaderView"];
    //上拉下载
    __weak typeof(self)weakself = self;
    _cardTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        if (_isSearch) {
            [weakself requestDataWithPage:weakself.page];
        } else {
            [weakself requestData];
        }
        
        
    }];
    //下拉加载
    _cardTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_isSearch) {
            weakself.page ++;
            [weakself requestDataWithPage:weakself.page];
        }
        
        
    }];

}

- (void)requestData{
    __weak typeof(self)weakself = self;
    
    [weakself POST:findMyUserCardUrl parameters:nil success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            _cardModel = [BusinessCardModel yy_modelWithDictionary:responseObject[@"result"]];
            [self.cardTableView reloadData];
        } else {
            _isExits = NO;
            [self addImgWithNoArray];
        }
    } failure:^(NSError *error) {
        
    }];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = _cardId;
    
    [weakself POST:findMyFriendsUrl parameters:nil success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        int i = [responseObject[@"code"] intValue];
        
        if ([str intValue] == 1) {
            _isExits = YES;
            if (_friendsArray.count > 0) {
                [_friendsArray removeAllObjects];
            }
            NSArray * array = responseObject[@"result"];
            if (array.count > 0) {
                
                [self removeImg];
                
                NSArray * modelArray = [NSArray yy_modelArrayWithClass:[BusinessCardModel class] json:array];
                
                [weakself.friendsArray addObjectsFromArray:modelArray];
                
                [weakself.cardTableView reloadData];
            } else {
                [self addImgWithNoArray];
            }
            
            
        }
        
        [weakself.cardTableView.mj_header endRefreshing];
        [weakself.cardTableView.mj_footer endRefreshing];
        
        if (i == 7288) {
            _isExits = NO;
            [weakself.cardTableView reloadData];
        }
        
        if (i == 7230){
            [self addImgWithNoArray];

        }
        
        if (self.friendsArray.count < 5) {
            
            weakself.cardTableView.mj_footer.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.cardTableView reloadData];
            
            
        });
    } failure:^(NSError *error) {
        [weakself.cardTableView.mj_header endRefreshing];
        [weakself.cardTableView.mj_footer endRefreshing];
    }];
}

#pragma --数据请求
-(void)requestDataWithPage:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"content"] = searchBar.searchField.text;
    param[@"page"] =[NSString stringWithFormat:@"%ld",page];
    param[@"type"] = @(1);
    [weakself.httpManager POST:findUserCardByConditionUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        NSString * code = responseObject[@"code"];
        if ([str intValue] == 1) {
            
            [self removeImg];
            
            NSArray * array = responseObject[@"result"];
            if (page == 0) {
                
                [weakself.friendsArray removeAllObjects];
            }
            
            NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[BusinessCardModel class] json:array];
            
            [weakself.friendsArray addObjectsFromArray:shoplistArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.cardTableView reloadData];
            });
            
            weakself.cardTableView.mj_footer.hidden = NO;
            weakself.cardTableView.mj_header.hidden = NO;
        }
        
        [weakself.cardTableView.mj_header endRefreshing];
        [weakself.cardTableView.mj_footer endRefreshing];
        
        if ([code integerValue] == 7230) {
            
            [weakself.friendsArray removeAllObjects];
            [weakself.cardTableView reloadData];
            [self addImgWithNoArray];
            
            weakself.cardTableView.mj_footer.hidden = YES;
            weakself.cardTableView.mj_header.hidden = YES;
            
        }else if ([code integerValue] == 7030){
            
            [weakself.cardTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.friendsArray.count < 5) {
            
            weakself.cardTableView.mj_footer.hidden = YES;
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakself.cardTableView.mj_header endRefreshing];
        [weakself.cardTableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)addImgWithNoArray{
    //没有数据
    
    if (!nullGoodsImageView) {
        CGFloat imageW = 120;
        nullGoodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW, screenH, imageW, imageW)];
        
        nullGoodsImageView.center = CGPointMake(ScreenW/2.0f, screenH/4.0f*3 - 140);//-80
        
        nullGoodsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW, screenH , ScreenW, 20)];
        
        nullGoodsLabel.center = CGPointMake(ScreenW/2.0f, screenH/4.0f*3 +imageW - 160);//-100
        
        nullGoodsLabel.font = [UIFont systemFontOfSize:16];
        nullGoodsLabel.textAlignment = 1;
        
        [nullGoodsImageView setImage:[UIImage imageNamed:@"no_good_friends"]];
    }
    if (_isSearch) {
        nullGoodsLabel.text = @"没有该好友";
    } else {
        nullGoodsLabel.text = @"你还没有好友，赶紧去添加吧";
    }
    [self.cardTableView addSubview:nullGoodsImageView];
    [self.cardTableView addSubview:nullGoodsLabel];
}

- (void)removeImg{
    [nullGoodsLabel removeFromSuperview];
    [nullGoodsImageView removeFromSuperview];
}

#pragma mark ---导航栏按钮事件
-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFriends{
    SearchFriendViewController * searchFriendVC = [[SearchFriendViewController alloc] init];
    
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:searchFriendVC animated:YES];
}

- (void)checkMessage{
    MsgListViewController *msgListVC = [[MsgListViewController alloc] init];
    [self.navigationController pushViewController:msgListVC animated:YES];
}

- (void)clickCodeBtn{
    NSLog(@"二维码");
    CardQrCodeViewController *codeVC = [[CardQrCodeViewController alloc] init];
    codeVC.userName = _cardModel.username;
    codeVC.qrcodePath = _cardModel.qrcode;
    [self.navigationController pushViewController:codeVC animated:YES];
}

- (void)clickShareBtn{
    NSLog(@"发名片");
    [UMSocialQQHandler setQQWithAppId:@"1105491978" appKey:@"4vcul0EYJddeh32a" url:[NSString stringWithFormat:@"%@?id=%@",store_by_IDUrl,[User defalutManager].selectedShop]];
    
    [UMSocialWechatHandler setWXAppId:__WXappID appSecret:__WXappSecret url:[NSString stringWithFormat:@"%@?id=%@",store_by_IDUrl,[User defalutManager].selectedShop]];
    
    //分享类型为店铺
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"%@的名片",_cardModel.username];
    [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:@"%@的名片",_cardModel.username];
    //分享名片
    NSString * shareText = [NSString stringWithFormat:@"职务：%@\n公司：%@",_cardModel.job,_cardModel.company];
    
    // 显示分享界面
    
    //分享图片
    UIImage * shareImage = [UIImage imageNamed:@"shareLogo"];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMSocialAppKey                                      shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone, nil] delegate:nil];
    
}
#pragma mark ---搜索当前存在好友---
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //查询当前已添加好友
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _isSearch = NO;
    } else {
        _isSearch = YES;
    }
    
}

//收起键盘
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [searchBar.searchField resignFirstResponder];
    if (_isSearch) {
        _isSearch = NO;
        searchBar.searchField.text = @"";
        [_cardTableView.mj_header beginRefreshing];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        _isSearch = NO;
        [_cardTableView.mj_header beginRefreshing];
    } else {
        _isSearch = YES;
        _page = 0;
        
        [_cardTableView.mj_header beginRefreshing];
        
        
    }
    [searchBar.searchField resignFirstResponder];
    
    return YES;
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _searchTableView) {
        return 1;
    } else {
       return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchTableView) {
        return _searchArray.count;
    } else {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return _friendsArray.count;
                break;
                
            default:
                return 0;
                break;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _searchTableView) {
        return 0;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _cardTableView) {
        CardHeaderView * headerView = [[CardHeaderView alloc] initWithFrame:CGRectMake(0, 242 * ScreenScale, ScreenW, 50)];
        if (section == 0) {
            headerView.type = YES;
        } else {
            headerView.type = NO;
        }
        
        return headerView;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _searchTableView) {
        return 0;
    }else {
        if (section == 0) {
            return 10.0;
        }
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 95.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SelfCardTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"SelfCardTableViewCell" forIndexPath:indexPath];
        cell.isExit = _isExits;
        if (_isExits) {
            cell.model = _cardModel;
            [cell.codeButton addTarget:self action:@selector(clickCodeBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareButton addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    } else {
        FriendsCardTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"FriendsCardTableViewCell" forIndexPath:indexPath];
        
        BusinessCardModel *friendModel = _friendsArray[indexPath.row];
        
        cell.model = friendModel;
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteFriend:)];
//        longPress.view.tag = indexPath.row;
//        [cell addGestureRecognizer:longPress];
        
        return cell;
    }
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (_isExits) {
            CardDetailViewController *detailVC = [[CardDetailViewController alloc] init];
            detailVC.type = selfType;//自己
            detailVC.isFriend = YES;
            detailVC.userCardId = _cardModel.userCardId;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            EditCardViewController *editVC = [[EditCardViewController alloc] init];
            editVC.editType = createType;
            [self.navigationController pushViewController:editVC animated:YES];
        }
        
    } else {
        CardDetailViewController *detailVC = [[CardDetailViewController alloc] init];
        detailVC.type = friendType;//好友
        detailVC.isFriend = YES;
        BusinessCardModel *model = _friendsArray[indexPath.row];
        detailVC.userCardId = model.id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (void)addSearchBackView{
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, screenH-64)];
        bgView.backgroundColor = [UIColor colorWithHexString:WordColor alpha:0.7];
        [self.view addSubview:bgView];
    }
    
    
    if ((!_searchTableView)) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
        _searchTableView.separatorStyle = NO;
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        [bgView addSubview:_searchTableView];
    }
    [_searchTableView registerNib:[UINib nibWithNibName:@"FriendsCardTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendsCardTableViewCell"];
    //上拉下载
    __weak typeof(self)weakself = self;
    _searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.page = 0;
        [weakself requestDataWithPage:weakself.page];
        
    }];
    //下拉加载
    _searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page ++;
        [weakself requestDataWithPage:weakself.page];
  
    }];
    
    
}

- (void)removeSearchBackView{
    [bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [bgView removeFromSuperview];
}






- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
