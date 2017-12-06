//
//  MsgListViewController.m
//  XuXin
//
//  Created by xian on 2017/9/28.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MsgListViewController.h"
#import "MsgListCollectionViewCell.h"

@interface MsgListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *msgArray;

@end

@implementation MsgListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    
    [self initUI];
    
    [self requestData];
    
}

-(void)creatNavgationBar{
    //状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    UIView * navBegView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    navBegView.backgroundColor = [UIColor colorWithHexString:MainColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"消息列表"];
    
    UIButton * button= [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 60, 40)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setImage:[UIImage imageNamed:@"sign_in_fanhui@2x"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
    //添加点击事件
    [button addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchDown];
    [navBegView addSubview:label];
    [navBegView addSubview:button];
    [self.view addSubview:navBegView];
}

-(void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI{
    
    
    UICollectionViewFlowLayout * flyout = [[UICollectionViewFlowLayout alloc] init];
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 64, ScreenW, screenH -64) collectionViewLayout:flyout];
    
    [self.view addSubview:_collectionView];
    
    _collectionView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    
    flyout.minimumInteritemSpacing = 0;
    flyout.minimumLineSpacing = 0;
    
    flyout.itemSize =CGSizeMake(166, ScreenW/2.0f);
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MsgListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"MsgListCollectionViewCell"];
    
    __weak typeof(self)weakself = self;
    
    weakself.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself requestData];
        
        
    }];
    
}

- (void)requestData{
    
}


#pragma mark ---UICollectionViewDelegate,UICollectionViewDataSource
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenW-30, 190);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 1, 1);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return _msgArray.count;
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MsgListCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MsgListCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 2.0f;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
