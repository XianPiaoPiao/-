//
//  EditNewsViewController.m
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "EditNewsViewController.h"
#import "LMWordViewController.h"
#import "HTMLViewController.h"
#import "LMWordView.h"
#import "SetNewsViewController.h"
#import "NewsViewController.h"
#import "NSTextAttachment+LMText.h"


@interface EditNewsViewController ()

@property (nonatomic, strong) LMWordViewController *wordViewController;
@property (nonatomic, strong) HTMLViewController *htmlViewController;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, strong)  UIView *container;

//@property (nonatomic, strong) NSString *contentDetail;

@end

@implementation EditNewsViewController


-(UIView *)container{
    if (!_container) {
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, KNAV_TOOL_HEIGHT, ScreenW, screenH)];//self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_container];
    }
    return _container;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self requestData];
    
    [self createNavBar];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"changeNewsLogo" object:nil];
    
}

- (void)getNotification:(NSNotification *)sender{
    NSDictionary *dic = sender.userInfo;
    self.titleContent = dic[@"titleContent"];
    self.logoId = dic[@"logoId"];
    self.editType = updateType;
    UIButton *btn = [self.view viewWithTag:200];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveNews) forControlEvents:UIControlEventTouchDown];
    self.wordViewController.edittype = @(updateType);
}

- (void)createNavBar{
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+self.StatusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+self.StatusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:_navTitle];
    [navBgView addSubview:label];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+self.StatusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:returnButton];
    if (_introductionType != 0) {//动态新闻加盟
        if (_type == selfType) {//自己
            UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 70, 27+self.StatusBarHeight, 50, 30)];
            addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            addBtn.tag = 200;
            [navBgView addSubview:addBtn];
            if (_editType == readType) {
                [addBtn setTitle:@"编辑" forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(changeNews) forControlEvents:UIControlEventTouchDown];
            } else {
                [addBtn setTitle:@"保存" forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(saveNews) forControlEvents:UIControlEventTouchDown];
            }
        }else {//好友
            //无操作
        }
    } else {//介绍
        if (_type == selfType) {
//            if (_editType != readType) {
            UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 70, 27+self.StatusBarHeight, 50, 30)];
            [navBgView addSubview:addBtn];
            [addBtn setTitle:@"保存" forState:UIControlStateNormal];
            addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [addBtn addTarget:self action:@selector(saveNews) forControlEvents:UIControlEventTouchDown];
//            }
        } else {
            //无操作
        }
    }
    
    
    
}

- (void)returnAction:(UIButton *)sender{
    if (_introductionType != 0 && _editType == createType && _logoId != nil) {
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)deleteLogoImg{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"编辑正在进行中，确认退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self)weakself = self;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"id"] = _logoId;
        
        [weakself.httpManager POST:delectAccessoryByIdUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString * str = responseObject[@"isSucc"];
            if ([str intValue] == 1) {
                
                //                [self showStaus:@"请上传新的Logo图"];
                //                _logoId = nil;
                //                [_logoImgView setImage:[UIImage imageNamed:@"sst2"]];
            } else {
                //                [self showStaus:@"删除失败"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            [self showStaus:@"删除失败"];
        }];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action2];
    
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.currentViewController.view.frame = self.container.bounds;
}

- (LMWordViewController *)wordViewController {
    
    if (!_wordViewController) {
        
        _wordViewController = [[LMWordViewController alloc] init];
    }
    return _wordViewController;
}

- (HTMLViewController *)htmlViewController {
    
    if (!_htmlViewController) {
        _htmlViewController = [[HTMLViewController alloc] init];
    }
    return _htmlViewController;
}

