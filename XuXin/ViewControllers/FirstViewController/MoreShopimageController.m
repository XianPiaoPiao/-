//
//  MoreShopimageController.m
//  XuXin
//
//  Created by xuxin on 16/12/30.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MoreShopimageController.h"

@interface MoreShopimageController ()<UIScrollViewDelegate>

@end

@implementation MoreShopimageController
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
}
-(void)creatUI{
 
    
    CGFloat  imageH =  ScreenW /5*3;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, (screenH - imageH)/2.0f)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor blackColor];
    UIView * bootmView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - (screenH - imageH)/2.0f, ScreenW, (screenH - imageH)/2.0f)];
    [self.view addSubview:bootmView];
    bootmView.backgroundColor= [UIColor blackColor];
    UIScrollView * igScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:igScrollView];
    igScrollView.pagingEnabled = YES;
    igScrollView.showsHorizontalScrollIndicator =NO;
    igScrollView.contentSize = CGSizeMake(ScreenW * self.imageArray.count,0);
    igScrollView.delegate = self;
    [igScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.bottom.equalTo(bootmView.mas_top);
    }];
    
    
    for (int i = 0; i < self.imageArray.count; i++) {
        
        NSString * url = self.imageArray[i][@"slide"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW * i, 0, ScreenW,  imageH)];
        [igScrollView addSubview:imageView];
      
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
    
    UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 20)];
    numberLabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.imageArray.count];
    numberLabel.tag = buttonTag;
    numberLabel.font =[UIFont systemFontOfSize:15];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = 1;
    [self.view addSubview:numberLabel];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UILabel * numberLabel = [self.view viewWithTag:buttonTag];
    NSInteger page = scrollView.contentOffset.x/ScreenW + 1;
    
    numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)page,self.imageArray.count];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
