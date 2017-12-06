//
//  RecomondMyFriendViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/28.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecomondMyFriendViewController.h"
#import "ReconmondFriendTableViewCell.h"
NSString * const reconmodFriendTableIndertifer = @"ReconmondFriendTableViewCell";
@interface RecomondMyFriendViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *recomondView;
@property (weak, nonatomic) IBOutlet UIView *recmondLifeView;
@property (weak, nonatomic) IBOutlet UILabel *secondTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondManLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTotalLable;
@property (weak, nonatomic) IBOutlet UILabel *firstManLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTotalLabel;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UILabel *secondPeople;
@property (nonatomic ,strong)NSMutableArray * dataArray2;
@property (weak, nonatomic) IBOutlet UILabel *peopelLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (nonatomic ,copy)NSString * iconUrl;
@end

@implementation RecomondMyFriendViewController{
    UITapGestureRecognizer * tap;
    UITapGestureRecognizer * tap2 ;
    UITableView * _tableView;
    UITableView * _tableView2;
    UIScrollView * _contentScrollView;
    UIView * _sliderView;
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
    
    [self creatTableView];
    //创建滑块
    [self creatSliderView];
    
    [self firstLoad];
  
    
}
-(void)firstLoad{
    
    [_tableView.mj_header beginRefreshing];
    
    [_tableView2.mj_header beginRefreshing];
    
}
-(void)creatSliderView{
    //给view添加点击事件
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAnother:)];
    
    tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAnother:)];
    [self.recomondView addGestureRecognizer:tap];
    [self.recmondLifeView addGestureRecognizer:tap2];
    
    _sliderView  = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenW/ 2.0f, 1)];
    _sliderView.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self selectFirst];
    [self.view addSubview:_sliderView];
    
}
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    
    [weakself.httpManager POST:myRecommendUserUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            
            NSArray * array = responseObject[@"result"][@"user_ref1"];
            NSArray * array2 = responseObject[@"result"][@"user_ref2"];
            weakself.dataArray = [NSMutableArray arrayWithArray:array];
            weakself.dataArray2 = [NSMutableArray arrayWithArray:array2];
            _iconUrl = responseObject[@"user_ico"];
            //
            _peopelLabel.text = [NSString stringWithFormat:@"%ld人",self.dataArray.count];
            _secondPeople.text = [NSString stringWithFormat:@"%ld人",self.dataArray2.count];
            CGFloat total =0 ;
            for (NSString * str in self.dataArray) {
                
                NSArray * array = [str componentsSeparatedByString:@","];
                for (int i = 0; i< array.count;i++) {
                    NSString * str2 =array[1];
                    CGFloat number = [str2 floatValue];
                    
                    total = number + total;
                }
            }
            
            
            CGFloat total2 =0 ;
            for (NSString * str in self.dataArray2) {
                
                NSArray * array = [str componentsSeparatedByString:@","];
                for (int i = 0; i< array.count;i++) {
                    NSString * str2 =array[1];
                    CGFloat number = [str2 floatValue];
                    
                    total2 = number + total2;
                }
            }
            _totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",total/2.0f];
            _secondTotalLabel.text= [NSString stringWithFormat:@"%.2f",total2/2.0f];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [_tableView2 reloadData];
        });
        [_tableView.mj_header endRefreshing];
        [_tableView2.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView2.mj_header endRefreshing];

    }];
  

}
-(void)jumpAnother:(UITapGestureRecognizer *)gesture{
    if (gesture  == tap) {
        
        [self selectFirst];
        _contentScrollView.contentOffset = CGPointMake(0, 0);
        [UIView animateWithDuration:0.4 animations:^{
            
            _sliderView.center = CGPointMake(ScreenW/4*1.0f, 60);

        }];

    } else if (gesture ==tap2){
        
        [self selectSecond];
        _contentScrollView.contentOffset = CGPointMake(ScreenW, 0);

        [UIView animateWithDuration:0.4 animations:^{
            
            _sliderView.center = CGPointMake(ScreenW/4*3.0f, 60);

        }];

    }
}
//滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _contentScrollView) {
 
        
        if (scrollView.contentOffset.x  == 0) {
            
            [self selectFirst];
            
            [UIView animateWithDuration:0.4 animations:^{
                _sliderView.center = CGPointMake(ScreenW/4*1.0f, 60);

            }];

        
        }else if(scrollView.contentOffset.x  == ScreenW){
            
            [self selectSecond];
            
            [UIView animateWithDuration:0.4 animations:^{
                _sliderView.center = CGPointMake(ScreenW/4*3.0f, 60);

            }];

        
        }
    }

}

