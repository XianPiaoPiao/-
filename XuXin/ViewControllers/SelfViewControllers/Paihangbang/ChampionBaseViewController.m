//
//  ChampionBaseViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ChampionBaseViewController.h"
#import "RankingModel.h"
#import "DayTableViewCell.h"
 NSString * const dayTableFriendsIndertifer = @"DayTableViewCell";
NSString * const weekTableFriendsIndertifer = @"DayTableViewCell";
NSString * const monthTableFriendsIndertifer = @"DayTableViewCell";

@interface ChampionBaseViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong)NSMutableArray * dayArray;
@property(nonatomic ,strong)NSMutableArray * weekArray;
@property(nonatomic ,strong)NSMutableArray * monthArray;
@end

@implementation ChampionBaseViewController{
    UIScrollView * _VCScrollView;
    UITableView * _dayTableView;
    UITableView * _weekTableView;
    UITableView * _monthTableView;

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(NSMutableArray *)dataArray{
    if (!_dayArray) {
        _dayArray = [[NSMutableArray alloc] init];
    }
    return _dayArray;
}
-(NSMutableArray *)weekArray{
    if (!_weekArray) {
        _weekArray = [[NSMutableArray alloc] init];
    }
    return _weekArray;
}
-(NSMutableArray *)monthArray{
    if (!_monthArray) {
        _monthArray = [[NSMutableArray alloc] init];
    }
    return _monthArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self addCategoryButton];
    
    [self creatUI];
    
    [self creatNavgationBar];
    //
    [self firstLoad];

}

-(void)firstLoad{
    
    //开始动画
    [self.view addSubview:[EaseLoadingView defalutManager]];

    [[EaseLoadingView defalutManager] startLoading];
    
    
    [self requestDayData];
    [self requestWeekData];
    [self requestMonthData];

}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"冠军排行榜"];
    [self addBackBarButtonItem];
}

-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 数据请求
-(void)requestDayData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"] =[NSString stringWithFormat:@"%ld", (long)championDayType];
    
    [weakself POST:userChampionRankingUrl parameters:dic success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];

        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            
            //日榜
            NSArray * array = responseObject[@"result"][@"rankList"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.dayArray = [NSMutableArray arrayWithArray:modelArray];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_dayTableView reloadData];
            });
            
//            [weakself requestWeekData];

        }

    } failure:^(NSError *error) {
        
//        [weakself requestWeekData];

        [[EaseLoadingView defalutManager] stopLoading];

    }];
  }
-(void)requestWeekData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", (long)championrecomondWeekType];
    
    [weakself POST:userChampionRankingUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"rankList"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.weekArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_weekTableView reloadData];
            });
            
//            [weakself requestMonthData];

        }
        

    } failure:^(NSError *error) {
        
//        [weakself requestMonthData];

    }];
  }
//yuebang
-(void)requestMonthData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", (long)championrecomondMOnthType];
    [weakself POST:userChampionRankingUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"rankList"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.monthArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_monthTableView reloadData];
            });
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}
-(void)creatUI{
    
    
    _VCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 107, ScreenW, screenH)];
    _VCScrollView.contentSize = CGSizeMake(ScreenW * 3, screenH);
    
    _VCScrollView.pagingEnabled = YES;
    _VCScrollView.delegate = self;
    [self.view addSubview:_VCScrollView];
    
    
    _dayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH - 107) style:UITableViewStylePlain];
    _dayTableView.dataSource = self;
    _dayTableView.delegate = self;
    _dayTableView.separatorStyle = NO;
    [_dayTableView registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:dayTableFriendsIndertifer];
    [_VCScrollView addSubview:_dayTableView];
    
   _weekTableView  = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, screenH - 107) style:UITableViewStylePlain];
    _weekTableView.dataSource = self;
    _weekTableView.delegate = self;
    _weekTableView.separatorStyle = NO;

    [_weekTableView registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:weekTableFriendsIndertifer];
    [_VCScrollView addSubview:_weekTableView];

    _monthTableView =  [[UITableView alloc] initWithFrame:CGRectMake(ScreenW* 2, 0, ScreenW, screenH - 107) style:UITableViewStylePlain];
    _monthTableView.dataSource = self;
    _monthTableView.delegate = self;
    _monthTableView.separatorStyle = NO;
    [_monthTableView registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:monthTableFriendsIndertifer];
    [_VCScrollView addSubview:_monthTableView];
}

- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 3.0f, 2)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}

- (void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 3; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/3.0f, 0, ScreenW/3.0f, 40)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"日排行榜",@"周排行榜",@"月排行榜"];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        if (i == 0) {
            
            button.selected = YES;
        }
        
        
        [view addSubview:button];
    }
    
    [view addSubview:self.readLabel];
    
    
    
   [self.view addSubview:view];
}

- (void)switchDetailView:(UIButton *)sender{
    
    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
    
    btnSelected.selected=NO;
    
    sender.selected=YES;
    _index = sender.tag - buttonTag;
   
    
    if (_index == 0) {
        sender.selected = YES;
        _VCScrollView.contentOffset = CGPointMake(0, 0);
        //日榜
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==1){
        sender.selected = YES;
        _VCScrollView.contentOffset = CGPointMake(ScreenW , 0);

        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/3.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==2){
        sender.selected = YES;
        _VCScrollView.contentOffset = CGPointMake(ScreenW * 2, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/3*2.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _VCScrollView) {
        
        CGPoint offset = scrollView.contentOffset;
        CGFloat x  = offset.x / 3;
        
        if (x >= 0 && x < scrollView.frame.size.width) {
            
            CGRect frame = self.readLabel.frame;
            frame.origin.x = x;
            self.readLabel.frame = frame;
        }
        NSInteger currenPage =  scrollView.contentOffset.x /ScreenW;
        
        UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
        
        btnSelected.selected=NO;
        
        UIButton * button = [self.view viewWithTag:buttonTag + currenPage];
        button.selected=YES;
        
        _index = button.tag - buttonTag;
        

    }
  }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView  == _dayTableView) {
        
        return self.dayArray.count;
        
    }else if (tableView == _weekTableView){
        
        return self.weekArray.count;

    }else{
        
        return self.monthArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _dayTableView) {
        
        DayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dayTableFriendsIndertifer forIndexPath:indexPath];
        RankingModel * model =self.dataArray[indexPath.row];
        cell.userNameLabel.text = model.username;
        cell.dateLabel.text = [NSString stringWithFormat:@"获得%@月%@日排行榜冠军",model.moon,model.day];
        return cell;
    }else if (tableView == _weekTableView){
        
        DayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:weekTableFriendsIndertifer forIndexPath:indexPath];
        RankingModel * model =self.weekArray[indexPath.row];
        cell.userNameLabel.text = model.username;

        
        cell.dateLabel.text = [NSString stringWithFormat:@"获得%@月%@周排行榜冠军",model.moon,model.week];
        return cell;
    }else{
            
        DayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:monthTableFriendsIndertifer forIndexPath:indexPath];
        RankingModel * model =self.monthArray[indexPath.row];
        cell.userNameLabel.text = model.username;
        cell.dateLabel.text = [NSString stringWithFormat:@"获得%@月排行榜冠军",model.moon];
        return cell;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
