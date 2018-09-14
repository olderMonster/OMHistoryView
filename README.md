# OMHistoryView
一个常用的搜索历史展示视图。

###中文说明

1、安装

```
pod 'OMHistoryView' 
```

注意：若搜索不到库，可使用rm ~/Library/Caches/CocoaPods/search_index.json移除本地索引然后再执行安装，或者更新一下 cocoapods 版本。

2、手动导入
直接将该 Demo 的 OMHistoryView 文件夹拖入你的工程中。


###用法
######该框架设计时参考的就是苹果官方的API提供方式。最简单的比如我们实例化UIView的方法去使用即可。

####使用方法：
######定义一个属性，以懒加载的方式去实例化该对象
```
@property (nonatomic , strong)OMHistoryView *historyView;
、
- (OMHistoryView *)historyView{
    if (_historyView == nil) {
        _historyView = [[OMHistoryView alloc] init];
        _historyView.edgeInset = UIEdgeInsetsMake(0, 10, 10, 10);
        _historyView.title = @"最近搜索历史";
    }
    return _historyView;
}

```





######添加到当前View上，并设置其位置和大小
```
[self.view addSubview:self.historyView];


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    self.historyView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
}
```
######在需要的时候设置数据源。
```
- (void)loadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *tmpArray = @[@"iphone6s电池",@"小米路由器",@"熨斗",@"泳帽",@"苹果认证数据线",@"鼠标宏",@"演唱会望远镜",@"移动路由器"];
        NSMutableArray *tmpMArray = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < 100; index++) {
        NSInteger i = arc4random()%tmpArray.count;
        [tmpMArray addObject:tmpArray[i]];
    }
    NSArray *historyArray = tmpMArray.copy;
    self.historyView.historyArray = historyArray;
    });
}
```

######然后就可以得到一个历史记录的页面，如下所示
<div align=center><img width="320" src="https://github.com/olderMonster/GBChartLineView/blob/master/ScreenShot/Simulator%20Screen%20Shot%20-%20iPhone%206s%20Plus%20-%202018-03-06%20at%2015.54.04.png"/></div>



######当然对于该视图我还提供了其他的属性去控制对应的显示效果。

######对于title，如果不设置就是不显示的。
```

/**
标题
*/
@property (nonatomic , copy)NSString *title;
```


######对于“清空历史记录”的按钮默认是s显示，即便不去设置clearText的属性，所以如果不需要显示“清空历史记录”按钮只需要设置showClear为NO就可以。
```
/**
清空搜索历史文本
*/
@property (nonatomic , copy)NSString *clearText;


/**
是否显示“清空搜索历史”,默认为YES
*/
@property (nonatomic , assign)BOOL showClear;
```


######更多实现细节以及效果可以再demo中去查看API说明。
