//
//  MyOrderBaseViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyOrderBaseViewController.h"
#import "OrderFacePayViewController.h"
#import "OrderConvertViewController.h"
#import "OnlineOrderListController.h"
#import "GroupListController.h"
@interface MyOrderBaseViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;

@property (nonatomic ,strong)OrderFacePayViewController * orderFacePayVC;
@property (nonatomic ,strong)OrderConvertViewController * orderConverVC;
@property (nonatomic ,strong)OnlineOrderListController * onlineListVC;
@property (nonatomic ,strong)GroupListController * groupListVC;

@end

@implementation MyOrderBaseViewController{
   
    UIScrollView * _VCscrollView;
}
-(OrderFacePayViewController *)orderFacePayVC{
    if (!_orderFacePayVC) {
        
        _orderFacePayVC = [[OrderFacePayViewController alloc] init];
        //面对面
        _orderFacePayVC.view.frame = CGRectMake(ScreenW * 2, 0, ScreenW , screenH);
        
        [self addChildViewController:_orderFacePayVC];
        
      //  [_VCscrollView addSubview:_orderFacePayVC.view];
    }
    return _orderFacePayVC;
}
-(OrderConvertViewController *)orderConverVC{
    if (!_orderConverVC) {
        //兑换订单
        _orderConverVC = [[OrderConvertViewController alloc] init];
        [self addChildViewController:_orderConverVC];
        _orderConverVC.view.frame = CGRectMake(ScreenW * 3, 0, ScreenW, screenH);
      //  [_VCscrollView addSubview:_orderConverVC.view];
    }
    return _orderConverVC;
}
-(OnlineOrderListController *)onlineListVC{
    if (!_onlineListVC) {
        //线上
        _onlineListVC = [[OnlineOrderListController alloc] init];
        _onlineListVC.view.frame = CGRectMake(0, 0, ScreenW, screenH);
        
        [self addChildViewController:_onlineListVC];
        
     //   [_VCscrollView addSubview:_onlineListVC.view];
    }
    return _onlineListVC;
}
-(GroupListController *)groupListVC{
    if (!_groupListVC) {
        
        //线下
        _groupListVC = [[GroupListController alloc] init];
        _groupListVC.view.frame = CGRectMake(ScreenW, 0, ScreenW , screenH);
        
        [self addChildViewController:_groupListVC];
        
     //   [_VCscrollView addSubview:_groupListVC.view];
    }
    
    return _groupListVC;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MTA trackPageViewBegin:@"MyOrderBaseViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MyOrderBaseViewController"];
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
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 4, 1)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}

-(void)creatNavgationBar{
    
     [self addNavgationTitle:@"我的订单"];
    
     [self addBarButtonItemWithTitle:@"返回" image:[UIImage imageNamed:@"fanhui@3x"] target:self action:@selector(returnAction) isLeft:YES];
}
//返回
-(void)returnAction{

    
        UIViewController * viewCtl = self.navigationController.viewControllers[0];
 
        [self.navigationController popToViewController:viewCtl animated:YES];

}

- (void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 65+self.StatusBarHeight, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 4; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/4.0f, 0, ScreenW/4.0f, 40)];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"线上",@"线下",@"面对面",@"兑换"];
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
        [_VCscrollView addSubview:self.onlineListVC.view];
        
    } else if (_index ==1){
        
        sender.selected = YES;
        
        _VCscrollView.contentOffset = CGPointMake(ScreenW, 0);

        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/4.0f, sender.frame.size.height, sender.frame.size.width, 2);
            
        }];
        [_VCscrollView addSubview:self.groupListVC.view];

    }else if (_index == 2){
        
        _VCscrollView.contentOffset = CGPointMake(ScreenW * 2, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            
        self.readLabel.frame= CGRectMake(ScreenW/2.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        [_VCscrollView addSubview:self.orderFacePayVC.view];

    }else if (_index == 3){
        
        _VCscrollView.contentOffset = CGPointMake(ScreenW * 3, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
        self.readLabel.frame= CGRectMake(ScreenW/4 * 3.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        [_VCscrollView addSubview:self.orderConverVC.view];

    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat x  = offset.x / 4;
    
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
        
        [_VCscrollView addSubview:self.onlineListVC.view];

    }else if (_index ==1){
        
        [_VCscrollView addSubview:self.groupListVC.view];

    }else if (_index == 2){
        
        [_VCscrollView addSubview:self.orderFacePayVC.view];

    }else{
        [_VCscrollView addSubview:self.orderConverVC.view];

    }
    
}

#pragma mark -- 创建子视图控制器
-(void)creatChildrenController{
    
    _VCscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 106+self.StatusBarHeight, ScreenW, screenH)];
    //设置scrollView的代理
    _VCscrollView.delegate = self;
    //scrollview翻页设置
    _VCscrollView.pagingEnabled = YES;
    
    _VCscrollView.contentSize = CGSizeMake(ScreenW * 4, screenH);
    
    [self.view addSubview:_VCscrollView];

    [_VCscrollView addSubview:self.onlineListVC.view];
    
    if (_ordrType == 1 || _ordrType == 0) {
        
          _VCscrollView .contentOffset = CGPointMake(0 , 0);
    }
  else  if (self.ordrType == 2 ) {
        
        _VCscrollView .contentOffset = CGPointMake(ScreenW , 0);
        
    }else if(self.ordrType == 3){
        
        _VCscrollView .contentOffset = CGPointMake(ScreenW * 2, 0);

    }else{
        
        _VCscrollView .contentOffset = CGPointMake(ScreenW * 3, 0);

    }
}


@end
