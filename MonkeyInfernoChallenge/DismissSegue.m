//
//  DismissSegue.m
//  MonkeyInfernoChallenge
//
//  Created by Neil Dwyer on 8/15/14.
//  Copyright (c) 2014 Neil Dwyer. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

-(void) perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
