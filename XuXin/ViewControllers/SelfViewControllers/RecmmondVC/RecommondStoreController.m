//
//  RecommondStoreController.m
//  XuXin
//
//  Created by xuxin on 16/12/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecommondStoreController.h"
#import "ReconmondFriendTableViewCell.h"

NSString * const reconmodSotreTableIndertifer = @"ReconmondFriendTableViewCell";
@interface RecommondStoreController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign)NSInteger page;

@property (nonatomic ,assign)NSInteger page2;

@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)NSMutableArray * dataArray2;

@end

@implementation RecommondStoreController{
    //显示商家总数
    UILabel * _totalStoreLabel;
    UILabel * _totalPriceLabel;
    
    UILabel * _totalManagerLabel;
    UILabel * _totalManagerMoneyLabel;

    UIScrollView * _contentScrollView;
    UIView * _sliderView;

    UITableView * _tableView;
    UITableView * _tableView2;

  
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)dataArray2{
    if (!_dataArray2) {
        
        _dataArray2 = [[NSMutableArray alloc] init];
    }
    return _dataArray2;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingUI];
    
    [self creatSliderView];
    
    [self firstLoad];
    
    
}

-(void)firstLoad{
    //初始化page
    [self.view addSubview:[EaseLoadingView defalutManager]];
    
    [EaseLoadingView defalutManager].frame = CGRectMake(0, 0, ScreenW, screenH);
    [[EaseLoadingView defalutManager] startLoading];
//    
     _page = 0;
    
     _page2 = 0;
    
    [self requestData];
    
    [self requestData2];
}
-(void)settingUI{
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, ScreenW /2.0f, 54)];
    leftView.tag = 100;
    
    leftView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:leftView];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/2.0f, 1, ScreenW /2.0f, 54)];
    rightView.backgroundColor = [UIColor whiteColor];
    rightView.tag = 200;
    [self.view addSubview:rightView];
   
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAnother:)];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAnother:)];
    
    [leftView addGestureRecognizer:tap];
    [rightView addGestureRecognizer:tap2];
    
    for (int i = 0; i < 2; i ++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW /4.0f * i, 10, ScreenW /4.0f , 20)];
        label.textAlignment = 1;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:14];
        if ( i == 0) {
            label.text = @"推荐商家";

        }else{
            label.text = @"总佣金";

        }
        
       [leftView addSubview:label];

    }
    
    for (int i = 0; i < 2; i ++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW /4.0f * i, 10, ScreenW /4.0f, 20)];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        if ( i == 0) {
            label.text = @"管理商家";
            
        }else{
            label.text = @"总佣金";
            
        }
        [rightView addSubview:label];
        
    }
    //
    _totalStoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenW/4.0f, 20)];
    _totalStoreLabel.font = [UIFont systemFontOfSize:14];
    _totalStoreLabel.textAlignment = 1;
    [leftView addSubview:_totalStoreLabel];
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW /4.0f, 30, ScreenW /4.0f, 20)];
    _totalPriceLabel.font = [UIFont systemFontOfSize:14];
    _totalPriceLabel.textAlignment = 1;
    [leftView addSubview:_totalPriceLabel];
    
    //
    _totalManagerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenW/4.0f, 20)];
    _totalManagerLabel.font = [UIFont systemFontOfSize:14];
    _totalManagerLabel.textAlignment = 1;
    [rightView addSubview:_totalManagerLabel];
    
    _totalManagerMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW /4.0f, 30, ScreenW /4.0f, 20)];
    _totalManagerMoneyLabel.font = [UIFont systemFontOfSize:14];
    _totalManagerMoneyLabel.textAlignment = 1;
    [rightView addSubview:_totalManagerMoneyLabel];
    
    //分割线
    UIView * seperateString = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/ 2.0f, 16, 1, 28)];
    seperateString.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:seperateString];
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 54, ScreenW , screenH +50)];
    _contentScrollView.contentSize = CGSizeMake(ScreenW * 2, screenH + 50);
    [self.view addSubview:_contentScrollView];
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    [self.view addSubview:_contentScrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, ScreenW,screenH - 54 - 64)];
    _tableView.backgroundColor =[UIColor colorWithHexString:BackColor];
    
    _tableView.separatorStyle = NO;
    [_contentScrollView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ReconmondFriendTableViewCell" bundle:nil] forCellReuseIdentifier:reconmodSotreTableIndertifer];

    
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 8, ScreenW,screenH - 54 - 64)];
    _tableView2.backgroundColor =[UIColor colorWithHexString:BackColor];
    
    _tableView2.separatorStyle = NO;
    [_contentScrollView addSubview:_tableView2];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    [_tableView2 registerNib:[UINib nibWithNibName:@"ReconmondFriendTableViewCell" bundle:nil] forCellReuseIdentifier:reconmodSotreTableIndertifer];
    

  
}
-(void)creatSliderView{
    //给view添加点击事件

    
    _sliderView  = [[UIView alloc] initWithFrame:CGRectMake(0, 55, ScreenW/ 2.0f, 1)];
    _sliderView.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self selectFirst];
    
    [self.view addSubview:_sliderView];
    
}
//数据请求

-(void)requestData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param  = [NSMutableDictionary dictionary];
    param[@"type"] = @"2";
    

    [weakself.httpManager POST:userRecommendStoreUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            
            NSArray * array = responseObject[@"result"][@"remd_store"];
            self.dataArray = [NSMutableArray arrayWithArray:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
                
                NSInteger count =  [responseObject[@"result"][@"total_count"] integerValue];
                
                _totalStoreLabel.text = [NSString stringWithFormat:@"%ld",count];
                
                CGFloat total = [responseObject[@"result"][@"total_bonus"] floatValue];
                
                _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",total];
                
            });
            
            if (self.dataArray.count == 0) {
                
                [self showNullImage];
                
            }
        }
        
        [[EaseLoadingView defalutManager] stopLoading];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[EaseLoadingView defalutManager] stopLoading];

    }];
}

