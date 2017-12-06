//
//  groupGoodsController.m
//  XuXin
//
//  Created by xuxin on 17/3/9.
//  Copyright © 2017年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "groupGoodsController.h"
#import "RecievePlaceTableViewCell.h"
#import "GroupGoodsMOdel.h"
#import "HaiDuiTextView.h"
#import "InsetLabel.h"
#import "MyOrderTableViewController.h"
#import "SBMyOrderTableviewController.h"
#import "GoodsLIstViewController.h"
NSString * const GroupReceiveIndertifer = @"RecievePlaceTableViewCell";
@interface groupGoodsController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (nonatomic ,strong)UITableView * tableView;

@property (nonatomic ,copy)NSString * orderId;

@property (nonatomic ,copy)NSString * orderSn;
@end

@implementation groupGoodsController{
    HaiDuiTextView * _textView;
    UITextField * _phoneField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavgationBar];
    [self creatTableView];
    
    
}
-(NSMutableArray *)ImageArray{
    if (!_ImageArray) {
        _ImageArray = [[NSMutableArray alloc] init];
    }
    return _ImageArray;
}

-(void)creatNavgationBar{
    
    [self addNavgationTitle:@"线下商品"];
    
    [self addBackBarButtonItem];
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, screenH) style:UITableViewStyleGrouped];
    [_tableView registerNib:[UINib nibWithNibName:@"RecievePlaceTableViewCell" bundle:nil] forCellReuseIdentifier:GroupReceiveIndertifer];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 80, ScreenW, 100)];
    footView.backgroundColor = [UIColor colorWithHexString:BackColor];
    
    UIButton * uploadOrderBtn =[[UIButton alloc] initWithFrame:CGRectMake(10, 50, ScreenW - 20, 50)];
    uploadOrderBtn.backgroundColor =[UIColor colorWithHexString:MainColor];
    [uploadOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [uploadOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadOrderBtn.layer.cornerRadius = 25;
    [footView addSubview:uploadOrderBtn];
    
    [uploadOrderBtn addTarget:self action:@selector(uploadOrder) forControlEvents:UIControlEventTouchDown];
    
    _tableView.tableFooterView = footView;
    
}
#pragma mark ---提交订单
-(void)uploadOrder{
    
    if (_orderId != nil) {
        
        CGFloat  totalMoney = [_amountMoney floatValue];
        
        if (totalMoney >= 150 && [User defalutManager].redPacket > 0 ) {
            
            UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
            myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
            //订单类型,线下订单
            myOrderVC.orderType = 2;
            
            myOrderVC.orderId = self.orderId;
            //订单号
            myOrderVC.orderNumber = self.orderSn;
            
            [self.navigationController pushViewController:myOrderVC animated:YES];
            
        }else{
            
            UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            
            SBMyOrderTableviewController * myOrderVC =  (SBMyOrderTableviewController *)[storybord instantiateViewControllerWithIdentifier:@"SBMyOrderTableviewController"];
            myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
            
            myOrderVC.orderId = self.orderId;
            //订单类型，线下订单
            myOrderVC.orderType = 2;
            //订单号
            myOrderVC.orderNumber = self.orderSn;
            
            [self.navigationController pushViewController:myOrderVC animated:YES];
        
    }
    
    }else{
        
        [self uploadOrderData];
    }


}
-(void)uploadOrderData{
    
    __weak typeof(self)weakself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    
    NSMutableString * goodsID = [NSMutableString string];
    
    for (int i = 0; i< self.ImageArray.count; i++) {
        
        GroupGoodsMOdel * model  = self.ImageArray[i];
        
        [goodsID appendString:[NSString stringWithFormat:@"%@,",model.goods_id]];
        
    }
    if (goodsID.length) {
        
    [goodsID deleteCharactersInRange:NSMakeRange([goodsID length]-1, 1)];
        
    }

    param[@"goodsCartID"] = _goodsCartId;
    
    param[@"remarks"] = _textView.text;
    
    param[@"storeCartId"] =_storeCartId;

    
    [self POST:app_save_line_orderUrl parameters:param success:^(id responseObject) {
        
        NSString * str = responseObject[@"isSucc"];
        weakself.orderId = responseObject[@"result"][@"orderId"];
        weakself.orderSn = responseObject[@"result"][@"order"];
        
        if ([str integerValue] == 1) {
            
          CGFloat  totalMoney = [_amountMoney floatValue];
                
            if (totalMoney >= 150 && [User defalutManager].redPacket > 0 ) {
                
                UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                MyOrderTableViewController * myOrderVC =  (MyOrderTableViewController *)[storybord instantiateViewControllerWithIdentifier:@"MyOrderTableViewController"];
                myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
                //订单类型,线下订单
                myOrderVC.orderType = 2;
                
                myOrderVC.orderId = weakself.orderId;
                //订单号
                myOrderVC.orderNumber = weakself.orderSn;
                
                [weakself.navigationController pushViewController:myOrderVC animated:YES];
                
            }else{
                
                UIStoryboard * storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                SBMyOrderTableviewController * myOrderVC =  (SBMyOrderTableviewController *)[storybord instantiateViewControllerWithIdentifier:@"SBMyOrderTableviewController"];
                myOrderVC.orderPrice =[NSString stringWithFormat:@"%.2f", totalMoney];
                
                myOrderVC.orderId = weakself.orderId;
                //订单类型，线下订单
                myOrderVC.orderType = 2;
                //订单号
                myOrderVC.orderNumber = weakself.orderSn;
                
                [weakself.navigationController pushViewController:myOrderVC animated:YES];
            }
        }

    } failure:^(NSError *error) {
        
        
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        UITableViewCell * cell =[[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        
      _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        [_phoneField setKeyboardType:UIKeyboardTypePhonePad];
        
        _phoneField.backgroundColor = [UIColor whiteColor];
        InsetLabel * label = [[InsetLabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        label.text = @"   手机号:";
        label.font = [UIFont systemFontOfSize:15];
        [_phoneField setLeftViewMode:UITextFieldViewModeAlways];
        
        _phoneField.leftView = label;
        [_phoneField setPlaceholder:@"请输入手机号码"];
        _phoneField.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:_phoneField];
        _phoneField.text = self.userMobile;
        _phoneField.enabled = NO;
        return cell;
    }else if (indexPath.section == 1){
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = NO;
        UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 60, 10, 60, 20)];
        countLabel.textAlignment = 2;
        countLabel.center = CGPointMake(ScreenW - 50, 45);
        countLabel.textColor = [UIColor colorWithHexString:WordLightColor];
        
        countLabel.font = [UIFont systemFontOfSize:14];
        
        countLabel.text = [NSString stringWithFormat:@"共%ld件",self.ImageArray.count];
        
        [cell.contentView addSubview:countLabel];
        
        UIImageView * nextImageView =[[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 22, 10, 8, 8)];
        nextImageView.center = CGPointMake(ScreenW - 10, 45);
        [nextImageView setImage:[UIImage imageNamed:@"icon_address_right_arrow@2x"]];
        [cell.contentView addSubview:nextImageView];
        
        for (int i = 0; i < self.ImageArray.count; i++) {
            
            GroupGoodsMOdel * goodModel = self.ImageArray[i];
            
            CGFloat imageViewW = 70;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (imageViewW +10) *i, 10 , imageViewW, imageViewW)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 4;
            [cell.contentView addSubview:imageView];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:goodModel.img] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
            if (i>= 2) {
                
            imageView.hidden = YES;
            }
        }
        //分割线
        UIView * sptString = [[UIView alloc] initWithFrame:CGRectMake(0, 89, ScreenW , 1)];
        sptString.backgroundColor = [UIColor colorWithHexString:BackColor];
        
        [cell.contentView addSubview:sptString];
        
        //消费金额
        UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 20)];
        priceLabel.text = @"消费金额:";
        priceLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:priceLabel];
        
        UILabel * moneyLabel =[[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 110, 100, 100, 20)];
        
        moneyLabel.textAlignment = 2;
        moneyLabel.font = [UIFont systemFontOfSize:15];
      
        moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_amountMoney floatValue]];
        
        moneyLabel.textColor = [UIColor colorWithHexString:MainColor];
        [cell.contentView addSubview:moneyLabel];
        
        return cell;
    }else{
        
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        
        _textView =[[HaiDuiTextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
        [_textView setMyPlaceholder:@"备注信息"];
        _textView.delegate = self;
        
        [cell.contentView addSubview:_textView];
        return cell;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        
        return 130;
    
    }else {
        return 120;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        [self jumpGoodsListVC];
    }
}
#pragma mark ---商品列表
-(void)jumpGoodsListVC{
    
    GoodsLIstViewController * goodListVC = [[GoodsLIstViewController alloc] init];
    //线下商品
    goodListVC.goodsType = 1;
    goodListVC.goodsCount = _goodsCount;
    
    for ( GroupGoodsMOdel * goodModel in self.ImageArray) {
        
        [goodListVC.goodsModelArray addObject:goodModel];
    }
    
    [self.navigationController pushViewController:goodListVC animated:YES];
    
}
#pragma mark ---uitextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.tableView.contentOffset = CGPointMake(0, 100);
        
    }];
}


@end
