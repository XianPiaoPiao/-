//
//  RecivePlaceTableViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecivePlaceTableViewController.h"
#import "RecivePlaceTableViewCell.h"
#import "receivePlaceModel.h"
#import "EdictPlaceViewController.h"
#import "ChangeRecievePlaceViewController.h"
#import "WriteOrderViewController.h"
  NSString * const recivePlaceIndertifer = @"RecivePlaceTableViewCell";
@interface RecivePlaceTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)UITableView * tableView;

@property (nonatomic ,strong)receivePlaceModel * model;

@property (nonatomic ,assign)NSInteger lastCellIndex;
@property (nonatomic ,assign)NSInteger willSelectedCellIndex;
@property (nonatomic ,assign)NSInteger contromIndex;
@end

@implementation RecivePlaceTableViewController{
    RecivePlaceTableViewCell * _DeleteRecivePlaceCell;

    UIAlertView * _deleteAlterView;
    UIAlertView * _adressAlterView;
    NSIndexPath * _deleteIndexPath;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray  =[[NSMutableArray alloc] init];

    }
    return _dataArray;
}
-(receivePlaceModel *)model{
    
    if (!_model) {
        _model = [[receivePlaceModel alloc] init];
    }
    return _model;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"RecivePlaceTableViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"RecivePlaceTableViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatNavgationBar];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshingView) name:@"refreshingPlace" object:nil];
    
    [self creatTableView];

    //数据请求
    [self requestData];
    
    [self creatBotomBtn];
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 10, ScreenW, screenH - 60-self.TabbarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecivePlaceTableViewCell" bundle:nil] forCellReuseIdentifier:recivePlaceIndertifer];
}
#pragma mark --- 通知方法
-(void)refreshingView{
    
    [self requestData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return  126;
}
-(void)creatNavgationBar{
    
   self.navigationController.navigationBarHidden = NO;
   self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self addBackBarButtonItem];
    
    [self addNavgationTitle:@"收货地址"];

}
-(void)creatBotomBtn{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, screenH - 50-self.TabbarHeight, ScreenW, 50)];
    btn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(addReceivePlace) forControlEvents:UIControlEventTouchDown];

}
#pragma mark ----跳转添加新的收货地址
-(void)addReceivePlace{
    
    EdictPlaceViewController * edictVC =[[EdictPlaceViewController alloc] init];
    edictVC.placeType = 1;
    [self.navigationController pushViewController:edictVC animated:YES];
    
}

#pragma mark ---用户收货地址列表
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    [weakself POST:addressseUrl parameters:nil success:^(id responseObject) {
        
        NSArray * array = responseObject[@"result"];
        
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[receivePlaceModel class] json:array];
        
        weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
            
        });

    } failure:^(NSError *error) {
        

    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecivePlaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:recivePlaceIndertifer forIndexPath:indexPath];
     receivePlaceModel * model =self.dataArray[indexPath.row];
     cell.model = model;

    //默认地址
    if (cell.model.is_default == 1) {
        
        cell.setAdressBtn.selected = YES;
        _lastCellIndex = indexPath.row;

    }else{
        
        cell.setAdressBtn.selected = NO;
    }
    
    [cell.deleteBtn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.setAdressBtn addTarget:self action:@selector(setAdress:envent:) forControlEvents:UIControlEventTouchDown];
    
    [cell.eidcBtn addTarget:self action:@selector(eidcAdress:envent:) forControlEvents:UIControlEventTouchDown];
    return cell;
    
}
#pragma mark --- 设置默认地址

-(void)setAdress:(id)sender envent:(id)event{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];

    _willSelectedCellIndex = indexPath.row ;

    _contromIndex = indexPath.row;

    //设置默认地址
    _adressAlterView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否设置新的收货地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [_adressAlterView show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (alertView == _adressAlterView) {
        
        if (buttonIndex == 0) {
            
            receivePlaceModel *lastModel = self.dataArray[_lastCellIndex];
            lastModel.is_default = NO ;
            
            RecivePlaceTableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastCellIndex inSection:0]];
            lastCell.setAdressBtn.selected = NO ;
            
            _lastCellIndex = _willSelectedCellIndex ;
            
            
            receivePlaceModel *newModel = self.dataArray[_willSelectedCellIndex];
            newModel.is_default = YES ;
            
            RecivePlaceTableViewCell *newCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_willSelectedCellIndex inSection:0]];
            newCell.setAdressBtn.selected = YES ;

            [self requestSureAdressData:newModel];
            
        }

    }
    
   else if (alertView == _deleteAlterView) {
       
        if (buttonIndex == 0){
            
        [self requestDeleteAdress:_DeleteRecivePlaceCell andIndex:_deleteIndexPath];
        }
    }
}
#pragma mark ----- 删除默认地址

- (void)cellBtnClicked:(id)sender event:(id)event
{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    _deleteIndexPath = [_tableView indexPathForRowAtPoint:currentTouchPosition];
    receivePlaceModel * model = self.dataArray[_deleteIndexPath.row];
    
    _DeleteRecivePlaceCell =  [_tableView cellForRowAtIndexPath:_deleteIndexPath];
    _DeleteRecivePlaceCell.model = model;
    
    _deleteAlterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除收货地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    [_deleteAlterView show];
}
//删除地址
-(void)requestDeleteAdress:( RecivePlaceTableViewCell * )cell andIndex:(NSIndexPath *) indexPath{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"addressIds"] =[NSString stringWithFormat:@"%ld",cell.model.id];
    
    [weakself POST:batchDeleteAddressUrl parameters:dic success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            cell.model.isSelected = NO;
            
            if (indexPath!= nil)
            {
                [weakself.dataArray removeObject:cell.model];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
        });
        

    } failure:^(NSError *error) {

    }];

}
#pragma mark ---编辑
-(void)eidcAdress:(id)sender envent:(id)event{
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    RecivePlaceTableViewCell * cell =  [_tableView cellForRowAtIndexPath:indexPath];
    
    EdictPlaceViewController  * updateAdressVC = [[EdictPlaceViewController alloc] init];
    updateAdressVC.model = cell.model;
    updateAdressVC.placeType = 2;
    
    [self.navigationController pushViewController:updateAdressVC animated:YES];
}
#pragma mark --- 默认地址

-(void)requestSureAdressData:(receivePlaceModel *) model{
    
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"addressId"] =[NSString stringWithFormat:@"%ld",model.id];
    
    [weakself POST:setAddressUrl parameters:dic success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            [weakself showStaus:@"设置默认地址成功"];
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model,@"name", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectAdress" object:nil userInfo:dic];
            
        }

    } failure:^(NSError *error) {
        

}];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    receivePlaceModel * model =self.dataArray[indexPath.row];
    
  
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model,@"name", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectAdress" object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
