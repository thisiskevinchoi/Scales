//
//  Key.m
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import "Key.h"

@implementation Key

- (float)getFrequency
{
    float freq = pow(2.0, (self.num - 49)/12.0) * 440.0;
    return freq;
}

- (void)transposeOctaveUp
{
    self.num += 12;
    NSAssert(self.num > 0, @"Key value under 0");
}

- (void)transposeOctaveDown
{
    self.num -= 12;
    NSAssert(self.num < 88, @"Key value over 88");
}

@end
