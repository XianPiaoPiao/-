//
//  API.h
//  XuXin
//
//  Created by xuxin on 16/9/8.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#ifndef API_h
#define API_h

#endif /* API_h */

#define                     Host    @"https://hiidui.com"//119.23.143.136//测试环境//@"http://192.168.1.20"//本地//@"http://192.168.1.134:80"//名片1.134//@"http://192.168.1.134:8080"//名片//@"https://hiidui.com:80"//@"http://192.168.1.105/shopping"//@"https://hidui.com.cn"//正式环境//

#define fullURL(path)       [NSString stringWithFormat:@"%@%@",Host,path]

#define baseUrl             fullURL(@"/")

#define ShopThreeMoveUrl    fullURL(@"/app/common/city_3level.htm")
#define CitySearchUrl       fullURL(@"/app/common/citys.htm")
#define VerifyCodeUrl       fullURL(@"/app/user/verifyCode.htm")
#define registerUrl         fullURL(@"/app/user/register.htm")
#define forgetUrl           fullURL(@"/app/user/forgetPwd.htm")
#define landUrl             fullURL(@"/app/user/login.htm")
#define storeListUrl        fullURL(@"/app/store/storeList.htm")
#define shopCategoryUrl     fullURL(@"/app/store/storeClass.htm")
#define storeDetailUrl      fullURL(@"/app/store/storeDetail.htm")
#define countrysUrl         fullURL(@"/app/common/countrys.htm")
#define openCityListUrl     fullURL(@"/app/area/openCityList.htm")
#define updateUserUrl       fullURL(@"/app/user/updateUserInformation.htm")
#define integralGoodsUrl    fullURL(@"/app/integralGoods/goods.htm")
#define payOrderUrl         fullURL(@"/app/pay/payOrder.htm")
#define faceOrderUrl        fullURL(@"/app/order/createFace2FaceOrder.htm")
#define MainadervtsUrl      fullURL(@"/app/common/adverts.htm")
#define orderListUrl        fullURL(@"/app/order/orderList.htm")
#define integerGoodsDetailUrl fullURL(@"/app/integerGoods/integerGooodsDetail.htm")
#define integerGoodsSortUrl fullURL(@"/app/integerGoods/integerGoodsSort.htm")
#define integralGoodsCategoryUrl fullURL(@"/app/integralGoods/goods.htm")
#define addGoodsUrl         fullURL(@"/app/cart/addIntegralGoods.htm")
#define buyNowUrl           fullURL(@"/app/integral/buyNow.htm")
#define integralListUrl     fullURL(@"/app/cart/integralList.htm")
#define convertInfoUrl      fullURL(@"/app/integerGoods/convertInfo.htm")
//购物车中积分商品加减数量
#define integralGoods_adjust_countUrl fullURL(@"/app/cart/integralGoodsAdjustCount.htm")
//积分商品移除购物车
#define removeIntegralsUrl fullURL(@"/app/cart/removeIntegrals.htm")
#define myQrcodeUrl fullURL(@"/app/user/myQrcode.htm")
//积分商品根据商品ID查询规格
#define integralGoodsSpecUrl fullURL(@"/app/integralGoods/integralGoodsSpec.htm")

//用户添加收货地址
#define addAddressUrl fullURL(@"/app/address/addAddress.htm")
//默认收货地址
#define setAddressUrl fullURL(@"/app/address/setAddress.htm")
#define addressseUrl fullURL(@"/app/address/addresse.htm")
#define city_3levelUrl fullURL(@"/app/common/city_3level.htm")

