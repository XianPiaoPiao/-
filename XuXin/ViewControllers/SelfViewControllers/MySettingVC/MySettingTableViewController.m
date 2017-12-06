//
//  MySettingTableViewController.m
//  XuXin
//
//  Created by xuxin on 16/8/31.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "MySettingTableViewController.h"
#import "ChangeBirthDayViewContrlloer.h"
#import "ForgetScretViewController.h"
#import "LandingViewController.h"
#import "ChangeSexViewController.h"
#import "ChangePayPasswordViewController.h"
#import "RegistViewController.h"
#import "RecivePlaceTableViewController.h"
#import "updatePasswordViewController.h"
@interface MySettingTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(nonatomic,assign) BOOL isUserCamera;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *recieveGoodsPlaceLabel;
@property (nonatomic ,strong)UIImage * nowHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerSettingLabel;
@end

@implementation MySettingTableViewController{
    NSString * _imagePath;
}

#pragma mark - 懒加载
- (UIImage *)nowHeaderImage {
    
    if (!_nowHeaderImage) {
        _nowHeaderImage = self.headerImageView.image;
    }
    return _nowHeaderImage;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //头像
    UIImage * image =[ UIImage imageWithContentsOfFile:_imagePath];
    if (image ==nil) {
        
        [self.headerImageView setImage:[UIImage imageWithContentsOfFile:@"touxiang"]];
        
    }else{
        [self.headerImageView setImage:image];
    }
    //性别
    if ([User defalutManager].sex == 0) {
        
        self.sexLabel.text = @"男";
        
    }else if ([User defalutManager].sex == 1){
        
        self.sexLabel.text = @"女";
        
    }
    //生日
    [self settingBirthday];
    
    [MTA trackPageViewBegin:@"MySettingTableViewController"];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:@"MySettingTableViewController"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshingUI" object:nil];
    //图片保存到本地
     [self settingPath];
    //设置导航条
    [self creatNavgationBar];
    //初始化界面
    [self creatUI];
  
}

#pragma 通知方法

