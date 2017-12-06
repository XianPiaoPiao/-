//
//  ConvertPictureDetailViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/22.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ConvertPictureDetailViewController.h"

@interface ConvertPictureDetailViewController ()<UIWebViewDelegate>
@property(nonatomic ,strong)UIWebView * pictureWebView;
@end

@implementation ConvertPictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self firstLoad];
    
    [self creatNavgationBar];
}
-(void)firstLoad{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"id"] =[User defalutManager].selectedGoodsID;

    [weakself.httpManager POST:ig_contentUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //加载
        NSString * contentHtml = responseObject[@"result"][@"ig_content"];
    
        self.pictureWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,  0, ScreenW, screenH -114 )];
        
        self.pictureWebView.backgroundColor = [UIColor whiteColor];
        
        //不能滑
        //  self.pictureWebView.scrollView.bouncesZoom = NO;
       //   self.pictureWebView.scrollView.bounces = NO;//不允许漏出空白背景
        //不能点
        //  self.pictureWebView.multipleTouchEnabled=NO;
        
        [self.view addSubview:self.pictureWebView];
 
        [self.pictureWebView setScalesPageToFit:YES];
     //   self.pictureWebView.dataDetectorTypes = UIDataDetectorTypeAll;

        [self.pictureWebView loadHTMLString:contentHtml baseURL:[NSURL URLWithString:Host]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"买单说明"];
    [self addBarButtonItemWithTitle:@"返回" image:[UIImage imageNamed:@"s011"] target:self action:@selector(returnAction) isLeft:YES];
    
    
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    
    return nil;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [self.pictureWebView stringByEvaluatingJavaScriptFromString:js];
    [self.pictureWebView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
