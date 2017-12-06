//
//  PayWayConfig.h
//  XuXin
//
//  Created by xuxin on 16/9/19.
//  Copyright © 2016年 ChongqingWanZhongXinDa. All rights reserved.
//

#ifndef PayWayConfig_h
#define PayWayConfig_h
/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */
#define AppId @"2016092201946505"

//#define SellerID  @"2016012622380725"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANcv6r66mqXo/5hK5agrDtyiwMCQlwTF4eVSFfXHY+hmdWvl9heN+ScItUo4/hw6ZZfXAL4RV1bMzGNwHgURvk+KgaFoquyRWcyYzOd6BVcHheHGJUKx5hLlVPbkIUGMRXIC8r53WB7sbNYEwdjWQYaEjy5uGjGJWfGPJnUjD3gNAgMBAAECgYB5T2gVEfmw4oOFBWQmw+9i7tWfOWQJqszIjNgYcMmf8HLt2vw7FyyIlt4s86g9naY8TVb7z6bfJiFrRX+G+BPClovcLHVnOf7s3xh2ovU93oObXBm33UTx1HjsvvXkr+KvvU8cW5rQMAN8epVk1v2Apc0JiVdckhMj8912mcE4QQJBAPjCGZTXqEBIHteMx1XzZtMogKULY5mgl6OoJGC7zLKRxEbPr8OLjWYAtksXQPzezRrx3hetAhktI8DcsI5R0gkCQQDdc5/+YuTd0wjGRY9M6R7dyIDMCGWNgUkGbTgfEsgcdeNdmu6Wl5AT/6O8l2BDBfX9sKoNVTYislOAXknYd2blAkBGo0eEXqDmcBRh/RX1sEJ4n724ID3OOC4XSP3bgjikVIQ532v3yT8DwhwBwr6vj80KY7g/XN+Fqq3GbGSuZUmRAkEAvO9rL3RcY00rjU3HhwzVws7P5EO9sM7+6LbCTPCPPojt5OzMZjsFN6rBnaNhA43QZBMX4qwytcODLmBDjKXCaQJAJkluCBeOrizgvxLUjbhsWnTsMq4G0BM6HKLJXjK+2Ht+TnvE6g9HhLJuVbqEiICDSvmzND/6IGVGonKDWfuTrg=="


#pragma mark ----- 微信支付 -----

// appID
#define __WXappID @"wxefd2397f8a7c08e4"

// appSecret
#define __WXappSecret @"74af39d6a26353ee893126fe8bfc71c4 "

//商户号，填写商户对应参数
#define __WXmchID @"1414965702"

//商户API密钥，填写相应参数
#define __WXpaySignKey @"ayd189acW7EX52Wy7m42t4E7ovxUk41e"


#endif /* PayWayConfig_h */
