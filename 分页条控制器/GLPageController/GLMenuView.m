//
//  GLMenuView.m
//  分页条控制器
//
//  Created by lang on 2018/5/10.
//  Copyright © 2018年 cnovit. All rights reserved.
//

#import "GLMenuView.h"
#import "GLMaskView.h"
#import "GLMenuItem.h"

static NSString *GLMENUITEM_NIBNAME = @"GLSegmentedItem";
static const NSInteger BOTTOM_COLLECTIONVIEW_TAG = 11;
static const NSInteger TOP_COLLECTIONVIEW_TAG = 22;

@interface GLMenuView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) CGFloat itemHeight;               /*!< item的高度*/
@property (nonatomic, assign) CGFloat collectionViewEdge;       /*!< collectionView内边距*/
@property (nonatomic, strong) UICollectionView *collectViewBottom;  /*!< 遮罩下面的collectionView*/
@property (nonatomic, strong) UICollectionView *collectViewTop;     /*!< 遮罩上面的collectionView*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;   /*!< collectionView的布局*/
@property (nonatomic, strong) GLMaskView *maskView;                     /*!< 遮罩视图*/


@end

@implementation GLMenuView

+ (instancetype)glMenuViewWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles subTitles:(NSArray<NSString *> *)subTitles{
    
    GLMenuView *menuView = [[GLMenuView alloc] initWithFrame:frame];
    menuView.titles = [titles copy];
    menuView.subTitles = [subTitles copy];
    return menuView;
}
- (void)setMenuContentOffect:(CGPoint)offect{
    [_collectViewTop setContentOffset:offect];
}

- (void)reload{
    [self.collectViewTop reloadData];
    [self.collectViewBottom reloadData];
}

#pragma mark - init

- (void)initialization{
    _itemWidth                      = 80;
    _itemHeight                     = self.bounds.size.height;
    _menuBackgroundColor            = [UIColor blackColor];
    _maskFillColor                  = [UIColor redColor];
    _triangleWidth                  = 20;
    _triangleHeight                 = 8;
    
    _normalTitleColor               = [UIColor lightGrayColor];
    _selectedTitleColor             = [UIColor whiteColor];
    _titleTextFont                  = [UIFont systemFontOfSize:16.f];
    _titleTextHeight                = 16;
    
    _normalSubTitleColor            = [UIColor lightGrayColor];
    _selectedSubTitleColor          = [UIColor whiteColor];
    _subTitleTextFont               = [UIFont systemFontOfSize:12];
    _subTitleTextHeight             = 12;
    
    _collectionViewEdge             = self.bounds.size.width/2 - _itemWidth/2;
}

- (void)setupContentView{
    self.backgroundColor = self.menuBackgroundColor;
    [self addSubview:self.collectViewBottom];
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.collectViewTop];
}


//代码初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupContentView];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initialization];
        [self setupContentView];
    }
    return self;
}

// xib初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        [self setupContentView];
    }
    return self;
}

#pragma mark - life circle
- (void)layoutSubviews{
    [super layoutSubviews];
    self.itemHeight                     = self.bounds.size.height;
    self.collectionViewEdge             = self.bounds.size.width/2 - self.itemWidth/2;
    self.flowLayout.itemSize            = CGSizeMake(self.itemWidth, self.itemHeight);
    self.flowLayout.sectionInset        = UIEdgeInsetsMake(0, self.collectionViewEdge, 0, self.collectionViewEdge);
    self.collectViewBottom.frame        = self.bounds;
    self.maskView.frame                 = CGRectMake(self.collectionViewEdge, 0, self.itemWidth, self.itemHeight + self.triangleHeight);
    self.collectViewTop.frame           = CGRectMake(-self.collectionViewEdge, 0, self.bounds.size.width, self.itemHeight);
    self.collectViewTop.contentSize     = CGSizeMake(self.itemWidth * self.titles.count + self.collectionViewEdge * 2, 0);
    self.collectViewBottom.contentSize  = CGSizeMake(self.itemWidth * self.titles.count + self.collectionViewEdge * 2, 0);
    
    if (self.selectIndex != 0) {
        [self selectItemAtIndex:_selectIndex];
    }
    
}

