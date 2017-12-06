//
//  HDCovertViewController.m
//  XuXin
//
//  Created by xuxin on 16/9/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDCovertViewController.h"
#import "GradeCollectionViewCell.h"
#import "CoverDetailViewController.h"
#import "CovertGoodsViewController.h"
#import "SectionHeaderView.h"
#import "SearchCovertGoodsViewController.h"
#import "HDConvertButton.h"
#import "ScanQrcodeController.h"
#import "MessageViewController.h"
#import "ConvertClassModel.h"
#import "UIButton+WebCache.h"
#import "ConvertVCViewController.h"
NSString  *const  GradeIdertifer2 = @"GradeCollectionViewCell";

@interface HDCovertViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)UITableView * covertTableView;
@property (nonatomic ,strong)UIScrollView * imageScrollView;
@property (nonatomic ,strong)UIScrollView * bgScrollView;

@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)NSMutableArray * goodsCategoryArray;
@property (nonatomic ,strong)NSMutableArray * pictureArray;
@end
@implementation HDCovertViewController{
    
    UIPageControl *_pageControl;
    UIPageControl * _categoryPageControl;
    NSTimer * _timer;
    UICollectionView * _recommodCollectionView;
    
    UIButton * _messageBtn;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)goodsCategoryArray{
    if (!_goodsCategoryArray) {
        _goodsCategoryArray = [[NSMutableArray alloc] init];
    }
    return _goodsCategoryArray;
}
-(NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc] init];
    }
    return _pictureArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //jiaobiao
    [User defalutManager].bage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"badge"] integerValue];
    
    if ([User defalutManager].bage > 0) {
        
        
        [_messageBtn setImage:[UIImage imageNamed:@"Red-Icon-2"] forState:UIControlStateNormal];
        
    }else{
        
         [_messageBtn setImage:[UIImage imageNamed:@"XX@2x.png"] forState:UIControlStateNormal];
    }
    [MTA trackPageViewBegin:@"HDCovertViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"HDCovertViewController"];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self creatNavigationBar];
    
    [self creatUI];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(slider) userInfo:nil repeats:YES];
    //加到runloop里面
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //第一次加载
    [self firstLoad];
 
}
-(void)creatUI{
    
    _covertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH - 64 -49) style:UITableViewStyleGrouped];

    _covertTableView.separatorStyle = NO;
    [self.view addSubview:_covertTableView];
    _covertTableView.sectionFooterHeight = 4;
    _covertTableView.sectionHeaderHeight = 4;
    _covertTableView.delegate = self;
    _covertTableView.dataSource = self;
    
    __weak typeof(self)weakself = self;
    
    _covertTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself requestData];
        
        [weakself requestGoodsCategoryData];
        
        [weakself requestScrollPictureData];
        
    }];
   
}
#pragma mark --- 数据加载
-(void)firstLoad{
    
    
    NSDictionary * dic = [HaiduiArchiverTools unarchiverObjectByKey:@"convertGoodsClassCache" WithPath:@"convertGoodsClass.plist"];
    __weak typeof(self)weakself = self;
    
    NSArray * array = dic[@"result"];
    NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertClassModel class] json:array];
        
    weakself.goodsCategoryArray = [NSMutableArray arrayWithArray:modelArray];
 
     [_covertTableView.mj_header beginRefreshing];

}
#pragma mark ---商品分类请求
-(void)requestGoodsCategoryData{
    __weak typeof(self)weakself = self;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"isCommend"] = @"1";
    [weakself POST:integerGoodsSortUrl parameters:param success:^(id responseObject) {
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            //归档
            [HaiduiArchiverTools archiverObject:responseObject ByKey:@"convertGoodsClassCache" WithPath:@"convertGoodsClass.plist"];
            NSArray * array = responseObject[@"result"];
            NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertClassModel class] json:array];
            
            weakself.goodsCategoryArray = [NSMutableArray arrayWithArray:modelArray];
        }
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.covertTableView reloadData];
            
        });
    } failure:^(NSError *error) {
        
    }];
   
}
#pragma mark ---数据请求
-(void)requestData{
    
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"isRecommend"] = @"1";
    param[@"currentPage"]= @"0";
    param[@"orderBy"] = @"1";
    
    [weakself POST:integralGoodsUrl parameters:param success:^(id responseObject) {
        
        NSArray * array = responseObject[@"result"];
        
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[ConvertGoodsCellModel class] json:array];
        
        weakself.dataArray = [NSMutableArray arrayWithArray:modelArray];
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.covertTableView reloadData];
        });
        [weakself.covertTableView.mj_header endRefreshing];
        

    } failure:^(NSError *error) {
        
        [weakself.covertTableView.mj_header endRefreshing];

    }];
 
}
#pragma mark ---- 图片轮播数据
-(void)requestScrollPictureData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"value"] = @"2";
    [weakself POST:advertsUrl parameters:param success:^(id responseObject) {
        NSArray * array = responseObject[@"result"];
        NSString * str = responseObject[@"isSucc"];
        
        if ([str intValue] == 1) {
            
            weakself.pictureArray = [NSMutableArray arrayWithArray:array];
            
        }
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself.covertTableView reloadData];
        });
        

    } failure:^(NSError *error) {
        
    }];
    
}
-(void)creatNavigationBar{
    
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    
   
     _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25+self.StatusBarHeight, 30, 30)];
    [_messageBtn setImage:[UIImage imageNamed:@"XX@2x.png"] forState:UIControlStateNormal];
    [navBgView addSubview:_messageBtn];
    [_messageBtn addTarget:self action:@selector(messageOnClicked) forControlEvents:UIControlEventTouchDown];
    
    UIButton * scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 36, 30+self.StatusBarHeight, 26, 26)];
    [navBgView addSubview:scanBtn];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"SM@2x"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchDown];
    
    EasySearchBar  * searchBar = [[EasySearchBar alloc] initWithFrame:CGRectMake(51, 26+self.StatusBarHeight, ScreenW - 102, 32)];
    searchBar.easySearchBarPlaceholder = @"输入商品名称、品名";
    searchBar.searchField.delegate = self;
    [navBgView addSubview:searchBar];
        
}
#pragma mark ----- 消息中心
-(void)messageOnClicked{
    
   MessageViewController * messageVC =[[MessageViewController alloc] init];
    
   [self.navigationController pushViewController:messageVC animated:YES];
}
#pragma mark ---- 二维码扫描
-(void)scan{
    
   ScanQrcodeController * scanVC =[[ScanQrcodeController alloc] init];
    
   [self.navigationController pushViewController:scanVC animated:YES];
}
//图片滚动
-(void)slider{
    
    static int i = 0;
    _pageControl.currentPage = i;
    
    [UIView animateWithDuration:0.4 animations:^{
        _imageScrollView.contentOffset = CGPointMake((i+1)*ScreenW, 0);
        i++;
    }];
    if (i> self.pictureArray.count) {
        _imageScrollView.contentOffset = CGPointMake(ScreenW, 0);
        i = 0;
    }
}
#pragma mrak  ----scrollViewwDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _imageScrollView) {
        //开起定时器
        [_timer setFireDate:[NSDate distantPast]];

    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _imageScrollView) {
        
        CGPoint point = scrollView.contentOffset;
        
        NSUInteger currentPage = point.x/_imageScrollView.frame.size.width;
        _pageControl.currentPage = currentPage;
        
    }else  if (scrollView == _bgScrollView) {
        
        CGPoint point = scrollView.contentOffset;
        NSUInteger currentPage = point.x/_bgScrollView.frame.size.width;
        _categoryPageControl.currentPage = currentPage;
        
    }
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _imageScrollView) {
        //开起定时器
        [_timer setFireDate:[NSDate distantFuture]];

    }
    
}
-(void)chagePage:(UIPageControl *)page{
    
    float x= page.currentPage * _imageScrollView.frame.size.width;
    [_imageScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}


#pragma tableViewDelegate方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGFloat imageH = 136 * ScreenScale;
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW , imageH)];
        _imageScrollView.delegate = self;
        if (self.pictureArray.count) {
            for (int i = 0; i< self.pictureArray.count; i++) {
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i +1)*ScreenW, 0, ScreenW, imageH)];
                
                NSString * urlString = self.pictureArray[i][@"img"];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:BigbgImage]];
              
                [_imageScrollView addSubview:imageView];
                
            }
            UIImageView * lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, imageH)];
            NSString * lasturlString = self.pictureArray[self.pictureArray.count -1][@"img"];
            
            [lastImageView sd_setImageWithURL:[NSURL URLWithString:lasturlString] placeholderImage:[UIImage imageNamed:BigbgImage]];
            [_imageScrollView addSubview:lastImageView];
        }
     
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.contentSize = CGSizeMake((self.pictureArray.count +1) * ScreenW, 0);
        
        //创建pagecontrol
        _pageControl = [[UIPageControl alloc] init];
        [cell.contentView addSubview:_imageScrollView];
        [cell.contentView  addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageScrollView.mas_left);
            make.right.equalTo(_imageScrollView.mas_right);
            make.bottom.equalTo(_imageScrollView.mas_bottom);
            make.height.equalTo(@20);
        }];
        _pageControl.numberOfPages = self.pictureArray.count;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:MainColor]];
        [_pageControl addTarget:self action:@selector(chagePage:) forControlEvents:UIControlEventValueChanged];
        
     
        
        return cell;
    }else if (indexPath.section == 1){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW , 147 )];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        
     //设置bgview的宽
        if (self.goodsCategoryArray.count % 8 == 0) {
        _bgScrollView.contentSize = CGSizeMake(ScreenW * (self.goodsCategoryArray.count/8 ), 147);
        }else{
        _bgScrollView.contentSize = CGSizeMake(ScreenW * (self.goodsCategoryArray.count/8 + 1), 147);
        }
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        CGFloat buttonW = ScreenW/4.0f;
        CGFloat buttonH = 55;
        
        for (int i = 0; i< self.goodsCategoryArray.count; i++) {
            if (i< 8) {
                
        ConvertClassModel * model = self.goodsCategoryArray[i];
        HDConvertButton * buttons=[[HDConvertButton alloc] initWithFrame:CGRectMake((i%4)*buttonW,10 +buttonH*(i/4) +10 *(i/4), buttonW , buttonH )];
                //字体居中
                [buttons.titleLabel setTextAlignment:NSTextAlignmentCenter];
                //跳转到下一个页面
                [buttons addTarget:self action:@selector(jumpCategoryVC:) forControlEvents:UIControlEventTouchDown];
                [buttons setTitle:model.className forState:UIControlStateNormal];
                
                [buttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [buttons sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal placeholderImage:nil];//[UIImage imageNamed:@""]
                //设置button的tag值
                buttons.tag = model.id;
            
                [buttons.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [buttons setImagePositionWithType:SSImagePositionTypeTop spacing:5];
                
                [_bgScrollView addSubview:buttons];
            }
      
          else if (i >= 8) {
              
            ConvertClassModel * model = self.goodsCategoryArray[i];

            HDConvertButton * buttons=[[HDConvertButton alloc] initWithFrame:CGRectMake((i%4)*buttonW + ScreenW,10 , buttonW , buttonH )];
              //字体居中
            [buttons.titleLabel setTextAlignment:NSTextAlignmentCenter];
             //跳转下一个界面
            [buttons addTarget:self action:@selector(jumpCategoryVC:) forControlEvents:UIControlEventTouchDown];
            [buttons setTitle:model.className forState:UIControlStateNormal];
                
            [buttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
           
            [buttons sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal placeholderImage:nil];//[UIImage imageNamed:@""]
                //设置button的tag值
            buttons.tag = model.id;
            
            [buttons.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [buttons setImagePositionWithType:SSImagePositionTypeTop spacing:5];
                
            [_bgScrollView addSubview:buttons];
        }
            _bgScrollView.delegate = self;
            //创建pagecontrol
            _categoryPageControl = [[UIPageControl alloc] init];
            [cell.contentView addSubview:_bgScrollView];
            [cell.contentView  addSubview:_categoryPageControl];
            
            [_categoryPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_bgScrollView.mas_left);
                make.right.equalTo(_bgScrollView.mas_right);
                make.bottom.equalTo(_bgScrollView.mas_bottom);
                make.height.equalTo(@20);
            }];
            if (self.goodsCategoryArray.count % 8 == 0) {
                
                _categoryPageControl.numberOfPages = self.goodsCategoryArray.count /8;
            }else{
                
            _categoryPageControl.numberOfPages = self.goodsCategoryArray.count /8 + 1;
                
            }
            
            [_categoryPageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:MainColor]];
            _categoryPageControl.pageIndicatorTintColor = [UIColor colorWithHexString:BackColor];
          
    }
        return cell;

        
    }  else if (indexPath.section ==2){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        UICollectionViewFlowLayout * flyout = [[UICollectionViewFlowLayout alloc] init];
        
        if (self.dataArray.count%2 == 0) {
             _recommodCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, ScreenW, (ScreenW/2.0f+65) * self.dataArray.count/2 ) collectionViewLayout:flyout];
        }else{
            
             _recommodCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, ScreenW, (ScreenW/2.0f+65) * (self.dataArray.count/2 +1 )) collectionViewLayout:flyout];
        }
       
        
        _recommodCollectionView.backgroundColor = [UIColor colorWithHexString:BackColor];
        [_recommodCollectionView setScrollEnabled:NO];
        _recommodCollectionView.delegate = self;
        _recommodCollectionView.dataSource =self;
        
        flyout.minimumInteritemSpacing = 0;
        flyout.minimumLineSpacing = 0;
        
        flyout.itemSize =CGSizeMake(ScreenW /2.0f, ScreenW/2.0f + 65);
        [_recommodCollectionView registerNib:[UINib nibWithNibName:@"GradeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:GradeIdertifer2];
     
        [cell.contentView addSubview:_recommodCollectionView];
           return cell;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 0.01;
    }else if (section ==1){
        
        return 0.01;
    }
    
    else if (section ==2){
        
        return 40;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else if (section ==1){
        return 8;
    }
      else if (section ==2) {
        return 80;
    }
    return 0;
}
//创建sectionHeaderView方法
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==2) {
        
    SectionHeaderView * HeaderView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 242 * ScreenScale, ScreenW, 40)];
        
    [HeaderView addImage:@"tj" andTitle:@"推荐兑换商品"];
        
    return HeaderView;

    }
    return 0;
}
//创建sectionFootView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section ==2) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
        bgView.backgroundColor = [UIColor colorWithHexString:BackColor];
        UIButton * AllShopButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, ScreenW -40, 50)];
        
        AllShopButton.layer.cornerRadius = 10;
        AllShopButton.backgroundColor = [UIColor whiteColor];
        [AllShopButton setTitle:@"查看全部积分商品" forState:UIControlStateNormal];
        AllShopButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [AllShopButton setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        
        [AllShopButton addTarget:self action:@selector(jumpConvertDetailVC:) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:AllShopButton];
        return bgView;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 136 * ScreenScale;
        
    }else if (indexPath.section ==1){
        
        return 147;
        
    }else if (indexPath.section ==2){
        
        if (self.dataArray.count % 2 == 0) {
            
            return (ScreenW/2.0f+65) * self.dataArray.count/2;

        }else{
            
            return (ScreenW/2.0f+65) * (self.dataArray.count/2 +1);

        }
    }
    return 0;
}

