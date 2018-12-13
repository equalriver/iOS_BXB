//
//  BXBSwipeButtonsView.h
//  BXB
//
//  Created by equalriver on 2018/9/18.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBXBSwipeButtonWidthDefault 80 * UIScreen.mainScreen.bounds.size.width/375.0

@interface BXBSwipeButtonsView : UIView

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(UIView *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;
- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(UIView *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@property (nonatomic, weak, readonly) UIView *parentCell;
@property (nonatomic, copy) NSArray *utilityButtons;
@property (nonatomic, assign) SEL utilityButtonSelector;

- (void)setUtilityButtons:(NSArray *)utilityButtons WithButtonWidth:(CGFloat)width;
- (void)pushBackgroundColors;
- (void)popBackgroundColors;

@end
