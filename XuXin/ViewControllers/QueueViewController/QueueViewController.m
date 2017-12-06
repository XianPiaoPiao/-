//
//  QueueViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "QueueViewController.h"
#import "QueueTableViewCell.h"
#import "QueueStatusTableViewCell.h"
#import "PriceSortedCollectionViewCell.h"

#import "AllcouponsModel.h"
#import "userListCouponModel.h"
//劵的状态
#import "QueuingUpCell.h"
#import "CompletionQueueCell.h"
#import "AlreadyExchangeCell.h"
#import "AlreadyGetMoneyCell.h"

NSString * const queueTableIndertfer = @"QueueTableViewCell";
NSString * const questatusIndertifier = @"QueueStatusTableViewCell";
NSString * const collectionCellIdentifier2 = @"PriceSortedCollectionViewCell";
//劵的状态
NSString  * const CompletionQueueCellIndertifer = @"CompletionQueueCell";
NSString  * const QueuingUpCellInderfier = @"QueuingUpCell";
NSString  * const AlreadyExchangeCellIndertifer = @"AlreadyExchangeCell";
NSString  * const AlreadyGetMoneyCellIndertifer = @"AlreadyGetMoneyCell";

@interface QueueViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong)NSMutableArray * dataSourceArray;
@property (nonatomic ,strong)NSMutableArray * couponsArray;
@property (nonatomic,assign) NSInteger lastSelectedCell;
@property (nonatomic ,assign)NSInteger lastTableViewCell;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,copy)NSString * priceValue;
@property (nonatomic ,copy)NSString * selectStauts;

@property (nonatomic ,assign)NSInteger index;

//标记展开
@property (nonatomic ,assign)NSInteger openStatus;
@end

