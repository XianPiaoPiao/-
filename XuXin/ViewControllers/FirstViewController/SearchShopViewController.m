//
//  SearchShopViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/11.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SearchShopViewController.h"
#import "AllShopTableViewCell.h"
#import "StoresGoodsCellTableViewCell.h"
#import "CovertDetailTableViewCell.h"
#import "shopListDetailModel.h"
#import "GroupGoodsMOdel.h"
#import "JGPopView.h"
#import "ShopsGoodsBaseController.h"
NSString * const allshopTableCellIndertfier = @"AllShopTableViewCell";
NSString * const searchGoodsCellIndertifer = @"CovertDetailTableViewCell";

@interface SearchShopViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,selectIndexPathDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic ,strong)NSArray * selectArray;

@property (nonatomic ,assign)NSInteger searchType;

@end

@implementation SearchShopViewController{
    EasySearchBar * _searchBar;
    UITableView * _shopTableView;
    UIImageView * _nullImageView;
    UILabel * _nullLabel;
    
    UITextField * _searchField;
    UIButton * _selectBtn;
}
-(NSArray *)selectArray{
    if (!_selectArray) {
        _selectArray = @[@"商家",@"商品"];
    }
    return _selectArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    [MTA trackPageViewBegin:@"SearchShopViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"SearchShopViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    [self creatUI];
    
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
   // self.edgesForExtendedLayout = NO;

    //初始化
    _page = 0;
    _searchType = 1;
    
    [self creatNavgationBar];
    
 
}
-(void)creatUI{
    //创建tableview
    _shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH ) style:UITableViewStylePlain];
    _shopTableView.backgroundColor =[UIColor colorWithHexString:BackColor];
    
    _shopTableView.separatorStyle = NO;
    [self.view addSubview:_shopTableView];
    _shopTableView.delegate = self;
    _shopTableView.dataSource =self;
    [_shopTableView registerNib:[UINib nibWithNibName:@"AllShopTableViewCell" bundle:nil] forCellReuseIdentifier:allshopTableCellIndertfier];
    [_shopTableView registerNib:[UINib nibWithNibName:@"CovertDetailTableViewCell" bundle:nil] forCellReuseIdentifier:searchGoodsCellIndertifer];
    
    __weak typeof(self)weakself = self;
    _shopTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _shopTableView.mj_footer.hidden = YES;
        weakself.page = 0;
        [weakself requestDataWithPage:weakself.page];
        
    }];
    //下拉加载
    _shopTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestDataWithPage:weakself.page];
    }];
    //搜索不到商家
    CGFloat imageW = 120;
    _nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screenH, imageW, imageW)];
    _nullLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH + 60, ScreenW, 20)];
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.textAlignment = 1;
    
    [_nullImageView setImage:[UIImage imageNamed:@"shangjia_kong@2x"]];
    [self.view addSubview:_nullImageView];
    [self.view addSubview:_nullLabel];
    
    _shopTableView.hidden = YES;
    
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    
    [self addBackBarButtonItem];

    
    //
   _searchField = [[UITextField alloc] initWithFrame:CGRectMake(50, 26, ScreenW - 80, 32)];
   _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 32)];
    [_selectBtn setTitle:@"商家" forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(showSelectView:) forControlEvents:UIControlEventTouchDown];
    [_selectBtn setImage:[UIImage imageNamed:@"xiajianto"] forState:UIControlStateNormal];
    [_selectBtn setImagePositionWithType:SSImagePositionTypeRight spacing:3];
    
    _searchField.leftView = _selectBtn;
    [_searchField setLeftViewMode:UITextFieldViewModeAlways];
    _searchField.layer.cornerRadius = 10;
    _searchField.backgroundColor = [UIColor colorWithHexString:BackColor];
    _searchField.delegate = self;
    
    _searchField.returnKeyType =  UIReturnKeySearch;

    _searchField.font = [UIFont systemFontOfSize:14];
    _searchField.placeholder = @"输入商家、商品";
    self.navigationItem.titleView = _searchField;
    [_searchField becomeFirstResponder];
    
}

