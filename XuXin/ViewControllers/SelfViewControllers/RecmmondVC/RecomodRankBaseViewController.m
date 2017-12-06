//
//  RecomodRankBaseViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecomodRankBaseViewController.h"
#import "RankingModel.h"
#import "DayDayTableViewCell.h"
#import "FirstInformationTableViewCell.h"
#import "RecomondStoresModel.h"
#import "ChampionBaseViewController.h"
#import "UIButton+WebCache.h"
#define buttonTag 100
NSString * const dayFriendsIndertifer = @"DayDayTableViewCell";
NSString * const weekFriendsIndertifer = @"DayDayTableViewCell";
NSString * const monthFriendsIndertifer = @"DayDayTableViewCell";
NSString * const dayFirstInformationdIndertifer = @"FirstInformationTableViewCell";
NSString * const weekFirstInformationdIndertifer = @"FirstInformationTableViewCell";
NSString * const monthFirstInformationdIndertifer = @"FirstInformationTableViewCell";
@interface RecomodRankBaseViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong)RankingModel * dayModel;
@property (nonatomic ,strong)RankingModel * weekModel;
@property (nonatomic ,strong)RankingModel * monthModel;


@property (nonatomic ,strong)NSMutableArray * dayArray;
@property (nonatomic ,strong)NSMutableArray * weekArray;
@property (nonatomic ,strong)NSMutableArray * monthArray;

@end

@implementation RecomodRankBaseViewController{
   
    UIScrollView * _VCScrollView ;
    UITableView * _dayTableView;
    UITableView * _weekTableView;
    UITableView * _monthTableView;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"RecomodRankBaseViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"RecomodRankBaseViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self addCategoryButton];
    
    [self firstLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
}

-(void)firstLoad{
    //开始动画
    [self creatIndortor];
    
    [self requestDayData];

}
-(void)returnAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI{
   
    
     _VCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 42, ScreenW, screenH)];
    
    _VCScrollView.contentSize = CGSizeMake(ScreenW * 3, screenH);
   
    _VCScrollView.delegate = self;
    [self.view addSubview:_VCScrollView];
    _VCScrollView.pagingEnabled = YES;
    //日排行榜
    _dayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH-105) style:UITableViewStyleGrouped];
    _dayTableView.dataSource = self;
    _dayTableView.delegate = self;
    _dayTableView.separatorStyle = NO;
    [_dayTableView registerNib:[UINib nibWithNibName:@"DayDayTableViewCell" bundle:nil] forCellReuseIdentifier:dayFriendsIndertifer];
     [_dayTableView registerNib:[UINib nibWithNibName:@"FirstInformationTableViewCell" bundle:nil] forCellReuseIdentifier:dayFirstInformationdIndertifer];
    [_VCScrollView addSubview:_dayTableView];
    
    _weekTableView  = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, screenH - 105) style:UITableViewStyleGrouped];
    _weekTableView.dataSource = self;
    _weekTableView.delegate = self;
    _weekTableView.separatorStyle = NO;
    
    [_weekTableView registerNib:[UINib nibWithNibName:@"DayDayTableViewCell" bundle:nil] forCellReuseIdentifier:weekFriendsIndertifer];
      [_weekTableView registerNib:[UINib nibWithNibName:@"FirstInformationTableViewCell" bundle:nil] forCellReuseIdentifier:weekFirstInformationdIndertifer];
    [_VCScrollView addSubview:_weekTableView];
    
    _monthTableView =  [[UITableView alloc] initWithFrame:CGRectMake(ScreenW* 2, 0, ScreenW, screenH - 105) style:UITableViewStyleGrouped];
    _monthTableView.dataSource = self;
    _monthTableView.delegate = self;
    _monthTableView.separatorStyle = NO;
    [_monthTableView registerNib:[UINib nibWithNibName:@"DayDayTableViewCell" bundle:nil] forCellReuseIdentifier:monthFriendsIndertifer];
        [_monthTableView registerNib:[UINib nibWithNibName:@"FirstInformationTableViewCell" bundle:nil] forCellReuseIdentifier:monthFirstInformationdIndertifer];
    [_VCScrollView addSubview:_monthTableView];

}

- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 3.0f, 2)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}
#pragma 数据请求
-(void)requestDayData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"] =[NSString stringWithFormat:@"%ld", recomondDayType];
    [weakself.httpManager POST:userChampionRankingUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self  timerStop];
        NSLog(@"*******%@",responseObject);
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            //日榜
            NSArray * array = responseObject[@"result"][@"rankList"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.dayArray = [NSMutableArray arrayWithArray:modelArray];
            
            self.dayModel = weakself.dayArray[0];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self creatUI];
            
            [_dayTableView reloadData];
            
        });
        
        [weakself requestWeekData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self timerStop];
        [weakself requestWeekData];

    }];
  
  
    
}
-(void)requestWeekData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", recomondWeekType];
    [weakself.httpManager POST:userChampionRankingUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"rankList"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.weekArray = [NSMutableArray arrayWithArray:modelArray];
            self.weekModel = weakself.weekArray[0];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_weekTableView reloadData];
            
        });
        [weakself requestMonthData];


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
  
    
}
//yuebang
-(void)requestMonthData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", recomondMonthType];
    [weakself.httpManager POST:userChampionRankingUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"rankList"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.monthArray = [NSMutableArray arrayWithArray:modelArray];
            self.monthModel = weakself.monthArray[0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_monthTableView reloadData];
            });
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
  
    
}

