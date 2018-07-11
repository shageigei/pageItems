//
//  ViewController.m
//  分页条控制器
//
//  Created by lang on 2018/5/10.
//  Copyright © 2018年 cnovit. All rights reserved.
//

#import "ViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "SocietyViewController.h"
#import "VideoViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

#import "PageSelect.h"

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height
#define FTiPhoneX        ([UIScreen mainScreen].bounds.size.height == 812)
#define FTtopHeight      (FTiPhoneX ? 88 : 64)

static CGFloat const labelW = 100;

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroView;       //滑动条
@property (nonatomic, strong) UIScrollView *vcScroView;     //页面滑动
@property (nonatomic, weak) UILabel *selLable;
@property (nonatomic, strong) NSMutableArray *titleLabels;


@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *controllers;

@end

@implementation ViewController

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray arrayWithObjects:@"头条",@"热点",@"视频",@"社会",@"阅读",@"科技", nil];
    }
    return _items;
}

- (NSMutableArray *)controllers{
    if (!_controllers) {
        _controllers = [NSMutableArray arrayWithObjects:@"TopLineViewController",@"HotViewController",@"VideoViewController",@"SocietyViewController",@"ReaderViewController",@"ScienceViewController", nil];
    }
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addPageSelecView];
}

- (void)addPageSelecView{
    PageSelect *page = [[PageSelect alloc] initWithFrame:(CGRect){0,FTtopHeight,kScreenWidth,kScreenHeight - FTtopHeight}];
    page.backgroundColor = [UIColor clearColor];
    page.items = self.items;
    page.controllers = self.controllers;
    [page setUpChildViewController:self];
    [self.view addSubview:page];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