-(void)refreshData{
    
    [self refreshingData];
}
-(void)refreshingData{
    //
    //时间戳转时间
    [self settingBirthday];
    
}
-(void)creatUI{
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 24;
    //设置section的间距
    self.tableView.sectionFooterHeight = 5;
    self.tableView.sectionHeaderHeight = 5;
    [self creatNavgationBar];
    //添加退出账号
    UIButton * leaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 450, ScreenW - 20, 50)];
    [leaveBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [leaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leaveBtn addTarget:self action:@selector(backToLandVC) forControlEvents:UIControlEventTouchDown];
    leaveBtn.layer.cornerRadius = 25;
    leaveBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
    [self.view addSubview:leaveBtn];
    
   self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if ([User defalutManager].sex == 0) {
        self.sexLabel.text = @"男";
        
    }else if ([User defalutManager].sex == 1){
        self.sexLabel.text = @"女";
        
    }
    //时间戳转时间
    [self settingBirthday];
}
-(void)settingBirthday{
    
    NSString * str = [NSString stringWithFormat:@"%lld",[User defalutManager].birthday];
    
    if (str.length  == 10 || str.length == 9) {
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMdd"];
        [format setDateStyle:NSDateFormatterMediumStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[User defalutManager].birthday ]
        ;
        NSString * dateStr = [format stringFromDate:date];
        NSMutableString * dateMustr = [NSMutableString stringWithString:dateStr];
        if (dateMustr.length > 16) {
            
            NSString * showStr =  [dateMustr substringWithRange:NSMakeRange(0, 11)];
            self.birthdayLabel.text = showStr;;
            
        }else{
            
            NSString * showStr =  [dateMustr substringWithRange:NSMakeRange(0, 10)];
            self.birthdayLabel.text = showStr;;
            
        }
        
     
    }
    else if (str.length == 13 || str.length == 12){
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMdd"];
        [format setDateStyle:NSDateFormatterMediumStyle];
        [format setTimeStyle:NSDateFormatterShortStyle];
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[User defalutManager].birthday /1000.f];
        NSString * dateStr = [format stringFromDate:date];
        NSMutableString * dateMustr = [NSMutableString stringWithString:dateStr];
        if (dateMustr.length > 16) {
            
             NSString * showStr =  [dateMustr substringWithRange:NSMakeRange(0, 11)];
            self.birthdayLabel.text = showStr;;

        }else{
            NSString * showStr =  [dateMustr substringWithRange:NSMakeRange(0, 10)];
            self.birthdayLabel.text = showStr;;

        }
       
        
      }else if (str.length == 0){
          
        self.birthdayLabel.text = @"";

    }
   

}
//保存到本地
-(void)settingPath{
    
    NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = pathArray[0];
    NSString * imageDocPath = [NSString stringWithFormat:@"%@/ImageFile",documentPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    _imagePath = [NSString stringWithFormat:@"%@/image.png",imageDocPath];
}
-(void)creatNavgationBar{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui@3x"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    
    leftItem.tintColor = [UIColor blackColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [titleLabel setText:@"账户设置"];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.titleView = titleLabel;
    
}
-(void)returnAction{
    if (self.block) {
        
        self.block(_imagePath);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark ---退出账号

-(void)backToLandVC{
    //
    
    [self.httpManager POST:loginOutUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        if ([str intValue] == 1) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sex"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"birthDay"];
            //synchronize的作用就是命令直接同步到文件里
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backToLand" object:nil];
            //同步数据
            [User defalutManager].userName = @"NO";
            [User defalutManager].shopcart = 0;
       
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openCamera];
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openPhoto];
            }];
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:action];
            [alertController addAction:action2];
            
            [alertController addAction:action3];
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (indexPath.row ==2){
            //修改性别
            ChangeSexViewController * sexVC = [[ChangeSexViewController alloc] init];

            [self.navigationController pushViewController:sexVC animated:YES];
            
        }else if (indexPath.row == 3){
            //修改生日
            ChangeBirthDayViewContrlloer * birthSettingVC = [[ChangeBirthDayViewContrlloer alloc] init];

            [self.navigationController pushViewController:birthSettingVC animated:YES];

        }

    }else if (indexPath.section ==1){
        if (indexPath.row ==0) {
            //修改收货地址

            RecivePlaceTableViewController * recieveVC = [[RecivePlaceTableViewController alloc] init];
            
            [self.navigationController pushViewController:recieveVC animated:YES];

        }else if (indexPath.row == 1){
            //修改支付密码
            
            self.hidesBottomBarWhenPushed = YES;
            ChangePayPasswordViewController * passWordVC = [[ChangePayPasswordViewController alloc] init];
            passWordVC.type = changePasswordType;
            
            [self.navigationController pushViewController:passWordVC animated:YES];
         
            
        }else if (indexPath.row ==2){
            //修改登录密码

            updatePasswordViewController * forgetVC = [[updatePasswordViewController alloc] init];
            
            [self.navigationController pushViewController:forgetVC animated:YES];

        }
    }
}
#pragma 修改图片
-(void)openCamera{
    BOOL ret = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    //判断是否支持相机
    if (ret) {
        
        //1.创建一个图片选择器控制器对象
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //2.设置图片资源类型
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //3.设置代理
        picker.delegate = self;
        
        //4.显示图片选择器
        [self presentViewController:picker animated:YES completion:nil];
        self.isUserCamera = YES;
        
    }else{
        
       // FLLog(@"该设备没有相机");
    }

}
//参数1：委托
//参数2：选中的资源信息
-(void)openPhoto{
    //1.创建一个图片选择器控制器对象
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    //2.设置资源类型
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //3.设置代理
    picker.delegate = self;
    
    //5.选择的时候看大图
    picker.allowsEditing = YES;
    
    
    //4.显示在界面
    [self presentViewController:picker animated:YES completion:nil];
    self.isUserCamera = NO;
}

#pragma mark - imagePicker Delegate
//参数1:委托
//参数2:选中的资源信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //1.获取原图
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    
    //获取截图(只有在允许编辑的时候才有)
    UIImage * image2 = info[@"UIImagePickerControllerEditedImage"];

    //2.将图片显示在imageView上
    if (self.isUserCamera) {
        
        self.nowHeaderImage = image;
    } else {
        
        self.nowHeaderImage = image2;
    }
    
    [self.headerImageView setImage:self.nowHeaderImage];
    
    NSData * data;
    if (UIImagePNGRepresentation(image2)) {
        
        data= UIImagePNGRepresentation(image2);
    } else {
        
        data =UIImageJPEGRepresentation(image2, 1.0);
    }
    [[NSFileManager defaultManager] createFileAtPath:_imagePath contents:data attributes:nil];
    
    //3.让图片选择器消失
    //上传数据
    __weak typeof(self)weakSelf = self;
    
    NSURLSessionDataTask *task = [weakSelf.httpManager POST:updateUserUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image2,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        
        self.headerSettingLabel.hidden = YES;
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        
    }];
    [task resume];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(AFHTTPSessionManager *)httpManager{
    if (!_httpManager) {
        _httpManager = [AFHTTPSessionManager manager];
        //设置序列化,将JSON数据转化为字典或者数组
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //在序列化器中追加一个类型，text、html这个类型不支持的，text、json，apllication，json
        _httpManager.responseSerializer.acceptableContentTypes = [_httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _httpManager.requestSerializer.timeoutInterval = 15;
        // AFSSLPinningModeCertificate 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        securityPolicy.allowInvalidCertificates = YES;
        
        [securityPolicy setValidatesDomainName:NO];
        [_httpManager setSecurityPolicy:securityPolicy];
    }
    return _httpManager;
}
@end