- (void)dealloc{
    _collectViewTop.delegate = nil;
    _collectViewBottom.delegate = nil;
}

#pragma mark - setter && getter

- (void)setTitles:(NSArray<NSString *> *)titles{
    _titles = [titles copy];
    [self reload];
}

- (void)setSubTitles:(NSArray<NSString *> *)subTitles{
    _subTitles = [subTitles copy];
    [self reload];
}

- (void)setMenuBackgroundColor:(UIColor *)menuBackgroundColor{
    _menuBackgroundColor = menuBackgroundColor;
    self.backgroundColor = menuBackgroundColor;
}

- (void)setMaskFillColor:(UIColor *)maskFillColor{
    _maskFillColor = maskFillColor;
    self.maskView.fillColor = maskFillColor;
}

- (void)setTriangleHeight:(CGFloat)triangleHeight {
    _triangleHeight              = triangleHeight;
    self.maskView.triangleHeight = triangleHeight;
}

- (void)setTriangleWidth:(CGFloat)triangleWidth {
    _triangleWidth              = triangleWidth;
    self.maskView.triangleWidth = triangleWidth;
}

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;
    if (_selectIndex != selectIndex) {
        [self selectItemAtIndex:selectIndex];
    }
}

#pragma mark lazy
- (UICollectionView *)collectViewTop{
    if (!_collectViewTop) {
        _collectViewTop = [[UICollectionView alloc] initWithFrame:CGRectMake(-self.collectionViewEdge, 0, self.bounds.size.width, self.itemHeight) collectionViewLayout:self.flowLayout];
        [_collectViewTop registerClass:[GLMenuItem class] forCellWithReuseIdentifier:GLMENUITEM_NIBNAME];
        _collectViewTop.tag = TOP_COLLECTIONVIEW_TAG;
        _collectViewTop.backgroundColor = [UIColor clearColor];
        _collectViewTop.showsHorizontalScrollIndicator = NO;
        _collectViewTop.decelerationRate = 0;   //设置手指放开后的减速率(值域 0~1 值越小减速停止的时间越短),默认为1
        _collectViewTop.delegate = self;
        _collectViewTop.dataSource = self;
    }
    return _collectViewTop;
}

- (UICollectionView *)collectViewBottom{
    if (!_collectViewBottom) {
        _collectViewBottom = [[UICollectionView alloc] initWithFrame:CGRectMake(-self.collectionViewEdge, 0, self.bounds.size.width, self.itemHeight) collectionViewLayout:self.flowLayout];
        [_collectViewBottom registerClass:[GLMenuItem class] forCellWithReuseIdentifier:GLMENUITEM_NIBNAME];
        _collectViewBottom.tag = BOTTOM_COLLECTIONVIEW_TAG;
        _collectViewBottom.backgroundColor = [UIColor clearColor];
        _collectViewBottom.showsHorizontalScrollIndicator = NO;
        _collectViewBottom.decelerationRate = 0;   //设置手指放开后的减速率(值域 0~1 值越小减速停止的时间越短),默认为1
        _collectViewBottom.delegate = self;
        _collectViewBottom.dataSource = self;
    }
    return _collectViewBottom;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, self.collectionViewEdge, 0, self.collectionViewEdge);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[GLMaskView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.fillColor = self.maskFillColor;
        _maskView.triangleHeight = self.triangleHeight;
        _maskView.triangleWidth = self.triangleWidth;
        _maskView.clipsToBounds = YES;
    }
    return _maskView;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GLMENUITEM_NIBNAME forIndexPath:indexPath];
    
    NSString *title = self.titles[indexPath.row];
    NSString *subTitle = self.subTitles[indexPath.row];
    if (collectionView.tag == BOTTOM_COLLECTIONVIEW_TAG) {
        cell.titleColor = self.normalTitleColor;
        cell.subTitleColor = self.normalSubTitleColor;
    }else{
        cell.titleColor = self.selectedTitleColor;
        cell.subTitleColor = self.selectedSubTitleColor;
    }
    
    cell.titleText           = title;
    cell.subTitleText        = subTitle;
    cell.titleTextFont       = self.titleTextFont;
    cell.subTitleTextFont    = self.subTitleTextFont;
    cell.titleLabelHeight    = self.titleTextHeight;
    cell.subTitleLabelHeight = self.subTitleTextHeight;
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GLMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GLMENUITEM_NIBNAME forIndexPath:indexPath];
    if (collectionView.tag == BOTTOM_COLLECTIONVIEW_TAG && cell) {
        //禁用手势 （防止连续点击）
        self.collectViewBottom.userInteractionEnabled = NO;
//        [self refreshContentOffsetItemFrame:cell.frame];
    }
}

