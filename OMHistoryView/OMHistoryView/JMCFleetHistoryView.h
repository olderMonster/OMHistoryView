//
//  JMCFleetHistoryView.h
//  JMCFleetSDK
//
//  Created by 印聪 on 2018/7/13.
//  Copyright © 2018年 jie.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMCFleetHistoryView;

#import "JMCFleetKeywordContentView.h"

@protocol JMCFleetHistoryViewDelegate <NSObject>

- (void)view:(JMCFleetHistoryView *)view didSelectedSearchText:(NSString *)text;

@end

@interface JMCFleetHistoryView : UIView

@property (nonatomic , assign)JMCFleetInfoType type;
@property (nonatomic , weak)id<JMCFleetHistoryViewDelegate>delegate;

- (void)reloadData;

@end
