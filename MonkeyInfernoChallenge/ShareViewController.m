//
//  ShareViewController.m
//  MonkeyInfernoChallenge
//
//  Created by Neil Dwyer on 8/15/14.
//  Copyright (c) 2014 Neil Dwyer. All rights reserved.
//

#import "ShareViewController.h"
#import "SocialSingleton.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)twitterButton:(id)sender
{
    [[SocialSingleton sharedInstance] shareLink:_linkToShare WithTitle:_titleToShare ToTwitterCompletionSelector:@selector(shareComplete) FailedSelector:@selector(shareFailed) Sender:self];
}

- (IBAction)facebookButton:(id)sender
{
    [[SocialSingleton sharedInstance] shareLink:_linkToShare WithTitle:_titleToShare ToFacebookCompletionSelector:@selector(shareComplete) FailedSelector:@selector(shareFailed) Sender:self];
}


-(void) shareComplete
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Sharing worked" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
    });
}

-(void) shareFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Sharing Failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
