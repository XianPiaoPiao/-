//
//  CardDetailViewController.m
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CardDetailViewController.h"
#import "CardDetailHeadView.h"
#import "HDConvertButton.h"
#import "CardDetailTableViewCell.h"
#import "EditCardViewController.h"
#import "NewsViewController.h"
#import "EditNewsViewController.h"

#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import "LJContactManager.h"

#import "BusinessCardModel.h"
//友盟分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

@interface CardDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CNContactViewControllerDelegate,CNContactPickerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger categoryPage;

@property (nonatomic, copy) BusinessCardModel *cardModel;


@end

@implementation CardDetailViewController{
    UIScrollView * _categorySrollView;
    UIPageControl *_categoryControl;
    UIButton *addFriendBtn;
}

- (BusinessCardModel *)cardModel{
    if (!_cardModel) {
        _cardModel = [[BusinessCardModel alloc] init];
    }
    return _cardModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavigationBar];
    
    [self createUI];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeUserCard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"IntroduceChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContactSuccess) name:@"saveContact" object:nil];

}

- (void)saveContactSuccess{
//    [self showStaus:@"已存入本机通讯录"];
    [SVProgressHUD showSuccessWithStatus:@"已存入本机通讯录"];
}

- (void)requestData{
    __weak typeof(self)weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"id"] = _userCardId;
    [weakself POST:findMyUserCardUrl parameters:dic success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            _cardModel = [BusinessCardModel yy_modelWithDictionary:responseObject[@"result"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ---initUI
-(void)creatNavigationBar{
    
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"名片管理"];
    [navBgView addSubview:label];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:returnButton];
    if (_type == selfType) {
        UIButton * editBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 50, 20+self.StatusBarHeight, 50, 44)];
        [navBgView addSubview:editBtn];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editDetail) forControlEvents:UIControlEventTouchDown];
    } else if (_type == friendType && _isFriend == YES) {
        UIButton * editBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 70, 20+self.StatusBarHeight, 70, 44)];
        [navBgView addSubview:editBtn];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [editBtn setTitle:@"删除好友" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchDown];
    }
    
}
#pragma mark ---导航栏按钮事件
-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editDetail{
    //编辑
    EditCardViewController *editCardVC = [[EditCardViewController alloc] init];
    editCardVC.editType = updateType;
    editCardVC.cardId = _userCardId;//_cardModel.userCardId;
    [self.navigationController pushViewController:editCardVC animated:YES];
}

- (void)deleteFriend:(UIButton *)sender{
    __weak typeof(self)weakself = self;
    
    NSString *msg = [NSString stringWithFormat:@"确认删除好友%@",_cardModel.username];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"id"] = _userCardId;
        dic[@"type"] = @(0);
        [weakself POST:deleteBuddyUrl parameters:dic success:^(id responseObject) {
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFriendNumber" object:nil];
                [self showStaus:@"已删除"];
                int64_t delayInSeconds = 1.0;      // 延迟的时间
                /*
                 *@parameter 1,时间参照，从此刻开始计时
                 *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
                 */
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:delAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    if (_isFriend) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH) style:UITableViewStylePlain];
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH-124) style:UITableViewStylePlain];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:NSClassFromString(@"CardDetailTableViewCell") forCellReuseIdentifier:@"CardDetailTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (_isFriend == NO) {
        addFriendBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, screenH-70, ScreenW-20, 49)];
        [addFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
        [addFriendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [addFriendBtn setBackgroundColor:[UIColor colorWithHexString:MainColor]];
        addFriendBtn.layer.cornerRadius = 20;
        addFriendBtn.layer.masksToBounds = YES;
        [self.view addSubview:addFriendBtn];
        [addFriendBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addFriend{
    __weak typeof(self)weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"id"] = _userCardId;
    dic[@"type"] = @(1);
    [weakself POST:deleteBuddyUrl parameters:dic success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFriendNumber" object:nil];
            [self showStaus:@"添加好友成功"];
            _isFriend = YES;
            addFriendBtn.hidden = YES;
            self.tableView.frame = CGRectMake(0, 64, ScreenW, screenH);
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 92;
    } else {
        return 73;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CardDetailHeadView *headView = [[CardDetailHeadView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 200)];
    headView.model = _cardModel;
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
        _categorySrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 92)];
        [cell.contentView addSubview:_categorySrollView];
        
        _categorySrollView.delegate = self;
        _categorySrollView.pagingEnabled = YES;
        _categorySrollView.showsHorizontalScrollIndicator = NO;
        
        cell.selectionStyle = NO;
        _categorySrollView.backgroundColor = [UIColor whiteColor];
        
        //添加分类pagecontrol
        _categoryControl = [[UIPageControl alloc] init];
        [cell.contentView addSubview:_categoryControl];
        //创建约束
        [_categoryControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_categorySrollView.mas_left);
            make.right.equalTo(_categorySrollView.mas_right);
            make.bottom.equalTo(_categorySrollView.mas_bottom);
            make.height.equalTo(@20);
        }];
        
        NSArray *btnTitleArray = @[@"存入通讯录",@"电话",@"个人介绍",@"分享名片",@"公司介绍",@"产品中心",@"新闻动态",@"招商加盟"];
        NSArray *imgTitleArray = @[@"mail_list",@"telephone",@"introduce",@"share_card",@"company_introduction",@"product_center",@"news_information",@"join"];
        _categoryControl.numberOfPages = 2 ;
        _categorySrollView.contentSize = CGSizeMake(ScreenW * 2, 92);
        
        [_categoryControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:MainColor]];
        _categoryControl.pageIndicatorTintColor = [UIColor colorWithHexString:BackColor];
        //保持tableView滑动时
        _categoryControl.currentPage = _categoryPage;
        _categorySrollView.contentOffset = CGPointMake(ScreenW * _categoryPage, 0);
        
        CGFloat buttonW = ScreenW/4 ;
        CGFloat buttonH = 60;
        
        for (int i = 0; i<btnTitleArray.count; i++) {
            
            UIButton * button =[[HDConvertButton alloc] init];
            //字体居中
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            //跳转下一个界面
            [button addTarget:self action:@selector(jumpDetailVC:) forControlEvents:UIControlEventTouchDown];
            [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button setImage:[UIImage imageNamed:imgTitleArray[i]] forState:UIControlStateNormal];
            
            //设置button的tag值
            button.tag = buttonTag + i;
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [button setImagePositionWithType:SSImagePositionTypeTop spacing:5];
            
            [_categorySrollView addSubview:button];
            if (_type == selfType) {
                if (i == 0 || i == 1) {
                    button.hidden = YES;
                } else {
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_categorySrollView.mas_left).offset((i-2)*buttonW);
                        make.top.equalTo(_categorySrollView.mas_top).offset(14);
                        make.size.sizeOffset(CGSizeMake(buttonW, buttonH));
                    }];
                }
            } else {
                button.hidden = NO;
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_categorySrollView.mas_left).offset(i*buttonW);
                    make.top.equalTo(_categorySrollView.mas_top).offset(14);
                    make.size.sizeOffset(CGSizeMake(buttonW, buttonH));
                }];
            }
            
            
        }
        return cell;
    } else {
        CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardDetailTableViewCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"手机";
                cell.contentLabel.text = _cardModel.mobile;
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"邮箱";
                cell.contentLabel.text = _cardModel.email;
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"公司";
                cell.contentLabel.text = _cardModel.company;
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    return nil;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    NSUInteger currentPage = point.x/_categorySrollView.frame.size.width;
    _categoryControl.currentPage = currentPage;
    _categoryPage = currentPage;
    
    // 头视图固定
//    NSInteger pushNewsTableViewHeaderViewHeight = 200;
//    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= pushNewsTableViewHeaderViewHeight) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//
//    }else if (scrollView.contentOffset.y >= pushNewsTableViewHeaderViewHeight){
//
//        scrollView.contentInset = UIEdgeInsetsMake(-pushNewsTableViewHeaderViewHeight, 0, 0, 0);
//
//    }
   
}

