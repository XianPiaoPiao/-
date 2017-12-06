//
//  ChooseLocationView.m

//  Created by xuxin on 16/8/25.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.//
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"
#import "AddressTableViewCell.h"
#import "AddressItemModel.h"

#define QLScreenW [UIScreen mainScreen].bounds.size.width

static  CGFloat  const  QLTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  QLTopTabbarHeight = 30; //地址标签栏的高度

@interface ChooseLocationView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, weak) AddressView *topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic ,strong)AFHTTPSessionManager * httpManager;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;



@end

@implementation ChooseLocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

//省级别数据源
- (NSMutableArray *)dataSouce{
    
    if (_dataSouce == nil) {
        
        [SVProgressHUD showWithStatus:@"正在加载中"];
        __weak typeof(self)weakself = self;
        
        [self.httpManager POST:city_3levelUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [SVProgressHUD dismiss];
            
            NSMutableArray * mArray = [NSMutableArray array];
            for (NSDictionary * dict0 in responseObject[@"result"]) {
                
                NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                [mDict setValue:dict0[@"childs"] forKey:@"childs"];
                AddressItemModel* item = [AddressItemModel initWithName:dict0[@"areaName"] andId:dict0[@"id"] isSelected:NO];
                
                [mDict setValue:item forKey:@"result"];
                [mArray addObject:mDict];
                weakself.dataSouce = mArray;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.tabbleView reloadData];
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
};
    return _dataSouce;
}


//市级别数据源
- (NSArray *)dataSouce1{
    
    if (_dataSouce1 == nil) {
        
        _dataSouce1 = [NSArray array];
    }
    return _dataSouce1;
}

//区级别数据源
- (NSArray *)dataSouce2{
    
    if (_dataSouce2 == nil) {
        
        _dataSouce2 = [NSArray array];
    }
    return _dataSouce2;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}



#pragma mark - 创建UI
- (void)createUI{

    //初始化address
    _address = @"";
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, QLTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"所在地区";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];
    
    
    AddressView * topTabbar = [[AddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, QLTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    
    [self addTopBarItem];
    
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor orangeColor];
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - QLTopViewHeight - QLTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(QLScreenW, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    
    [self addTableView];
    _contentView.delegate = self;

}

//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * QLScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn{
    
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}



#pragma mark - 分割线
//分割线
- (UIView *)separateLine{
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (void)addTableView{

   _tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * QLScreenW, 0, QLScreenW, _contentView.height)];
    [_contentView addSubview:_tabbleView];
    [self.tableViews addObject:_tabbleView];
    _tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabbleView.delegate = self;
    _tabbleView.dataSource = self;
    _tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [_tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    topBarItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topBarItem sizeToFit];
    topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        return self.dataSouce1.count;
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        return self.dataSouce2.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0){
        
        AddressItemModel * itemModel= self.dataSouce[indexPath.row][@"result"];
      //     cell.itemlModel = itemModel;
        [cell initUI:itemModel];

        
        //市级别
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        NSIndexPath * indexPath0 = [self.tableViews.firstObject indexPathForSelectedRow];
        if ([self addressDictToDataSouce:self.dataSouce[indexPath0.row][@"childs"]].count == 1) {
            
            AddressItemModel * itemModel = self.dataSouce1[indexPath.row];
            cell.itemlModel = itemModel;
            [cell initUI:itemModel];

        }else{
            
            AddressItemModel * itemModel = self.dataSouce1[indexPath.row][@"result"];
            cell.itemlModel = itemModel;
            [cell initUI:itemModel];

        }
        
        
        //区级别
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        
        AddressItemModel * itemModel = self.dataSouce2[indexPath.row];
        cell.itemlModel = itemModel;
        [cell initUI:itemModel];
    }
    
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.tableViews indexOfObject:tableView] == 0){
        
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        
        //第二级数据源
        _dataSouce1 = [self addressDictToDataSouce:self.dataSouce[indexPath.row][@"childs"]];
        if (_dataSouce1.count == 1) { //此时为直辖市，第二级的地名都是区级别
            NSMutableArray * mArray = [NSMutableArray array];
            for (NSDictionary * dic in _dataSouce1.firstObject[@"childs"]) {
                
                AddressItemModel * item = [AddressItemModel initWithName:dic[@"areaName"] andId:dic[@"id"] isSelected:NO];
                [mArray addObject:item];
            }
            _dataSouce1 = mArray;
        }
        
        //之前有选中省，重新选择省,切换省.
        if (indexPath0 != indexPath && indexPath0) {
            
            for (int i = 0; i < self.tableViews.count; i++) {
                [self removeLastItem];
            }
            
            if (_dataSouce1 != nil && _dataSouce1.count > 0) {
                [self addTopBarItem];
                
                [self addTableView];
                AddressItemModel * item = self.dataSouce[indexPath.row][@"result"];
                [self scrollToNextItem:item.name ];
            }
            
            return indexPath;
        }
        
        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        AddressItemModel * item = self.dataSouce[indexPath.row][@"result"];
        [self scrollToNextItem:item.name ];
        
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        
        
        
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        //重新选择市,切换市.
        if (indexPath0 != indexPath && indexPath0) {
            
            //如果发现省级别字典里sub关联的数组只有一个元素,说明是直辖市,这时2级界面为区级别
            if ([self.dataSouce1[indexPath.row] isKindOfClass:[AddressItemModel class]]){
                AddressItemModel * item = self.dataSouce1[indexPath.row];
                [self setUpAddress:item.name];
                
                return indexPath;
            }
            
            NSMutableArray * mArray = [NSMutableArray array];
            NSArray * tempArray = _dataSouce1[indexPath.row][@"childs"];
            for (NSDictionary * dic in tempArray) {
                
                AddressItemModel * item = [AddressItemModel initWithName:dic[@"areaName"] andId:dic[@"id"] isSelected:NO];
                [mArray addObject:item];
            }
            _dataSouce2 = mArray;
            [self removeLastItem];
            [self addTopBarItem];
            [self addTableView];
            AddressItemModel * item = self.dataSouce1[indexPath.row][@"result"];
            [self scrollToNextItem:item.name];
            
            return indexPath;
        }
        
        
        //之前未选中市,第一次选择
        if ([self.dataSouce1[indexPath.row] isKindOfClass:[AddressItemModel class]]){//只有两级,此时self.dataSouce1装的是直辖市下面区的数组
            
            AddressItemModel * item = self.dataSouce1[indexPath.row];
            [self setUpAddress:item.name];
            
        }else{
            
            NSMutableArray * mArray = [NSMutableArray array];
            NSArray * tempArray = _dataSouce1[indexPath.row][@"childs"];
            for (NSDictionary * dic in tempArray) {
                AddressItemModel * item = [AddressItemModel initWithName:dic[@"areaName"] andId:dic[@"id"] isSelected:NO];
                [mArray addObject:item];
            }
            _dataSouce2 = mArray;
            
            [self addTopBarItem];
            [self addTableView];
            AddressItemModel* item = self.dataSouce1[indexPath.row][@"result"];
            [self scrollToNextItem:item.name];
        }
        
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        
        AddressItemModel * item = self.dataSouce2[indexPath.row];
        
        [self setUpAddress:item.name];
    }
    
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    AddressItemModel * itemModel = cell.itemlModel;
    [cell initUI:itemModel];
    itemModel.isSelected = YES;
    cell.itemlModel = itemModel;

    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:itemModel.areaId,@"textOne", nil ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"areaId" object:nil userInfo:info];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    AddressItemModel * itemModel = cell.itemlModel;
    itemModel.isSelected = NO;
    cell.itemlModel = itemModel;
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _contentView) {
        NSInteger index = _contentView.contentOffset.x / QLScreenW;
        [UIView animateWithDuration:0.25 animations:^{
            [self changeUnderLineFrame:self.topTabbarItems[index]];
        }];
    }
}


