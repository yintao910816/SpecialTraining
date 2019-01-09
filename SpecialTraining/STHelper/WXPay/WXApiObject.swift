//
//  WXApiObject.swift
//  SpecialTraining
//
//  Created by yintao on 2019/1/9.
//  Copyright © 2019 youpeixun. All rights reserved.
//

import Foundation
/*
 /*! @brief 第三方向微信终端发起支付的消息结构体
 *
 *  第三方向微信终端发起支付的消息结构体，微信终端处理后会向第三方返回处理结果
 * @see PayResp
 */
 @interface PayReq : BaseReq
 
 /** 商家向财付通申请的商家id */
 @property (nonatomic, retain) NSString *partnerId;
 /** 预支付订单 */
 @property (nonatomic, retain) NSString *prepayId;
 /** 随机串，防重发 */
 @property (nonatomic, retain) NSString *nonceStr;
 /** 时间戳，防重发 */
 @property (nonatomic, assign) UInt32 timeStamp;
 /** 商家根据财付通文档填写的数据和签名 */
 @property (nonatomic, retain) NSString *package;
 /** 商家根据微信开放平台文档对数据做的签名 */
 @property (nonatomic, retain) NSString *sign;
 
 @end

 */

class PayReq {
    
}
