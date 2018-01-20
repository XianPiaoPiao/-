//
//  SetNewsViewController.m
//  XuXin
//
//  Created by xian on 2017/9/29.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "SetNewsViewController.h"
#import "EditNewsViewController.h"

@interface SetNewsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITextView *titleView;

@property (nonatomic, strong) UIImageView *logoImgView;

@property (nonatomic, strong) UIButton *nextBtn;

@property(nonatomic,assign) BOOL isUserCamera;
@property (nonatomic ,strong)UIImage * nowHeaderImage;
@property (nonatomic ,strong)AFHTTPSessionManager * httpManager;


@end

@implementation SetNewsViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    [self createUI];
    
    if (_editType == updateType) {
        
        self.titleView.text = _titleContent;
        [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:_logoUrlPath] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
        
    }
    
}

- (void)createNavBar{
    UIView * navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, KNAV_TOOL_HEIGHT)];
    [self.view addSubview:navBgView];
    navBgView.backgroundColor = [UIColor colorWithHexString:MainColor];
    self.navigationController.navigationBarHidden = YES;
    NSInteger statusBarHeight = 0;
    if (kDevice_Is_iPhoneX) {
        statusBarHeight = 20;
    } else {
        statusBarHeight = 0;
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+statusBarHeight, 160, 44)];
    label.textColor = [UIColor whiteColor];
    label.center = CGPointMake(ScreenW/2.0f, 42+statusBarHeight);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:16];
    [label setText:_navTitle];
    [navBgView addSubview:label];
    
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 27+statusBarHeight, 60, 30)];
    [returnButton setImage:[UIImage imageNamed:@"sign_in_fanhui@3x"] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    [returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
    [navBgView addSubview:returnButton];
}

- (void)returnAction:(UIButton *)sender{
    if (_editType == createType && _logoId != nil) {
        [self deleteLogoImg];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)deleteLogoImg{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"编辑正在进行中，确认退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self)weakself = self;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"id"] = _logoId;
        
        [weakself.httpManager POST:delectAccessoryByIdUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action2];
    
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createUI{
    NSInteger tabbarHeight = 0;
    if (kDevice_Is_iPhoneX) {
        tabbarHeight = 34;
    } else {
        tabbarHeight = 0;
    }
    [self.view setBackgroundColor:[UIColor colorWithHexString:BackColor]];
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.titleView.mas_bottom).offset(55);
        make.size.sizeOffset(CGSizeMake(120, 120));
    }];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadLogoImg)];
    [self.logoImgView addGestureRecognizer:tapGR];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-tabbarHeight);
        make.size.sizeOffset(CGSizeMake(ScreenW-20, 40));
    }];
    
    [_nextBtn addTarget:self action:@selector(jumpToNextVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)uploadLogoImg{
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
    
}

- (void)jumpToNextVC{
    if ([[_titleView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        [self showStaus:[NSString stringWithFormat:@"%@标题不能为空",_navTitle]];
    } else if (_logoId == nil){
        [self showStaus:@"请上传图片"];
    } else {
        if (_editType == updateType) {
            NSDictionary *contentDic = @{@"titleContent":_titleView.text,
                                         @"logoId":_logoId,
                                         };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNewsLogo" object:nil userInfo:contentDic];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            EditNewsViewController *editVC = [[EditNewsViewController alloc] init];
            editVC.navTitle = _navTitle;
            editVC.type = _type;
            editVC.editType = createType;
            editVC.logoId = _logoId;
            editVC.titleContent = _titleView.text;
            editVC.introductionType = _newsType;
            [self.navigationController pushViewController:editVC animated:YES];
        }
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_titleView resignFirstResponder];
}
- (void)showStaus:(NSString *)str{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    // 设置显示文本信息
    hud.label.text = str;
    
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    //设置小矩形背景颜色
    hud.bezelView.color = [UIColor blackColor];
    
    
    // 2秒钟之后隐藏HUD
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [hud hideAnimated:YES afterDelay:2];
        
    });
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
    
    [self.logoImgView setImage:self.nowHeaderImage];
    
    NSData * data;
    if (UIImagePNGRepresentation(image2)) {
        
        data= UIImagePNGRepresentation(image2);
    } else {
        
        data =UIImageJPEGRepresentation(image2, 1.0);
    }
//    [[NSFileManager defaultManager] createFileAtPath:_imagePath contents:data attributes:nil];
    
    //3.让图片选择器消失
    //上传数据
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在上传图片"];
    NSURLSessionDataTask *task = [weakSelf.httpManager POST:uploadAccessoryUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
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
        if ([responseObject[@"isSucc"] integerValue] == 1) {
            [SVProgressHUD dismiss];
            _logoId = responseObject[@"result"][@"id"];
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        [SVProgressHUD dismiss];
        [self showStaus:@"网络错误"];
        
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

#pragma mark --lazy load
- (NSString *)logoId{
    if (!_logoId) {
        _logoId = [NSString new];
    }
    return _logoId;
}
- (UITextView *)titleView{
    if (!_titleView) {
        _titleView = [[UITextView alloc] initWithFrame:CGRectMake(10, KNAV_TOOL_HEIGHT+10, ScreenW-20, 100)];
        _titleView.font = [UIFont systemFontOfSize:14.0f];
        _titleView.tintColor = [UIColor colorWithHexString:WordLightColor];
        _titleView.layer.cornerRadius = 2;
        _titleView.layer.masksToBounds = YES;
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [UIImageView new];
        _logoImgView.userInteractionEnabled = YES;
        [_logoImgView setImage:[UIImage imageNamed:@"sst2"]];
        [self.view addSubview:_logoImgView];
    }
    return _logoImgView;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        _nextBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
        _nextBtn.layer.cornerRadius = 20.0f;
        _nextBtn.layer.masksToBounds = YES;
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
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
