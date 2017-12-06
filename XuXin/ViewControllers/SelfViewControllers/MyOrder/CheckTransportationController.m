//
//  CheckTransportationController.m
//  XuXin
//
//  Created by xuxin on 17/2/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CheckTransportationController.h"
#import "ConvertTransporttationCell.h"
#import "ConvertTransStatusCell.h"

#import "ConvertTransportationModel.h"
NSString * const convertTransportCellIndertfier = @"ConvertTransporttationCell";
NSString * const convertTransStasusCellIndertifer = @"ConvertTransStatusCell";
@interface CheckTransportationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;

@property (nonatomic ,strong)NSMutableDictionary * respondDic;
@property (nonatomic ,strong)UITableView * tableView;
;\
@end

@implementation CheckTransportationController{
    
    
    ConvertTransporttationCell * _cell;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableDictionary *)respondArray{
    if (!_respondDic) {
        
        _respondDic = [[NSMutableDictionary alloc] init];
    }
    return _respondDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavgationBar];
    
    //创建tableView
    [self creatTableView];
    
    [self firstLoad];
    
}
-(void)firstLoad{
    
    [self.view addSubview:[EaseLoadingView defalutManager]];
    [[EaseLoadingView defalutManager] startLoading];
    
    if (_orderType == 1) {
        //线上订单
        [self requestOrderData];
        
    }else{
        
        [self requestConvetOrder];
    }
    

}
-(void)requestOrderData{
    
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderId"] = _inergralId;
    
    [self POST:self.requestUrl parameters:param success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            NSArray * array =  responseObject[@"result"][@"data"];
            
            weakself.respondDic = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertTransportationModel class] json:array];
            
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself .tableView reloadData];
            
        });
        
    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
    }];
    
}
-(void)requestConvetOrder{
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"integralId"] = _inergralId;
    
    [self POST:checkKuaidi_detailUrl parameters:param success:^(id responseObject) {
        
        [[EaseLoadingView defalutManager] stopLoading];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str integerValue] == 1) {
            NSArray * array =  responseObject[@"result"][@"data"];
            
            weakself.respondDic = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertTransportationModel class] json:array];
            
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
            
        });
        
    } failure:^(NSError *error) {
        
        [[EaseLoadingView defalutManager] stopLoading];
    }];
    
}
-(void)addNavgationBar{
    
    [self addBackBarButtonItem];
    
    [self addNavgationTitle:@"查看物流"];
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
   // [self addString];
    
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenW, screenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"ConvertTransporttationCell" bundle:nil] forCellReuseIdentifier:convertTransportCellIndertfier];
    [_tableView registerNib:[UINib nibWithNibName:@"ConvertTransStatusCell" bundle:nil] forCellReuseIdentifier:convertTransStasusCellIndertifer];
  
    
    _tableView.delegate = self;
    _tableView.dataSource =self;
}

//添加线

-(void)addString{

    CGFloat total = 0;
    
    for (ConvertTransportationModel * model in self.dataArray) {
        
        CGFloat CellH =  [_cell getPointCellHeight:model];
        total = total + CellH;
        
        
    }
    ConvertTransportationModel * lastModel = self.dataArray[self.dataArray.count -1];
    
    CGFloat lastCellH = [_cell getPointCellHeight:lastModel];

    UIView * stringView = [[UIView alloc] initWithFrame:CGRectMake(28, 142, 1,total - lastCellH - 3) ];
    
    stringView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [_tableView addSubview:stringView];
    
}
#pragma mark -- tableViewDelegate,TABLEviewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
       _cell  = [tableView dequeueReusableCellWithIdentifier:convertTransportCellIndertfier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            
            _cell.contextLabel.textColor = [UIColor colorWithHexString:MainColor];
            _cell.timeLabel.textColor = [UIColor colorWithHexString:MainColor];
        }else{
            
            [_cell.statusBtn setImage:[UIImage imageNamed:@"Logistics-Icon 2@3x"] forState:UIControlStateNormal];
        }
        
        ConvertTransportationModel * model =self.dataArray[indexPath.row];
        _cell.model = model;
        
        [self addString];
        
        return _cell;
        
    }else{
        
        ConvertTransStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:convertTransStasusCellIndertifer forIndexPath:indexPath];
        
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:_respondDic[@"goodsLog"]] placeholderImage:nil];//[UIImage imageNamed:@""]
        
        //订单状态
        NSInteger  states =  [_respondDic[@"state"] integerValue];
        if (states == 0) {
            
            cell.trnsportStatus.text = @"在途";
        }else if (states == 1){
            
            cell.trnsportStatus.text = @"揽件";
        }else if (states ==2){
            
            cell.trnsportStatus.text = @"疑难";

        }else if (states ==3){
            cell.trnsportStatus.text = @"签收";

        }else if (states ==4){
            cell.trnsportStatus.text = @"退签";

        }else if (states == 5){
            cell.trnsportStatus.text = @"派件";

        }else if (states == 6){
            cell.trnsportStatus.text = @"退回";

        }
        cell.companyLabel.text =_respondDic[@"com"];
        
        cell.ordeSnLabel.text =_respondDic[@"nu"];
        return cell;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        
        return self.dataArray.count;

    }else{
        
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01;
    }else{
        return 0.01;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        
        return 10;
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {

        
        ConvertTransportationModel * model = self.dataArray[indexPath.row];
        
        return  [_cell getPointCellHeight:model];
        
    }else{
        
        return 100;
    }
   
}

@end
