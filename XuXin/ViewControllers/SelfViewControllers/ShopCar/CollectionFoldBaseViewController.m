//
//  CollectionFoldBaseViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/27.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CollectionFoldBaseViewController.h"
#import "GoodsCollectionViewController.h"
#import "ShopsCollecionViewController.h"
#define buttonTag 100
@interface CollectionFoldBaseViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger inderx;
@end

@implementation CollectionFoldBaseViewController{
    GoodsCollectionViewController * _goodsCollectionVC;
    ShopsCollecionViewController * _shopsCollectionVC ;
    UIScrollView * _VCScrollView;
    UIView * _edictBotomView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"CollectionFoldBaseViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"CollectionFoldBaseViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 

    [self addCategoryButton];
    [self creatNavgation];
    [self creatChildrenController];
    
    [self creatDeleteBtn];
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
   
}
#pragma mark -- 下标
- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 2, 2)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}
#pragma 底部视图
-(void)creatDeleteBtn{
    //创建底部编辑视图
    _edictBotomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH , ScreenW, 50)];
    
      [self.view addSubview:_edictBotomView];
    
    UIButton * allSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , ScreenW/2.0f, 50)];
  
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allSelectBtn setImagePositionWithType: SSImagePositionTypeLeft spacing:20];
    [allSelectBtn setImage:[UIImage imageNamed:@"商品未选择状态@2x"] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"商品选中状态@3x"] forState:UIControlStateSelected];
    allSelectBtn.backgroundColor = [UIColor whiteColor];
    [allSelectBtn addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * deleteBtn = [[UIButton alloc]
                            initWithFrame:CGRectMake(ScreenW/2.0f, 0, ScreenW/2.0f, 50)];
    [deleteBtn addTarget:self action:@selector(deleteData:) forControlEvents:UIControlEventTouchDown];
    deleteBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_edictBotomView addSubview:allSelectBtn];
    [_edictBotomView addSubview:deleteBtn];
    
}
-(void)selectState:(UIButton *)btn{
    static int i = 0;
    if (i== 0) {
        btn.selected = YES;
        //观查中心发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allSelect" object:self userInfo:nil];
        i++;
    } else if (i ==1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAllSelect" object:self userInfo:nil];
        btn.selected =NO;
        i--;
    }
}

-(void)deleteData:(UIButton *)btn{
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self userInfo:nil];
    
}
-(void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 65, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i< 2; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/2.0f, 0, ScreenW/2.0f, 40)];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = @[@"商品收藏",@"商家收藏"];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            button.selected = YES;
        }
        
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        [view addSubview:button];
    }
    
    [view addSubview:self.readLabel];
    
    
    
    [self.view addSubview:view];
}
#pragma mark ---切换子视图控制器
- (void)switchDetailView:(UIButton *)sender{
 
    UIButton * btnSelected=[self.view viewWithTag:_inderx + buttonTag];
    btnSelected.selected=NO;
    
    sender.selected=YES;
    _inderx = sender.tag - buttonTag;
    
    if (_inderx == 0) {
   
        _VCScrollView.contentOffset = CGPointMake(0, 0);
        sender.selected = YES;
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
    } else if (_inderx ==1){

        _VCScrollView.contentOffset = CGPointMake(ScreenW, 0);

        sender.selected = YES;
        [UIView animateWithDuration:0.4 animations:^{
            self.readLabel.frame= CGRectMake(ScreenW/2.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        
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
    UIButton * btnSelected=[self.view viewWithTag:_inderx + buttonTag];
  
    btnSelected.selected=NO;
    UIButton * button = [self.view viewWithTag:buttonTag + currenPage];
    button.selected=YES;
    
    _inderx = button.tag - buttonTag;
    
    
}


-(void)creatNavgation{
    
    self.navigationController.navigationBarHidden = NO;
    [self addNavgationTitle:@"收藏夹"];
    [self addBackBarButtonItem];
    
    [self addBarButtonItemWithTitle:@"编辑" image:nil target:self action:@selector(edit:) isLeft:NO];
    
}
#pragma mark ---编辑
-(void)edit:(UIButton *)btn{
    static int i = 0;
    if (i == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"edict" object:self userInfo:nil];
        
        [btn setTitle:@"完成" forState:UIControlStateNormal];;
        [UIView animateWithDuration:0.4 animations:^{
           
    _edictBotomView.frame = CGRectMake(0, screenH -50, ScreenW, 50);
            
        }];
        i++;
    } else if (i==1){
           [[NSNotificationCenter defaultCenter] postNotificationName:@"compelete" object:self userInfo:nil];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];;
        [UIView animateWithDuration:0.4 animations:^{

    _edictBotomView.frame = CGRectMake(0 , screenH , ScreenW, 50);
        }];
        
        i--;
    }
    

}
-(void)returnAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 创建子视图控制器
-(void)creatChildrenController{
    
    
    _VCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 106, ScreenW, screenH)];
    //设置scrollView的代理
    _VCScrollView.delegate = self;
    
    //scrollview翻页设置
    _VCScrollView.pagingEnabled = YES;
    
    _VCScrollView.contentSize = CGSizeMake(ScreenW *2, screenH);
    [self.view addSubview:_VCScrollView];
    
    _goodsCollectionVC =[[GoodsCollectionViewController alloc] init];
    _goodsCollectionVC.view.frame = CGRectMake(0, 0, ScreenW, screenH);
    [self addChildViewController:_goodsCollectionVC];
    [_VCScrollView addSubview:_goodsCollectionVC.view];
    
    _shopsCollectionVC = [[ShopsCollecionViewController alloc] init];
    [self addChildViewController:_shopsCollectionVC];
    _shopsCollectionVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, screenH);
    [_VCScrollView addSubview:_shopsCollectionVC.view];
    
}



@end


