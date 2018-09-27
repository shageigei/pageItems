# pageItems



点击顶部item 切换到相应的控制器，滑动界面，顶部的title也跟着变化到相应的title，title颜色改变，大小改变
```

//items和controllers要一一对应
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


PageSelect *page = [[PageSelect alloc] initWithFrame:(CGRect){0,FTtopHeight,kScreenWidth,kScreenHeight - FTtopHeight}];
    page.backgroundColor = [UIColor clearColor];
    page.items = self.items;
    page.controllers = self.controllers;
    [page setUpChildViewController:self];
    [self.view addSubview:page];
```

![7D54FD75-73BB-481A-894C-40A5D6F6072D](https://github.com/shageigei/pageItems/blob/master/7D54FD75-73BB-481A-894C-40A5D6F6072D.png)










