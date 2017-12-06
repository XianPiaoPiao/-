//
//  RedWalletListController.m
//  XuXin
//
//  Created by xuxin on 16/12/1.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RedWalletListController.h"
#import "MyRedWalletTableViewCell.h"

#import "HtmWalletPaytypeController.h"

NSString * const myredwalletInderfier = @"MyRedWalletTableViewCell";

@interface RedWalletListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)NSMutableArray * dataArray;

@end

@implementation RedWalletListController{
    UITableView * _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //self.tableView是我们希望正常显示cell的视图

    _tableView.subviews[0].frame = CGRectMake(0, 0, ScreenW, screenH);

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   // self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self creatWalletListUI];
    
    [self requestWalletListData];

}
-(void)creatWalletListUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"MyRedWalletTableViewCell" bundle:nil] forCellReuseIdentifier:myredwalletInderfier];
    [self.view addSubview:_tableView];
    
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self addNavgationTitle:@"我的红包"];
    [self addBackBarButtonItem];
}
#pragma mark ----数据请求
-(void)requestWalletListData{
    
    __weak typeof(self)weakself = self;
    [self POST:redPacketUrl parameters:nil success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[RedWalletModel class] json:array];
            
            weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
            });
            
        }
        

    } failure:^(NSError *error) {
        

    }];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyRedWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myredwalletInderfier forIndexPath:indexPath];
    RedWalletModel * model = self.dataArray[indexPath.section];
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenW, 40)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenW -20, 15)];
    label.text = @"在线上支付可以选则红包";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, ScreenW -10, 15)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor colorWithHexString:@"333333"];
    label2.text = @"一次只能使用一个红包,不能叠加使用";
    [footView addSubview:label];
    [footView addSubview:label2];
    
    return footView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 35;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(10,0, ScreenW, 35)];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 65, 15, 60, 15)];
        [btn setTitle:@"红包说明" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(redWalletExplain) forControlEvents:UIControlEventTouchDown];
        [headerView addSubview:btn];
        return headerView;
    }
    return 0;
}
//红包说明
-(void)redWalletExplain{
    
    HtmWalletPaytypeController * walletExpainVC = [[HtmWalletPaytypeController alloc] init];
    walletExpainVC.requestUrl = redBag_explainHtmlUrl;
    walletExpainVC.htmlType = redWalletHtmlType;
    [self.navigationController pushViewController:walletExpainVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}
@end
