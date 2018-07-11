//
//  PageSelect.h
//  分页条控制器
//
//  Created by lang on 2018/7/11.
//  Copyright © 2018年 cnovit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageSelect : UIView

@property (nonatomic, strong) NSMutableArray *items;        //顶部items集合
@property (nonatomic, strong) NSMutableArray *controllers;  //控制器集合

- (void)setUpChildViewController:(UIViewController *)controller;

@end
