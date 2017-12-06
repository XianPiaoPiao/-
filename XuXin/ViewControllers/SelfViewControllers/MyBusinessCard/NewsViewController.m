//
//  NewsViewController.m
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "SetNewsViewController.h"
#import "EditNewsViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *imageView;
    UILabel *label;
}

@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, strong) NSMutableArray *newsArray;

@property (nonatomic ,assign)NSInteger page;

@end

@implementation NewsViewController

-(NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    [self createUI];
    
    [self firstLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstLoad) name:@"NewsHaveChanged" object:nil];
}

-(void)firstLoad{
    
    [self.newsTableView.mj_header beginRefreshing];
}

- (void)requestData:(NSInteger)page{
    
    //数据请求
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"ucId"] = [NSString stringWithFormat:@"%@",_ucId];
    if (_newsType == productType) {
        param[@"type"] = [NSString stringWithFormat:@"%d",0];
    } else {
        param[@"type"] = [NSString stringWithFormat:@"%ld",_newsType];
    }
    param[@"page"]= [NSString stringWithFormat:@"%ld",page];
    
    [self POST:findCardContentListUrl parameters:param success:^(id responseObject) {
        
        
        NSString * str = responseObject[@"isSucc"];
        
        int i = [responseObject[@"code"] intValue];
        
        if ([str intValue] == 1) {
            
            if (weakself.newsArray.count > 0 && page == 0) {
                [weakself.newsArray removeAllObjects];
            }
            weakself.newsTableView.hidden = NO;
            [self removeImage];
            
            NSArray *array = responseObject[@"result"];
            weakself.newsArray = [NSMutableArray arrayWithArray:array];
            
        }else{
            //为空
            weakself.newsTableView.hidden = YES;
            
            [self adddImageWithNoArray];
        }
        weakself.newsTableView.mj_header.hidden = NO;
        weakself.newsTableView.mj_footer.hidden = NO;
        [weakself.newsTableView.mj_header endRefreshing];
        [weakself.newsTableView.mj_footer endRefreshing];
        
        if(i == 7030){
            
            //没有更多数据
            [weakself.newsTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        //小于5条数据
        if (weakself.newsArray.count < 5 && self.newsArray.count >0) {
            //数据全部请求完毕
            weakself.newsTableView.mj_footer.hidden = YES;
            
        }else if (self.newsArray.count == 0){
            
            [weakself.newsTableView.mj_footer endRefreshing];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.newsTableView reloadData];
        });
        
        
    } failure:^(NSError *error) {
        
        [weakself.newsTableView.mj_header endRefreshing];
        [weakself.newsTableView.mj_footer endRefreshing];
        //将自增的page减下来
        if(weakself.page > 0){
            weakself.page--;
        }
    }];
    
}

- (void)adddImageWithNoArray{
    CGFloat imageW = 120;
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW+60, imageW)];
        label  = [[UILabel alloc] init];//WithFrame:CGRectMake(0, screenH/ 2.0f , ScreenW, 20)
        label.text = @"诶，这里还没有东西";
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = 1;
        
        imageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f);
        [imageView setImage:[UIImage imageNamed:@"no_data"]];
    }
    
    [self.view addSubview:imageView];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(ScreenW, 20));
        make.centerX.mas_equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
}

- (void)removeImage{
    [imageView removeFromSuperview];
    [label removeFromSuperview];
}

- (void)createNavBar{
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:_navTitle];
    [navBgView addSubview:label];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:returnButton];
}

- (void)returnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    CGFloat tableH ;
    if (_type == 1) {
        tableH = screenH-60;
    } else {
        tableH = screenH;
    }
    
    _newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, tableH-64)];
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _newsTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:_newsTableView];
    
    [_newsTableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];
    //上拉下载
    __weak typeof(self)weakself = self;
    _newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //  加载全部分类数据
        weakself.page = 0;
        
        [weakself requestData:weakself.page];
        //  加载城市分类数据
        weakself.newsTableView.mj_footer.hidden = YES;
        
        
    }];
    //下拉加载
    _newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.page ++;
        [weakself requestData:weakself.page];
        
    }];
    
    
    if (_type == selfType) {
        UIButton *addNewsBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, tableH-10-self.TabbarHeight, ScreenW-20, 49)];
        [addNewsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addNewsBtn setTitle:@"发布新信息" forState:UIControlStateNormal];
        [addNewsBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [addNewsBtn setBackgroundColor:[UIColor colorWithHexString:MainColor]];
        addNewsBtn.layer.cornerRadius = 20;
        addNewsBtn.layer.masksToBounds = YES;
        [self.view addSubview:addNewsBtn];
        [addNewsBtn addTarget:self action:@selector(addNews:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addNews:(UIButton *)sender{
    SetNewsViewController *setVC = [[SetNewsViewController alloc] init];
    setVC.navTitle = _navTitle;
    setVC.newsType = _newsType;
    setVC.type = _type;
    setVC.editType = createType;
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark ------UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _newsArray[indexPath.row];
    cell.type = _type;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    cell.contentLabel.text = dic[@"title"];
    
    NSTimeInterval time = [dic[@"addTime"] doubleValue]/1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSString * dateStr = [format stringFromDate:date];
    cell.dateLabel.text = dateStr;
    
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(delNews:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row != 0) {
        
        [cell.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(@18);
            make.top.equalTo(cell.contentView.mas_top).offset(2);
            make.left.equalTo(cell.contentView.mas_left).offset(100);
            make.right.equalTo(cell.contentView.mas_right).offset(-100);
        }];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"查看动态详情");
    NSDictionary *dic = _newsArray[indexPath.row];
    EditNewsViewController *editNewsVC = [[EditNewsViewController alloc] init];
    editNewsVC.navTitle = _navTitle;
    editNewsVC.editType = readType;
    editNewsVC.ccId = dic[@"id"];
    editNewsVC.logoUrlPath = dic[@"logo"];
    editNewsVC.titleContent = dic[@"title"];
    editNewsVC.type = _type;
    editNewsVC.introductionType = _newsType;
    [self.navigationController pushViewController:editNewsVC animated:YES];
}

- (void)delNews:(UIButton *)sender{
    __weak typeof(self)weakself = self;
    NSDictionary *dic = _newsArray[sender.tag];
    NSString *msg = [NSString stringWithFormat:@"确认删除此条动态？"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"ccId"] = dic[@"id"];
        [weakself POST:delectCardContentByID parameters:param success:^(id responseObject) {
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                [self requestData:_page];
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:delAction];
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
