//
//  StartViewController.m
//

#import "StartViewController.h"
#import "XXTabBarController.h"
@interface StartViewController ()<UIScrollViewDelegate>

@end

@implementation StartViewController
{
    UIScrollView * _scrollView ;
    UIPageControl * _pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self creatPageControl];
}

-(void)creatPageControl{
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height-20, _scrollView.frame.size.width, 20)];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = 3;
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:MainColor]];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:BackColor];
    
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
}
-(void)changePage:(UIPageControl *)pageC{
    float x = pageC.currentPage * _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
-(void)creatUI{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];

    static int i = 0;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"yingdaoye_1@2x"]];
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView1 setImage:[UIImage imageNamed:@"yingdaoye_2@2x"]];
    
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(2*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //开起交互
    imageView2.userInteractionEnabled = YES;
    UIButton * enterBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW - 120)/2.0f, screenH - 60, 120, 40)];
    [enterBtn setImage:[UIImage imageNamed:@"jinru@2x"] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(junmpMainVC) forControlEvents:UIControlEventTouchDown];
    
    [imageView2 addSubview:enterBtn];
    
    [imageView2 setImage:[UIImage imageNamed:@"yingdaoye_3@2x"]];
        [_scrollView addSubview:imageView];
        [_scrollView addSubview:imageView1];
        [_scrollView addSubview:imageView2];
 
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
}
-(void)junmpMainVC{
    
    XXTabBarController * tabBar = [[XXTabBarController alloc] init];
    
    self.view.window.rootViewController = tabBar;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint point = scrollView.contentOffset;
    NSInteger currentPage = (NSInteger)(point.x / _scrollView.frame.size.width);
      _pageControl.currentPage = currentPage;

   
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
