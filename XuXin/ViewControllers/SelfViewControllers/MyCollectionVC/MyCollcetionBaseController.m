//
//  MyCollcetionBaseController.m
//  XuXin
//
//  Created by xuxin on 17/3/21.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MyCollcetionBaseController.h"

#import "OnlineCollectedController.h"
#import "GroupCollectController.h"
#import "ConvetCollectController.h"
#import "StroreCollectController.h"

@interface MyCollcetionBaseController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UILabel * readLabel;
@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)BOOL isSelected;

@property (nonatomic ,strong)OnlineCollectedController * onlineVC;
@property (nonatomic ,strong)ConvetCollectController * convertVC;
@property (nonatomic ,strong)StroreCollectController * storeColletVC;
@property (nonatomic ,strong)GroupCollectController * groupVC;

@end

@implementation MyCollcetionBaseController{
    
    UIView * _edictBotomView;
    UIScrollView * _contentScrollView;
    UIButton * _edictBtn;
}
-(ConvetCollectController *)convertVC{
    if (!_convertVC) {
        _convertVC = [[ConvetCollectController alloc] init];
        _convertVC.view.frame = CGRectMake(ScreenW * 2, 0, ScreenW, screenH);
        [self addChildViewController:_convertVC];
    }
    return _convertVC;
}
-(GroupCollectController *)groupVC{
    if (!_groupVC) {
        _groupVC = [[GroupCollectController alloc] init];
        _groupVC.view.frame = CGRectMake(ScreenW , 0, ScreenW, screenH);
        [self addChildViewController:_groupVC];
    }
    return _groupVC;
}
-(OnlineCollectedController *)onlineVC{
    if (!_onlineVC) {
        
        _onlineVC = [[OnlineCollectedController alloc] init];
        _onlineVC.view.frame = CGRectMake(0, 0, ScreenW, screenH);
        [self addChildViewController:_onlineVC];
    }
    return _onlineVC;
}
-(StroreCollectController *)storeColletVC{
    if (!_storeColletVC) {
        _storeColletVC = [[StroreCollectController alloc] init];
        _storeColletVC.view.frame = CGRectMake(ScreenW * 3, 0, ScreenW, screenH);
        [self addChildViewController:_storeColletVC];
    }
    return _storeColletVC;
}
#pragma mark -- 下标
- (UILabel *)readLabel{
    
    if (!_readLabel) {
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenW / 4, 2)];
        _readLabel.backgroundColor = [UIColor colorWithHexString:MainColor];
        
    }
    return _readLabel;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [MTA trackPageViewBegin:@"MyCollcetionBaseController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MyCollcetionBaseController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addCategoryButton];

    [self creatUI];

    [self creatNavgationBar];

    self.view.backgroundColor = [UIColor colorWithHexString:BackColor];
    
}

-(void)creatUI{
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 106+self.StatusBarHeight, ScreenW , screenH )];
    _contentScrollView.contentSize = CGSizeMake(ScreenW * 4, screenH );
    
    [self.view addSubview:_contentScrollView];
    
    _contentScrollView.delegate = self;
    
    _contentScrollView.pagingEnabled = YES;
    
    [_contentScrollView addSubview:self.onlineVC.view];
    
}
#pragma mark ---创建标签栏
-(void)addCategoryButton{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT+1, ScreenW, 40)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i< 4; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake( i * ScreenW/4.0f, 0, ScreenW/4.0f, 40)];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(switchDetailView:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray * array = @[@"线上",@"线下",@"兑换",@"商家"];
        
         button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            
            button.selected = YES;
        }
        
        [button setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateSelected];
        
        [view addSubview:button];
    }
    
    //分割线
    for (int i = 0; i < 3; i++) {
        
        UIView * stringView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/4.0f * (i+1), 10, 1, 20)];
        stringView.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        [view addSubview:stringView];
    }
    
    [view addSubview:self.readLabel];
    
    [self.view addSubview:view];
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"收藏夹"];
    
    [self addBackBarButtonItem];
    
    _edictBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, 12, 40, 40)];
    [_edictBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _edictBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_edictBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_edictBtn addTarget:self action:@selector(editList:) forControlEvents:UIControlEventTouchDown];
    
    _edictBtn.selected = YES;
    
    UIBarButtonItem * edictBtnBar = [[UIBarButtonItem alloc]
                                     initWithCustomView:_edictBtn];
    
    self.navigationItem.rightBarButtonItem = edictBtnBar;
    
}

