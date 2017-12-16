//
//  ScanQrcodeController.m
//  XuXin
//
//  Created by xuxin on 16/11/4.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ScanQrcodeController.h"
#import "SHBQRView.h"
#import "ScanErcodeEndingController.h"
#import "MyOrderTableViewController.h"
#import "SBMyOrderTableviewController.h"
#import "PayViewController.h"
#import "HDRegisterController.h"
#import "CardDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "IntrgralPayViewController.h"

@interface ScanQrcodeController ()<SHBQRViewDelegate>

@property(nonatomic,strong) AVCaptureDevice *device;

@end

@implementation ScanQrcodeController{
    SHBQRView * _qrView;
}
    
-(void)viewDidLoad {
    
    [super viewDidLoad];
   // self.view.backgroundColor = [UIColor whiteColor];
     _qrView = [[SHBQRView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_qrView];
    _qrView.delegate = self;
    
    [self creatNavgationBar];

}
-(void)viewWillAppear:(BOOL)animated{
    

    [_qrView startScan];
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [MTA trackPageViewBegin:@"ScanQrcodeController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"ScanQrcodeController"];
}

-(void)creatNavgationBar{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20+self.StatusBarHeight, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"fhui"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    UIButton * btn2 =[[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 50, 20+self.StatusBarHeight, 30, 30)];
    [btn2 setImage:[UIImage imageNamed:@"sguang"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(openlight:) forControlEvents:UIControlEventTouchDown];
    btn2.selected = YES;
    [self.view addSubview:btn2];
}
//调用闪光灯的代码
-(void)openlight:(UIButton *)sender
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (sender.selected == YES) {
      
        if (![device hasTorch]) {
            //判断是否有闪光灯
            NSLog(@"no torch");
        }else{
            [device lockForConfiguration:nil];//锁定闪光灯
            [device setTorchMode: AVCaptureTorchModeOn];//打开闪光灯
            [device unlockForConfiguration];  //解除锁定
            
        }
        sender.selected = NO;
    }else{
        [device lockForConfiguration:nil];//锁定闪光灯
        [device setTorchMode: AVCaptureTorchModeOff];//关闭闪光灯
        [device unlockForConfiguration];  //解除锁定
        sender.selected = YES;
    }
 
}
-(void)returnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result {
    [view stopScan];
    
    NSMutableString * subResult = [NSMutableString stringWithString:result];
    
    if ([subResult containsString:@"http://www.hidui.com.cn/wap"] == YES){
        
        HDRegisterController * registVC = [[HDRegisterController alloc] init];
        registVC.pushType = 1;
        NSArray * stringArray = [subResult componentsSeparatedByString:@"="];
        registVC.userId = stringArray[stringArray.count -1];
       
        [self.navigationController pushViewController:registVC animated:YES];
       
    }else if ([subResult containsString:Host] == YES ||[subResult containsString:@"http://hidui.com.cn"] == YES || [subResult containsString:@"http://www.hidui.com.cn"]) {
       
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
             
            NSArray * array = [subResult componentsSeparatedByString:@"id="];
           
            NSMutableString * subString =  array[1];
            NSArray * array2 =  [subString componentsSeparatedByString:@"-"];
            NSString * storeId = array2[0];
            if (_priceValue.length > 0) {
               
                [self requestData:storeId];
               
            }else if ([subResult containsString:@"deleteBuddy"]){
                //添加名片好友
                CardDetailViewController *cardDetailVC = [[CardDetailViewController alloc] init];
                cardDetailVC.userCardId = array[1];
                cardDetailVC.isFriend = NO;
                cardDetailVC.type = friendType;
                [self.navigationController pushViewController:cardDetailVC animated:YES];
            } else if ([subResult containsString:@"userGetOrder"]){
                
                IntrgralPayViewController *intrgralVC = [[IntrgralPayViewController alloc] init];
                intrgralVC.ID = array[1];
                [self.navigationController pushViewController:intrgralVC animated:YES];
                
            } else {
               
                [User defalutManager].selectedShop = storeId;
                
                PayViewController * payVC =[[PayViewController alloc] init];
                [self.navigationController pushViewController:payVC animated:YES];
               
            }
             
        }else{
             
             [self goLanding];
        }
       
    } else if ([subResult containsString:@"deleteBuddy"]){
        //添加名片好友
        CardDetailViewController *cardDetailVC = [[CardDetailViewController alloc] init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addFriendCardByQrcode" object:nil userInfo:@{@"url":subResult}];
        [self.navigationController pushViewController:cardDetailVC animated:YES];
    } else if ([subResult containsString:@"userGetOrder"]){
        NSArray * array = [subResult componentsSeparatedByString:@"id="];
        IntrgralPayViewController *intrgralVC = [[IntrgralPayViewController alloc] init];
        intrgralVC.ID = array[1];
        [self.navigationController pushViewController:intrgralVC animated:YES];
        
    } else {
        
        [self showStaus:@"该商家不存在"];
        
    }
    
}
#pragma mark ---创建订单
-(void)requestData:(NSString *)storeId{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"storeId"] = storeId;
    
    param[@"price"] =[NSString stringWithFormat:@"%.2f",[_priceValue floatValue]];
    [weakself POST:faceOrderUrl parameters:param success:^(id responseObject) {
        int i = [responseObject[@"isSucc"] floatValue];
        
        if (i == 1) {
            
            NSString * orderOk = responseObject[@"result"][@"order_sn"];
            NSString * orderId = responseObject[@"result"][@"order_id"];
            //    创建通知
//            if ([_priceValue intValue] >= 150 && [User defalutManager].redPacket > 0) {
                UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
                myOrderVC.orderPrice =_priceValue;
                myOrderVC.orderId = orderId;
                myOrderVC.orderNumber = orderOk;
                //    myOrderVC.storeName = _store;
                [self.navigationController pushViewController:myOrderVC animated:YES];
                
//            }else{
//                
//                UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                
//                SBMyOrderTableviewController * myOrderVC =  (SBMyOrderTableviewController *)[storybord instantiateViewControllerWithIdentifier:@"SBMyOrderTableviewController"];
//                myOrderVC.orderPrice = _priceValue;
//                myOrderVC.orderId = orderId;
//                myOrderVC.orderNumber = orderOk;
//                //   myOrderVC.storeName = _storeName;
//                [self.navigationController pushViewController:myOrderVC animated:YES];
//            }
            
        }
        

    } failure:^(NSError *error) {
        
    }];

}


@end
