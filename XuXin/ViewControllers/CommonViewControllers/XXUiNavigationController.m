//
//  XXUiNavigationController.m
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "XXUiNavigationController.h"

@interface XXUiNavigationController ()

@end

@implementation XXUiNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
//拦截所有push进来的控制器。在这可以写
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;

    }
    
    [super pushViewController:viewController animated:animated];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
