//
//  HDshopCarBaseController.m
//  XuXin
//
//  Created by xuxin on 17/3/15.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "HDshopCarBaseController.h"
#import "OnlineShopCsarController.h"
#import "GroupShopCarController.h"
#import "HDshopCarViewController.h"

@interface HDshopCarBaseController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;

@property (nonatomic ,strong)OnlineShopCsarController * onlineCarVC;
@property (nonatomic ,strong)GroupShopCarController * groupCarVC;
@property (nonatomic ,strong)HDshopCarViewController * convertCarVC;
@end

@implementation HDshopCarBaseController{
    
    UIScrollView * _VCscrollView;

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"HDshopCarBaseController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"HDshopCarBaseController"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addCategoryButton];
    
    [self creatChildrenController];
    
    [self creatNavgationBar];
    
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
}


- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 2, 1)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}

-(OnlineShopCsarController *)onlineCarVC{
    if (!_onlineCarVC) {
        _onlineCarVC.view.frame = CGRectMake(0, 0, ScreenW , screenH);

        _onlineCarVC = [[OnlineShopCsarController alloc] init];
        [self addChildViewController:_onlineCarVC];
    }
    return _onlineCarVC;
}
-(GroupShopCarController *)groupCarVC{
    if (!_groupCarVC) {
        _groupCarVC =[[GroupShopCarController alloc] init];
        _groupCarVC.view.frame = CGRectMake(ScreenW, 0, ScreenW , screenH);
        [self addChildViewController:_groupCarVC];

    }
    return _groupCarVC;
}
-(HDshopCarViewController *)convertCarVC{
    if (!_convertCarVC) {
        _convertCarVC =[[HDshopCarViewController alloc] init];
        
        _convertCarVC.view.frame = CGRectMake(ScreenW , 0, ScreenW , screenH);
        [self addChildViewController:_convertCarVC];

    }
    return _convertCarVC;
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"购物车"];
    [self addBackBarButtonItem];
    
    [self addBarButtonItemWithTitle:@"编辑" image:nil target:self action:@selector(edict:) isLeft:NO];
    
    
}

-(void)edict:(UIButton *)sender{
    
    if (sender.selected == YES) {
        
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
        sender.selected = NO;

        _VCscrollView.scrollEnabled = YES;
        
        UIButton * btn = [self.view viewWithTag:buttonTag];
        UIButton * btn2 = [self.view viewWithTag:buttonTag +1];

        btn.userInteractionEnabled = YES;
        btn2.userInteractionEnabled = YES;
        
        if (_VCscrollView.contentOffset.x == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"online" object:nil];
            
        }else if (_VCscrollView.contentOffset.x == ScreenW){
            
              [[NSNotificationCenter defaultCenter] postNotificationName:@"convert" object:nil];
        }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"convert" object:nil];
        }
        
    } else{
        
        if (_VCscrollView.contentOffset.x == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineOff" object:nil];
            
        }else if (_VCscrollView.contentOffset.x == ScreenW){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"convertOff" object:nil];
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"convertOff" object:nil];
        }
        [sender setTitle:@"完成" forState:UIControlStateNormal];;
        
        _VCscrollView.scrollEnabled = NO;
        
        UIButton * btn = [self.view viewWithTag:buttonTag];
        UIButton * btn2 = [self.view viewWithTag:buttonTag +1];
        btn.userInteractionEnabled = NO;
        btn2.userInteractionEnabled = NO;
        
        sender.selected = YES;
    }
    
}
- (void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT+1, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 2; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/2.0f, 0, ScreenW/2.0f, 40)];
        button.tag = buttonTag + i;
        
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"线上",@"兑换"];
        
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

#pragma mark ---子视图控制器切换
- (void)switchDetailView:(UIButton *)sender{
    
    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
    btnSelected.selected=NO;
    
    sender.selected=YES;
    _index = sender.tag - buttonTag;
    if (_index == 0) {
        sender.selected = YES;
        _VCscrollView.contentOffset = CGPointMake(0, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        [_VCscrollView addSubview:self.onlineCarVC.view];
        
    } else if (_index ==1){
        
        sender.selected = YES;
        
        _VCscrollView.contentOffset = CGPointMake(ScreenW, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            
        self.readLabel.frame= CGRectMake(ScreenW/2.0f, sender.frame.size.height, sender.frame.size.width, 2);
            
        }];
        [_VCscrollView addSubview:self.convertCarVC.view];
        
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat x  = offset.x / 2;
    
    if (x >= 0 && x < scrollView.frame.size.width) {
        
        CGRect frame = self.readLabel.frame;
        frame.origin.x = x;
        self.readLabel.frame = frame;
    }
    
    NSInteger currenPage =  scrollView.contentOffset.x /ScreenW;
    
    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
    
    btnSelected.selected=NO;
    
    UIButton * button = [self.view viewWithTag:buttonTag + currenPage];
    
    button.selected=YES;
    
    _index = button.tag - buttonTag;
    if (_index == 0) {
        
        [_VCscrollView addSubview:self.onlineCarVC.view];
        
    }else if (_index ==1){
        
        [_VCscrollView addSubview:self.convertCarVC.view];
        
    }
    
}

#pragma mark -- 创建子视图控制器
-(void)creatChildrenController{
    
    _VCscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 106+self.StatusBarHeight+3, ScreenW, screenH)];
    //设置scrollView的代理
    _VCscrollView.delegate = self;
    //scrollview翻页设置
    _VCscrollView.pagingEnabled = YES;
    
    _VCscrollView.contentSize = CGSizeMake(ScreenW * 2, screenH);
    
    
    [_VCscrollView addSubview:self.onlineCarVC.view];
    
    [self.view addSubview:_VCscrollView];
    //购物车类型判断
    if (_type == 1) {
        
        _VCscrollView.contentOffset = CGPointMake(ScreenW, 0);
    }

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
