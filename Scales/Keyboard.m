//
//  Keyboard.m
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import "Keyboard.h"

@implementation Keyboard

#define OCTAVE 12

- (id)init
{
    self = [super init];
    // INIT THE KEYS
    self.keys = [NSMutableArray new];
    // SET UP SCALES ARRAY
    self.scales = @[
                    @[@"CHROMATIC", @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11]],
                    @[@"MAJOR", @[@0, @2, @4, @5, @7, @9, @11]],
                    @[@"NATURAL MINOR", @[@0, @2, @3, @5, @7, @8, @10]],
                    @[@"MELODIC MINOR", @[@0, @2, @3, @5, @7, @9, @11]],
                    @[@"HARMONIC MINOR", @[@0, @2, @3, @5, @7, @8, @11]],
                    @[@"DORIAN", @[@0, @2, @3, @5, @7, @9, @10]],
                    @[@"PHRYGIAN", @[@0, @1, @3, @5, @7, @8, @10]],
                    @[@"LYDIAN", @[@0, @2, @4, @6, @7, @9, @11]],
                    @[@"MIXOLYDIAN", @[@0, @2, @4, @5, @7, @9, @10]],
                    @[@"LOCRIAN", @[@0, @1, @3, @5, @6, @8, @10]],
                    @[@"MAJOR PENTATONIC", @[@0, @2, @4, @7, @9]],
                    @[@"MINOR PENTATONIC", @[@0, @3, @5, @7, @10]],
                    @[@"BLUES", @[@0, @3, @5, @6, @7, @10]],
                    @[@"OCTATONIC 1", @[@0, @2, @3, @5, @6, @8, @9, @11]],
                    @[@"OCTATONIC 2", @[@0, @1, @3, @4, @6, @7, @9, @10]],
                    @[@"WHOLE TONE", @[@0, @2, @4, @6, @8, @10]],
                    @[@"AUGMENTED", @[@0, @3, @4, @7, @8, @11]],
                    ];
    // SET UP TONIC NOTE NUMBESR DICTIONARY
    self.tonics = @[
                              @[@"A", @37],
                              @[@"A#/Bb", @38],
                              @[@"B", @39],
                              @[@"C", @40],
                              @[@"C#/Db", @41],
                              @[@"D", @42],
                              @[@"D#/Eb", @43],
                              @[@"E", @44],
                              @[@"F", @45],
                              @[@"F#/Gb", @46],
                              @[@"G", @47],
                              @[@"G#/Ab", @48]
                              ];
    // SET DEFAULT KEYS (fix later)
    self.currentTonic = 3;
    self.currentScale = 0;
    return self;
}

- (void)changePosition:(int)position
{
    self.position = position;
    if (self.numOctaves == 1)
    {
        NSAssert(self.position >= 0 && self.position <= 1, @"Position out of bounds for 1 octaves!");
    }
    if (self.numOctaves == 2)
    {
        NSAssert(self.position == 0, @"Position out of bounds for 2 octaves!");
    }
}
- (void)changeNumOctave:(int)numOctave
{
    self.numOctaves = numOctave;
    if (self.numOctaves == 2) {
        self.position = 0;
    }
    if (self.numOctaves == 1) {
        self.position = 0;
    }
}

- (NSMutableArray*)setKeys
{
    // RESET THE KEYS
    self.keys = [NSMutableArray new];
    // GET THE TYPE OF SCALE
    NSArray* scale = self.scales[self.currentScale][1];
    int scaleNum = (int)[scale count];
    // CALCULATE THE NUMBER OF KEYS
    int numKeys = (int)([scale count] * self.numOctaves) + 1;
    // CALCULATE START NOTE NUM
    int startNoteNum = (int)[self.tonics[self.currentTonic][1] integerValue] + (self.position + 1) * OCTAVE;
    
    for (int i = 0; i < numKeys; ++i)
    {
        Key* key = [Key new];
        key.num = startNoteNum + [scale[i % scaleNum] integerValue] + (i / scaleNum) * OCTAVE;
        [self.keys addObject:key];
    }
    return self.keys;
}

- (NSString*)getTonic
{
    return self.tonics[self.currentTonic][0];
}

- (NSString*)changeTonicLeft
{
    self.currentTonic += 1;
    if (self.currentTonic > [self.tonics count] - 1) {
        self.currentTonic = 0;
    }
    [self setKeys];
    return self.tonics[self.currentTonic][0];
}

- (NSString*)changeTonicRight
{
    self.currentTonic -= 1;
    if (self.currentTonic < 0) {
        self.currentTonic = [self.tonics count] - 1;
    }
    [self setKeys];
    return self.tonics[self.currentTonic][0];
}


- (NSString*)getScale
{
    return self.scales[self.currentScale][0];
}

- (NSString*)changeScaleLeft
{
    self.currentScale += 1;
    if (self.currentScale > [self.scales count] - 1) {
        self.currentScale = 0;
    }
    [self setKeys];
    return self.scales[self.currentScale][0];
}

- (NSString*)changeScaleRight
{
    self.currentScale -= 1;
    if (self.currentScale < 0) {
        self.currentScale = [self.scales count] - 1;
    }
    [self setKeys];
    return self.scales[self.currentScale][0];
}

@end