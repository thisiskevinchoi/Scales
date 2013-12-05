//
//  KeyboardView.h
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyView.h"

@protocol KeyboardViewDelegate

- (void) keyPressed:(int)keyNum withAmplitude:(double)amp;
- (void) keyChanged:(int)keyNum withAmplitude:(double)amp;
- (void) keyUnpressed;

@end

@interface KeyboardView : UIView

@property NSMutableArray *keys;

@property id <KeyboardViewDelegate> delegate;

- (void)createKeys:(int)numKeysTotal withScale:(int)numKeysInScale;
@end