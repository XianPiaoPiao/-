//
//  StoresDayController.m
//  XuXin
//
//  Created by xuxin on 16/12/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "StoresDayController.h"
#import "DayTableViewCell.h"
#import "RankingModel.h"
NSString * const storesDayrankInderfier = @"DayTableViewCell";

@interface StoresDayController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)UITableView * tableView;
@end

@implementation StoresDayController{

}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化url
    [self creatTableView];
    
    [self requestData];
    //初始化type
  
}
-(void)requestData{
    //开始动画
    [[EaseLoadingView defalutManager] startLoading];
    [self.view addSubview:[EaseLoadingView defalutManager]];
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"type"] =[NSString stringWithFormat:@"%ld",(long)_type];
    
    [weakself POST:recommendStoreKempRankUrl parameters:dic success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            //日榜
            NSMutableDictionary * array = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RankingModel class] json:array];
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
            });
            
        }
    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
    }];
    
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:storesDayrankInderfier];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:storesDayrankInderfier forIndexPath:indexPath];
    RankingModel * model =self.dataArray[indexPath.row];
    cell.userNameLabel.text = model.userName;
   
    if (_type == 4) {
         cell.dateLabel.text = [NSString stringWithFormat:@"获得%@月%@日排行榜冠军",model.moon,model.day];
    }else if (_type == 5){
        
        NSInteger week = [model.day integerValue]/7 + 1;
        cell.dateLabel.text = [NSString stringWithFormat:@"获得%@月%ld周排行榜冠军",model.moon,(long)week];
    }else{
         cell.dateLabel.text = [NSString stringWithFormat:@"获得%@月排行榜冠军",model.moon];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