- (void)createUI{
    if (self.currentViewController) {
        
        [self.currentViewController removeFromParentViewController];
        
        [self.currentViewController.view removeFromSuperview];
        
    }
    
    if (_editType == readType || _type == friendType) {
        //阅读
        self.wordViewController.edittype = @(readType);
        if (_introductionType) {
            //动态
            [self loadContendDetail];
        } else {
            //介绍
            NSString *newString = [self.contentDetail stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",ScreenW - 10]];
            
            NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            UIViewController *viewController = self.wordViewController;
            
            [self addChildViewController:viewController];
            [self.container addSubview:viewController.view];
            viewController.view.frame = self.container.bounds;
            
            [self.wordViewController.textView setAttributedText:strAtt];
        }
        
        
        
    } else if (_editType == updateType){
        
        //修改
        self.wordViewController.edittype = @(updateType);
        NSString *newString = [self.contentDetail stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",ScreenW - 10]];
        
        NSAttributedString * attributedString = [[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        UIViewController *viewController = self.wordViewController;
        
        [self addChildViewController:viewController];
        [self.container addSubview:viewController.view];
        viewController.view.frame = self.container.bounds;
        [self.wordViewController.textView setAttributedText:attributedString];
        self.wordViewController.contentDetail = self.contentDetail;
        
    } else {
        self.wordViewController.edittype = @(createType);
        //添加
        UIViewController *viewController = self.wordViewController;
        [self addChildViewController:viewController];
        [self.container addSubview:viewController.view];
        viewController.view.frame = self.container.bounds;
        
    }
}

- (void)loadContendDetail{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self POST:findCardContentByIDUrl parameters:@{@"ccId":_ccId} success:^(id responseObject) {
        [SVProgressHUD dismiss];
        int str = [responseObject[@"isSucc"] intValue];
        if (str == 1) {
            NSDictionary *dic = responseObject[@"result"];
            self.contentDetail = dic[@"card_content_detail"];
            self.logoId = dic[@"photoid"];
            NSString *newString = [self.contentDetail stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",ScreenW - 10]];
            
            NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
         
            UIViewController *viewController = self.wordViewController;
            [self addChildViewController:viewController];
            [self.container addSubview:viewController.view];
            viewController.view.frame = self.container.bounds;
            
            [self.wordViewController.textView setAttributedText:strAtt];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)changeNews{
    SetNewsViewController *setVC = [[SetNewsViewController alloc] init];
    setVC.navTitle = _navTitle;
    setVC.newsType = _introductionType;
    setVC.type = _type;
    setVC.ccId = _ccId;
    setVC.editType = updateType;
    setVC.titleContent = _titleContent;
    setVC.logoUrlPath = _logoUrlPath;
    setVC.logoId = _logoId;
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)saveNews{
    
    if (_introductionType){
        [self saveIntroductions];
    } else {
        [self saveIntroduces];
    }
}

- (void)saveIntroduces{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"intro"] = [self.wordViewController exportHTML];
    dic[@"type"] = [NSString stringWithFormat:@"%ld",_intrType];
    [weakself POST:revisedIntroductionUrl parameters:dic success:^(id responseObject) {
        if ([responseObject[@"isSucc"] integerValue] == 1) {
            [self showStaus:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IntroduceChanged" object:nil];
            int64_t delayInSeconds = 1.0;      // 延迟的时间
            /*
             *@parameter 1,时间参照，从此刻开始计时
             *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
             */
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)saveIntroductions{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_introductionType == productType) {
        dic[@"type"] = [NSString stringWithFormat:@"%d",0];
    } else {
        dic[@"type"] = [NSString stringWithFormat:@"%ld",_introductionType];
    }
    
    dic[@"title"] = _titleContent;
    dic[@"card_content_detail"] = [self.wordViewController exportHTML];
    dic[@"photoid"] = _logoId;
    if (_editType == updateType) {
        
        dic[@"id"] = _ccId;
        
    }
    [weakself POST:updateIntroductionsUrl parameters:dic success:^(id responseObject) {
        if ([responseObject[@"isSucc"] integerValue] == 1) {
            [self showStaus:@"成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsHaveChanged" object:nil];
            [self back];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)back {
//    //这个是复杂的写法
//    UINavigationController *navigationVC = self.navigationController;
//    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//    //遍历导航控制器中的控制器
//    for (UIViewController *vc in navigationVC.viewControllers) {
//
//        [viewControllers addObject:vc];
//
//        //[XXXXViewController class]就是你需要返回的指定的控制器
//        if ([vc isKindOfClass:[NewsViewController class]]) {
//
//            [navigationVC setViewControllers:viewControllers animated:YES];
//
//            [navigationVC popViewControllerAnimated:YES];
//
//            break;
//
//        }
//    }
    //简单写法
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[NewsViewController  class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    
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
