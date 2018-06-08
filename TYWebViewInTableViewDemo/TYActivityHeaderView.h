//
//  TYActivityHeaderView.h
//  TYWebViewInTableViewDemo
//
//  Created by Tiny on 2018/6/8.
//  Copyright © 2018年 hxq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYActivityHeaderView : UIView

@property (nonatomic, copy) void (^headerBlock)(CGFloat height);

@property (nonatomic, strong) NSDictionary* paramDict;

@end
