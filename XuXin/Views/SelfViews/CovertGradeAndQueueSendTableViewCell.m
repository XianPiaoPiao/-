//
//  CovertGradeAndQueueSendTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "CovertGradeAndQueueSendTableViewCell.h"

@implementation CovertGradeAndQueueSendTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.checkTransportBtn.layer.cornerRadius = 3;
    self.checkTransportBtn.layer.borderColor = [UIColor colorWithHexString:@"a5a5a5"].CGColor;
    self.checkTransportBtn.layer.borderWidth = 1;
    self.sureRecieveGoodsBtn.layer.cornerRadius = 3;
    

}
-(void)setModel:(convertDetailModel *)model{
    
    _model = model;
    //判读快递方式
    if (model.transport == 1 && model.status == haveDoneSend ) {
        
        _checkTransportBtn.hidden = NO;
        
    }else if (model.transport == 1 && model.status == haveReceived){
        
        _checkTransportBtn.hidden = NO;
    }
    else{
        
        _checkTransportBtn.hidden = YES;
        
    }
        //判断收货状态
    
    if( model.status == haveDoneSend){
        
        _sureRecieveGoodsBtn.hidden = NO;
        
        _payQuklyFeeBtn.hidden = YES;
        _payOrderBtn.hidden = YES;
        _cancelOrderBtn.hidden = YES;
        _deleteOrderBtn.hidden = YES;
        
    } else {
        
        _sureRecieveGoodsBtn.hidden = YES;
        //待发货
        if (model.status == waitSendGoods ) {
            
            _payQuklyFeeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 105, 80, 28)];
            
            [_payQuklyFeeBtn setTitle:@"继续支付" forState:UIControlStateNormal];
            [_payQuklyFeeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_payQuklyFeeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _payQuklyFeeBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _payQuklyFeeBtn.layer.cornerRadius = 3;
            [self.contentView addSubview:_payQuklyFeeBtn];
            
            //取消订单
            _cancelOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 180, 105, 80, 28)];
            
            [_cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_cancelOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _cancelOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _cancelOrderBtn.layer.cornerRadius = 3;
            [self.contentView addSubview:_cancelOrderBtn];
            
        } else if (model.status == waitPayCashType) {
            
            _payQuklyFeeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 105, 80, 28)];
            
            [_payQuklyFeeBtn setTitle:@"继续支付" forState:UIControlStateNormal];
            [_payQuklyFeeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_payQuklyFeeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _payQuklyFeeBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _payQuklyFeeBtn.layer.cornerRadius = 3;
            [self.contentView addSubview:_payQuklyFeeBtn];
            
            //取消订单
            _cancelOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 180, 105, 80, 28)];
            
            [_cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_cancelOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _cancelOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _cancelOrderBtn.layer.cornerRadius = 3;
            [self.contentView addSubview:_cancelOrderBtn];
        } else if (model.status == waitSend || model.status == sellerRejectGoods || model.status == waitSendIntergralGoods) {
            //取消订单
            _cancelOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 105, 80, 28)];
            
            [_cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_cancelOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            _cancelOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _cancelOrderBtn.layer.cornerRadius = 3;
            [self.contentView addSubview:_cancelOrderBtn];
        } else  if (model.status == waitPayType) {
            
            _payOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 105, 80, 28)];
            
            [_payOrderBtn setTitle:@"再次支付" forState:UIControlStateNormal];
            [_payOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_payOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _payOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _payOrderBtn.layer.cornerRadius = 3;
            [self.contentView addSubview:_payOrderBtn];
           //取消订单
            _cancelOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 180, 105, 80, 28)];
           
            [_cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_cancelOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [_cancelOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           
            _cancelOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
            _cancelOrderBtn.layer.cornerRadius = 3;
           [self.contentView addSubview:_cancelOrderBtn];
           
        }else if (model.status == cancelType || model.status == cancelIntegralType){
            
            if (model) {
                _deleteOrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 90, 105, 80, 28)];
                
                [_deleteOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                [_deleteOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [_deleteOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _deleteOrderBtn.backgroundColor = [UIColor colorWithHexString:MainColor];
                _deleteOrderBtn.layer.cornerRadius = 3;
                [self.contentView addSubview:_deleteOrderBtn];
            }
        }

        
    }
    
    _goodsPointLabel.text =[NSString stringWithFormat:@"%ld积分", (long)model.totalIntegral];
    
    _sendPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.trans_fee];
    
    _cashLabel.text = [NSString stringWithFormat:@"￥%.2f",model.totalCash];
}
-(void)layoutSubviews{
    
    //判断收货状态
    if( _model.status == haveDoneSend){
        
        self.rightConstant.constant = 90;
        
    } else {
        
        self.rightConstant.constant = 10;

    }
    
    [super layoutSubviews];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