#pragma mark - UIScrollerViewDelegate

//当有滚动的时候就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    //同步两个collectionView的滚动
    if(collectionView.tag == BOTTOM_COLLECTIONVIEW_TAG){
        [_collectViewTop setContentOffset:collectionView.contentOffset];
    }else{
        [_collectViewBottom setContentOffset:collectionView.contentOffset];
    }
}

// 当手动拖拽结束后调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) {
        GLMenuItem *cell = [self getItemWithLocation:_collectViewBottom.center];
        
        if (cell) {
            [self refreshContentOffsetItemFrame:cell.frame];
        }
    }
}
// 当手动拖动结束且减速后调用（如果拖动后就停止了，就不会调用该方法）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    GLMenuItem *cell = [self getItemWithLocation:_collectViewBottom.center];
    if (cell) {
        [self refreshContentOffsetItemFrame:cell.frame];
    }
}

// setContentOffset改变 且 滚动动画结束后会 调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 滚动动画结束后启用手势 (防止连续点击)
    self.collectViewBottom.userInteractionEnabled = YES;
}

#pragma mark -

//设置选中指定下标的item
- (void)selectItemAtIndex:(int)selectIndex{
    CGRect curItemFrame = CGRectMake(selectIndex * self.itemWidth + self.collectionViewEdge, 0, self.itemWidth, self.itemHeight);
    [self refreshContentOffsetItemFrame:curItemFrame];
}

//获取屏幕中指定点所在的cell
- (GLMenuItem *)getItemWithLocation:(CGPoint)location{
    //坐标点的转化（将当前点击的位置坐标从self上转换到collectionView上）
    CGPoint tableLocation = [self convertPoint:location toView:_collectViewBottom];
    
    //获取当前所点击的下标
    NSIndexPath *selectedPath = [_collectViewBottom indexPathForItemAtPoint:tableLocation];
    GLMenuItem *cell = [_collectViewBottom dequeueReusableCellWithReuseIdentifier:GLMENUITEM_NIBNAME forIndexPath:selectedPath];
    
    return cell;
    
}

//让选中的item位于中间
- (void)refreshContentOffsetItemFrame:(CGRect)frame{
    CGFloat itemX = frame.origin.x;         //选中的item的原始x坐标
    CGFloat width = _collectViewBottom.bounds.size.width;   //view的宽度 即屏幕宽
    CGSize contentSize = _collectViewBottom.contentSize;   //总宽度
    
    CGFloat targetX;
    if ((contentSize.width - itemX) <= width/2) {
        targetX = contentSize.width - width;
    }else{
        targetX = frame.origin.x - width/2 + frame.size.width/2;
    }
    if (targetX + width > contentSize.width) {
        targetX = contentSize.width - width;
    }
    
    [_collectViewBottom setContentOffset:CGPointMake(targetX, 0) animated:YES];
    if (_clickIndexBlock) {
        _clickIndexBlock((itemX - self.collectionViewEdge)/self.itemWidth);
    }
    
}

@end