-(void)requestData2{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param  = [NSMutableDictionary dictionary];
    param[@"type"] = @"1";
    

    [weakself.httpManager POST:userRecommendStoreUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            
            NSArray * array = responseObject[@"result"][@"remd_store"];
            weakself.dataArray2 = [NSMutableArray arrayWithArray:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView2 reloadData];
                
                NSInteger count =  [responseObject[@"result"][@"total_count"] integerValue];
                
                _totalManagerLabel.text = [NSString stringWithFormat:@"%ld",count];
                
                CGFloat total = [responseObject[@"result"][@"total_bonus"] floatValue];
                _totalManagerMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",total];
                
            });
            
            if (self.dataArray2.count == 0) {
                
                [self showTwoImage];
                
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[EaseLoadingView defalutManager] stopLoading];

    }];
    
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        
        return self.dataArray.count;

    }else{
        return self.dataArray2.count;

    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView == _tableView) {
        ReconmondFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reconmodSotreTableIndertifer forIndexPath:indexPath];
        
        cell.userNameLabel.text = self.dataArray[indexPath.row][@"storeName"];
        cell.priceValueLabel.text =[NSString stringWithFormat:@"￥%@", self.dataArray[indexPath.row][@"money"]];
        NSString * iconUrl = self.dataArray[indexPath.row][@"store_logo"];
        [cell.userIconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
        
        return cell;

    }else{
        
        ReconmondFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reconmodSotreTableIndertifer forIndexPath:indexPath];
        
        cell.userNameLabel.text = self.dataArray2[indexPath.row][@"storeName"];
        cell.priceValueLabel.text =[NSString stringWithFormat:@"￥%@", self.dataArray2[indexPath.row][@"money"]];
        NSString * iconUrl = self.dataArray2[indexPath.row][@"store_logo"];
        [cell.userIconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
        
        return cell;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void)jumpAnother:(UITapGestureRecognizer *)gesture{
    
    if (gesture.view.tag  == 100) {
        
        [self selectFirst];
        _contentScrollView.contentOffset = CGPointMake(0, 0);
        [UIView animateWithDuration:0.4 animations:^{
            
            _sliderView.center = CGPointMake(ScreenW/4*1.0f, 54);
            
        }];
        
    } else if (gesture.view.tag ==200){
        
        [self selectSecond];
        _contentScrollView.contentOffset = CGPointMake(ScreenW, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            
            _sliderView.center = CGPointMake(ScreenW/4*3.0f, 54);
            
        }];
        
    }
}
-(void)selectFirst{
    
    UIView * leftView =[self.view viewWithTag:100];
    for (UILabel * label in leftView.subviews) {
        
        label.textColor = [UIColor colorWithHexString:MainColor];
    }
    UIView * rightView =[self.view viewWithTag:200];
    for (UILabel * label in rightView.subviews) {
        
        label.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}
-(void)selectSecond{
    
    UIView * leftView =[self.view viewWithTag:100];
    for (UILabel * label in leftView.subviews) {
        
        label.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    UIView * rightView =[self.view viewWithTag:200];
    for (UILabel * label in rightView.subviews) {
        
        label.textColor = [UIColor colorWithHexString:MainColor];
    }
}

-(void)showNullImage{
    //搜索不到商家
    
        CGFloat imageW = 120;
        
        UIImageView * nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
        UILabel * nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
        nullLabel.text = @"你还没有推荐任何商家";
        nullLabel.font = [UIFont systemFontOfSize:16];
        nullLabel.textAlignment = 1;
        
        [nullImageView setImage:[UIImage imageNamed:@"shangjia_kong@2x"]];
        [_contentScrollView addSubview:nullImageView];
        [_contentScrollView addSubview:nullLabel];
        
        nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 80);
        nullLabel.frame = CGRectMake(0, screenH/ 2.0f , ScreenW, 20);
        
    
   
   
}
-(void)showTwoImage{
    
    CGFloat imageW = 120;
    
    UIImageView * nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    UILabel * nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    nullLabel.text = @"你还没有推荐任何商家";
    nullLabel.font = [UIFont systemFontOfSize:16];
    nullLabel.textAlignment = 1;
    
    [nullImageView setImage:[UIImage imageNamed:@"shangjia_kong@2x"]];
    [_contentScrollView addSubview:nullImageView];
    [_contentScrollView addSubview:nullLabel];
    
    nullImageView.center = CGPointMake(ScreenW / 2* 3, screenH/2.0f - 80);
    nullLabel.frame = CGRectMake(ScreenW, screenH/ 2.0f , ScreenW, 20);

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _contentScrollView) {
        
        
        if (scrollView.contentOffset.x  == 0) {
            
            [self selectFirst];
            
            [UIView animateWithDuration:0.4 animations:^{
                _sliderView.center = CGPointMake(ScreenW/4*1.0f, 54);
                
            }];
            
            
        }else if(scrollView.contentOffset.x  == ScreenW){
            
            [self selectSecond];
            
            [UIView animateWithDuration:0.4 animations:^{
                
                _sliderView.center = CGPointMake(ScreenW/4*3.0f, 54);
                
            }];
            
            
        }
    }
    
}


@end
