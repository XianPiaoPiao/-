//
//  ConvertVCViewController.m
//  XuXin
//
//  Created by xuxin on 16/11/15.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ConvertVCViewController.h"
#import "CovertGoodsViewController.h"
#import "ChoseView.h"
@interface ConvertVCViewController ()

@end

@implementation ConvertVCViewController{
    CovertGoodsViewController * _goodsVC;
    CGPoint center;
    ChoseView * _choseView;
    NSArray *sizearr;//型号数组
    NSArray *colorarr;//分类数组
    NSDictionary *stockdic;//商品库存量
}
-(ConvertGoodsCellModel *)model{
    if (!_model) {
        _model = [[ConvertGoodsCellModel alloc] init];
    }
    return _model;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initConvertGoodsVC];
    
    [self initChoseView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show) name:@"selectMeature" object:nil];
}
-(void)initConvertGoodsVC{
    
   _goodsVC =[[CovertGoodsViewController alloc] init];
    [self addChildViewController:_goodsVC];
   // _goodsVC.model = self.model;
    _goodsVC.view.frame = CGRectMake(0, 0, ScreenW, screenH);
    [self.view addSubview:_goodsVC.view];
    
}

-(void)initChoseView
{
    //选择尺码颜色的视图
    _choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_choseView];
    [_choseView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_choseView.bt_sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_choseView.alphaiView addGestureRecognizer:tap];
    
}


#pragma mark  ----选择商品尺寸
-(void)show
{
    center = _goodsVC.view.center;
    center.y -= 64;
    
    self.view.window.backgroundColor = [UIColor blackColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration: 0.35 animations: ^{
        
        _goodsVC.view.center = center;
        _goodsVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        [self.view bringSubviewToFront:_choseView];
        _choseView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height);
        
    } completion: nil];
    
    
}
-(void)dismiss
{
    center.y += 64;
    [UIView animateWithDuration: 0.35 animations: ^{
        
        _choseView.frame =CGRectMake(0, self.view.frame.size.height + 200, self.view.frame.size.width, self.view.frame.size.height);
        _goodsVC.view.center = center;
        _goodsVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        
    } completion: nil];
    
}
-(void)sure
{
    [self dismiss];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
