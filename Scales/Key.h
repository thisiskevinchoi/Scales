//
//  Key.h
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Key : NSObject

@property int num;

- (float)getFrequency;
- (void)transposeOctaveUp;
- (void)transposeOctaveDown;

@end