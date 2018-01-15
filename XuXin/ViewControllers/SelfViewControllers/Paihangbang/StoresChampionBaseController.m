//
//  StoresChampionBaseController.m
//  XuXin
//
//  Created by xuxin on 16/12/14.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "StoresChampionBaseController.h"
#import "StoresDayController.h"
#import "StoresWeekController.h"
#import "StoresMonthController.h"
#import "RankingModel.h"
#import "DayTableViewCell.h"
 NSString* const weekTableCellIndertifer = @"DayTableViewCell";
 NSString* const monthTableCellIndertifer = @"DayTableViewCell";

@interface StoresChampionBaseController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,strong)NSMutableArray * dayArray;

@property (nonatomic ,strong)NSMutableArray * weekArray;
@property (nonatomic ,strong)NSMutableArray * monthArray;


@end

@implementation StoresChampionBaseController{
    
    UIScrollView * _VCScrollView;
    StoresDayController * _storesDayVC;
    StoresWeekController * _storeWeekVC;
    StoresMonthController * _monthVC;
}
-(NSMutableArray *)dataArray{
    if (!_dayArray) {
        _dayArray = [[NSMutableArray alloc] init];
    }
    return _dayArray;
}
-(NSMutableArray *)weekArray{
    if (!_weekArray) {
        _weekArray = [[NSMutableArray alloc] init];
    }
    return _weekArray;
}
-(NSMutableArray *)monthArray{
    if (!_monthArray) {
        _monthArray = [[NSMutableArray alloc] init];
    }
    return _monthArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    [self addCategoryButton];
    
    
    [self creatNavgationBar];
    
    [self creatUI];
    
    
}


-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"冠军排行榜"];
    [self addBackBarButtonItem];
}
-(void)returnAction:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)creatUI{
    
    
    _VCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 107, ScreenW, screenH)];
    _VCScrollView.contentSize = CGSizeMake(ScreenW * 3, screenH);
    
    _VCScrollView.pagingEnabled = YES;
    _VCScrollView.delegate = self;
    [self.view addSubview:_VCScrollView];
    
    _storesDayVC = [[StoresDayController alloc] init];
    _storesDayVC.type = 4;
    _storesDayVC.view.frame  = CGRectMake(0, 0, ScreenW , screenH);
    [self addChildViewController:_storesDayVC];
    
    [_VCScrollView addSubview:_storesDayVC.view];
    
    _storeWeekVC = [[StoresWeekController alloc] init];
    _storeWeekVC.type = 5;
    _storeWeekVC.view.frame  = CGRectMake(ScreenW, 0, ScreenW , screenH);
    
    [_VCScrollView addSubview:_storeWeekVC.view];
//
    
    _monthVC = [[StoresMonthController alloc] init];
    _monthVC.type = 6;
    _monthVC.view.frame  = CGRectMake(ScreenW *2, 0, ScreenW , screenH);
    [self addChildViewController:_monthVC];
    
    [_VCScrollView addSubview:_monthVC.view];
//   _weekTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, screenH) style:UITableViewStylePlain];
//    [_VCScrollView addSubview:_weekTbaleView];
//    _weekTbaleView.separatorStyle = NO;
//    _weekTbaleView.delegate = self;
//    _weekTbaleView.dataSource = self;
//    [_weekTbaleView registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:weekTableCellIndertifer];
//    
//    _monthTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenW * 2, 0, ScreenW, screenH) style:UITableViewStylePlain];
//    [_VCScrollView addSubview:_monthTableView];
//    _monthTableView.separatorStyle = NO;
//    _monthTableView.delegate = self;
//    _monthTableView.dataSource = self;
//    [_monthTableView registerNib:[UINib nibWithNibName:@"DayTableViewCell" bundle:nil] forCellReuseIdentifier:monthTableCellIndertifer];

}

- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 3.0f, 2)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}

- (void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 3; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/3.0f, 0, ScreenW/3.0f, 40)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"日排行榜",@"周排行榜",@"月排行榜"];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
        }
        
        [view addSubview:button];
    }
    
    [view addSubview:self.readLabel];
    
    
    
    [self.view addSubview:view];
}

- (void)switchDetailView:(UIButton *)sender{
    
    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
    
    btnSelected.selected=NO;
    
    sender.selected=YES;
    _index = sender.tag - buttonTag;
    
    
    if (_index == 0) {
        sender.selected = YES;
        _VCScrollView.contentOffset = CGPointMake(0, 0);

        
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==1){
        
        sender.selected = YES;
        [self addChildViewController:_storeWeekVC];


        _VCScrollView.contentOffset = CGPointMake(ScreenW, 0);

        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/3.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==2){
        sender.selected = YES;
        [self addChildViewController:_monthVC];

        _VCScrollView.contentOffset = CGPointMake(ScreenW * 2, 0);

        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/3*2.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _VCScrollView) {
        
        CGPoint offset = scrollView.contentOffset;
        CGFloat x  = offset.x / 3;
        
        if (x >= 0 && x < scrollView.frame.size.width) {
            
            CGRect frame = self.readLabel.frame;
            frame.origin.x = x;
            self.readLabel.frame = frame;
        }
        NSInteger currenPage =  scrollView.contentOffset.x /ScreenW;
        if (currenPage  == 0) {
            
        }else if (currenPage == 1){
            
            [self addChildViewController:_storeWeekVC];

        }else{
            
            [self addChildViewController:_monthVC];

        }
        UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
        
        btnSelected.selected=NO;
        
        UIButton * button = [self.view viewWithTag:buttonTag + currenPage];
        button.selected=YES;
        
        _index = button.tag - buttonTag;
        
    }
   
    
}

@end
