//
//  EaseLoadingView.h
//  XuXin
//
//  Created by xuxin on 16/9/24.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseLoadingView : UIView
@property (nonatomic ,strong)UIImageView * headerImageView;
+(instancetype)defalutManager;
- (void)startLoading;
- (void)stopLoading;
//数据加载失败
-(void)showErrorStatus;

@end
