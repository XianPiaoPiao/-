//
//  StroreCollectController.m
//  XuXin
//
//  Created by xuxin on 17/3/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "StroreCollectController.h"
#import "GoodsCollectionTableViewCell.h"
#import "StoreCollectionsModel.h"
NSString * const storesCollectInderfer = @"GoodsCollectionTableViewCell";
@interface StroreCollectController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView * storeTableView;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSMutableArray * storeArray;
/** 标记是否全选 */
@property (nonatomic ,assign)BOOL isSelected;
@end

@implementation StroreCollectController{
    UIView * _edictBotomView;
    
}
-(NSMutableArray *)storeArray{
    if (!_storeArray) {
        _storeArray = [[NSMutableArray alloc] init];
    }
    return _storeArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatUI];
    
    [self creatBottom];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottom) name:@"storeCollect" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottom) name:@"hideStoreBottom" object:nil];
    //初始化
    _type = 4;
    _page = 0;
    
    [self firstLoading];
};
     
-(void)firstLoading{
    
    [self.storeTableView.mj_header beginRefreshing];
    
}

-(void)creatUI{
    
    _storeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH - 104) style:UITableViewStylePlain];
    _storeTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:_storeTableView];
    
    _storeTableView.delegate = self;
    _storeTableView.dataSource = self;
    _storeTableView.separatorStyle = NO;
    _storeTableView.allowsMultipleSelectionDuringEditing = YES;
    
    [_storeTableView registerNib:[UINib nibWithNibName:@"GoodsCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:storesCollectInderfer];
    
    //上拉刷新下拉加载
    __weak typeof(self)weakself = self;
  
    _storeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _storeTableView.mj_footer.hidden = YES;
        weakself.page = 0;
        [self requestStoreData:weakself.page];
        
    }];
   
    _storeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestStoreData:weakself.page];
        
    }];

}
#pragma mark ---通知
-(void)showBottom{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _edictBotomView.frame = CGRectMake(0, screenH - 156, ScreenW, 50);
        
    }];
    _storeTableView.editing = !_storeTableView.editing;
    
}
-(void)hideBottom{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _edictBotomView.frame = CGRectMake(0, screenH , ScreenW, 50);
        
    }];
    _storeTableView.editing = !_storeTableView.editing;
    
}
#pragma mark --数据请求
-(void)requestStoreData:(NSInteger )page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"type"] =[NSString stringWithFormat:@"%ld",(long)_type];
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld",(long)page];
    
    [weakself POST:goodsAndStoreFavoriteUrl parameters:param success:^(id responseObject) {
        
        weakself.storeTableView.mj_footer.hidden = NO;
        
        NSString * str = responseObject[@"isSucc"];
        int i = [responseObject[@"code"] intValue];
        
        if ([str intValue] == 1) {
            
            weakself.storeTableView.hidden = NO;
            NSArray * array = responseObject[@"result"];
            
            if (page == 0) {
                
                [self.storeArray removeAllObjects];
            }
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[StoreCollectionsModel class] json:array];
            
            [weakself.storeArray addObjectsFromArray:modelArray];
            
        }
        [weakself.storeTableView.mj_header endRefreshing];
        [weakself.storeTableView.mj_footer endRefreshing]
        ;
        weakself.storeTableView.mj_footer.hidden = NO;
        weakself.storeTableView.mj_header.hidden = NO;
        if(i == 7030){
            
            //没有更多数据
            [weakself.storeTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (i == 7230){
            //没有收藏商家
            weakself.storeTableView.hidden = YES;

          CGFloat imageW = 160 * ScreenScale;
            
           UIImageView *  nullGoodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW, screenH, imageW, imageW)];
            
           UILabel *  nullGoodsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW, screenH , ScreenW, 20)];
            
            nullGoodsImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 80);
            
            nullGoodsLabel.center = CGPointMake(ScreenW/2.0f, screenH/2.0f +imageW -100);
            
            nullGoodsLabel.text = @"你还没有收藏任何商家";
            nullGoodsLabel.font = [UIFont systemFontOfSize:16];
            nullGoodsLabel.textAlignment = 1;
            
            [nullGoodsImageView setImage:[UIImage imageNamed:@"nullCollection@2x"]];
            [self.view addSubview:nullGoodsImageView];
            [self.view addSubview:nullGoodsLabel];
          
        }
        
        
    
        if (self.storeArray.count < 5) {
            
            weakself.storeTableView.mj_footer.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.storeTableView reloadData];
            
        });
        
    } failure:^(NSError *error) {
        
        
        [weakself.storeTableView.mj_header endRefreshing];
        [weakself.storeTableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark ---TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.storeArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        GoodsCollectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:storesCollectInderfer forIndexPath:indexPath];
        StoreCollectionsModel * model = self.storeArray[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.ShopModel = model;
        
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
  
    if (_storeTableView.editing == NO) {
        
        StoreCollectionsModel * model = self.storeArray[indexPath.row];
        
        [User defalutManager].selectedShop =[NSString stringWithFormat:@"%ld",(long)model.store_id];
        
        UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
        
        
        [self.navigationController pushViewController:MyVC animated:YES];
        
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
    
    for (int i = 0; i<self.storeArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isSelected) {
            
            [sender setSelected:YES];
            [_storeTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            //反选
            [sender setSelected:NO];
            
            [_storeTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    for (int i = 0; i<self.storeArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isSelected) {
            
            [sender setSelected:YES];
            [_storeTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            
        }else{//反选
            [sender setSelected:NO];
            
            [_storeTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
}


#pragma mark ---删除
-(void)deleteGoodsUrl{
    
    __weak typeof(self)weakself = self;
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableString * goodsID = [NSMutableString string];
    
    
    for (NSIndexPath *indexPath in _storeTableView.indexPathsForSelectedRows) {
        
        [deleteArrarys addObject:self.storeArray[indexPath.row]];
        
    }
    
    for (int i = 0; i< deleteArrarys.count; i++) {
        
        StoreCollectionsModel * model = deleteArrarys[i];
        
        [goodsID appendString:[NSString stringWithFormat:@"%ld,",model.id]];
        
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
            
            [self.storeArray removeObjectsInArray:deleteArrarys];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_storeTableView reloadData];
                
            });
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