- (void)jumpDetailVC:(UIButton *)sender{
    
    switch (sender.tag) {
        case buttonTag:
        {
            //@"存入通讯录",
//            [self isAllowContacts];
            [self saceContacts];
        }
            break;
        case buttonTag+1:
        {
            //@"电话",
            UIWebView * webVIew = [[UIWebView alloc] init];
            NSString * phoneNumber = _cardModel.mobile;
            
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
            [webVIew loadRequest:[NSURLRequest requestWithURL:url]];
            
            [self.view addSubview:webVIew];
            
        }
            break;
        case buttonTag+2:
        {
            
            //@"个人介绍",
            EditNewsViewController *editVC = [[EditNewsViewController alloc] init];
            editVC.type = _type;
            if (_type) {
                editVC.editType = updateType;
            }else {
                editVC.editType = readType;
            }
            editVC.navTitle = @"个人介绍";
            editVC.intrType = 0;
            editVC.contentDetail = _cardModel.intro;
            [self.navigationController pushViewController:editVC animated:YES];
            
        }
            break;
        case buttonTag+3:
        {
            //@"分享名片"
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
            break;
        case buttonTag+4:
        {
            //@"公司介绍",
            EditNewsViewController *editVC = [[EditNewsViewController alloc] init];
            editVC.type = _type;
            if (_type) {
                editVC.editType = updateType;
            }else {
                editVC.editType = readType;
            }
            editVC.navTitle = @"公司介绍";
            editVC.intrType = 1;
            editVC.contentDetail = _cardModel.company_intro;
            [self.navigationController pushViewController:editVC animated:YES];
        }
            break;
        //类型:0 产品 1 新闻 2 招商
        case buttonTag+5:
        {
            //@"产品中心",
            NewsViewController *newsVC = [[NewsViewController alloc] init];
            newsVC.type = _type;
            newsVC.navTitle = @"产品中心";
            newsVC.newsType = productType;
            newsVC.ucId = _userCardId;
            [self.navigationController pushViewController:newsVC animated:YES];
            
        }
            break;
        case buttonTag+6:
        {
            //@"新闻动态",
            NewsViewController *newsVC = [[NewsViewController alloc] init];
            newsVC.type = _type;
            newsVC.navTitle = @"新闻动态";
            newsVC.newsType = theNewsType;
            newsVC.ucId = _userCardId;
            [self.navigationController pushViewController:newsVC animated:YES];
        }
            break;
        case buttonTag+7:
        {
            //@"招商加盟",
            NewsViewController *newsVC = [[NewsViewController alloc] init];
            newsVC.type = _type;
            newsVC.navTitle = @"招商加盟";
            newsVC.newsType = merchantsType;
            newsVC.ucId = _userCardId;
            [self.navigationController pushViewController:newsVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 存入通讯录
- (void)saceContacts{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择存入方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveNewAction = [UIAlertAction actionWithTitle:@"新建联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[LJContactManager sharedInstance] createNewContactWithPerson:_cardModel controller:self];
        
    }];
    
    UIAlertAction *saveExistAction = [UIAlertAction actionWithTitle:@"保存到现有联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[LJContactManager sharedInstance] addToExistingContactsWithPhoneNum:_cardModel.mobile controller:self];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:saveNewAction];
    [alertController addAction:saveExistAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
