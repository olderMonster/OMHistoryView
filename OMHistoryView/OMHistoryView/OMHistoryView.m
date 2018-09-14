//
//  JMCFleetHistoryView.m
//  JMCFleetSDK
//
//  Created by 印聪 on 2018/7/13.
//  Copyright © 2018年 jie.huang. All rights reserved.
//

#import "OMHistoryView.h"

@interface OMHistoryView()


@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIScrollView *historyScrollView;
@property (nonatomic , strong)NSArray *itemsBtnArray;

@property (nonatomic , strong)UILabel *clearHistoryLabel;


@end



@implementation OMHistoryView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _itemsInnerSpace = 10; //按钮间距
        _itemHeight = 30;
        _edgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _showClear = YES;
        _clearText = @"清空搜索历史";
        _itemBoderColor =  [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1.0];
        _itemTextColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.historyScrollView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    if (self.titleLabel.text) {
        self.titleLabel.frame = CGRectMake(self.edgeInset.left,0, self.bounds.size.width - self.edgeInset.left - self.edgeInset.right, 50);
    }else{
        self.titleLabel.frame = CGRectMake(self.edgeInset.left, 0, 0, 0);
    }
    
    self.historyScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.bounds.size.width,self.bounds.size.height - CGRectGetMaxY(self.titleLabel.frame));
    
   
    UIButton *lastButton = [self setupKeywordsItems];
    if (lastButton) {
        
        if (!self.clearHistoryLabel.hidden) {
            CGSize size = [self.clearHistoryLabel.text sizeWithAttributes:@{NSFontAttributeName:self.clearHistoryLabel.font}];
            self.clearHistoryLabel.frame = CGRectMake(self.bounds.size.width * 0.5 - size.width * 0.5, CGRectGetMaxY(lastButton.frame) + 40, size.width, size.height);
            if (CGRectGetMaxY(self.clearHistoryLabel.frame) + self.edgeInset.bottom > CGRectGetMaxY(self.historyScrollView.frame)) {
                self.historyScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.clearHistoryLabel.frame) + self.edgeInset.bottom);
            }
        }else{
            if (CGRectGetMaxY(lastButton.frame) + self.edgeInset.bottom > CGRectGetMaxY(self.historyScrollView.frame)) {
                self.historyScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lastButton.frame) + self.edgeInset.bottom);
            }
        }
        
        
    }else{
        self.clearHistoryLabel.frame = CGRectZero;
    }
}

#pragma mark - private method
- (UIButton *)setupKeywordsItems{
    
    CGFloat itemsInnerSpace = self.itemsInnerSpace; //按钮之间的间距
    CGFloat buttonH = self.itemHeight;  //按钮高度
    CGFloat buttonMaxWidth = self.historyScrollView.bounds.size.width - self.edgeInset.left - self.edgeInset.right;
    for (NSInteger index = 0; index < self.itemsBtnArray.count; index++) {
        UIButton *button = self.itemsBtnArray[index];
        CGSize textSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        CGFloat buttonW = textSize.width + 25;
        //如果计算出的按钮的宽度大于了屏幕的宽度那么此时将按钮的宽度重置为屏幕的宽度
        if (buttonW > buttonMaxWidth) {
            buttonW = buttonMaxWidth;
        }
        if (index == 0) {
            button.frame = CGRectMake(self.edgeInset.left, self.edgeInset.top, buttonW, buttonH);
        }else{
            UIButton *lastButton = self.itemsBtnArray[index - 1];
            //换行显示
            if (CGRectGetMaxX(lastButton.frame) + itemsInnerSpace  + self.edgeInset.right + buttonW > self.historyScrollView.bounds.size.width - self.edgeInset.right) {
                //for循环，找到上一行的第一个按钮
                UIButton *lastRowfirstColButton = nil; //上一行第一列的数据
                for (NSInteger i = index - 1; i >= 0; i--) {
                    UIButton *lastButton = self.itemsBtnArray[i];
                    //这里不知道为什么直接对比数值无效，只能先转成字符串之后再去比较
                    NSString *orginX = [NSString stringWithFormat:@"%.0f",lastButton.frame.origin.x];
                    NSString *edgeLeft = [NSString stringWithFormat:@"%.0f",self.edgeInset.left];
                    if ([orginX isEqualToString:edgeLeft]) {
                        lastRowfirstColButton = lastButton;
                        break;
                    }
                }
                if (lastRowfirstColButton) {
                    button.frame = CGRectMake(lastRowfirstColButton.frame.origin.x, CGRectGetMaxY(lastRowfirstColButton.frame) + itemsInnerSpace, buttonW, buttonH);
                }else{
                    //如果没有找到，那就默认为是第一个按钮
                    button.frame = CGRectMake(self.edgeInset.left, self.edgeInset.top, buttonW, buttonH);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didSelectedSearchItem:)]) {
        [self.delegate view:self didSelectedSearchItem:button.tag];
    }
}

- (void)clearHistoryAction{
    BOOL canClear = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(beforePerformClearHistorys:)]) {
        [self.delegate beforePerformClearHistorys:self];
    }
    
    if (canClear) {
        [self setHistoryArray:nil];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(afterPerformClearHistorys:)]) {
        [self.delegate afterPerformClearHistorys:self];
    }
}