-(void)showSelectView:(UIButton *)btn{
    
    CGPoint point = CGPointMake(btn.center.x + 90,btn.frame.origin.y + 60);
    JGPopView *view2 = [[JGPopView alloc] initWithOrigin:point Width:btn.frame.size.width * 2 Height:40 * 2 Type:JGTypeOfUpCenter Color:[UIColor blackColor]];
    view2.dataArray = self.selectArray;
    view2.fontSize = 13;
    view2.row_height = 40;
    view2.titleTextColor = [UIColor whiteColor];
    view2.delegate = self;
    
    [view2 popView];
 
}
#pragma --数据请求
-(void)requestDataWithPage:(NSInteger)page{
    
    __weak typeof(self)weakself= self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"name"] = _searchField.text;
    
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld", page];
    
    param[@"type"] = [NSString stringWithFormat:@"%ld", _searchType];
    if (_searchType == 1) {
        
        param[@"areaId"] = [User defalutManager].selectedCityID;

    }
    
    [self.httpManager POST:goodsAndStoreListUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int i = [responseObject[@"code"] intValue];

        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            //隐藏
            _nullImageView.hidden = YES;
            _nullLabel.hidden = YES;
            
            if (page == 0) {
                
                [self.dataArray removeAllObjects];
            }
            if (_searchType == 1) {
                
                
                NSArray * array = responseObject[@"result"][@"store"];
                
                
                NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[shopListDetailModel class] json:array];
                
                [weakself.dataArray addObjectsFromArray:shoplistArray];
                
                NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:_searchField.text,@"textOne", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopName" object:nil userInfo:dic];
            }else{
                
                NSArray * array = responseObject[@"result"];
                
                NSArray * shoplistArray = [NSArray yy_modelArrayWithClass:[GroupGoodsMOdel class] json:array];
                
                [weakself.dataArray addObjectsFromArray:shoplistArray];
                
                NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:_searchField.text,@"textOne", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopName" object:nil userInfo:dic];
                
            }
       
            
        }
            
        
        
        [_shopTableView.mj_header endRefreshing];
        [_shopTableView.mj_footer endRefreshing];
        _shopTableView.mj_header.hidden = NO;
        _shopTableView.mj_footer.hidden = NO;
        //处理加载数据完成情况
        if(i == 7030){
            
            //没有更多数据
            [_shopTableView.mj_footer endRefreshingWithNoMoreData];
            //没有数据
        }else if (i == 7230){
            
            [self.dataArray removeAllObjects];
            
            _shopTableView.mj_header.hidden = YES;
            
            _nullImageView.hidden = NO;
            _nullLabel.hidden = NO;
            if (_searchType == 1) {
                
                _nullLabel.text = @"没有该商家";

            }else{
                
                _nullLabel.text = @"没有该商品";

            }
            _nullImageView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f - 20);
            _nullLabel.frame = CGRectMake(0, screenH/ 2.0f + 60, ScreenW, 20);
        }
        //小于5条数据
        if (self.dataArray.count < 5) {
            //数据全部请求完毕
            _shopTableView.mj_footer.hidden = YES;
        }

        
        
            //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_shopTableView reloadData];
        });
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [_shopTableView.mj_header endRefreshing];
        [_shopTableView.mj_footer endRefreshing];

        [self showStaus:@"网络错误，请检查你的网络"];
        
    }];
 

}
#pragma --tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchType == 1) {
        
        AllShopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:allshopTableCellIndertfier forIndexPath:indexPath];
        
        cell.model = self.dataArray[indexPath.row];
        return cell;

    }else{
        CovertDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:searchGoodsCellIndertifer forIndexPath:indexPath];
        cell.selectionStyle = NO;
        GroupGoodsMOdel * model = self.dataArray[indexPath.row];
        
        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        cell.goodNumberLabel.text = [NSString stringWithFormat:@"%@人付款",model.goods_salenum];
        cell.goodsDescribeLabel.text = model.goods_name;
        cell.saleNumberLabel.text = [NSString stringWithFormat:@"￥%.2f",model.goods_price];
        cell.saleNumberLabel.textColor = [UIColor colorWithHexString:MainColor];

        return cell;
        
//        StoresGoodsCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:searchGoodsCellIndertifer forIndexPath:indexPath];
       

//        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
//        cell.goodsPriceLabel.text =[NSString stringWithFormat:@"价格:%.2f", model.goods_price];
//        cell.goodsNameLbael.text = model.goods_name;
//        cell.goodsCountLabel.text =[NSString stringWithFormat:@"销量:%@",model.goods_salenum];
//        return cell;
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140 ;
}
//跳转到商家详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
            if (_searchType == 1) {
                
                shopListDetailModel * model = self.dataArray[indexPath.row];
                [User defalutManager].selectedShop = [NSString stringWithFormat:@"%ld", (long)model.idName];
                
                UIStoryboard * storybord =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                UIViewController * MyVC = [storybord instantiateViewControllerWithIdentifier:@"ShopDetailViewController"] ;
                
                
                [self.navigationController pushViewController:MyVC animated:YES];
            }else{
                
                GroupGoodsMOdel * model = self.dataArray[indexPath.row];

                ShopsGoodsBaseController * goodsBaseVC =[[ShopsGoodsBaseController alloc] init];
                
                goodsBaseVC.goodsId = model.id;
                //线上
                goodsBaseVC.goodsType = 1;
                
                [self.navigationController pushViewController:goodsBaseVC animated:YES];
                
            }
    
}
//收起键盘

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
      [_searchField resignFirstResponder];

}
- (void)selectIndexPathRow:(NSInteger)index{
    
    //    JGLog(@"=====%@",[self.allNameArrM objectAtIndex:index]);
    
    [_selectBtn setTitle:[self.selectArray objectAtIndex:index] forState:UIControlStateNormal];
    
    if (index == 1) {
        
        _searchType = 2;
    }else{
        
        _searchType = 1;
    }
    
}
#pragma mark ---点击搜索按钮

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    _shopTableView.hidden = NO;

    //开始搜索
    [_shopTableView.mj_header beginRefreshing];
    
    [self.dataArray removeAllObjects];

    [_searchField resignFirstResponder];
    
    return YES;
}

@end
