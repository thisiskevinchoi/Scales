//
//  ToneGenerator.h
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ToneGenerator : NSObject

@property AudioComponentInstance toneUnit;

@property double amplitude;
@property double frequency;
@property double sampleRate;
@property double theta;

- (void)playToneWithFreq:(double)freq andAmplitude:(double)amp;
- (void)setFrequency:(double)freq andAmplitude:(double)amp;
- (void)stop;
@end
