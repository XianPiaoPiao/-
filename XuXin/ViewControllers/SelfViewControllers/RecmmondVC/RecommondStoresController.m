//
//  RecommondStoresController.m
//  XuXin
//
//  Created by xuxin on 16/12/9.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "RecommondStoresController.h"
#import "RecdMonthController.h"
#import "RecdWeeklyController.h"
#import "RecdStoresDayController.h"
#import "RankingModel.h"
@interface RecommondStoresController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;

@property (nonatomic ,strong)NSMutableArray * dayArray;
@property (nonatomic ,strong)NSMutableArray * weekArray;
@property (nonatomic ,strong)NSMutableArray * monthArray;
@end

@implementation RecommondStoresController{
    
    UIScrollView * _VCScrollView;
    RecdStoresDayController * _dayVC;
    RecdWeeklyController * _weekVC;
    RecdMonthController * _monthVC;
}
-(NSMutableArray *)dayArray {
    if (!_dayArray) {
        _dayArray = [[NSMutableArray alloc] init];
    }
    return _dayArray;
}
-(NSMutableArray *)weekArray{
    if (!_weekArray) {
        _weekArray =[[NSMutableArray alloc] init];
    }
    return _weekArray;
}
-(NSMutableArray *)monthArray {
    if (!_monthArray ) {
        _monthArray = [[NSMutableArray alloc] init];
    }
    return _monthArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addCategoryButton];
 
    [self creatUI];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
}


- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 3.0f, 2)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   
        [self addNavgationTitle:@"推荐商家"];
       [self addBackBarButtonItem];
}

-(void)returnAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI{
    
    
    _VCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 42, ScreenW, screenH)];
    _VCScrollView.pagingEnabled = YES;

    _VCScrollView.contentSize = CGSizeMake(ScreenW * 3, screenH);
    
    _VCScrollView.delegate = self;
    [self.view addSubview:_VCScrollView];
    
    //日排行榜
    _dayVC = [[RecdStoresDayController alloc] init];
    _dayVC.type = 1;

    _dayVC.view.frame = CGRectMake(0, 0, ScreenW, screenH);
    [self addChildViewController:_dayVC];
    
    [_VCScrollView addSubview:_dayVC.view];
    
    //周排行榜
    _weekVC = [[RecdWeeklyController alloc] init];
    _weekVC.type = 2;

    _weekVC.view.frame  = CGRectMake(ScreenW , 0, ScreenW  , screenH);
    [_VCScrollView addSubview:_weekVC.view];
    
    //月排行榜
    _monthVC = [[RecdMonthController alloc] init];
    _monthVC.type = 3;

    _monthVC.view.frame  = CGRectMake(ScreenW * 2, 0, ScreenW  , screenH);
  
    [_VCScrollView addSubview:_monthVC.view];
}



-(void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 3; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/3.0f, 0, ScreenW/3.0f, 40)];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"日排行榜",@"周排行榜",@"月排行榜"];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
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
        
        [self addChildViewController:_weekVC];

        sender.selected = YES;
        _VCScrollView.contentOffset = CGPointMake(ScreenW, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/3.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_index ==2){
        
        sender.selected = YES;
        [self addChildViewController:_monthVC];

        _VCScrollView.contentOffset = CGPointMake(ScreenW *2, 0);
        
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
        
        if (currenPage == 1) {
            
            [self addChildViewController:_weekVC];

        }else if (currenPage ==2){
            
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