-(void)editList:(UIButton *)sender{
    
    if (sender.selected == YES) {
        
        if (_contentScrollView.contentOffset.x == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineCollect" object:nil];
            
        }else if (_contentScrollView.contentOffset.x == ScreenW){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineCollect" object:nil];
            
        }else if (_contentScrollView.contentOffset.x == ScreenW * 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"convertCollect" object:nil];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"storeCollect" object:nil];
            
        }

        [sender setTitle:@"完成" forState:UIControlStateNormal];
        //不能点不能滑
        _contentScrollView.scrollEnabled = NO;
        UIButton * btn =[self.view viewWithTag:buttonTag];
        UIButton * btn2 =[self.view viewWithTag:buttonTag + 1];
        UIButton * btn3 =[self.view viewWithTag:buttonTag + 2];
        UIButton * btn4 =[self.view viewWithTag:buttonTag + 3];
        btn.userInteractionEnabled = NO;
        btn2.userInteractionEnabled = NO;
        btn3.userInteractionEnabled = NO;
        btn4.userInteractionEnabled = NO;

        sender.selected  = NO;
        
    }else{
        
        
        if (_contentScrollView.contentOffset.x == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideOnlineBottom" object:nil];
            
        }else if (_contentScrollView.contentOffset.x == ScreenW){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideOnlineBottom" object:nil];
            
        }else if (_contentScrollView.contentOffset.x == ScreenW * 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideConvertBottom" object:nil];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideStoreBottom" object:nil];
            
        }
        
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        _contentScrollView.scrollEnabled = YES;
        UIButton * btn =[self.view viewWithTag:buttonTag];
        UIButton * btn2 =[self.view viewWithTag:buttonTag + 1];
        UIButton * btn3 =[self.view viewWithTag:buttonTag + 2];
        UIButton * btn4 =[self.view viewWithTag:buttonTag + 3];
        btn.userInteractionEnabled = YES;
        btn2.userInteractionEnabled = YES;
        btn3.userInteractionEnabled = YES;
        btn4.userInteractionEnabled = YES;
        
        sender.selected = YES;
    }
    
  }
#pragma mark ---标签栏标下标滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _contentScrollView) {
        

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
            
            [_contentScrollView addSubview:self.onlineVC.view];
            
        }else if (_index ==1){
            
            [_contentScrollView addSubview:self.groupVC.view];
            
        }else if (_index == 2){
            
            [_contentScrollView addSubview:self.convertVC.view];
            
        }else{
            
            [_contentScrollView addSubview:self.storeColletVC.view];
            
        }
        
    }
    
}
- (void)switchDetailView:(UIButton *)sender{
    
 
    UIButton * btnSelected=[self.view viewWithTag:_index + buttonTag];
    
    btnSelected.selected=NO;
    
    sender.selected=YES;
    
    _index = sender.tag - buttonTag;
    
    if (_index == 0) {
        
        _contentScrollView.contentOffset = CGPointMake(0, 0);

        sender.selected = YES;
        [UIView animateWithDuration:0.4 animations:^{
            
        self.readLabel.frame= CGRectMake(0, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        [_contentScrollView addSubview:self.onlineVC.view];
        
    } else if (_index ==1){
        
        _contentScrollView.contentOffset = CGPointMake(ScreenW, 0);
      
        sender.selected = YES;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.readLabel.frame= CGRectMake(ScreenW/4.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        [_contentScrollView addSubview:self.groupVC.view];
        
    }else if (_index == 2){
        
       _contentScrollView.contentOffset = CGPointMake(ScreenW * 2, 0);
    //
        sender.selected = YES;
        [UIView animateWithDuration:0.4 animations:^{
            
            self.readLabel.frame= CGRectMake(ScreenW/4 * 2.0f, sender.frame.size.height, sender.frame.size.width, 2);
            
        }];
        [_contentScrollView addSubview:self.convertVC.view];
        
    }else{
        
      _contentScrollView.contentOffset = CGPointMake(ScreenW * 3, 0);
        
        sender.selected = YES;
        [UIView animateWithDuration:0.4 animations:^{
            
        self.readLabel.frame= CGRectMake(ScreenW/4 * 3.0f, sender.frame.size.height, sender.frame.size.width, 2);
        }];
        [_contentScrollView addSubview:self.storeColletVC.view];
        
    }
    
    
}


@end
