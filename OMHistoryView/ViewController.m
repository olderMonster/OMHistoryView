//
//  ViewController.m
//  OMHistoryView
//
//  Created by 印聪 on 2018/9/13.
//  Copyright © 2018年 tima. All rights reserved.
//

#import "ViewController.h"
#import "OMHistoryView.h"
@interface ViewController ()

@property (nonatomic , strong)OMHistoryView *historyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.historyView];
    
    [self loadData];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.historyView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
}


#pragma mark -- private method
- (void)loadData{
    //read data from cache or request from server
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


#pragma mark -- getters and setters
- (OMHistoryView *)historyView{
    if (_historyView == nil) {
        _historyView = [[OMHistoryView alloc] init];
        _historyView.edgeInset = UIEdgeInsetsMake(0, 10, 10, 10);
//        _historyView.itemTextColor = [UIColor blueColor];
//        _historyView.itemBoderColor = [UIColor greenColor];
        _historyView.title = @"最近搜索历史";
//        _historyView.showClear = YES; //显示或者隐藏清空历史按钮
    }
    return _historyView;
}



@end
