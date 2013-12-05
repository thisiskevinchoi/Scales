//
//  ScaleView.h
//  Scales
//
//  Created by Kevin Choi on 11/28/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsViewDelegate

- (void)octavePositionChanged:(int)position;
- (void)octaveNumChanged:(int)num;

@end

@interface OptionsView : UIView

@property id <OptionsViewDelegate> delegate;

@property UILabel* scaleLabel;
@property UISegmentedControl *oneOctavePositionSegmentedControl;
@property UISegmentedControl *twoOctavePositionSegmentedControl;

@property UISegmentedControl *octaveNumSegmentedControl;

- (void)setSegmentedControlForOctave:(int)numOctaves;
- (void)setOctivePositionSegmentedControlPosition:(int)position;
- (void)setOctaveNumSegmentedControlPosition:(int)position;

@end
