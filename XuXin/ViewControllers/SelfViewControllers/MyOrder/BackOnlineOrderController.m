//
//  BackOnlineOrderController.m
//  XuXin
//
//  Created by xuxin on 17/4/10.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "BackOnlineOrderController.h"
#import "BackGoodsTransportController.h"
#import "InsetLabel.h"
#import "problemModel.h"
@interface BackOnlineOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView * tabelView;
@property (nonatomic ,strong)NSMutableArray * problemArray;

@end

@implementation BackOnlineOrderController
-(NSMutableArray *)problemArray{
    if (!_problemArray) {
        _problemArray = [[NSMutableArray alloc] init];
    }
    return _problemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgationBar];
}
-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"申请退款"];
    [self addBackBarButtonItem];
    
    self.backMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_backPriceValue];
    
    NSArray * array = @[@"拍错/多拍/不想要",@"协商一致退款",@"缺货",@"未按约定时间发货",@"其他"];
    
    for (int i = 0; i < array.count; i++) {
        
        problemModel * model = [[problemModel alloc] init];

        model.name = array[i];
        [self.problemArray addObject:model];
        
    }
}
- (IBAction)tapAlterView:(id)sender {
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    bgView.tag = buttonTag;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBgView)];
    [bgView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:bgView];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(20, 64, ScreenW - 40, 200) style:UITableViewStylePlain];
    
    _tabelView.center = CGPointMake(ScreenW/2.0f, screenH/2.0f);
    
    _tabelView.separatorStyle = NO;
    [self.view addSubview:_tabelView];
    
    _tabelView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    
    

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

    problemModel * model = self.problemArray[indexPath.row];
    label.text = model.name;
    
    UIImageView * selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 100, 10, 20, 20)];
    selectImageView.tag = buttonTag + 30 + indexPath.row;
    
    [selectImageView setImage:[UIImage imageNamed:@"icon_money_check_off@2x"]];
    [selectImageView setHighlightedImage:[UIImage imageNamed:@"exchange_selected@3x"]];
    UIView * seperateString = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 10, 1)];
    seperateString.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    [cell.contentView addSubview:selectImageView];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:seperateString];
    
    return cell;

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.problemArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [self removeBgView];
    
    problemModel * model = self.problemArray[indexPath.row];
    _problemLabel.text =model.name;
    
    
}

- (IBAction)uploadRequest:(id)sender{
    
    if ([_problemLabel.text isEqualToString:@"请选择退款原因"]) {
        [self showStaus:@"请选择退款原因"];
    }else{
        if (_orderType == 1) {
            
            [self backGoodsMoneyData];
        }else{
            
            [self backGoodsData];
        }
        
  }
}
-(void)backGoodsData{
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    param[@"content"] = _problemLabel.text;
    
    
    [weakself POST:appOnLineApplyForRefundUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str integerValue] == 1) {
            
            [weakself showStaus:@"买家申请退货成功"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderOK" object:nil];
                
                UIViewController * viewVC = self.navigationController.viewControllers[1];
                
                [weakself.navigationController popToViewController:viewVC animated:YES];
                
            });
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark
-(void)backGoodsMoneyData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    param[@"content"] = _problemLabel.text;
    
    
    [weakself POST:appOnLineApplyForMoneyUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        
        if ([str integerValue] == 1) {
            
            [weakself showStaus:@"买家申请退款成功"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrderOK" object:nil];
                
                UIViewController * viewVC = self.navigationController.viewControllers[1];
                
                [weakself.navigationController popToViewController:viewVC animated:YES];
                
            });
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    }];
}
@end
