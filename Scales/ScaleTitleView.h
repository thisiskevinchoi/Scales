//
//  ScaleTitleView.h
//  Scales
//
//  Created by Kevin Choi on 12/1/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScaleTitleViewDelegate

- (void)swipeScaleLeft;
- (void)swipeScaleRight;

@end

@interface ScaleTitleView : UIView

@property id <ScaleTitleViewDelegate> delegate;

@property UILabel* titleLabel;

@property UISwipeGestureRecognizer *swipeGestureLeftRecognizer;
@property UISwipeGestureRecognizer *swipeGestureRightRecognizer;

@property BOOL animationRunning;

- (void)setTitle:(NSString*)title;

@end
