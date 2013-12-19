//
//  ScaleTonicView.m
//  Scales
//
//  Created by Kevin Choi on 12/1/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import "ScaleTonicView.h"

@implementation ScaleTonicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setBackgroundColor:[UIColor blackColor]];
        // SET UP TONIC LABEL
        self.tonicLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.tonicLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self.tonicLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1]];
        UIFont *font = [self.tonicLabel font];
        [self.tonicLabel setFont:[font fontWithSize:40.0]];
        [self.tonicLabel setTextAlignment:NSTextAlignmentCenter];
        //[self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        //[self.titleLabel setMinimumScaleFactor:1.0/[UIFont labelFontSize]];
        
        [self addSubview:self.tonicLabel];
        
        // SET SWIPE GESTURE RECOGNIZERS
        self.swipeGestureLeftRecognizer = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handleSwipes:)];
        self.swipeGestureLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.swipeGestureLeftRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:self.swipeGestureLeftRecognizer];
        
        self.swipeGestureRightRecognizer = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handleSwipes:)];
        self.swipeGestureRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        self.swipeGestureRightRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:self.swipeGestureRightRecognizer];
        
        self.animationRunning = NO;
    }
    return self;
}

- (void)setTonic:(NSString*)tonic
{
    [self.tonicLabel setText:tonic];
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.tonicLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
     }
                     completion:nil
     ];
}

- (void)handleSwipes:(UISwipeGestureRecognizer*)paramSender
{
    if ((paramSender.direction == UISwipeGestureRecognizerDirectionLeft) & !self.animationRunning){
        // NSLog(@"Swiped Left.");
        if (self.delegate != nil) {
            self.animationRunning = YES;
            [UIView animateWithDuration:0.2f
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^
             {
                 self.tonicLabel.center = CGPointMake(-self.frame.size.width, self.tonicLabel.center.y);
             }
                             completion:^(BOOL finished)
             {
                 [UIView animateWithDuration:0.2f
                                       delay:0
                                     options:UIViewAnimationOptionCurveEaseInOut
                                  animations:^
                  {
                      self.tonicLabel.center = CGPointMake(2*self.frame.size.width, self.tonicLabel.center.y);
                      [self.delegate swipeTonicLeft];
                  }
                                  completion:^(BOOL finished)
                  {
                      
                      self.animationRunning = NO;
                  }
                  ];
             }];
        }
    }
    if ((paramSender.direction == UISwipeGestureRecognizerDirectionRight) & !self.animationRunning){
        // NSLog(@"Swiped Right.");
        if (self.delegate != nil) {
            self.animationRunning = YES;
            [UIView animateWithDuration:0.2f
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^
             {
                 self.tonicLabel.center = CGPointMake(2*self.frame.size.width, self.tonicLabel.center.y);
             }
                             completion:^(BOOL finished)
             {
                 [UIView animateWithDuration:0.2f
                                       delay:0
                                     options:UIViewAnimationOptionCurveEaseInOut
                                  animations:^
                  {
                      self.tonicLabel.center = CGPointMake(-self.frame.size.width, self.tonicLabel.center.y);
                      [self.delegate swipeTonicRight];
                  }
                                  completion:^(BOOL finished)
                  {
                      self.animationRunning = NO;
                  }
                  ];
             }];
        }
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
