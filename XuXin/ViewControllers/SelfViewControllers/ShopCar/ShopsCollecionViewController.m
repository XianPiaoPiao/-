//
//  ShopsCollecionViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ShopsCollecionViewController.h"
#import "GoodsCollectionTableViewCell.h"
NSString * const goodsCollectionIndertfier = @"GoodsCollectionTableViewCell";
@interface ShopsCollecionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShopsCollecionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
}
-(void)creatTableView{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStylePlain];
    tableView.rowHeight = 80;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"GoodsCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:goodsCollectionIndertfier];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCollectionIndertfier forIndexPath:indexPath];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
