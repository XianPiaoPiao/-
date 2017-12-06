//
//  BackGoodsTransportController.m
//  XuXin
//
//  Created by xuxin on 17/4/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BackGoodsTransportController.h"
#import "InsetLabel.h"
@interface BackGoodsTransportController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView * tabelView;

@property (nonatomic ,strong)NSMutableArray * transportArray;

@property (nonatomic ,copy)NSString * trnsportId;

@property (nonatomic ,assign)NSInteger  trnsportType;


@end

@implementation BackGoodsTransportController
-(NSMutableArray *)transportArray{
    if (!_transportArray) {
        _transportArray = [[NSMutableArray alloc] init];
    }
    return _transportArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.transportNumberField setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    [self creatNavgationBar];
    
    [self requestData];

}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"物流信息"];
    
    [self addBackBarButtonItem];
    
}
-(void)requestData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"orderId"] = _orderId;
    
    
    [weakself POST:appReturnLogisticsUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        NSDictionary * dic = responseObject[@"result"];
        
        if ([str integerValue] == 1) {
            
            weakself.transportArray = dic[@"expressCompany"];
            
           _trnsportType = [dic[@"type"] integerValue];
            if (_trnsportType == 1) {
                
                weakself.companyNameLabel.text = dic[@"logisticsCompany"];
                weakself.transportNumberField.text = dic[@"logisticsNumber"];
                weakself.transportNumberField.enabled = NO;
                
            }
        }
        
      
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)tapAlterView:(id)sender {
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    bgView.tag = buttonTag;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBgView)];
    [bgView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:bgView];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(30, 64, ScreenW - 60, screenH - 114) style:UITableViewStylePlain];
    [self.view addSubview:_tabelView];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    
    __weak typeof(self)weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakself.tabelView reloadData];
        
    });
    
}
//移除背景图
-(void)removeBgView{
    
    UIView * bgView = [self.view viewWithTag:buttonTag];
    
    [_tabelView removeFromSuperview];
    
    [bgView removeFromSuperview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    InsetLabel * label = [[InsetLabel alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 10, 40)];
    label.textAlignment = 0;
    
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.transportArray[indexPath.row][@"logisticsName"];
   
    
    UIImageView * selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 100, 10, 20, 20)];
    selectImageView.tag = buttonTag + 30 + indexPath.row;
    
    [selectImageView setImage:[UIImage imageNamed:@"icon_money_check_off@2x"]];
    [selectImageView setHighlightedImage:[UIImage imageNamed:@"exchange_selected@3x"]];
    
    [cell.contentView addSubview:selectImageView];
    [cell.contentView addSubview:label];
    return cell;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.transportArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
- (IBAction)uploadTransportData:(id)sender {
    if (_trnsportType == 1) {
        
        [self showStaus:@"你已经提交过了物流信息"];
    }else{
        
        if (_transportNumberField.text.length && _companyNameLabel.text.length) {
            
            __weak typeof(self)weakself = self;
            
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            param[@"orderId"] = _orderId;
            param[@"exId"] = _trnsportId;
            
            param[@"returnShipCode"] =  _transportNumberField.text;
            
            [weakself POST:appSaveReturnLogisticsUrl parameters:param success:^(id responseObject) {
                
                [weakself showStaus:@"填写物流成功,等待卖家退款"];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderOK" object:nil];
                    
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                    
                });
            } failure:^(NSError *error) {
                
            }];
        }else{
            [self showStaus:@"请填写完整信息"];
        }
        
 
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self removeBgView];
    _companyNameLabel.text = self.transportArray[indexPath.row][@"logisticsName"];
    _trnsportId = self.transportArray[indexPath.row][@"logisticsId"];
    
}
@end
