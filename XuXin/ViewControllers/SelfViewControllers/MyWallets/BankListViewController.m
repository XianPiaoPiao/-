//
//  BankListViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BankListViewController.h"
#import "BankListModel.h"
#import "TrueMethodTableViewCell.h"
#import "UIImageView+AFNetworking.h"
 NSString * const bankListInderfier = @"TrueMethodTableViewCell";
@interface BankListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)UITableView * tableView;

@end

@implementation BankListViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    [self creatNavgationBar];
    
    [self creatTableView];
    
    [self requestBankListData];
}

#pragma mark --- 数据请求
-(void)requestBankListData{
    
    
    __weak typeof(self)weakself = self;
    
    [weakself POST:bankListUrl parameters:nil success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[BankListModel class] json:array];
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.tableView reloadData];
        });
        

    } failure:^(NSError *error) {
        
    }];
 

}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"银行列表"];
    [self addBackBarButtonItem];
    
}


-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"TrueMethodTableViewCell" bundle:nil] forCellReuseIdentifier:bankListInderfier];
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrueMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bankListInderfier forIndexPath:indexPath];
    BankListModel * model = self.dataArray[indexPath.row];
    cell.trueMethodStateImage.hidden = YES;
  
    [cell.TrueMethodHeadImage sd_setImageWithURL:[NSURL URLWithString:model.logoPath] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    cell.PayMethodLabel.text = model.name;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BankListModel * model = self.dataArray[indexPath.row];
    
    self.block(model);
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
