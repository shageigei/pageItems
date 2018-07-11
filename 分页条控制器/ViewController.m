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

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define FTiPhoneX        ([UIScreen mainScreen].bounds.size.height == 812)
#define FTtopHeight      (FTiPhoneX ? 88 : 64)

static CGFloat const labelW = 100;

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroView;       //滑动条
@property (nonatomic, strong) UIScrollView *vcScroView;     //页面滑动
@property (nonatomic, weak) UILabel *selLable;
@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scroView];
    [self.view addSubview:self.vcScroView];
    
    //添加子控制器
    [self setUpChildViewController];
    //添加title标题
    [self setUpTitleLabel];
    
    [self setUpScrollView];
}

- (void)setUpScrollView{
    NSInteger count = self.childViewControllers.count;
    self.scroView.contentSize = CGSizeMake(labelW * count, 0);
    self.vcScroView.contentSize = CGSizeMake(kScreenWidth * count, 0);
}

- (void)setUpTitleLabel{
    NSInteger count = self.childViewControllers.count;
    
    CGFloat lableX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = 44;
    
    for (NSInteger i = 0; i < count; i++) {
        UILabel *lable = [[UILabel alloc] init];
        lableX = labelW * i;
        lable.tag = i;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.frame = CGRectMake(lableX, labelY, labelW, labelH);
        lable.text = self.childViewControllers[i].title;
        lable.userInteractionEnabled = YES;
        lable.highlightedTextColor = [UIColor redColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [lable addGestureRecognizer:tapGesture];
        //默认选择第一个
        if (i == 0) {
            [self titleClick:tapGesture];
        }
        [self.titleLabels addObject:lable];
        [self.scroView addSubview:lable];
    }
    
    
}

- (void)titleClick:(UITapGestureRecognizer *)tap{
    //改变标题
    UILabel *selLabel = (UILabel *)tap.view;
    [self selectLabel:selLabel];
    NSInteger index = selLabel.tag;
    
    //页面滚动到相应位置
    CGFloat offSet = index * kScreenWidth;
    self.vcScroView.contentOffset = CGPointMake(offSet, 0);
    
    //给对应位置添加对应控制器
    [self showVC:index];
    [self setTitleCenter:selLabel];
}

- (void)showVC:(NSInteger)index{
    
    CGFloat offSet = index * kScreenWidth;
    UIViewController *vc = self.childViewControllers[index];
    if (vc.isViewLoaded) return;
    vc.view.frame = CGRectMake(offSet, 0, self.vcScroView.frame.size.width, self.vcScroView.frame.size.height);
    [self.vcScroView addSubview:vc.view];
}

- (void)selectLabel:(UILabel *)label{
    [_selLable setHighlighted:NO];
    _selLable.transform = CGAffineTransformIdentity;
    _selLable.textColor = [UIColor blackColor];
    [label setHighlighted:YES];
    label.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _selLable = label;
}

- (void)setUpChildViewController{
    
    //头条
    TopLineViewController *topLineVC = [[TopLineViewController alloc] init];
    topLineVC.title = @"头条";
    [self addChildViewController:topLineVC];
    
    //热点
    HotViewController *hotVC = [[HotViewController alloc] init];
    hotVC.title = @"热点";
    [self addChildViewController:hotVC];
    
    //视频
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    //社会
    SocietyViewController *societyVC = [[SocietyViewController alloc] init];
    societyVC.title = @"社会";
    [self addChildViewController:societyVC];
    
    //阅读
    ReaderViewController *readerVC = [[ReaderViewController alloc] init];
    readerVC.title = @"阅读";
    [self addChildViewController:readerVC];
    
    //科技
    ScienceViewController *scienceVC = [[ScienceViewController alloc] init];
    scienceVC.title = @"科技";
    [self addChildViewController:scienceVC];
}

- (void)setTitleCenter:(UILabel *)centerLable{
    CGFloat offSetX = centerLable.center.x - kScreenWidth/2;
    if (offSetX < 0) offSetX = 0;
    //最大滚动范围
    CGFloat maxOffset = self.scroView.contentSize.width - kScreenWidth;
    if (offSetX > maxOffset) offSetX = maxOffset;
    [self.scroView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat curPage = scrollView.contentOffset.x / self.scroView.bounds.size.width;
    //获取左边的角标
    NSInteger leftIndex = curPage;
    //获取右边的角标
    NSInteger rightIndex = leftIndex + 1;
    //获取左边的label
    UILabel *leftLabel = self.titleLabels[leftIndex];
    //获取右边的label
    UILabel *rightLabel;
    if (rightIndex < self.titleLabels.count - 1) {
        rightLabel = self.titleLabels[rightIndex];
    }
    
    //计算右边缩放比例
    CGFloat rightScale = curPage - leftIndex;
    //计算左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    
    //左边缩放
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * 0.3 + 1, leftScale * 0.3 + 1);
    
    //右边缩放
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * 0.3 + 1, rightScale * 0.3 + 1);
    NSLog(@"11111:%f",rightScale);
    //颜色渐变
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取对应子控制器view(滚动到哪一页)
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    UILabel *label = self.titleLabels[index];
    [self selectLabel:label];
    [self showVC:index];
    [self setTitleCenter:label];
}

#pragma mark - lazy Set
-(UIScrollView *)scroView{
    if (!_scroView) {
        _scroView = [[UIScrollView alloc] init];
        _scroView.backgroundColor = [UIColor clearColor];
        _scroView.showsHorizontalScrollIndicator = NO;
        _scroView.bounces = NO;
        _scroView.frame = CGRectMake(0, FTtopHeight, [UIScreen mainScreen].bounds.size.width, 44);
    }
    return _scroView;
}

- (UIScrollView *)vcScroView{
    if (!_vcScroView) {
        _vcScroView = [[UIScrollView alloc] init];
        _vcScroView.backgroundColor = [UIColor clearColor];
        _vcScroView.pagingEnabled = YES;
        _vcScroView.showsHorizontalScrollIndicator = NO;
        _vcScroView.delegate = self;
        _vcScroView.bounces = NO;
        _vcScroView.frame = CGRectMake(0, FTtopHeight+44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - FTtopHeight);
    }
    return _vcScroView;
}

- (NSMutableArray *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
