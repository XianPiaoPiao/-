//
//  ConvertOrderTableViewCell.m
//  XuXin
//
//  Created by xuxin on 16/8/29.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#import "ConvertOrderTableViewCell.h"
#import "UILabel+Extension.h"

@implementation ConvertOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.orderImageView.layer.masksToBounds = YES;
//    self.orderImageView.layer.cornerRadius = 6;
   
     }
-(void)setModel:(ConvertOrderModel *)model{
    _model = model;
    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:model.firstIntegralGoodsLogo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    _orderNumberLabel.text =[NSString stringWithFormat:@"订单号: %@", model.orderSn];
    _orderDetailLabel.text = model.firstIntegralGoodsName;
    //订单状态
    
    if (model.status == cancelType) {
        _orderStateLabel.text = @"已取消";
        
    } else if (model.status == cancelIntegralType) {
        _orderStateLabel.text = @"已取消";
        
    }else if (model.status == waitPayType ){
        _orderStateLabel.text = @"待付款";
        
    }else if (model.status == waitSendGoods) {
        _orderStateLabel.text = @"待支付快递费";
        
    }else if (model.status == waitPayCashType) {
        _orderStateLabel.text = @"待支付现金";
        
    }else if (model.status == waitLinedType){
        _orderStateLabel.text = @"线下支付待审核";
    }else if (model.status == goodsHavePayAndWaitSendGoos){
        _orderStateLabel.text = @"货到付款待发货";
    }else if (model.status == waitSend){
        _orderStateLabel.text = @"待发货";
    }else if (model.status ==haveDoneSend){
        _orderStateLabel.text = @"已发货";
    }else if (model.status == haveReceived){
        _orderStateLabel.text = @"已收货";
    }else if(model.status == haveUsedType){
        _orderStateLabel.text = @"已使用";

    }else if(model.status == buyerend){
        _orderStateLabel.text = @"买家申请退货";
        
    }else if (model.status == returnMoneyType){
        
        _orderStateLabel.text = @"已退款";

    }
    else if(model.status == returnGoodsType){
        _orderStateLabel.text = @"退货中";
        
    }else if(model.status == returnGoodsCompete){
        _orderStateLabel.text = @"退货完成，已结束";
        
    }else if(model.status == sellerRejectGoods){
        _orderStateLabel.text = @"卖家拒绝退货";
        
    }else if(model.status == regectFail){
        _orderStateLabel.text = @"退货失败";
        
    }else if(model.status == commented){
        _orderStateLabel.text = @"已评价";
        
    }else if(model.status == haveDone){
        _orderStateLabel.text = @"已完成";
        
    }else if(model.status == compeleted){
        _orderStateLabel.text = @"已结束";
        
    }else if (model.status == waitSendIntergralGoods){
        
        _orderStateLabel.text = @"待发货";
    }
//         _orderNumberMuchLabel.text = [NSString stringWithFormat:@"消费积分: %ld",model.totalIntegral];
    [_orderNumberMuchLabel labelWithIntegral:model.totalIntegral money:model.totalCash];
    
}
//线上商品
-(void)setOrderModel:(OnlineOrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    _metureLabel.text = orderModel.goodsSpecifications;
    
    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.logo] placeholderImage:[UIImage imageNamed:HaiduiBgImage]];
    
    _orderNumberLabel.text =[NSString stringWithFormat:@"订单号: %@", orderModel.order_sn];
    _orderDetailLabel.text = orderModel.goodsName;
    //订单状态
    if (orderModel.status == cancelType) {
        
        _orderStateLabel.text = @"已取消";
        
    }else if (orderModel.status == waitPayType ){
        
        _orderStateLabel.text = @"待付款";
        
    }else if (orderModel.status == waitSendGoods) {
        _orderStateLabel.text = @"待支付快递费";
        
    }else if (orderModel.status == waitPayCashType) {
        _orderStateLabel.text = @"待支付现金";
        
    }else if (orderModel.status == waitLinedType){
        
        _orderStateLabel.text = @"线下支付待审核";
    }else if (orderModel.status == goodsHavePayAndWaitSendGoos){
        
        _orderStateLabel.text = @"货到付款待发货";
    }else if (orderModel.status == waitSend){
        
        _orderStateLabel.text = @"待发货";
    }else if (orderModel.status ==haveDoneSend){
        
        _orderStateLabel.text = @"已发货";
    }else if (orderModel.status == haveReceived){
        
        _orderStateLabel.text = @"已收货";
        
    }else if(orderModel.status == haveUsedType){
        
        _orderStateLabel.text = @"已消费";
        
    }else if (orderModel.status == returnMoney){
        
        _orderStateLabel.text = @"买家申请退款";

    }
    else if(orderModel.status == buyerend){
        
        _orderStateLabel.text = @"买家申请退货";
        
    }else if (orderModel.status == returnMoneyType){
        
        _orderStateLabel.text = @"已退款";
        
    }
    else if(orderModel.status == returnGoodsType){
        _orderStateLabel.text = @"退货中";
        
    }else if(orderModel.status == returnGoodsCompete){
        
        _orderStateLabel.text = @"退货完成";
        
    }else if(orderModel.status == sellerRejectGoods){
        _orderStateLabel.text = @"卖家拒绝退货";
        
    }else if(orderModel.status == regectFail){
        _orderStateLabel.text = @"退货失败";
        
    }else if(orderModel.status == commented){
        _orderStateLabel.text = @"已评价";
        
    }else if(orderModel.status == haveDone){
        _orderStateLabel.text = @"已完成";
        
    }else if(orderModel.status == compeleted){
        _orderStateLabel.text = @"已结束";
        
    }else if (orderModel.status == waitSendIntergralGoods){
        _orderStateLabel.text = @"待发货";
        
    }else if (orderModel.status == writeRetureGoodsStutes){
        
        _orderStateLabel.text = @"待填写退货物流";

    }
//    _orderNumberMuchLabel.text = [NSString stringWithFormat:@"总价: ￥%.1f     数量: %ld",orderModel.price,orderModel.count];
    _orderNumberMuchLabel.text = [NSString stringWithFormat:@"x%ld              ￥%.1f",orderModel.count,orderModel.price];
    _orderNumberMuchLabel.textColor = [UIColor redColor];//[UIColor colorWithHexString:MainColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
