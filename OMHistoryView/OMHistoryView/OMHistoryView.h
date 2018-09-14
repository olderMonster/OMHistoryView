//
//  JMCFleetHistoryView.h
//  JMCFleetSDK
//
//  Created by 印聪 on 2018/7/13.
//  Copyright © 2018年 jie.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OMHistoryView;

@protocol OMHistoryViewDelegate <NSObject>



/**
 点选item

 @param view 当前视图
 @param index 点选的数据索引
 */
- (void)view:(OMHistoryView *)view didSelectedSearchItem:(NSInteger)index;



/**
 即将点击“清空搜索历史”

 @param view 当前视图
 @return 返回NO则不在内部去清空页面否则清空,默认YES
 */
- (BOOL)beforePerformClearHistorys:(OMHistoryView *)view;


/**
 点击了“清空历史记录”

 @param view 当前视图
 */
- (void)afterPerformClearHistorys:(OMHistoryView *)view;


@end

@interface OMHistoryView : UIView



/**
 标题
 */
@property (nonatomic , copy)NSString *title;


/**
 清空搜索历史文本
 */
@property (nonatomic , copy)NSString *clearText;


/**
 数据源
 */
@property (nonatomic , strong)NSArray *historyArray;


/**
 边距，这里指的是按钮部分的边距，不包括title
 */
@property (nonatomic , assign)UIEdgeInsets edgeInset;



/**
 按钮之间的间距
 */
@property (nonatomic , assign)CGFloat itemsInnerSpace;



/**
 按钮背景颜色
 */
@property (nonatomic , strong)UIColor *itemBackgroundColor;

/**
 按钮文本颜色
 */
@property (nonatomic , strong)UIColor *itemTextColor;

/**
 按钮边框颜色
 */
@property (nonatomic , strong)UIColor *itemBoderColor;


/**
 按钮高度
 */
@property (nonatomic , assign)CGFloat itemHeight;



/**
 是否显示“清空搜索历史”,默认为YES
 */
@property (nonatomic , assign)BOOL showClear;

/**
 代理
 */
@property (nonatomic , weak)id<OMHistoryViewDelegate>delegate;


@end
