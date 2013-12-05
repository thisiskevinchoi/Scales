//
//  ScaleTonicView.h
//  Scales
//
//  Created by Kevin Choi on 12/1/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScaleTonicViewDelegate

- (void)swipeTonicLeft;
- (void)swipeTonicRight;

@end

@interface ScaleTonicView : UIView

@property id <ScaleTonicViewDelegate> delegate;

@property UILabel* tonicLabel;

@property UISwipeGestureRecognizer *swipeGestureLeftRecognizer;
@property UISwipeGestureRecognizer *swipeGestureRightRecognizer;

- (void)setTonic:(NSString*)tonic;

@end
