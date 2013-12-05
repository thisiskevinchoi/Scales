//
//  KeyboardView.m
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import "KeyboardView.h"

@implementation KeyboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)createKeys:(int)numKeysTotal withScale:(int)numKeysInScale
{
    for (KeyView* key in self.keys) {
        [key removeFromSuperview];
    }
    // Create keys
    self.keys = [NSMutableArray new];
    float spacing = 3.0;
    float width = (self.frame.size.width - (float)(numKeysTotal + 1) * spacing) / (float)numKeysTotal;
    
    float x = spacing;
    for (int i = 0; i < numKeysTotal; ++i) {
        CGRect frame = CGRectMake(x, 0, width, self.frame.size.height - spacing);
        KeyView* key = [[KeyView alloc] initWithFrame:frame];
        if (i % numKeysInScale == 0)
        {
            [key setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1]];
        }
        else
        {
            [key setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1]];
        }
        x += spacing + width;
        
        [self.keys addObject:key];
        [self addSubview:key];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1) {
        NSSet* touches = [event allTouches];
        for (int keyIndex = 0; keyIndex < [self.keys count]; ++keyIndex) {
            KeyView* key = self.keys[keyIndex];
            for (UITouch* touch in touches) {
                CGPoint location = [touch locationInView:self];
                if(CGRectContainsPoint(key.frame, location))
                {
                    if (self.delegate != nil)
                    {
                        double amp = (((160.0 - location.y) / 160.0) * .7) + .1;
                        [self.delegate keyChanged:keyIndex withAmplitude:amp];
                    }
                }
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1) {
        NSSet* touches = [event allTouches];
        for (int keyIndex = 0; keyIndex < [self.keys count]; ++keyIndex) {
            KeyView* key = self.keys[keyIndex];
            for (UITouch* touch in touches) {
                CGPoint location = [self convertPoint:[touch locationInView:self] fromView:self];
                // NSLog(@"%f, %f", location.x, location.y);
                // NSLog(@"%f, %f", key.frame.origin.x, key.frame.origin.y);
                if(CGRectContainsPoint(key.frame, location))
                {
                    if (self.delegate != nil)
                    {
                        double amp = (((160.0 - location.y) / 160.0) * .7) + .1;
                        [self.delegate keyPressed:keyIndex withAmplitude:amp];
                    }
                }
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.delegate != nil)
    {
        [self.delegate keyUnpressed];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
