//
//  define.h
//  XuXin
//
//  Created by xuxin on 16/8/10.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#ifndef define_h
#define define_h
typedef NS_ENUM(NSInteger, OrderStatusType){
    cancelIntegralType = -1,
    cancelType = 0,
    waitPayType = 10,
    waitSendGoods = 11,
    waitPayCashType = 12,
    waitLinedType = 15,
    goodsHavePayAndWaitSendGoos = 16,
    waitSend = 20,
    haveDoneSend = 30,
    haveReceived = 40,
    haveUsedType = 41,
    //申请退款
    returnMoney = 44,
    //申请退货
    buyerend = 45,
    
    returnGoodsType = 46,
    returnGoodsCompete = 47,
    sellerRejectGoods =48,
    regectFail =49,
    commented =50,
    writeRetureGoodsStutes = 64,
    returnMoneyType = 51,
    haveDone = 60,
    compeleted = 65,
    
    waitSendIntergralGoods = 70,
};
typedef NS_ENUM(NSInteger, htmlType){
    supendHtmlType = 1,
    balaceHtmlType = 2,
    pointHtmlType = 3,
    delegateHtmlType = 4,
    redWalletHtmlType = 5,
    activiteHtmlType = 6,
    couponRulerType = 7,
    registrAgreementType = 8,
    joinType = 9,
};
typedef NS_ENUM(NSInteger, recomondType){
    recomondFriendsType = 1,
    recomondStoresType = 2,
   
};
//推荐朋友类型
typedef NS_ENUM(NSInteger, recomondFriendsAndChampionType){
    recomondDayType = 1,
    recomondWeekType = 2,
    recomondMonthType = 3,
    championDayType = 4,
    championrecomondWeekType = 5,
    championrecomondMOnthType = 6,
};
//二维码类型
typedef NS_ENUM(NSInteger, CodeType) {
    
    registerType = 1,
    
    forgetPassWordType = 2,
    
    changePasswordType = 3,
    
    addBankCardType = 4,
    
    unBankCardType = 5,
};
//名片
typedef NS_ENUM(NSInteger, cardType) {
    ///1:编辑状态;0:阅读状态;2:修改状态
    readType = 0,
    createType = 1,
    updateType = 2,
};
typedef NS_ENUM(NSInteger, objectType) {
    friendType = 0,
    selfType = 1,
};
//Introduction
typedef NS_ENUM(NSInteger, introductionType) {
    //0 产品 1 新闻 2 招商
    productType = 3,
    theNewsType = 1,
    merchantsType = 2,
};

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define ScreenScale [UIScreen mainScreen].bounds.size.height/667.0f
#define StatusBarFrame [[UIApplication sharedApplication] statusBarFrame]

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//导航栏高度
#define KNAV_TOOL_HEIGHT kDevice_Is_iPhoneX ? 88.0f : 64.0f
#define KTABBAR_TOOL_HEIGHT kDevice_Is_iPhoneX ? 83.0f :49.0f
//友盟分享AppKey
static  NSString * const UMSocialAppKey = @"74af39d6a26353ee893126fe8bfc71c4";

//颜色
#define MainColor @"ed6721"
#define BackColor @"efefef"
#define  WordColor @"#333333"
#define  WordDeepColor @"#666666"
#define  WordLightColor @"#999999"
//字号大小
#define W1 16
#define W2 14
#define W3 12
#define buttonTag 100
//背景图片
#define HaiduiBgImage @"shangjia_moren"
#define BigbgImage @"shangjia_moren"
#define SqureBgImage @"shangpin_moren"


//用户默认图片
#define HaiduiUserImage @"the_charts_tx"

#define WEAK  @weakify(self);
#define STRONG  @strongify(self);
#endif /* define_h */