- (void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 3; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/3.0f, 0, ScreenW/3.0f, 40)];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"日排行榜",@"周排行榜",@"月排行榜"];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
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

        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==1){
        
         sender.selected = YES;
        _VCScrollView.contentOffset = CGPointMake(ScreenW, 0);

        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/3.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==2){
         sender.selected = YES;
        
        _VCScrollView.contentOffset = CGPointMake(ScreenW *2, 0);

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
        
        if (section == 0) {
            
            return 1;
            
        } else if (section==1){
            
            return self.dayArray.count+1;
        }
        return 0;
    }else if (tableView == _weekTableView){
        
        if (section == 0) {
            return 1;
            
        } else if (section==1){

            return self.weekArray.count+1;
        }
        return 0;
    }else{
        
        if (section == 0) {
            
            return 1;
            
        } else if (section==1){

            return self.monthArray.count+1;
        }
        return 0;

    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _dayTableView) {
        
        if (indexPath.section == 0) {
            
            FirstInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dayFirstInformationdIndertifer];
            if (self.dayModel) {
                cell.contentLabel.text = self.dayModel.username;
                
                cell.dateChampinLabel.text = [NSString stringWithFormat:@"获得%@月%@日排行榜冠军",self.dayModel.moon,self.dayModel.day];
            }else{
                  cell.contentLabel.text = @"";

                   cell.dateChampinLabel.text = @"暂时没有数据";
            }
        [cell.ChampionBtton addTarget:self action:@selector(jumpChampionVC:) forControlEvents:UIControlEventTouchDown];
            return cell;
        }else if (indexPath.section ==1){
            DayDayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dayFriendsIndertifer];
            if (indexPath.row == 0) {
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                for (int i = 0; i < self.dayArray.count; i ++) {
                    RankingModel *model = self.dayArray[i];
                    if ([model.username isEqualToString:userName]) {
                        
                        cell.userNameLabel.text = model.username;
                        cell.moneyLabel.text = [NSString stringWithFormat:@"人气:%@",model.moods];
                        cell.pepleLabel.text =[NSString stringWithFormat:@"财力:%@",model.money];
                        cell.nameLabel.text = [NSString stringWithFormat:@"%d",i + 1];
                        [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
                        UILabel *label = [UILabel new];
                        [cell.contentView addSubview:label];
                        label.text = @"我的排行";
                        label.textAlignment = NSTextAlignmentCenter;
                        label.font = [UIFont systemFontOfSize:11.0f];
                        label.textColor = [UIColor colorWithHexString:MainColor];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(cell.nameLabel.mas_centerX);
                            make.top.equalTo(cell.nameLabel.mas_bottom).offset(-4);
                            make.size.sizeOffset(CGSizeMake(60, 25));
                        }];
                    }
                }
            } else {
                
                RankingModel * model =self.dayArray[indexPath.row-1];
                cell.userNameLabel.text = model.username;
                cell.moneyLabel.text = [NSString stringWithFormat:@"人气:%@",model.moods];
                cell.pepleLabel.text =[NSString stringWithFormat:@"财力:%@",model.money];
                cell.nameLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
                [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
            }
            
            
            
            return cell;
        }
        return 0;
    }else if (tableView == _weekTableView){
        
        if (indexPath.section == 0) {
            
            FirstInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:weekFirstInformationdIndertifer];
               [cell.ChampionBtton addTarget:self action:@selector(jumpChampionVC:) forControlEvents:UIControlEventTouchDown];
            if (self.weekModel) {
                cell.contentLabel.text = self.weekModel.username;
    
                cell.dateChampinLabel.text = [NSString stringWithFormat:@"获得%@月第%@周排行榜冠军",self.weekModel.moon,self.weekModel.week];
             
            }else{
                
                cell.contentLabel.text = @"";
                
                cell.dateChampinLabel.text = @"暂时没有数据";
            }
    
            
            return cell;
             
        }else if (indexPath.section ==1){
            
            DayDayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:weekFriendsIndertifer];

            if (indexPath.row == 0) {
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                for (int i = 0; i < self.weekArray.count; i ++) {
                    RankingModel *model = self.weekArray[i];
                    if ([model.username isEqualToString:userName]) {
                        
                        cell.userNameLabel.text = model.username;
                        cell.moneyLabel.text = [NSString stringWithFormat:@"人气:%@",model.moods];
                        cell.pepleLabel.text =[NSString stringWithFormat:@"财力:%@",model.money];
                        cell.nameLabel.text = [NSString stringWithFormat:@"%d",i + 1];
                        [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
                        UILabel *label = [UILabel new];
                        [cell.contentView addSubview:label];
                        label.text = @"我的排行";
                        label.textAlignment = NSTextAlignmentCenter;
                        label.font = [UIFont systemFontOfSize:11.0f];
                        label.textColor = [UIColor colorWithHexString:MainColor];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(cell.nameLabel.mas_centerX);
                            make.top.equalTo(cell.nameLabel.mas_bottom).offset(-4);
                            make.size.sizeOffset(CGSizeMake(60, 25));
                        }];
                    }
                }
            } else {
                
                RankingModel * model =self.weekArray[indexPath.row-1];
                cell.userNameLabel.text = model.username;
                cell.moneyLabel.text = [NSString stringWithFormat:@"人气:%@",model.moods];
                cell.pepleLabel.text =[NSString stringWithFormat:@"财力:%@",model.money];
                cell.nameLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
                [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
            }
            return cell;
        }
        return 0;

    }else{
        
        if (indexPath.section == 0) {
            
            FirstInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:monthFirstInformationdIndertifer];
            [cell.ChampionBtton addTarget:self action:@selector(jumpChampionVC:) forControlEvents:UIControlEventTouchDown];
            if (self.monthModel) {
                
                cell.contentLabel.text = self.monthModel.username;
                
                cell.dateChampinLabel.text = [NSString stringWithFormat:@"获得%@月排行榜冠军",self.monthModel.moon];
         
            }else{
                
                cell.contentLabel.text = @"";
                
                cell.dateChampinLabel.text = @"暂时没有数据";
            }
 
            return cell;
        }else if (indexPath.section ==1){
            
            DayDayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:monthFriendsIndertifer];
            
            if (indexPath.row == 0) {
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
                for (int i = 0; i < self.monthArray.count; i ++) {
                    RankingModel *model = self.monthArray[i];
                    if ([model.username isEqualToString:userName]) {
                        
                        cell.userNameLabel.text = model.username;
                        cell.moneyLabel.text = [NSString stringWithFormat:@"人气:%@",model.moods];
                        cell.pepleLabel.text =[NSString stringWithFormat:@"财力:%@",model.money];
                        cell.nameLabel.text = [NSString stringWithFormat:@"%d",i + 1];
                        [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
                        UILabel *label = [UILabel new];
                        [cell.contentView addSubview:label];
                        label.text = @"我的排行";
                        label.textAlignment = NSTextAlignmentCenter;
                        label.font = [UIFont systemFontOfSize:11.0f];
                        label.textColor = [UIColor colorWithHexString:MainColor];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(cell.nameLabel.mas_centerX);
                            make.top.equalTo(cell.nameLabel.mas_bottom).offset(-4);
                            make.size.sizeOffset(CGSizeMake(60, 25));
                        }];
                    }
                }
            } else {
                
                RankingModel * model =self.monthArray[indexPath.row-1];
                cell.userNameLabel.text = model.username;
                cell.moneyLabel.text = [NSString stringWithFormat:@"人气:%@",model.moods];
                cell.pepleLabel.text =[NSString stringWithFormat:@"财力:%@",model.money];
                cell.nameLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
                [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture] placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
            }
            return cell;
            
        }
        return 0;

    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 160;
    } else if (indexPath.section ==1){
        
        return 60;
    }
    return 0;
}
//去掉行头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 0.01;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 0.01;
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


#pragma mark ---冠军排行榜
-(void)jumpChampionVC:(UIButton *)button{
    
    ChampionBaseViewController * championVC = [[ChampionBaseViewController alloc] init];
    [self.navigationController pushViewController:championVC animated:YES];
}

@end
