//
//  JMCFleetHistoryView.m
//  JMCFleetSDK
//
//  Created by 印聪 on 2018/7/13.
//  Copyright © 2018年 jie.huang. All rights reserved.
//

#import "JMCFleetHistoryView.h"

#import "JMCFleetCacheManager.h"

@interface JMCFleetHistoryView()

@property (nonatomic , strong)NSArray *historyArray;
@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIScrollView *historyScrollView;
@property (nonatomic , strong)NSArray *itemsBtnArray;

@property (nonatomic , strong)UILabel *clearHistoryLabel;


@end



@implementation JMCFleetHistoryView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.historyScrollView];
        
        [self reloadData];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.historyScrollView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(20,0, self.historyScrollView.bounds.size.width - 10 * 2, 50);
    
    UIButton *lastButton = [self setupKeywordsItems];
    if (lastButton) {
        
        CGSize size = [self.clearHistoryLabel.text sizeWithAttributes:@{NSFontAttributeName:self.clearHistoryLabel.font}];
        self.clearHistoryLabel.frame = CGRectMake(self.bounds.size.width * 0.5 - size.width * 0.5, CGRectGetMaxY(lastButton.frame) + 40, size.width, size.height);
        
        CGFloat edgeInsetBottom = 10;
        if (CGRectGetMaxY(lastButton.frame) > self.historyScrollView.bounds.size.height - edgeInsetBottom) {
            self.historyScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lastButton.frame) + edgeInsetBottom);
        }
    }else{
        self.clearHistoryLabel.frame = CGRectZero;
    }
}

#pragma mark - private method
- (UIButton *)setupKeywordsItems{
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.titleLabel.frame) + 10, self.titleLabel.frame.origin.x, 20, self.titleLabel.frame.origin.x);
    CGFloat itemsInnerSpace = 20; //按钮之间的间距
    CGFloat buttonH = 30;  //按钮高度
    CGFloat buttonMaxWidth = self.historyScrollView.bounds.size.width - edgeInsets.left - edgeInsets.right;
    for (NSInteger index = 0; index < self.itemsBtnArray.count; index++) {
        UIButton *button = self.itemsBtnArray[index];
        CGSize textSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        CGFloat buttonW = textSize.width + 25;
        //如果计算出的按钮的宽度大于了屏幕的宽度那么此时将按钮的宽度重置为屏幕的宽度
        if (buttonW > buttonMaxWidth) {
            buttonW = buttonMaxWidth;
        }
        if (index == 0) {
            button.frame = CGRectMake(edgeInsets.left, edgeInsets.top, buttonW, buttonH);
        }else{
            UIButton *lastButton = self.itemsBtnArray[index - 1];
            //换行显示
            if (CGRectGetMaxX(lastButton.frame) + itemsInnerSpace  + edgeInsets.right + buttonW > self.historyScrollView.bounds.size.width - edgeInsets.right) {
                //for循环，找到上一行的第一个按钮
                UIButton *lastRowfirstColButton = nil; //上一行第一列的数据
                for (NSInteger i = index - 1; i >= 0; i--) {
                    UIButton *lastButton = self.itemsBtnArray[i];
                    //这里不知道为什么直接对比数值无效，只能先转成字符串之后再去比较
                    NSString *orginX = [NSString stringWithFormat:@"%.0f",lastButton.frame.origin.x];
                    NSString *edgeLeft = [NSString stringWithFormat:@"%.0f",edgeInsets.left];
                    if ([orginX isEqualToString:edgeLeft]) {
                        lastRowfirstColButton = lastButton;
                        break;
                    }
                }
                if (lastRowfirstColButton) {
                    button.frame = CGRectMake(lastRowfirstColButton.frame.origin.x, CGRectGetMaxY(lastRowfirstColButton.frame) + itemsInnerSpace, buttonW, buttonH);
                }else{
                    //如果没有找到，那就默认为是第一个按钮
                    button.frame = CGRectMake(edgeInsets.left, edgeInsets.top, buttonW, buttonH);
                }
                
            }else{
                //接着在上一个按钮的后面显示
                button.frame = CGRectMake(CGRectGetMaxX(lastButton.frame) + itemsInnerSpace, lastButton.frame.origin.y, buttonW, buttonH);
            }
        }
        
        if (index == self.itemsBtnArray.count - 1) {
            return button;
        }
        
    }
    return nil;
}