#pragma mark -- getters and setters
- (UIScrollView *)historyScrollView{
    if (_historyScrollView == nil) {
        _historyScrollView = [[UIScrollView alloc] init];
        _historyScrollView.backgroundColor = [UIColor whiteColor];
        _historyScrollView.showsVerticalScrollIndicator = NO;
        
        [_historyScrollView addSubview:self.clearHistoryLabel];
    }
    return _historyScrollView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setClearText:(NSString *)clearText{
    _clearText = clearText;
    
    self.clearHistoryLabel.text = clearText;
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_clearHistoryLabel.text attributes:attribtDic];
    _clearHistoryLabel.attributedText = attribtStr;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _itemBackgroundColor = backgroundColor;
    NSMutableArray *tmpMArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.itemsBtnArray.count; index++) {
        UIButton *button = self.itemsBtnArray[index];
        button.backgroundColor = _itemBackgroundColor;
        tmpMArray[index] = button;
    }
    self.itemsBtnArray = tmpMArray.copy;
}

- (void)setItemTextColor:(UIColor *)itemTextColor{
    _itemTextColor = itemTextColor;
    NSMutableArray *tmpMArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.itemsBtnArray.count; index++) {
        UIButton *button = self.itemsBtnArray[index];
        [button setTitleColor:_itemTextColor forState:UIControlStateNormal];
        tmpMArray[index] = button;
    }
    self.itemsBtnArray = tmpMArray.copy;
}

- (void)setItemBoderColor:(UIColor *)itemBoderColor{
    _itemBoderColor = itemBoderColor;
    NSMutableArray *tmpMArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.itemsBtnArray.count; index++) {
        UIButton *button = self.itemsBtnArray[index];
        button.layer.borderColor = _itemBoderColor.CGColor;
        tmpMArray[index] = button;
    }
    self.itemsBtnArray = tmpMArray.copy;
}

- (void)setShowClear:(BOOL)showClear{
    _showClear = showClear;
    self.clearHistoryLabel.hidden = !_showClear;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (UILabel *)clearHistoryLabel{
    if (_clearHistoryLabel == nil) {
        _clearHistoryLabel = [[UILabel alloc] init];
        _clearHistoryLabel.text = self.clearText;
        _clearHistoryLabel.textColor = [UIColor colorWithRed:73/255.0 green:158/255.0 blue:233/255.0 alpha:1.0];
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


- (void)setHistoryArray:(NSArray *)historyArray{
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
        [button setTitleColor:self.itemTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = self.itemBoderColor.CGColor;
        button.layer.borderWidth = 1.0f;
        button.tag = index;
        [button addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.historyScrollView addSubview:button];
        [tmpBtnArray addObject:button];
    }
    self.itemsBtnArray = tmpBtnArray;
    if (self.showClear) {
        self.clearHistoryLabel.hidden = self.itemsBtnArray.count <= 0;
    }
    
    [self setNeedsLayout];
}


@end
