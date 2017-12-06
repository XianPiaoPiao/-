//
//  RecdStoresDayController.m
//  XuXin
//
//  Created by xuxin on 16/12/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecdStoresDayController.h"

#import "FirstInformationTableViewCell.h"
#import "StoresChampionBaseController.h"
#import "RecomondSotresRankCell.h"

#import "RecomondStoresModel.h"

#import "UIButton+WebCache.h"
NSString * const dayStoresIndertiferCell = @"RecomondSotresRankCell";
NSString * const championInderfierCell = @"FirstInformationTableViewCell";
@interface RecdStoresDayController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dayArray;
@property (nonatomic ,strong)RankingModel * championModel;
@end

@implementation RecdStoresDayController{
    
    UITableView * _tableView;
  
}

-(NSMutableArray *)dayArray{
    if (!_dayArray) {
        _dayArray = [[NSMutableArray alloc] init];
    }
    return _dayArray;
}
-(RankingModel *)championModel{
    if (!_championModel) {
        _championModel = [[RankingModel alloc] init];
    }
    return _championModel;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatTableView];
    //
    [self requestData];
}

#pragma mark --- 数据加载
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld", _type];
    
    [weakself POST:recommendStoreKempRankUrl parameters:param success:^(id responseObject) {
        [self timerStop];
        NSString *  str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            //对不同的数组赋值
            NSArray * array = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.dayArray = [NSMutableArray arrayWithArray:modelArray];
            
            if (weakself.dayArray.count > 0) {
                
                _championModel = weakself.dayArray[0];

            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
            });
                    
        }
        
    } failure:^(NSError *error) {
        
        [self timerStop];
    }];
    
    
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH - 105) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"FirstInformationTableViewCell" bundle:nil] forCellReuseIdentifier:championInderfierCell];
    [_tableView registerNib:[UINib nibWithNibName:@"RecomondSotresRankCell" bundle:nil] forCellReuseIdentifier:dayStoresIndertiferCell];
}
#pragma mark --- UITableViewdelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        FirstInformationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:championInderfierCell];
        
        
            if (_type == 1) {
                
                if (_championModel) {
                    
                   cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.championModel.userName];
                    
                    cell.dateChampinLabel.text = [NSString stringWithFormat:@"夺得第%@月%@日排行榜冠军",self.championModel.moon,self.championModel.day];
                }else{
                    
                    cell.contentLabel.text = @"";
                    cell.dateChampinLabel.text = @"暂时没有数据";
                }
                
                
                [cell.ChampionBtton addTarget:self action:@selector(jumpStoresChampionVC:) forControlEvents:UIControlEventTouchDown];
                
            }else if (_type == 2){
                
                if (_championModel) {
                    
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.championModel.userName];
                    NSInteger  week = [self.championModel.day integerValue]/7 + 1;
                    cell.dateChampinLabel.text = [NSString stringWithFormat:@"夺得%@月第%ld周排行榜冠军",self.championModel.moon,week];
                    
                }else{
                    
                    cell.contentLabel.text = @"";
                    cell.dateChampinLabel.text = @"暂时没有数据";
                }
                
                [cell.ChampionBtton addTarget:self action:@selector(jumpStoresChampionVC:) forControlEvents:UIControlEventTouchDown];
            }else{
                if (_championModel) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.championModel.userName];
                    
                    cell.dateChampinLabel.text = [NSString stringWithFormat:@"夺得第%@月排行榜冠军",self.championModel.moon];
                }else{
                    
                    cell.contentLabel.text = @"";
                    cell.dateChampinLabel.text = @"暂时没有数据";
                }
                
                
                [cell.ChampionBtton addTarget:self action:@selector(jumpStoresChampionVC:) forControlEvents:UIControlEventTouchDown];
            }
            

//
        return cell;
        
    }else if (indexPath.section ==1){
        
        RecomondSotresRankCell * cell = [tableView dequeueReusableCellWithIdentifier:dayStoresIndertiferCell];
        RankingModel * model =self.dayArray[indexPath.row];
        
        cell.userNameLabel.text = model.userName;
        cell.totalPeopelLabel.text = [NSString stringWithFormat:@"推荐商家总数:%ld家",model.num];
  
        [cell.headerBtn sd_setImageWithURL:[NSURL URLWithString:model.userPicture]  placeholderImage:[UIImage imageNamed:@"the_charts_tx"]];
        
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        
        return cell;
        
    }
    return 0;
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
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return 1;
        
    } else if (section==1){
        
        return self.dayArray.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

#pragma mark ---冠军排行榜
-(void)jumpStoresChampionVC:(UIButton *)button{
    
    StoresChampionBaseController * championVC = [[StoresChampionBaseController alloc] init];
    [self.navigationController pushViewController:championVC animated:YES];
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