#define getDefaultAddressUrl fullURL(@"/app/address/getDefaultAddress.htm")
#define batchDeleteAddressUrl fullURL(@"/app/address/batchDeleteAddress.htm")
//修改支付密码
#define updatePayPwdUrl fullURL(@"/app/user/updatePayPwd.htm")
#define createIntegralOrderUrl fullURL(@"/app/order/createIntegralOrder.htm")
#define updateAddressUrl fullURL(@"/app/address/updateAddress.htm")
#define calculateFreightUrl fullURL(@"/app/freight/calculateFreight.htm")
#define nearPickupCentersUrl fullURL(@"/app/address/nearPickupCenters.htm")
#define calculateFreightUrl fullURL(@"/app/freight/calculateFreight.htm")
#define face2faceOrderDetailUrl fullURL(@"/app/order/face2faceOrderDetail.htm")
//预充值
#define perpareChargeMoneyUrl fullURL(@"/app/pay/perpareChargeMoney.htm")
//支付宝支付快递
#define payIntegralOrderCourierUrl fullURL(@"/app/pay/payIntegralOrderCourier.htm")
//余额支付快递
#define payIntegralOrderCourierByBalanceUrl fullURL(@"/app/pay/payIntegralOrderCourierByBalance.htm")
//微信支付快递
#define payIntegralOrderWeChatUrl fullURL(@"/app/pay/payIntegralOrderWeChat.htm")
//兑换订单详情
#define integralOrderDetailUrl fullURL(@"/app/order/integralOrderDetail.htm")
#define addFavoriteGoodsAndStoreUrl fullURL(@"/app/userFavorite/addFavoriteGoodsAndStore.htm")
//多个商品收藏
#define batchAddFavoriteUrl fullURL(@"/app/userFavorite/batchAddFavorite.htm")
#define goodsAndStoreFavoriteUrl fullURL(@"/app/userFavorite/goodsAndStoreFavorite.htm")
#define activateRedPacketUrl fullURL(@"/app/redPacket/activateRedPacket.htm")
#define redPacketUrl fullURL(@"/app/redPacket/redPacket.htm")
//红包列表1.0版本
#define findUserRedPacketUrl fullURL(@"/app/redPacket/findUserRedPacket.htm")
#define batchDeleteGoodsUrl fullURL(@"/app/userFavorite/batchDeleteGoods.htm")
//推荐朋友排行榜
#define recommendUserRankingUrl fullURL(@"/app/recommend/recommendUserRanking.htm")
#define userChampionRankingUrl fullURL(@"/app/rank/userRanking.htm")
#define recommendUserChampionRankingUrl fullURL(@"/app/recommend/recommendUserChampionRanking.htm")
#define queryRankingUrl fullURL(@"/app/queryRanking.htm")
#define integerGooodsDetailUrl fullURL(@"/app/integerGoods/integerGooodsDetail.htm")
//我的我二维码和我的推荐列表
#define myRecommendUserUrl fullURL(@"/app/user/myRecommendUser.htm")
//我的兑换券
#define couponListUrl fullURL(@"/app/user/couponList.htm")
//更多推荐商品
#define moreRecommendUrl fullURL(@"/app/integralGoods/moreRecommend.htm")
//添加银行卡
#define bindBankCardUrl fullURL(@"/app/wallet/bindBankCard.htm")
#define myWalletUrl fullURL(@"/app/wallet/myWallet.htm")
#define bankListUrl fullURL(@"/app/wallet/bankList.htm")
#define myBindBankListUrl fullURL(@"/app/wallet/myBindBankList.htm")
#define unbindBankCardUrl fullURL(@"/app/wallet/unbindBankCard.htm")
#define createPreChargeOrderUrl fullURL(@"/app/wallet/createPreChargeOrder.htm")
#define listIntegralUrl fullURL(@"/app/integral/list.htm")
#define listBalanceUrl fullURL(@"/app/balance/list.htm")
#define chargeListUrl fullURL(@"/app/wallet/preCharge/chargeList.htm")
#define searcheStoreCouponUrl fullURL(@"/app/searche/searcheStoreCoupon.htm")
#define addCouponUrl fullURL(@"/app/coupon/addCoupon.htm")
#define updateUserInformationUrl fullURL(@"/app/user/updateUserInformation.htm")
#define selectMoreStoreUrl fullURL(@"/app/store/selectMoreStore.htm")
#define createGetCrashOrderUrl fullURL(@"/app/balance/createGetCrashOrder.htm")
//兑换轮播图
#define advertsUrl fullURL(@"/app/common/adverts.htm")
#define listCouponUrl fullURL(@"/app/coupon/listCoupon.htm")
#define userListCouponUrl fullURL(@"/app/coupon/userListCoupon.htm")
#define getValueOfCouponUrl fullURL(@"/app/coupon/getValueOfCoupon.htm")
#define homeAppListCouponUrl fullURL(@"/app/coupon/appHomeListCoupon.htm")
//买单说明
#define payExplainHtmlUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/bay_payExplain.html")
//兑换券
#define couponRuleHtmUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/exchange_Coupon_rule.html")
//余额
#define walletBalanceHtmUrl  fullURL(@"/wap/helpDocument.htm?html=helpDocument/money_wallet_balance.html")
//积分
#define intergarlHtmUrl  fullURL(@"/wap/helpDocument.htm?html=helpDocument/money_wallet_integral.html")
//预充值
#define Pre_depositHtmUrl  fullURL(@"/wap/helpDocument.htm?html=helpDocument/money_wallet_Pre_deposit.html")
//钱包说明
#define redBag_explainHtmlUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/redBag_explain.html")
//红包说明
#define redBag_ruleHtml fullURL(@"/wap/helpDocument.htm?html=helpDocument/redBag_rule.html")
#define registrAgreementUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/registrAgreement.html")
//我要代理
#define agreementHtmUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/agreement.html")
//我要加盟
#define joinHtmlUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/join.html")
#define ywywHtmlUrl fullURL(@"/wap/helpDocument.htm?html=helpDocument/ywyw.html")
//推荐商家
#define recommendStoreKempRankUrl fullURL(@"/app/recommendStoreRank/recommendStoreKempRank.htm")
//推荐商家排行榜
#define recommendStoreRankUrl  fullURL(@"/app/recommendStoreRank/recommendStoreRank.htm")
//我的推荐商家
#define userRecommendStoreUrl fullURL(@"/app/recommend/recommend_store.htm")
//图文详情
#define tuwenxiangqinghtml fullURL(@"/wap/helpDocument.htm?html=helpDocument/tuwenxiangqing.html")
//店铺详情
#define store_by_IDUrl fullURL(@"/wap/wap_store_by_ID.htm")
//线上线下商品详情
#define wapGoodsByIdUrl fullURL(@"/wap/wapGoodsById.htm")
//积分商品详情
#define integralByIdhtmUrl fullURL(@"/wap/integralById.htm")

