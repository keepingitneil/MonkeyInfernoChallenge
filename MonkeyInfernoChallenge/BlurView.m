//
//  BlurView.m
//  MonkeyInfernoChallenge
//
//  Created by Neil Dwyer on 8/15/14.
//  Copyright (c) 2014 Neil Dwyer. All rights reserved.
//

#import "BlurView.h"

@implementation BlurView
{
    float _currentBlurRadius;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentBlurRadius = 10;
        self.blurRadius = _currentBlurRadius;
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.hidden = YES;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.hidden = NO;
}

//if time permits fix this
-(void) animateBlurRadius
{
    _currentBlurRadius -= 1.0;
    if(_currentBlurRadius > 0)
    {
        self.blurRadius = _currentBlurRadius;
        [self setNeedsDisplay];
        [self performSelector:@selector(animateBlurRadius) withObject:nil afterDelay:.01];
    }
    else
    {
        _currentBlurRadius = 0;
        self.blurRadius = _currentBlurRadius;

    }
}

@end
