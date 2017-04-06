//
//  WRBButton.h
//  WeChat
//
//  Created by lsh on 15/8/24.
//  Copyright (c) 2015年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRBButton : UIButton
//添加点击后执行的block
// void action(ZTButton *button);
@property (copy,nonatomic) void (^action)(WRBButton *button);


@end