#pragma UICollectionViewDelegate方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GradeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:GradeIdertifer2 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:BackColor];
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW-6)/2.0f, ScreenW/2.0f+ 65);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 3, 3);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

#pragma mark --跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ConvertGoodsCellModel * model = self.dataArray[indexPath.row];
    [User defalutManager].selectedGoodsID =[NSString stringWithFormat:@"%ld",model.id];

    ConvertVCViewController * goodsVC = [[ConvertVCViewController alloc] init];
    goodsVC.model = model;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

-(void)jumpConvertDetailVC:(UIButton * )sender{
    
    CoverDetailViewController * goodsVC = [[CoverDetailViewController alloc] init];
    //全部商品
    goodsVC.idName = @"0";

    [self.navigationController pushViewController:goodsVC animated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    SearchCovertGoodsViewController * covertVC = [[SearchCovertGoodsViewController alloc] init];
    [self.view endEditing:YES];

    [self.navigationController pushViewController:covertVC animated:YES];
    
}
-(void)jumpCategoryVC:(UIButton *)button{
    
    CoverDetailViewController * covertDetailVC = [[CoverDetailViewController alloc] init];
    covertDetailVC.idName =[NSString stringWithFormat:@"%ld",button.tag];
    covertDetailVC.className = button.titleLabel.text;

    [self.navigationController pushViewController:covertDetailVC animated:YES];
}
@end
