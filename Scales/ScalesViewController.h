//
//  ScalesViewController.h
//  Scales
//
//  Created by Kevin Choi on 11/22/13.
//  Copyright (c) 2013 Kevin Choi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KeyboardView.h"
#import "Keyboard.h"

#import "ScaleTitleView.h"
#import "ScaleTonicView.h"
#import "OptionsView.h"

#import "ToneGenerator.h"

@interface ScalesViewController : UIViewController <KeyboardViewDelegate, OptionsViewDelegate, ScaleTitleViewDelegate, ScaleTonicViewDelegate>

@property KeyboardView *keyboardView;
@property Keyboard* keyboard;

@property ScaleTitleView *scaleTitleView;
@property ScaleTonicView *scaleTonicView;
@property OptionsView *optionsView;

@property ToneGenerator *toneGenerator;

@end