@implementation QueueViewController{
    UICollectionView  * _priceTableView;
    UITableView * _smartTableView;
    
    UITableView * _MaintableView;
    UIView * _offView;
    NSArray * _smartArray;
    UIButton * _priceButon;
    UIButton * _smartbutton;
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray =@[@"全部",@"10元",@"20元"
                            ,@"30元",@"50元",@"100元"
                            ,@"200元",@"300元",@"500元"
                            ,@"1000元",@"2000元",@"3000元"
                            ,@"5000元",@"1万元",@"2万元"
                            ,@"3万元",@"5万元",@"10万元"
                            ,@"20万元",@"30万元",@"50万元"
                            ].mutableCopy;
        
    }
    return _dataSourceArray;
}
-(NSMutableArray *)couponsArray{
    if (!_couponsArray) {
        _couponsArray = [[NSMutableArray alloc] init];
    }
    return _couponsArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"QueueViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"QueueViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatUI];
    
    [self creatTableView];
    
    [self creatOffView];
    //初始化
    _lastSelectedCell = 0;
    _lastTableViewCell = 0;
    //数据请求
    [self firstLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];

}
-(void)firstLoad{
    
    //初始化
    _page = 0;
    [_MaintableView.mj_header beginRefreshing];
}
-(void)creatOffView{
    
    //创建遮挡
    _offView = [[UIView alloc] initWithFrame:CGRectMake(0, -screenH, ScreenW, screenH - 112 )];
    _offView.backgroundColor = [UIColor blackColor];
    _offView.alpha = 0.7;
    [self.view addSubview:_offView];
    //添加点击事件隐藏遮挡
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offAction:)];
    [_offView addGestureRecognizer:tap];
}
#pragma mark ----UI布局
-(void)creatUI{
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, 40)];
    //设置背景颜色
    bgView.backgroundColor= [UIColor whiteColor];
    _priceButon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW/2.0f, 40)];

    //设置字体
    _priceButon.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_priceButon setTitle:@"全部面值" forState:UIControlStateNormal];
    [_priceButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_priceButon setImage:[UIImage imageNamed:@"xiala@3x"] forState:UIControlStateNormal];
    [_priceButon setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
    [_priceButon setImage:[UIImage imageNamed:@"xiala_shang@3x"] forState:UIControlStateSelected];
    //添加点击事件
    [_priceButon addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchDown];
    _priceButon.tag = buttonTag ;
    _priceButon.selected = NO;
    _smartbutton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW/2.0f, 0, ScreenW/2.0f, 40)];
    [_priceButon setImagePositionWithType: SSImagePositionTypeRight spacing:5];
    
    [_smartbutton setTitle:@"全部状态" forState:UIControlStateNormal];
    [_smartbutton setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
     [_smartbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //添加点击事件
    [_smartbutton addTarget:self action:@selector(jumpAction:)  forControlEvents:UIControlEventTouchDown];
    
    _smartbutton.tag = buttonTag +1;
    _smartbutton.selected = NO;
    //设置图片与文字的距离
    
    [_smartbutton setImage:[UIImage imageNamed:@"xiala@3x"] forState:UIControlStateNormal];
    [_smartbutton setImage:[UIImage imageNamed:@"xiala_shang@3x"] forState:UIControlStateSelected];
    _smartbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_smartbutton setImagePositionWithType: SSImagePositionTypeRight spacing:5];
    //分割线
    UIView * seperateView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/2.0f, 10, 2, _smartbutton.frame.size.height - 20)];
    seperateView.backgroundColor = [UIColor colorWithHexString:BackColor];
    [bgView addSubview:seperateView];
    [self.view addSubview:bgView];
    [bgView addSubview:_smartbutton];
    [bgView addSubview:_priceButon];
}
#define mark ---数据请求
-(void)requestData:(NSInteger)page{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    if (_priceValue != nil ) {
        
        param[@"value"] = _priceValue;
        
    }
    if (_selectStauts != nil){
        
        param[@"statusValue"] = _selectStauts;
        
    }
    param[@"currentPage"] =[NSString stringWithFormat:@"%ld", page];

    [weakself.httpManager POST:homeAppListCouponUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //状态码
        int i = [responseObject[@"code"] intValue];

        NSString * str = responseObject[@"isSucc"];
        if (page == 0) {
            
            [weakself.couponsArray removeAllObjects];
        }
        if ([str intValue] == 1) {
            
            NSArray * array = responseObject[@"result"][@"coupon"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[userListCouponModel class] json:array];
            
            [weakself.couponsArray addObjectsFromArray:modelArray];
        }

        [_MaintableView.mj_header endRefreshing];
        [_MaintableView.mj_footer endRefreshing];
        _MaintableView.mj_header.hidden = NO;
        _MaintableView.mj_footer.hidden = NO;
        //处理加载数据完成情况
        if(i == 7030){
            
            //没有更多数据
            [_MaintableView.mj_footer endRefreshingWithNoMoreData];
            
            //没有数据
        }else if (i == 7230){
            
            [self.couponsArray removeAllObjects];
            
        }
        //小于5条数据
        if (self.couponsArray.count < 5) {
            //数据全部请求完毕
            _MaintableView.mj_footer.hidden = YES;
        }
        //回到主线程刷新UI
        [_MaintableView reloadData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [_MaintableView reloadData];
//        });


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showStaus:@"网络错误"];
        [_MaintableView.mj_header endRefreshing];
        [_MaintableView.mj_footer endRefreshing];
    }];

}
#pragma mark --- 标签栏点击事件
-(void)jumpAction:(UIButton *)btn{
    
    UIButton * rightBtn = [self.view viewWithTag:buttonTag + 1];
    UIButton * leftBtn = [self.view viewWithTag:buttonTag ];
    
    if (btn.tag  == buttonTag) {
        
        if (btn.selected == YES && _openStatus == 0) {
            
            [self pickUp];

            btn.selected = NO;
            
        }else if (rightBtn.selected == YES && btn.selected == NO){
            
            rightBtn.selected = NO;
            
            btn.selected  = YES;
            [self pickUp];
            
            [self pickDown];
            
        }else if (_openStatus == 10){
            
            [self pickDown];
            btn.selected = YES;
            _openStatus = 0;
        }
        else{
            
            [self pickDown];
            btn.selected = YES;
        }
      
        
    } else if (btn.tag == buttonTag + 1){
        
        if (btn.selected == YES && _openStatus == 0) {
            
            [self pickUp];
            
            btn.selected = NO;
            
        }else if (leftBtn.selected == YES && btn.selected == NO){
            
            leftBtn.selected = NO;
            btn.selected = YES;
            [self pickUp];
            [self pickDownSmartTableView];
            
        }else if (btn.selected == YES && _openStatus == 10){
            
            [self pickDownSmartTableView];
            _openStatus= 0;
            btn.selected = YES;
        }
        else{
            
            [self pickDownSmartTableView];
            btn.selected = YES;
        }

    }
    
   
}
//手势
-(void)offAction:(UITapGestureRecognizer *)gesture{
    
    UIButton * rightBtn = [self.view viewWithTag:buttonTag + 1];
    UIButton * leftBtn = [self.view viewWithTag:buttonTag ];
    if (leftBtn.selected == YES) {
        
        leftBtn.selected = NO;
        
    }else if (rightBtn.selected == YES){
        
        rightBtn.selected = NO;
    }
    
    //移开其他视图
     _offView.frame = CGRectMake(0, -screenH, ScreenW, 0);
    _priceTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);
    _smartTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);

}
//收起
-(void)pickUp{
    
    _priceTableView.frame = CGRectMake(0, -screenH, ScreenW, 280+self.StatusBarHeight);
    _smartTableView.frame = CGRectMake(0, -screenH, ScreenW, 200+self.StatusBarHeight);
    _offView.frame = CGRectMake(0, -screenH , ScreenW, screenH);
}
-(void)pickDownSmartTableView{
    
    _smartTableView.frame = CGRectMake(0, 105+self.StatusBarHeight, ScreenW, 200+self.StatusBarHeight);
    _priceTableView.frame = CGRectMake(0, -screenH, ScreenW, 100+self.StatusBarHeight);
    _offView.frame = CGRectMake(0, 105 + _smartTableView.frame.size.height, ScreenW, screenH);
}
//弹出
-(void)pickDown{
    
    _priceTableView.frame = CGRectMake(0, 105+self.StatusBarHeight, ScreenW, 280+self.StatusBarHeight);
    _smartTableView.frame = CGRectMake(0, -screenH, ScreenW, 125+self.StatusBarHeight);
    _offView.frame = CGRectMake(0, 105 + _priceTableView.frame.size.height , ScreenW, screenH);
}
-(void)creatTableView{
    
    _MaintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105+self.StatusBarHeight, ScreenW, screenH - 105 -50) style:UITableViewStylePlain];
    [self.view addSubview:_MaintableView];
    _MaintableView.sectionFooterHeight = 1;
    _MaintableView.sectionHeaderHeight = 1;
    
    _MaintableView.separatorStyle = NO;
    _MaintableView.delegate = self;
    _MaintableView.dataSource = self;
    __weak typeof(self)weakself = self;
    
    _MaintableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _MaintableView.mj_footer.hidden = YES;
        weakself.page = 0;
        [self requestData:weakself.page];
        
    }];
    //下拉加载
    _MaintableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.page ++;
        [weakself requestData:weakself.page];
 
    }];
    
    [self.view addSubview:_MaintableView];
    
    [_MaintableView registerNib:[UINib nibWithNibName:@"CompletionQueueCell" bundle:nil] forCellReuseIdentifier:CompletionQueueCellIndertifer];
    [_MaintableView registerNib:[UINib nibWithNibName:@"QueuingUpCell" bundle:nil] forCellReuseIdentifier:QueuingUpCellInderfier];
     [_MaintableView registerNib:[UINib nibWithNibName:@"AlreadyExchangeCell" bundle:nil] forCellReuseIdentifier:AlreadyExchangeCellIndertifer];
     [_MaintableView registerNib:[UINib nibWithNibName:@"AlreadyGetMoneyCell" bundle:nil] forCellReuseIdentifier:AlreadyGetMoneyCellIndertifer];
    
    _smartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -screenH, ScreenW, 125) style:UITableViewStyleGrouped];
    _smartTableView.delegate = self;
    _smartTableView.dataSource = self;
    _smartTableView.scrollEnabled = NO;
    [self.view addSubview:_smartTableView];
    
    //创建价格collectionView
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _priceTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -screenH, ScreenW, 200) collectionViewLayout:flowLayout];
    _priceTableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _priceTableView.dataSource = self;
    _priceTableView.delegate = self;
    _priceTableView.scrollEnabled = NO;
    [_priceTableView registerNib:[UINib nibWithNibName:@"PriceSortedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionCellIdentifier2];
    
    [self.view addSubview:_priceTableView];
}
#pragma mark ---- tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _MaintableView) {
        
        return self.couponsArray.count;
    }
    else if (tableView == _smartTableView){
        
        return 5;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _MaintableView) {
        return 110;
    }
        else if (tableView == _smartTableView){
            
        return 40;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _MaintableView) {
        NSLog(@"indexpath.row = %ld",indexPath.row);
        userListCouponModel *model = self.couponsArray[indexPath.row];
        NSLog(@"model.value = %ld",model.value);
        if (model.isQueue ==1) {
            //排队中
            CompletionQueueCell * cell = [tableView dequeueReusableCellWithIdentifier:CompletionQueueCellIndertifer forIndexPath:indexPath];
            cell.model = model;
            cell.couponNumberLabel.text = model.ownerName;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }else if (model.isQueue == 2 ){
            //排队完成
            
            QueuingUpCell * cell = [tableView dequeueReusableCellWithIdentifier:QueuingUpCellInderfier forIndexPath:indexPath];
            cell.model = model;
            cell.couponNumberLabel.text = model.ownerName;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }else if (model.isQueue == 3){
            
            //已兑换
            AlreadyExchangeCell * cell = [tableView dequeueReusableCellWithIdentifier:AlreadyExchangeCellIndertifer forIndexPath:indexPath];
            cell.model = model;
            cell.couponNumberLabel.text = model.ownerName;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
            
        }else{
            //已领现
            AlreadyGetMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:AlreadyGetMoneyCellIndertifer forIndexPath:indexPath];
            cell.model = model;
            cell.couponNumberLabel.text = model.ownerName;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }

    } else if (tableView == _smartTableView){
        //初始化数组
        _smartArray = [[NSArray alloc]
                       init];
        _smartArray = @[@"全部",@"排队中",@"排队完成",@"已兑换",@"已返现"];
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = _smartArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        if (indexPath.row == 0) {
            
            cell.textLabel.textColor = [UIColor colorWithHexString:MainColor];
        }else{
            
           cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView  == _smartTableView) {
        //移开其他视图
        _offView.frame = CGRectMake(0, -screenH, ScreenW, 0);
        
        _priceTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);
        _smartTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);
        
        _selectStauts =[NSString stringWithFormat:@"%ld", indexPath.row];
        //点击记录
        _openStatus = 10;
        [_smartbutton setTitle:_smartArray[indexPath.row] forState:UIControlStateNormal] ;
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UITableViewCell * lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastTableViewCell inSection:0]];
        
        self.lastTableViewCell = indexPath.row;

        cell.textLabel.textColor =[UIColor colorWithHexString:MainColor];
        lastCell.textLabel.textColor = [UIColor blackColor];
        
        _page = 0;
        
        [self firstLoad];
    }
}