#define scanRegisterUrl fullURL(@"/wap/register.htm")

#define ig_contentUrl fullURL(@"/app/integralGoods/ig_content.htm")
#define wydlmp3Url fullURL(@"/resources/audio/wydl.mp3")
#define storeClassUrl fullURL(@"/app/store/storeClass.htm")
#define appWeChatEagleUrl fullURL(@"/app/wallet/appFaceOrderWeChatEagle.htm")
#define moreExchangeGoodsUrl fullURL(@"/app/integralGoods/moreExchangeGoods.htm")
//支付快递费
#define paypwdwordcheckUrl fullURL(@"/app/buyer/paypwdwordcheck.htm")
//附近商家
#define aroundStoreListUrl fullURL(@"/app/store/aroundStoreList.htm")
//
#define getUserInfoUrl fullURL(@"/app/user/getUserInfo.htm")
#define findAreaByNameUrl fullURL(@"/app/area/findAreaByName.htm")
#define updatePwdUrl fullURL(@"/app/user/updatePwd.htm")
//我要加盟
#define save_storeUrl fullURL(@"/app/save_store.htm")
#define saveStoreAndUserUrl fullURL(@"/app/saveStoreAndUser.htm")
#define app_testPngUrl fullURL(@"/saveAccessorybystore.htm")
#define getUserOrStore_StatusUrl fullURL(@"/app/getUserOrStore_Status.htm")
#define save_feedback_userUrl fullURL(@"/app/feedback/save_feedback_user.htm")
#define loginOutUrl fullURL(@"/app/user/loginOut.htm")
#define storeCommonAndGroupGoodsUrl fullURL(@"/app/store/storeCommonAndGroupGoods.htm")
//余额明细
#define balanceListUrl fullURL(@"/app/balance/list.htm")
#define findUserNameByIdUrl fullURL(@"/app/user/findUserNameById.htm")
#define checkKuaidi_detailUrl fullURL(@"/app/common/kuaidi_detail.htm")
#define ReturnGoodskuaidiUrl fullURL(@"/app/findOrderFormReturnGoodskuaidi.htm")
//确认收货
#define confirmRecepUrl fullURL(@"/app/confirmReceipt.htm")

