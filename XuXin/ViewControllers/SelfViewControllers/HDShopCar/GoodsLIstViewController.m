//
//  GoodsLIstViewController.m
//  XuXin
//
//  Created by xuxin on 16/10/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "GoodsLIstViewController.h"
#import "GoodsListTableViewCell.h"
#import "HDShopCarModel.h"
#import "GroupGoodsMOdel.h"
#import "IntergerGoodsDetailModel.h"
NSString * const goodsListIndertifer = @"GoodsListTableViewCell";
@interface GoodsLIstViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GoodsLIstViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"GoodsLIstViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"GoodsLIstViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
    [self creatTableView];
}
-(NSMutableArray *)goodsModelArray{
    
    if (!_goodsModelArray) {
        
        _goodsModelArray = [[NSMutableArray alloc] init];
    }
    return _goodsModelArray;
}
-(void)creatNavgationBar{
    
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self addBackBarButtonItem];
    [self addNavgationTitle:@"订单列表"];
}
-(void)creatTableView{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    
    [tableView registerNib:[UINib nibWithNibName:@"GoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:goodsListIndertifer];
    
    [self.view addSubview:tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsListIndertifer forIndexPath:indexPath];
    if (_goodsType == 1) {
        
        GroupGoodsMOdel * model =self.goodsModelArray[indexPath.row];
        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        cell.goodsNameLabel.text = model.goods_name;
        cell.pointLabel.text = [NSString stringWithFormat:@"单价:%.2f",model.goods_price];
        cell.numberLabel.text =[NSString stringWithFormat:@"数量:x%ld",_goodsCount];
    }else{
        //从购物车进来
        if (_shopCarType == 1) {
            
            HDShopCarModel * model = self.goodsModelArray[indexPath.row];
            [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
            cell.goodsNameLabel.text = model.ig_goods_name;
            
            
            cell.pointLabel.text = [NSString stringWithFormat:@"单价:%.2f",model.price];
            
            cell.numberLabel.text =[NSString stringWithFormat:@"数量:x%ld",(long)model.count];
        }else{
            
           IntergerGoodsDetailModel  * model = self.goodsModelArray[indexPath.row];
            [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
            cell.goodsNameLabel.text = model.ig_goods_name;
            
            
            cell.pointLabel.text = [NSString stringWithFormat:@"积分:%ld",model.ig_goods_integral];
            
            cell.numberLabel.text =[NSString stringWithFormat:@"数量:x%ld",(long)model.count];
        }
        
       
    }
    
  
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.goodsModelArray.count;
}


@end
