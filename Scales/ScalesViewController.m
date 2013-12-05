//
//  ScalesViewController.m
//  Scales
//
//  Created by Kevin Choi on 11/22/13.
//  Copyright (c) 2013 Kevin Choi. All rights reserved.
//

#import "ScalesViewController.h"

@interface ScalesViewController ()

@end

@implementation ScalesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        // SET TONEGENERATOR
        self.toneGenerator = [ToneGenerator new];
        
        // SET KEYBOARD MODEL
        self.keyboard = [[Keyboard alloc] init];
        
        // SET KEYBOARD VIEW
        self.keyboardView = [[KeyboardView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width/2.0, self.view.frame.size.height, self.view.frame.size.width/2.0)];
        [self.keyboardView setDelegate:self];
        [self.view addSubview:self.keyboardView];
        
        // SET SCALE TITLE VIEW
        self.scaleTitleView = [[ScaleTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width/6.0)];
        [self.scaleTitleView setDelegate:self];
        [self.view addSubview:self.scaleTitleView];
        
        // SET SCALE TONIC VIEW
        self.scaleTonicView = [[ScaleTonicView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width/6.0, self.view.frame.size.height, self.view.frame.size.width/6.0)];
        [self.scaleTonicView setDelegate:self];
        [self.view addSubview:self.scaleTonicView];
        
        // SET OPTIONS VIEW
        self.optionsView = [[OptionsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width/3.0, self.view.frame.size.height, self.view.frame.size.width/6.0)];
        [self.view addSubview:self.optionsView];
        [self.optionsView setDelegate:self];
        
        // SET OCTAVE NUMBER
        [self.optionsView setOctaveNumSegmentedControlPosition:0];
        [self.keyboard setNumOctaves:1];
        
        // SET OCTAVE POSITION
        [self.optionsView setSegmentedControlForOctave:self.keyboard.numOctaves];
        // returns true or false... FIXME
        [self.optionsView setOctivePositionSegmentedControlPosition:2];
        [self.keyboard changePosition:2];
        
        // SET SCALE TITLE
        [self.scaleTitleView setTitle:[self.keyboard getScale]];
        
        // SET SCALE TONIC
        [self.scaleTonicView setTonic:[self.keyboard getTonic]];
        
        // (create keyboard model from the given parameters, hard coded in for now
        [self.keyboard setKeys];
        
        // CREATE KEYS (FIXME) (CREATE KEYS REMOVES FROM VIEW... I THINK)
        int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
        [self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
    }
    return self;
}

- (void)octavePositionChanged:(int)position
{
    // SET OCTAVE POSITION
    [self.optionsView setSegmentedControlForOctave:self.keyboard.numOctaves];
    [self.keyboard changePosition:position];
    
    // (create keyboard model from the given parameters, hard coded in for now
    [self.keyboard setKeys];
    
    // CREATE KEYS (FIXME)
    // int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
    //[self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
}

- (void)octaveNumChanged:(int)num
{
    // SET OCTAVE NUMBER
    [self.optionsView setSegmentedControlForOctave:num];
    [self.keyboard changeNumOctave:num];
    // (create keyboard model from the given parameters, hard coded in for now
    [self.keyboard setKeys];
    
    // CREATE KEYS (FIXME)
    int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
    [self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
}

//
// TONE GENERATOR METHODS
//

- (void)keyPressed:(int)keyNum withAmplitude:(double)amp
{
    Key* key = [[self.keyboard keys] objectAtIndex:keyNum];
    [self.toneGenerator playToneWithFreq:[key getFrequency] andAmplitude:amp];
}

- (void)keyChanged:(int)keyNum withAmplitude:(double)amp
{
    Key* key = [[self.keyboard keys] objectAtIndex:keyNum];
    [self.toneGenerator setFrequency:[key getFrequency] andAmplitude:amp];
}

- (void)keyUnpressed
{
    [self.toneGenerator stop];
}

- (void)swipeScaleLeft
{
    [self.scaleTitleView setTitle:[self.keyboard changeScaleLeft]];
    // CREATE KEYS (FIXME) (CREATE KEYS REMOVES FROM VIEW... I THINK)
    int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
    [self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
}

- (void)swipeScaleRight
{
    [self.scaleTitleView setTitle:[self.keyboard changeScaleRight]];
    // CREATE KEYS (FIXME) (CREATE KEYS REMOVES FROM VIEW... I THINK)
    int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
    [self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
}

- (void)swipeTonicLeft
{
    [self.scaleTonicView setTonic:[self.keyboard changeTonicLeft]];
    // CREATE KEYS (FIXME) (CREATE KEYS REMOVES FROM VIEW... I THINK)
    int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
    [self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
}

- (void)swipeTonicRight
{
    [self.scaleTonicView setTonic:[self.keyboard changeTonicRight]];
    // CREATE KEYS (FIXME) (CREATE KEYS REMOVES FROM VIEW... I THINK)
    int notesInScale = ([[self.keyboard keys] count] - 1) / [self.keyboard numOctaves];
    [self.keyboardView createKeys:[[self.keyboard keys] count] withScale:notesInScale];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