#define OnloneConfirmRecepUrl fullURL(@"/app/OnLineConfirmReceipt.htm")
//消息列表
#define msgListUrl fullURL(@"/app/msgList.htm")
#define uploadUPushInformationUrl fullURL(@"/app/uploadUPushInformation.htm")
#define gooodsDetailUrl fullURL(@"/app/goods/gooodsDetail.htm")
#define buy_now_orderUrl fullURL(@"/app/buy_now_order.htm")
#define graphicDetailsUrl fullURL(@"/app/goods/graphicDetails.htm")

#define findOrderByTypeUrl fullURL(@"/app/findOrderByType.htm")
#define findOrderDetailsByIdUrl fullURL(@"/app/findOrderDetailsById.htm")
#define app_save_onLine_orderUrl fullURL(@"/app/app_save_onLine_order.htm")
#define app_save_line_orderUrl fullURL(@"/app/app_save_line_order.htm")
//#define getAreaByParentIdUrl fullURL(@"/app/common/getAreaByParentId.htm")
#define appCancellationOfOrderUrl fullURL(@"/app/appCancellationOfOrder.htm")
#define goodsSpecUrl fullURL(@"/app/goods/goodsSpec.htm")
#define evaluateUrl fullURL(@"/app/evaluate/evaluate.htm")
#define freightcalculationUrl fullURL(@"/wap/freightcalculation.htm")
#define add_goodsCart_storeCartUrl fullURL(@"/app/add_goodsCart_storeCart.htm")
#define appFindCartByTypeUrl fullURL(@"/app/appFindCartByType.htm")
#define delectCartByGoodsCartIdUrl fullURL(@"/app/delectCartByGoodsCartId.htm")
#define batchAddFavoriteUrl fullURL(@"/app/userFavorite/batchAddFavorite.htm")
#define lineoutlinePayOrderUrl fullURL(@"/app/lineoutline/payOrder.htm")
//搜索线上商家商品
#define goodsAndStoreListUrl fullURL(@"/app/home/goodsAndStoreList.htm")
#define appCancellationOfOrderUrl fullURL(@"/app/appCancellationOfOrder.htm")
#define updateCartCountUrl fullURL(@"/app/updateCartCount.htm")
#define goodsListUrl fullURL(@"/app/goods/goodsList.htm")
#define onlineGoodsClassUrl fullURL(@"/app/goods/onlineGoodsClass.htm")
#define face_two_faceUrl fullURL(@"/app/app_order_evaluate_save_by_face_two_face.htm")
#define cancelFace2FaceUrl fullURL(@"/app/order/cancelFace2Face.htm")
//订单删除
#define appdelectOrderUrl fullURL(@"/app/appdelectOrder.htm")
#define appOrderFormKuaidi_detailUrl fullURL(@"/app/appOrderFormKuaidi_detail.htm")
//店铺全部评价
#define appStoreEvaluateListUrl fullURL(@"/app/appStoreEvaluateList.htm")
#define appGoodsEvaluateListUrl fullURL(@"/app/appGoodsEvaluateList.htm")

#define appLineApplyForRefundUrl fullURL(@"/app/appLineApplyForRefund.htm")
#define appOnLineApplyForRefundUrl fullURL(@"/app/appOnLineApplyForRefund.htm")
#define appReturnLogisticsUrl fullURL(@"/app/appReturnLogistics.htm")
#define appSaveReturnLogisticsUrl fullURL(@"/app/appSaveReturnLogistics.htm")
#define appHomeNavigationUrl fullURL(@"/app/appHomeNavigation.htm")
#define recommendGooodsUrl fullURL(@"/app/goods/recommendGooods.htm")
#define findQRcodeUrl fullURL(@"/app/findQRcode.htm")
//申请退款
#define appOnLineApplyForMoneyUrl fullURL(@"/app/appOnLineApplyForMoney.htm")
#define moreGoodsListUrl fullURL(@"/app/goods/moreGoodsList.htm")
#define creatPreChargeOderUrl fullURL(@"/app/wallet/createPreChargeOrder.htm")
#define balancePayShopcoinUrl fullURL(@"/app/wallet/balancePayShopcoin.htm")
//
#define home_AgentHtml fullURL(@"/wap/helpDocument.htm?html=whole/App_home_agent_Agent.html")
#define blanceStoreCategoryUrl fullURL(@"/app/balance/findBalanceDetailStatus.htm")

