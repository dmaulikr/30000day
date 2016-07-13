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
    
//    NSString *urlString = [NSString stringWithFormat:@"%@?tool=alipay&plat=iOS&order_no=%@&product_name=%@&order_price=%@",
//                           WX_SP_URL,
//                           orderID,
//                           [goodTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                           price];
//    NSError *error;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    if ( response != nil) {
//
//        NSMutableDictionary *dict = NULL;
//        
//        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        
//        if(dict != nil) {
//            
//            NSMutableString *retcode = [dict objectForKey:@"retcode"];
//            
//            if (retcode.intValue == 0) {
//                
//                /*============================================================================*/
//                /*=======================需要填写商户app申请的===================================*/
//                /*============================================================================*/
//                NSString *partner = @"2088221626849093";
//                
//                NSString *seller = @"hr@countdaystech.com";
//                
//                NSString *notifyurl = @"http://www.17dong.com.cn/api/v2.0/payment/notify";
//                
//                NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMIc797RW76UmjfwVrRZonJb4+FHgqOQoqSeTsIFGujqg/UFGyH4o+EuS7FT1iSwbw8+3cv1eILivacoZW6Lroq2n4WIrF3TCRj8oKX96PeFKXY0dFhLt0wGhSL+RSb4LsGu1or7WSJ7nihbo+h6ksjD5NkXzL6vuT96L/o7tQmjAgMBAAECgYA7sZ5qjUODdjt+3GAtkisMtAl+K/mWx1HdAfoCXIOMASKXZPyVE9uB0jTg0YFXQxLEQ3b90/09cvETyK54smf4IiFS75oUfkGnXhK0UPX9cXAQEgYf42UbORmG8s7OAgSPzmy93akRyuwmFbzfA2efEcGK5ZPky5V5LvB0ciGu4QJBAP63v5qqMBDWUTOkPAPZokqb6v14Mqae9e5VpbsF9f1ku3zjXkdqOJsKXlpiL+IKCx9DaUopl3amNJB4hUEqNnsCQQDDFxaGrQwk8X70Ri7w9hNpyTMV+2/U8b070X4SRTOpfOYSSgDMickhj/20S3EAtZ/ThPM7OMfCiLs9U7olumT5AkBBYXznAEQyLjDNppxZCKXlrLvWr+GgbzEFKirOJKuNjSuq1NnATv2Unka1wHo19QoBzlXaWW6tX+AiLS1XGrS9AkBvuZ0w65F05sip5Delz4c2of8bq69T6E1TIJpupCr9+YVZHABxIseI7QmCY2IH4fvyCsWxOMdN5Tg12ulUCfchAkEAgdMdGrqpicF0YGzL4kYoUXwbUaLfjdhgJxFEFi24CbrIHT6YWQ3lw4lBYlxOZtAqN5v/eLGDFRLZwNZCPSH0oA==";
//                /*============================================================================*/
//                /*============================================================================*/
//                /*============================================================================*/
//                
//                //将商品信息赋予AlixPayOrder的成员变量
//                Order *order = [[Order alloc] init];
//                
//                order.partner = partner;
//                
//                order.seller = seller;
//                
//                order.tradeNO = orderID;
//                
//                order.productName = goodTitle;
//                
//                order.productDescription = goodTitle; //商品描述
//                
//                order.amount = price;
//                
//                order.notifyURL =  notifyurl; //回调URL
//                
//                order.service = @"mobile.securitypay.pay";
//                
//                order.paymentType = @"1";
//                
//                order.inputCharset = @"utf-8";
//                
//                order.itBPay = @"30m";
//                
//                order.showUrl = @"m.alipay.com";
//                
//                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//                NSString *appScheme = WX_APP_ID;
//                
//                //将商品信息拼接成字符串
//                NSString *orderSpec = [order description];
//                
//                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//                id<DataSigner> signer = CreateRSADataSigner(privateKey);
//                
//                NSString *signedString = [signer signString:orderSpec];
//                
//                //将签名成功字符串格式化为订单字符串,请严格按照该格式
//                NSString *orderString = nil;
//                
//                if (signedString != nil) {
//                    
//                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
//                    
//                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                        
//                        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
//                        
//                        if ([self.delegate respondsToSelector:@selector(resultStatus:)]) {
//                            
//                            [self.delegate resultStatus:resultStatus];
//                        }
//                    }];
//                    
//                } else {
//                    
//                    [self alert:@"提示信息" msg:@"支付失败，签名信息错误"];
//                }
//                
//            } else {
//                
//                [self alert:@"提示信息" msg:dict[@"errormsg"]];//原来是这个:服务器返回错误，RETCODE 不为零
//            }
//            
//        } else {
//            
//            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到 JSON 对象"];
//        }
//        
//    } else {
//        
//        [self alert:@"提示信息" msg:@"服务器返回错误"];
//    }
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088221626849093";
    
    NSString *seller = @"hr@countdaystech.com";
    
    NSString *notifyurl = [NSString stringWithFormat:@"%@%@",ST_API_SERVER,ASYNCNOTIFY];
    
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMIc797RW76UmjfwVrRZonJb4+FHgqOQoqSeTsIFGujqg/UFGyH4o+EuS7FT1iSwbw8+3cv1eILivacoZW6Lroq2n4WIrF3TCRj8oKX96PeFKXY0dFhLt0wGhSL+RSb4LsGu1or7WSJ7nihbo+h6ksjD5NkXzL6vuT96L/o7tQmjAgMBAAECgYA7sZ5qjUODdjt+3GAtkisMtAl+K/mWx1HdAfoCXIOMASKXZPyVE9uB0jTg0YFXQxLEQ3b90/09cvETyK54smf4IiFS75oUfkGnXhK0UPX9cXAQEgYf42UbORmG8s7OAgSPzmy93akRyuwmFbzfA2efEcGK5ZPky5V5LvB0ciGu4QJBAP63v5qqMBDWUTOkPAPZokqb6v14Mqae9e5VpbsF9f1ku3zjXkdqOJsKXlpiL+IKCx9DaUopl3amNJB4hUEqNnsCQQDDFxaGrQwk8X70Ri7w9hNpyTMV+2/U8b070X4SRTOpfOYSSgDMickhj/20S3EAtZ/ThPM7OMfCiLs9U7olumT5AkBBYXznAEQyLjDNppxZCKXlrLvWr+GgbzEFKirOJKuNjSuq1NnATv2Unka1wHo19QoBzlXaWW6tX+AiLS1XGrS9AkBvuZ0w65F05sip5Delz4c2of8bq69T6E1TIJpupCr9+YVZHABxIseI7QmCY2IH4fvyCsWxOMdN5Tg12ulUCfchAkEAgdMdGrqpicF0YGzL4kYoUXwbUaLfjdhgJxFEFi24CbrIHT6YWQ3lw4lBYlxOZtAqN5v/eLGDFRLZwNZCPSH0oA==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
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
    NSString *appScheme = @"wb3403884903";
    
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

- (void)payByWechatWithOrderID:(NSString *)out_trade_no goodTtitle:(NSString *)goodTitle goodPrice:(NSString *)price {
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
