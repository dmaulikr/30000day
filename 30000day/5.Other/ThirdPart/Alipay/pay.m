//
//  pay.m
//  17dong_ios
//
//  Created by win5 on 14-12-11.
//  Copyright (c) 2014年 win5. All rights reserved.
//

#import "pay.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation pay

- (void)payWithOrderID:(NSString *)orderID
          goodTtitle:(NSString *)goodTitle
           goodPrice:(NSString *)price {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?tool=alipay&plat=iOS&order_no=%@&product_name=%@&order_price=%@",
                           WX_SP_URL,
                           orderID,
                           [goodTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           price];
    NSError *error;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ( response != nil) {
        
        NSMutableDictionary *dict = NULL;
        
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        if(dict != nil) {
            
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            
            if (retcode.intValue == 0) {
                
                /*============================================================================*/
                /*=======================需要填写商户app申请的===================================*/
                /*============================================================================*/
                NSString *partner = @"2088711406433982";
                NSString *seller = @"only@win5.com.cn";
                NSString *notifyurl = @"http://www.17dong.com.cn/api/v2.0/payment/notify";
                NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMCwusUeuSWiX0USmc9wMlsOrKC6k+XvClbhOJpn2kWvE30Uq3LH6zeuIvvah1ESdb03CWepkEV+Mc3EMnxAkfNFyU6JgAW+onShU9iBhraWyoE3Al/MFclkO3DFAAYL7Mz8hjVtvnDV88ly91MolH6rlsT8vouniU0PUAFdEFMHAgMBAAECgYACFOavonlVkr98u4q11vx0R2BODDX00fRGpAA8isqs3gtT2plPkCFWZKc0GVRE5/IlrSaI3CgW2Bopouj4tqnc9iN7udGX34simD0HcD/pSsJokuYSk4w0y0jGyB5XXhoiBuEQzELahxEiMYuD5bPYCjPYYX7PM3IbdKMAgO4WAQJBAOBe1PRm9kIZYpuKm7LYrjxkzzAhTQPnWs+Og2mAS8gWZRsNGeVR5ZqOZn+vhSm1vduJ/AwilMoktJc4LjbRskECQQDb2p1FEqnVHrchZwELqSLeHxEDB5dCHPPTvvt/QEZmAb+9pJ05AIHcD5jxN1+iZhP1si2ytb8WxeWUIYlpSSNHAkBs0zJA9KuetcdRH/KS1Wv1GQQxGQXMzesK3tm4UyTugIY7j6guxQEzbLwkVFKnP2I92Hhqvl8iiJka+4HWzvDBAkAfsrhkIhm8cY5D0Z8T+FHfpqkEP87uKFB7YhjOswyzXmMvy5Eji9AtU05g0PQH7SHJleQC1TN07Bl6rw8pz/K3AkEApfJhDrCsXUwgwa7hf87S1hXMf+Hp7ycG5vmk4bLDWFntvwR3Nzep1Ig4n9J3+t0DNH1QV9G7o7phFtgey+9C9g==";
                /*============================================================================*/
                /*============================================================================*/
                /*============================================================================*/
                
                //partner和seller获取失败,提示
                if ([partner length] == 0 || [seller length] == 0) {
                    
                    [self alert:@"提示信息" msg:@"支付失败，缺少 partner 或者 seller"];
                    
                } else {
                    
                    //将商品信息赋予AlixPayOrder的成员变量
                    Order *order = [[Order alloc] init];
                    order.partner = partner;
                    order.seller = seller;
                    order.tradeNO = orderID;
                    order.productName = goodTitle;
                    order.productDescription = goodTitle; //商品描述
                    order.amount = price;
                    order.notifyURL =  notifyurl; //回调URL
                    order.service = @"mobile.securitypay.pay";
                    order.paymentType = @"1";
                    order.inputCharset = @"utf-8";
                    order.itBPay = @"30m";
                    order.showUrl = @"m.alipay.com";
                    
                    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                    NSString *appScheme = WX_APP_ID;
                    
                    //将商品信息拼接成字符串
                    NSString *orderSpec = [order description];
                    
                    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                    id<DataSigner> signer = CreateRSADataSigner(privateKey);
                    NSString *signedString = [signer signString:orderSpec];
                    
                    //将签名成功字符串格式化为订单字符串,请严格按照该格式
                    NSString *orderString = nil;
                    if (signedString != nil) {
                        
                        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                             NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                             if ([self.delegate respondsToSelector:@selector(resultStatus:)]) {
                                 
                                 [self.delegate resultStatus:resultStatus];
                             }
                         }];
                        
                    } else {
                        
                        [self alert:@"提示信息" msg:@"支付失败，签名信息错误"];
                    }
                }
            } else {
                [self alert:@"提示信息" msg:dict[@"errormsg"]];//原来是这个:服务器返回错误，RETCODE 不为零
            }
        } else {
            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到 JSON 对象"];
        }
        
    } else {
        
        [self alert:@"提示信息" msg:@"服务器返回错误"];
    }
}

-(void)payByWechatWithOrderID:(NSString *)out_trade_no goodTtitle:(NSString *)goodTitle goodPrice:(NSString *)price {
//    NSStringEncoding enc = NSUTF8StringEncoding;
//    NSString *ORDER_NAME    = goodTitle;                                                                                             // 订单标题
//    NSString *ORDER_PRICE   = [NSString stringWithFormat:@"%.0f", [price floatValue] * 100.0];  // 订单金额，单位（分） 2分 = 0.02元
//    NSString *ORDER_NO      = [out_trade_no stringByAddingPercentEscapesUsingEncoding:enc];                                          // 一起动的订单号
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@?tool=wechat&plat=iOS&order_no=%@&product_name=%@&order_price=%@",
//                           WX_SP_URL,
//                           ORDER_NO,
//                           [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
//                           ORDER_PRICE];
//    NSError *error;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if ( response != nil)
//    {
//        NSMutableDictionary *dict = NULL;
//        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        if(dict != nil)
//        {
//            NSMutableString *retcode = [dict objectForKey:@"retcode"];
//            if (retcode.intValue == 0)
//            {
//                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                //调起微信支付
//                PayReq *req             = [[PayReq alloc] init];
//                req.openID              = [dict objectForKey:@"appid"];
//                req.partnerId           = [dict objectForKey:@"partnerid"];
//                req.prepayId            = [dict objectForKey:@"prepayid"];
//                req.nonceStr            = [dict objectForKey:@"noncestr"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = [dict objectForKey:@"package"];
//                req.sign                = [dict objectForKey:@"sign"];
//                [WXApi sendReq:req];
//            }
//            else
//            {
//                [self alert:@"提示信息" msg:dict[@"errormsg"]];
//            }
//        }
//        else
//        {
//            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到 JSON 对象"];
//        }
//    }
//    else
//    {
//        [self alert:@"提示信息" msg:@"服务器返回错误"];
//    }
}

- (void)alert:(NSString *)title msg:(NSString *)msg {
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

@end