/// 新增或者修改名片 POST
#define saveUserCardUrl fullURL(@"/wap/saveUserCard.htm")
/// 根据名片ID查询名片	POST
#define findMyUserCardUrl fullURL(@"/wap/findMyUserCard.htm")
/// 根据填写的内容搜索名片	POST
#define findUserCardByConditionUrl fullURL(@"/wap/findUserCardByCondition.htm")
/// 删除好友或者添加好友	POST
#define deleteBuddyUrl fullURL(@"/wap/deleteBuddy.htm")
/// 我的好友	POST
#define findMyFriendsUrl fullURL(@"/wap/findMyFriends.htm")
/// 修改个人介绍或者公司介绍	POST
#define revisedIntroductionUrl fullURL(@"/wap/revisedIntroduction.htm")
/// 新增或者保存新闻、产品、招商	POST
#define updateIntroductionsUrl fullURL(@"/wap/updateIntroductions.htm")
/// 根据名片ID查询该名片的新闻、产品、招商列表	POST
#define findCardContentListUrl fullURL(@"/wap/findCardContentList.htm")
/// 根据ID查询新闻、产品、招商	POST
#define findCardContentByIDUrl fullURL(@"/wap/findCardContentByID.htm")
/// 根据ID删除新闻、产品、招商	POST
#define delectCardContentByID fullURL(@"/wap/delectCardContentByID.htm")
/// 上传新闻、产品、招商logo	POST
#define uploadAccessoryUrl fullURL(@"/common/uploadAccessory.htm")
/// 删除图片	POST
#define delectAccessoryByIdUrl fullURL(@"/delectAccessoryById.htm")
/// 富文本上传图片	POST
#define userCardUploadUrl fullURL(@"/wap/userCardUpload.htm")

//收银系统接口

//根据订单号查询订单，绑定给用户，查询用户的消费券(APP扫码)
#define userGetOrderUrl fullURL(@"/app/userGetOrder.htm")
//扫码过后支付积分（APP）
#define paymentPointsUrl fullURL(@"/app/paymentPoints.htm")
//用户使用现金支付积分订单（APP）
#define cashPaymentUrl fullURL(@"/app/cashPayment.htm")

//店铺优惠券接口

/// 查询某店铺的优惠券
#define findUnclaimedUrl fullURL(@"/findUnclaimed.htm")
/// APP线上线下立即购买和购物车购买通过storeCartId获取用户可以使用的优惠券
#define findUserCouponInfoByStoreIdUrl fullURL(@"/app/findUserCouponInfoByStoreId.htm")
/// 领取优惠券
#define sellerCouponSendSaveUrl fullURL(@"/seller/coupon_send_save.htm")
/// APP根据订单ID查询可以使用的红包列表
#define findUserRedPacketByOrderUrl fullURL(@"/app/findUserRedPacketByOrder.htm")
/// 查询当前登录用户的所有优惠券
#define findUserCouponUrl fullURL(@"/app/findUserCoupon.htm")
/// 线上线下使用优惠券红包支付1.0版本
#define lineoutlinePayOrderUsePracktUrl fullURL(@"/app/lineoutline/payOrderUsePrackt.htm")
/// 面对面支付使用优惠券红包1.0版本
#define payFace2FaceOrderUseCouponUrl fullURL(@"/app/pay/payFace2FaceOrderUseCoupon.htm")
/// 创建线上订单1.0版本（使用优惠券）
#define appSaveOnlineOrderUseCouponUrl fullURL(@"/app/app_save_onLine_order_use_coupon.htm")
/// 创建线下订单1.0版本（使用优惠券）
#define appSaveLineOrderUseCouponUrl fullURL(@"/app/app_save_line_order_use_coupon.htm")
/// 获取用户购物车商品数量(没有用过)
#define findUserCartCountUrl fullURL(@"/app/user/findUserCartCount.htm")





















