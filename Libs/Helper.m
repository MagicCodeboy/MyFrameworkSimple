//
//  Helper.m
//  MyFramework
//
//  Created by lalala on 2017/10/23.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height{
    NSDictionary * dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}
+ (CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width{
    NSDictionary * dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}
#pragma mark -- 获取当前的日期： 年 月  日 --
+ (NSDictionary * )getTodayDate{
    //获取今天的日期
    NSDate * today = [NSDate date];
    //使用日历类 比较耗内存
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay;
    NSDateComponents * components = [calendar components:unit fromDate:today];
    NSString * year = [NSString stringWithFormat:@"%ld",(long)components.year];
    NSString * month = [NSString stringWithFormat:@"%ld",(long)components.month];
    NSString * day = [NSString stringWithFormat:@"%ld",(long)components.day];
    NSMutableDictionary * todayDic = [[NSMutableDictionary alloc]init];
    [todayDic setObject:year forKey:@"year"];
    [todayDic setObject:month forKey:@"month"];
    [todayDic setObject:day forKey:@"day"];
    return todayDic;
}
+(BOOL)justEmail:(NSString *)email{
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)justMobile:(NSString *)mobile{
    //手机号以13， 15，18 ,17开头，八个 \d 数字字符
    NSString * mobileRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    return [phoneTest evaluateWithObject:mobile];
}
+(BOOL)justCarNo:(NSString *)carNo{
    NSString * carRegex = @"[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate * carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}
+(BOOL)justCarType:(NSString *)CarType{
    NSString * carTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate * carTypeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carTypeRegex];
    return [carTypeTest evaluateWithObject:CarType];
}
+(BOOL)justUserName:(NSString *)name{
    NSString * userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate * userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}
+(BOOL)justPassword:(NSString *)passWord{
    NSString * passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate * passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordTest evaluateWithObject:passWord];
}
+(BOOL)justNickname:(NSString *)nickname{
    NSString * nickNameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate * nickNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNameRegex];
    return [nickNameTest evaluateWithObject:nickname];
}

@end
