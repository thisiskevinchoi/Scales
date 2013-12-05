//
//  Keyboard.h
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Key.h"

@interface Keyboard : NSObject

@property NSArray* scales;
@property int currentScale;

@property NSArray* tonics;
@property int currentTonic;

@property NSMutableArray* keys;

@property int numOctaves;
@property int position;

- (NSMutableArray*)setKeys;
- (void)changePosition:(int)position;
- (void)changeNumOctave:(int)numOctave;

- (NSString*)getScale;
- (NSString*)changeScaleLeft;
- (NSString*)changeScaleRight;

- (NSString*)getTonic;
- (NSString*)changeTonicLeft;
- (NSString*)changeTonicRight;
@end