//
//  ScaleView.m
//  Scales
//
//  Created by Kevin Choi on 11/28/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import "OptionsView.h"

@implementation OptionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // SET UP OCTAVE POSITION SEGMENTED VIEW
        [self setUpOctavePositionSegmentedControl];
        
        // SET UP OCTAVE NUMBER SEGMENTED VIEW
        [self setUpOctaveNumSegmentedControl];
        
        // SET UP SOUND WAVE SEGMENTED VIEW
        [self setUpSoundWaveSegmentedControl];
        
    }
    return self;
}

//
// METHODS FOR OCTAVE POSITION
//

- (void)setUpOctavePositionSegmentedControl
{
    self.oneOctavePositionSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"-", @"+"]];
    self.twoOctavePositionSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"="]];
    
    self.oneOctavePositionSegmentedControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.twoOctavePositionSegmentedControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    self.oneOctavePositionSegmentedControl.tintColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    self.twoOctavePositionSegmentedControl.tintColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    
    [self.oneOctavePositionSegmentedControl addTarget:self action:@selector(octavePositionSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.twoOctavePositionSegmentedControl addTarget:self action:@selector(octavePositionSegmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setOctivePositionSegmentedControlPosition:(int)position
{
    [self.oneOctavePositionSegmentedControl setSelectedSegmentIndex:position];
    [self.twoOctavePositionSegmentedControl setSelectedSegmentIndex:position];
}

- (void)octavePositionSegmentChanged:(UISegmentedControl *)paramSender
{
    NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
    [self setOctivePositionSegmentedControlPosition:(int)selectedSegmentIndex];
    if (self.delegate != nil) {
        [self.delegate octavePositionChanged:(int)selectedSegmentIndex];
    }
}

- (void)setSegmentedControlForOctave:(int)numOctaves
{
    [self setOctivePositionSegmentedControlPosition:0];
    [self.oneOctavePositionSegmentedControl removeFromSuperview];
    [self.twoOctavePositionSegmentedControl removeFromSuperview];
    if (numOctaves == 1)
    {
        [self addSubview:self.oneOctavePositionSegmentedControl];
    }
    else if (numOctaves == 2)
    {
        [self addSubview:self.twoOctavePositionSegmentedControl];
    }
}

//
// METHODS FOR OCTAVE NUMBER
//

- (void)setUpOctaveNumSegmentedControl
{
    self.octaveNumSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1 Octave", @"2 Octaves"]];
    
    self.octaveNumSegmentedControl.center = CGPointMake(self.frame.size.width/4, self.frame.size.height/2);
    
    self.octaveNumSegmentedControl.tintColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    
    [self.octaveNumSegmentedControl addTarget:self action:@selector(octaveNumSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.octaveNumSegmentedControl];
}

- (void)setOctaveNumSegmentedControlPosition:(int)position
{
    [self.octaveNumSegmentedControl setSelectedSegmentIndex:position];
}

- (void)octaveNumSegmentChanged:(UISegmentedControl *)paramSender
{
    NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
    [self setOctaveNumSegmentedControlPosition:(int)selectedSegmentIndex];
    if (self.delegate != nil) {
        [self.delegate octaveNumChanged:(int)selectedSegmentIndex+1];
    }
}

//
// METHODS FOR SOUND WAVE
//

- (void)setUpSoundWaveSegmentedControl
{
    self.soundWaveSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Sine", @"Square", @"Sawtooth", @"Triangle"]];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.soundWaveSegmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    self.soundWaveSegmentedControl.center = CGPointMake(8.15*self.frame.size.width/10.0, self.frame.size.height/2);
    
    self.soundWaveSegmentedControl.tintColor = [UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    
    [self.soundWaveSegmentedControl addTarget:self action:@selector(soundWaveSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.soundWaveSegmentedControl];

}

- (void)setSoundWaveSegmentedControlPosition:(int)position
{
    [self.soundWaveSegmentedControl setSelectedSegmentIndex:position];
}

- (void)soundWaveSegmentChanged:(UISegmentedControl *)paramSender
{
    NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
    [self setSoundWaveSegmentedControlPosition:(int)selectedSegmentIndex];
    if (self.delegate != nil) {
        [self.delegate soundWaveNumChanged:(int)selectedSegmentIndex];
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
