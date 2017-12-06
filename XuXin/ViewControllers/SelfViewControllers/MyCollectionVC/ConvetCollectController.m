//
//  ConvetCollectController.m
//  XuXin
//
//  Created by xuxin on 17/3/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ConvetCollectController.h"
#import "IntergralModel.h"
#import "GoodsCollectedCell.h"
#import "ConvertVCViewController.h"
NSString * const convertCollectInderfier = @"GoodsCollectedCell";
@interface ConvetCollectController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView * convertTableView;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSMutableArray * goodsArray;

@property (nonatomic ,assign)BOOL isSelected;

@end

@implementation ConvetCollectController{
    
    UIView * _edictBotomView;
}
-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        
        _goodsArray = [[NSMutableArray alloc] init];
    }
    return _goodsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self creatBottom];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBottom) name:@"convertCollect" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottom) name:@"hideConvertBottom" object:nil];
    _page = 0;
    
    _type = 3;
    //加载数据
    [self firstLoading];
}
-(void)firstLoading{
    
    [self.convertTableView.mj_header beginRefreshing];
}
#pragma mark ---通知
-(void)showBottom{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _edictBotomView.frame = CGRectMake(0, screenH - 156, ScreenW, 50);
        
    }];
    _convertTableView.editing = !_convertTableView.editing;
    
}
-(void)hideBottom{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _edictBotomView.frame = CGRectMake(0, screenH , ScreenW, 50);
        
    }];
    _convertTableView.editing = !_convertTableView.editing;
    
}
-(void)creatUI{
    
    _convertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH - 104) style:UITableViewStylePlain];
    _convertTableView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self.view addSubview:_convertTableView];
    
    _convertTableView.delegate = self;
    _convertTableView.dataSource = self;
    _convertTableView.separatorStyle = NO;
    _convertTableView.allowsMultipleSelectionDuringEditing = YES;
    
    [_convertTableView registerNib:[UINib nibWithNibName:@"GoodsCollectedCell" bundle:nil] forCellReuseIdentifier:convertCollectInderfier];
    
    //上拉刷新下拉加载
    __weak typeof(self)weakself = self;
    
    _convertTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.convertTableView.mj_footer.hidden = YES;
        weakself.page = 0;
        [weakself requestGoodsData:weakself.page];
        
    }];
    
    _convertTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestGoodsData:weakself.page];
        
    }];
    
}

#pragma mark ----数据请求
-(void)requestGoodsData:(NSInteger)page{
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"type"] =[NSString stringWithFormat:@"%ld",(long)_type];
    
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld",(long)page];
    
    [weakself.httpManager POST:goodsAndStoreFavoriteUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        weakself.convertTableView.hidden = NO;
        
        int i = [responseObject[@"code"] intValue];
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            if (page == 0) {
                
                [weakself.goodsArray removeAllObjects];
            }
            
            NSArray * array = responseObject[@"result"];
            
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[IntergralModel class] json:array];
            
            [weakself.goodsArray addObjectsFromArray:modelArray];
            
        }
        
        [ weakself.convertTableView.mj_header endRefreshing];
        [ weakself.convertTableView.mj_footer endRefreshing];
        weakself.convertTableView.mj_footer.hidden = NO;
        weakself.convertTableView.mj_header.hidden = NO;
        
        if(i == 7030){
            
            //没有更多数据
            [ weakself.convertTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (i == 7230){
            
            //没有数据
            weakself.convertTableView.hidden = YES;
            //没有收藏商家
            
            CGFloat imageW = 160 * ScreenScale;
            
            UIImageView *  nullGoodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW, screenH, imageW, imageW)];
            UILabel *  nullGoodsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW, screenH , ScreenW, 20)];
            nullGoodsLabel.text = @"你还没有收藏任何商品";
            nullGoodsLabel.font = [UIFont systemFontOfSize:16];
            nullGoodsLabel.textAlignment = 1;
            
            nullGoodsImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f -80);
            
            nullGoodsLabel.center = CGPointMake(ScreenW/2.0f, screenH/2.0f +imageW -100);
            
            [nullGoodsImageView setImage:[UIImage imageNamed:@"nullCollection@2x"]];
            
            [self.view addSubview:nullGoodsImageView];
            [self.view addSubview:nullGoodsLabel];
            
        }
        
        
        if (weakself.goodsArray.count < 5) {
            
             weakself.convertTableView.mj_footer.hidden = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ weakself.convertTableView reloadData];
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [ weakself.convertTableView.mj_header endRefreshing];
        [ weakself.convertTableView.mj_footer endRefreshing];
    }];
}



#pragma mark ---TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.goodsArray.count;
        
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        GoodsCollectedCell * cell = [tableView dequeueReusableCellWithIdentifier:convertCollectInderfier forIndexPath:indexPath];
    
        IntergralModel * model = self.goodsArray[indexPath.row];
    
        cell.GoodsModel = model;
            
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
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
        
        IntergralModel * model = self.goodsArray[indexPath.row];
        ConvertVCViewController * convertVC = [[ConvertVCViewController alloc] init];
        [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",(long)model.integralGoods_id];
        
        [self.navigationController pushViewController:convertVC animated:YES];
        

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
    
    for (int i = 0; i<self.goodsArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isSelected) {
            
            [sender setSelected:YES];
            [_convertTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }else{
            //反选
            [sender setSelected:NO];
            
            [_convertTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    for (int i = 0; i<self.goodsArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.isSelected) {
            
            [sender setSelected:YES];
            [_convertTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            
        }else{
            //反选
            [sender setSelected:NO];
            
            [_convertTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
}


#pragma mark ---删除
-(void)deleteGoodsUrl{
    
    __weak typeof(self)weakself = self;
    
    NSMutableArray *deleteArrarys = [NSMutableArray array];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSMutableString * goodsID = [NSMutableString string];
    
    
    for (NSIndexPath *indexPath in _convertTableView.indexPathsForSelectedRows) {
        
        [deleteArrarys addObject:self.goodsArray[indexPath.row]];
        
    }
    
    for (int i = 0; i< deleteArrarys.count; i++) {
        
       IntergralModel  * model = deleteArrarys[i];
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
            
            [weakself showStaus:@"删除成功"];
            
            [weakself.goodsArray removeObjectsInArray:deleteArrarys];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.convertTableView reloadData];
                
            });
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