#pragma mark ----  uicollectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 21;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item < self.dataSourceArray.count){
        
   //    [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastSelectedCell inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
        PriceSortedCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier2 forIndexPath:indexPath];
        
        cell.titleLabel.text = self.dataSourceArray[indexPath.item];
     
 
       if (indexPath.item == 0) {
     
            cell.selectedImageView.hidden = NO;
            cell.titleLabel.textColor =[UIColor colorWithHexString:MainColor];
            
       }else{
           cell.selectedImageView.hidden = YES;
           cell.titleLabel.textColor =[UIColor blackColor];
       }

        return cell;
    }
    return 0;
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenW -3)/3.0f, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 1, 1);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据idenxPath获取对应的cell
    
    PriceSortedCollectionViewCell * lastSelectedcell =  (PriceSortedCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastSelectedCell inSection:0]];
    
    
    PriceSortedCollectionViewCell * currentSelectedcell =  (PriceSortedCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    currentSelectedcell.selectedImageView.hidden = NO;
    currentSelectedcell.titleLabel.textColor = [UIColor colorWithHexString:MainColor];
    
    lastSelectedcell.selectedImageView.hidden = YES;
    lastSelectedcell.titleLabel.textColor = [UIColor blackColor];
    
    //移开其他视图
    _offView.frame = CGRectMake(0, -screenH, ScreenW, 0);
    _priceTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);
    _smartTableView.frame = CGRectMake(0, -screenH, ScreenW, 0);
    //数据请求
    _priceValue = self.dataSourceArray[indexPath.item];
    [_priceButon setTitle:_priceValue forState:UIControlStateNormal];
    
    self.lastSelectedCell = indexPath.item;

    _page = 0;
    _openStatus = 10;
    [self firstLoad];
}
@end