//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address{
    
    NSInteger index = self.contentView.contentOffset.x / QLScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItems) {
        
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@" "];
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseAddressFinish) {
            self.chooseAddressFinish();
        }
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{
    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / QLScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        CGSize  size = self.contentView.contentSize;
        self.contentView.contentSize = CGSizeMake(size.width + QLScreenW, 0);
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + QLScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}

- (NSArray *)addressDictToDataSouce:(NSArray *)array{
    
    NSMutableArray * mArray = [NSMutableArray array];
    for (NSDictionary * dict0 in array) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setValue:dict0[@"childs"] forKey:@"childs"];
        AddressItemModel * item = [AddressItemModel initWithName:dict0[@"areaName"]andId:dict0[@"id"]  isSelected:NO];
        [mDict setValue:item forKey:@"result"];
        [mArray addObject:mDict];
    }
    return mArray;
}

-(AFHTTPSessionManager *)httpManager{
    if (!_httpManager) {
        
        _httpManager = [AFHTTPSessionManager manager];
        //设置序列化,将JSON数据转化为字典或者数组
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //在序列化器中追加一个类型，text、html这个类型不支持的，text、json，apllication，json
        _httpManager.responseSerializer.acceptableContentTypes = [_httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _httpManager.requestSerializer.timeoutInterval = 10;
        
        
        AFHTTPRequestSerializer *afHTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
        
        _httpManager.requestSerializer = afHTTPRequestSerializer;
        
        //        //https 配置证书
        //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:
        //                                 @"wt_https_ssl" ofType:@"cer"];
        //        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"songchunmin" ofType:@"cer"];//证书的路径
        //       NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        //
        // AFSSLPinningModeCertificate 使用证书验证模式
             AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //        // 如果是需要验证自建证书，需要设置为YES
             securityPolicy.allowInvalidCertificates = YES;
        //
        //        /*
        //         validatesDomainName 是否需要验证域名，默认为YES；
        //         假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //         置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //         如置为NO，建议自己添加对应域名的校验逻辑。
        //
        //         */
        securityPolicy.validatesDomainName = NO;
        //
        //       securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
        //        
        [_httpManager setSecurityPolicy:securityPolicy];

    }
    
    return _httpManager;
    
}


@end
