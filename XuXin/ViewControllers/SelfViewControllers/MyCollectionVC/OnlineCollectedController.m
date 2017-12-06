//
//  OnlineCollectedController.m
//  XuXin
//
//  Created by xuxin on 17/3/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "OnlineCollectedController.h"
#import "OnlineGoodsModel.h"
#import "GoodsCollectedCell.h"
#import "ShopsGoodsBaseController.h"
NSString * const onlineGoodsIndetifer = @"GoodsCollectedCell";

@interface OnlineCollectedController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView * onlineTableView;

@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)NSMutableArray * onlineArray;

/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isSelected;
@end

@implementation OnlineCollectedController{
    
    UIView * _edictBotomView;

}
-(NSMutableArray *)onlineArray{
    if (!_onlineArray) {
        
        _onlineArray = [[NSMutableArray alloc] init];
    }
    return _onlineArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    //初始化
    _page = 0;
    //类型
    _type = 1;
    //加载数据
    [self firstLoading];
    
    [self creatBottom];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottom) name:@"onlineCollect" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottom) name:@"hideOnlineBottom" object:nil];
}

-(void)firstLoading{
    
    [self.onlineTableView.mj_header beginRefreshing];
}
#pragma mark ---通知
-(void)showBottom{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
    _edictBotomView.frame = CGRectMake(0, screenH - 156, ScreenW, 50);
        
    }];
    _onlineTableView.editing = !_onlineTableView.editing;

}
-(void)hideBottom{
    
    [UIView animateWithDuration:0.25 animations:^{
        
    _edictBotomView.frame = CGRectMake(0, screenH , ScreenW, 50);
        
    }];
    _onlineTableView.editing = !_onlineTableView.editing;

}
-(void)requestOnlineData:(NSInteger )page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld",(long)_type];
    
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld",(long)page];
    
    [weakself POST:goodsAndStoreFavoriteUrl parameters:param success:^(id responseObject) {
        
        _onlineTableView.mj_footer.hidden = NO;
        
        NSString * str = responseObject[@"isSucc"];
        int i = [responseObject[@"code"] intValue];
        
        if ([str intValue] == 1) {
            
            weakself.onlineTableView.hidden = NO;
            NSArray * array = responseObject[@"result"];
            
            if (page == 0) {
                
                [self.onlineArray removeAllObjects];
            }
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ONLINEgoodsModel class] json:array];
            
            [weakself.onlineArray addObjectsFromArray:modelArray];
            
        }
        
        [weakself.onlineTableView.mj_header endRefreshing];
        [weakself.onlineTableView.mj_footer endRefreshing];
        
        weakself.onlineTableView.mj_footer.hidden = NO;
        weakself.onlineTableView.mj_header.hidden = NO;
        
        if(i == 7030){
            
            //没有更多数据
            [weakself.onlineTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (i == 7230){
            //没有数据
            weakself.onlineTableView.hidden = YES;
            
            CGFloat imageW = 120;
            UIImageView *  nullGoodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW, screenH, imageW, imageW)];
            
            nullGoodsImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 80);
            
            UILabel * nullGoodsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW, screenH , ScreenW, 20)];
            
            nullGoodsLabel.center = CGPointMake(ScreenW/2.0f, screenH/2.0f +imageW - 100);
            
            nullGoodsLabel.text = @"你还没有收藏任何商品";
            nullGoodsLabel.font = [UIFont systemFontOfSize:16];
            nullGoodsLabel.textAlignment = 1;
            
            [nullGoodsImageView setImage:[UIImage imageNamed:@"nullCollection@2x"]];
            [self.view addSubview:nullGoodsImageView];
            [self.view addSubview:nullGoodsLabel];
            
        }
        
        
   
        
        if (self.onlineArray.count < 5) {
            
            weakself.onlineTableView.mj_footer.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.onlineTableView reloadData];
            
            
        });
    } failure:^(NSError *error) {
        
        
        [weakself.onlineTableView.mj_header endRefreshing];
        [weakself.onlineTableView.mj_footer endRefreshing];
    }];
    
}
-(void)creatUI{
    
    _onlineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH -104 ) style:UITableViewStylePlain];
    _onlineTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [self.view addSubview:_onlineTableView];
    
    _onlineTableView.delegate = self;
    _onlineTableView.dataSource = self;
    _onlineTableView.separatorStyle = NO;
    
    [_onlineTableView registerNib:[UINib nibWithNibName:@"GoodsCollectedCell" bundle:nil] forCellReuseIdentifier:onlineGoodsIndetifer];
    
    _onlineTableView.allowsMultipleSelectionDuringEditing = YES;
 
    //上拉刷新下拉加载
    __weak typeof(self)weakself = self;
    _onlineTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _onlineTableView.mj_footer.hidden = YES;
        weakself.page = 0;
        [self requestOnlineData:weakself.page];
        
    }];
      //下拉加载
    _onlineTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestOnlineData:weakself.page];
        
    }];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.onlineArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCollectedCell * cell = [tableView dequeueReusableCellWithIdentifier:onlineGoodsIndetifer forIndexPath:indexPath];
    ONLINEgoodsModel * model = self.onlineArray[indexPath.row];
    
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    cell.goodsNameLabel.text = model.goods_name;
    cell.priceValueLabel.text =[NSString stringWithFormat:@"价格:%.2f", model.goods_price];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.editing == NO) {
        
        ONLINEgoodsModel * model = self.onlineArray[indexPath.row];
        
        ShopsGoodsBaseController * goodsVC = [[ShopsGoodsBaseController alloc] init];
        
        goodsVC.goodsId = model.goods_id;
        
        goodsVC.goodsType = _type;
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
    
        
}
#pragma 底部视图
-(void)creatBottom{
    
    //创建底部编辑视图
    _edictBotomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH, ScreenW, 50)];
    
    [self.view addSubview:_edictBotomView];
    
    UIButton * allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , ScreenW/2.0f, 50)];
    
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allSelectBtn setImagePositionWithType: SSImagePositionTypeLeft spacing:20];
    [allSelectBtn setImage:[UIImage imageNamed:@"icon_order_noactiv@2x"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"dingdan_chenggong@3x"] forState:UIControlStateSelected];
    allSelectBtn.backgroundColor = [UIColor whiteColor];
    [allSelectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchDown];
    
    
    //删除
    UIButton * deleteBtn = [[UIButton alloc]
                            initWithFrame:CGRectMake(ScreenW/2.0f, 0, ScreenW/2.0f, 50)];
    
    [deleteBtn addTarget:self action:@selector(deleteGoodsUrl) forControlEvents:UIControlEventTouchDown];
    deleteBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_edictBotomView addSubview:allSelectBtn];
    [_edictBotomView addSubview:deleteBtn];
    
}
#pragma marj --- 功能操作
//全选
-(void)allSelect:(UIButton *)sender{
    
    self.isSelected = !self.isSelected;
    
    for (int i = 0; i<self.onlineArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isSelected) {
            
            [sender setSelected:YES];
            [_onlineTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            //反选
            [sender setSelected:NO];
            
            [_onlineTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    for (int i = 0; i<self.onlineArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isSelected) {
            
            [sender setSelected:YES];
            [_onlineTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            
        }else{//反选
            [sender setSelected:NO];
            
            [_onlineTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
}


#pragma mark ---删除
-(void)deleteGoodsUrl{
    
    __weak typeof(self)weakself = self;
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableString * goodsID = [NSMutableString string];
    
    
    for (NSIndexPath *indexPath in _onlineTableView.indexPathsForSelectedRows) {
        
        [deleteArrarys addObject:self.onlineArray[indexPath.row]];
        
    }
    
    for (int i = 0; i< deleteArrarys.count; i++) {
        
        ONLINEgoodsModel * model = deleteArrarys[i];
        [goodsID appendString:[NSString stringWithFormat:@"%@,",model.id]];
        
    }
    //拼接字符串
    
    if (goodsID.length) {
        
        [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
    }
    
    param[@"favoriteIds"] = goodsID;

    [weakself POST:batchDeleteGoodsUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [self showStaus:@"删除成功"];
            
            [self.onlineArray removeObjectsInArray:deleteArrarys];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_onlineTableView reloadData];

            });
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