-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatTableView{
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, ScreenW , screenH +50)];
    _contentScrollView.contentSize = CGSizeMake(ScreenW * 2, screenH + 50);
    [self.view addSubview:_contentScrollView];
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    [self.view addSubview:_contentScrollView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenW,screenH - 74 - 60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    //去掉分割线
    _tableView.separatorStyle = NO;
    [_contentScrollView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate= self;
    
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"ReconmondFriendTableViewCell" bundle:nil] forCellReuseIdentifier:reconmodFriendTableIndertifer];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];
        
    }];
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW,screenH - 74 - 60) style:UITableViewStyleGrouped];
    _tableView2.backgroundColor = [UIColor colorWithHexString:BackColor];
    //去掉分割线
    _tableView2.separatorStyle = NO;
    [_contentScrollView addSubview:_tableView2];
    _tableView2.dataSource = self;
    _tableView2.delegate= self;
    _tableView2.sectionHeaderHeight = 0;
    _tableView2.sectionFooterHeight = 0;
    
    _tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];
        
    }];
    
    [_tableView2 registerNib:[UINib nibWithNibName:@"ReconmondFriendTableViewCell" bundle:nil] forCellReuseIdentifier:reconmodFriendTableIndertifer];
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        
        return self.dataArray.count;
    }else{
        return self.dataArray2.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        
        ReconmondFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reconmodFriendTableIndertifer forIndexPath:indexPath];
        
        NSString * str = self.dataArray[indexPath.section];
        NSArray * array = [str componentsSeparatedByString:@","];
        cell.userNameLabel.text = array[0];
        NSString * moneyStr = array[1];
        cell.priceValueLabel.text =[NSString stringWithFormat:@"￥%.2f",[moneyStr floatValue]];
        NSString * iconUrl = array[2];
        [cell.userIconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
        
        return cell;
    }else{
        
        ReconmondFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reconmodFriendTableIndertifer forIndexPath:indexPath];
        
        NSString * str = self.dataArray2[indexPath.section];
        NSArray * array = [str componentsSeparatedByString:@","];
        cell.userNameLabel.text = array[0];
        NSString * moneyStr = array[1];
        cell.priceValueLabel.text =[NSString stringWithFormat:@"￥%.2f",[moneyStr floatValue]];
        NSString * iconUrl = array[2];
        [cell.userIconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
        
        return cell;
    }
    
 
}

#pragma MARK ---一级选中
-(void)selectFirst{
    
    _firstManLabel.textColor = [UIColor colorWithHexString:MainColor];
    _firstTotalLabel.textColor = [UIColor colorWithHexString:MainColor];
    _peopelLabel.textColor = [UIColor colorWithHexString:MainColor];
    _totalMoneyLabel.textColor = [UIColor colorWithHexString:MainColor];
    
    _secondPeople.textColor = [UIColor colorWithHexString:WordColor];
    _secondTotalLabel.textColor = [UIColor colorWithHexString:WordColor];
    _secondManLabel.textColor = [UIColor colorWithHexString:WordColor];
    _secondTotalLable.textColor =[UIColor colorWithHexString:WordColor];
    
}
-(void)selectSecond{
    
    _firstManLabel.textColor = [UIColor colorWithHexString:WordColor];
    _firstTotalLabel.textColor = [UIColor colorWithHexString:WordColor];
    _peopelLabel.textColor = [UIColor colorWithHexString:WordColor];
    _totalMoneyLabel.textColor = [UIColor colorWithHexString:WordColor];
    
    _secondPeople.textColor = [UIColor colorWithHexString:MainColor];
    _secondTotalLabel.textColor = [UIColor colorWithHexString:MainColor];
    _secondManLabel.textColor = [UIColor colorWithHexString:MainColor];
    _secondTotalLable.textColor =[UIColor colorWithHexString:MainColor];
}

@end