#pragma mark -- event response
- (void)selectItem:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didSelectedSearchText:)]) {
        [self.delegate view:self didSelectedSearchText:button.titleLabel.text];
    }
}

- (void)clearHistoryAction{
    NSString *identifier = nil;
    if (self.type == JMCFleetInfoTypeDriver) {
        identifier = kJMCFleetCacheIdentifierHistoryDriver;
    }
    if (self.type == JMCFleetInfoTypeCar) {
        identifier = kJMCFleetCacheIdentifierHistoryCar;
    }
    if (self.type == JMCFleetInfoTypeCarPosition) {
        identifier = kJMCFleetCacheIdentifierHistoryCarLocation;
    }

    [JMCFleetCacheManager clearData:identifier];
    
    [self reloadData];
}

#pragma mark -- http request
- (void)reloadData{
    NSString *identifier = nil;
    if (self.type == JMCFleetInfoTypeDriver) {
        identifier = kJMCFleetCacheIdentifierHistoryDriver;
    }
    if (self.type == JMCFleetInfoTypeCar) {
        identifier = kJMCFleetCacheIdentifierHistoryCar;
    }
    if (self.type == JMCFleetInfoTypeCarPosition) {
        identifier = kJMCFleetCacheIdentifierHistoryCarLocation;
    }
    
    NSArray *tmpArray = [JMCFleetCacheManager loadData:identifier];
    
    [self sethistoryArray:tmpArray];
}


#pragma mark -- getters and setters
- (UIScrollView *)historyScrollView{
    if (_historyScrollView == nil) {
        _historyScrollView = [[UIScrollView alloc] init];
        _historyScrollView.backgroundColor = HJColor(255, 255, 255);
        _historyScrollView.showsVerticalScrollIndicator = NO;
        
        [_historyScrollView addSubview:self.titleLabel];
        [_historyScrollView addSubview:self.clearHistoryLabel];
    }
    return _historyScrollView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"最近搜索的历史";
    }
    return _titleLabel;
}

- (UILabel *)clearHistoryLabel{
    if (_clearHistoryLabel == nil) {
        _clearHistoryLabel = [[UILabel alloc] init];
        _clearHistoryLabel.text = @"清空搜索历史";
        _clearHistoryLabel.textColor = HJColor(73, 158, 233);
        _clearHistoryLabel.font = [UIFont systemFontOfSize:12];
        _clearHistoryLabel.textAlignment = NSTextAlignmentCenter;
        _clearHistoryLabel.hidden = YES;
        
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_clearHistoryLabel.text attributes:attribtDic];
        _clearHistoryLabel.attributedText = attribtStr;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearHistoryAction)];
        tap.numberOfTapsRequired = 1;
        _clearHistoryLabel.userInteractionEnabled = YES;
        [_clearHistoryLabel addGestureRecognizer:tap];
    }
    return _clearHistoryLabel;
}


- (void)sethistoryArray:(NSArray *)historyArray{
    _historyArray = historyArray;
    
    for (UIView *view in self.itemsBtnArray) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *tmpBtnArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < _historyArray.count; index++) {
        NSString *keyword = _historyArray[index];
        if (![keyword isKindOfClass:[NSString class]] || [keyword length] <= 0) {
            continue;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:keyword forState:UIControlStateNormal];
        [button setTitleColor:HJColor(140, 140, 140) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = HJColor(203, 203, 203).CGColor;
        button.layer.borderWidth = 1.0f;
        button.tag = index;
        [button addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.historyScrollView addSubview:button];
        [tmpBtnArray addObject:button];
    }
    self.itemsBtnArray = tmpBtnArray;
    self.clearHistoryLabel.hidden = self.itemsBtnArray.count <= 0;
    
    [self setNeedsLayout];
}

- (void)setType:(JMCFleetInfoType)type{
    _type = type;
    
    [self reloadData];
}

@end
