//
//  SocialSingleton.m
//  PortalPhysics
//
//  Created by Neil Dwyer on 6/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialSingleton.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation SocialSingleton
{
    ACAccount *_twitterAccount;
    ACAccount *_facebookAccount;
}

+(SocialSingleton *)sharedInstance
{
    static SocialSingleton *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[SocialSingleton alloc] init];
    });
    
    return sharedInstance;
}

-(void) shareLink:(NSString *)link WithTitle:(NSString *)title ToFacebookCompletionSelector:(SEL) completedSelector FailedSelector:(SEL)failedSelector Sender:(id)sender
{
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.name = title;
    params.link = [NSURL URLWithString:link];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params])
    {
        // Present share dialog
        [FBDialogs presentShareDialogWithParams:params clientState:nil handler:
                                      ^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error)
                                          {
                                              [sender performSelector:failedSelector withObject:nil];
                                          }
                                          else
                                          {
                                              // Success
                                              [sender performSelector:completedSelector withObject:nil];
                                              
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    }
    else
    {
        // Present the feed dialog
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       title, @"name",
                                       link, @"link",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      }
                                                      else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted)
                                                          {
                                                              // User cancelled.
                                                              [sender performSelector:failedSelector withObject:nil];
                                                          }
                                                          else
                                                          {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"])
                                                              {
                                                                  // User cancelled.
                                                                  [sender performSelector:failedSelector withObject:nil];
                                                                  
                                                              }
                                                              else
                                                              {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  [sender performSelector:completedSelector withObject:nil];
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void) shareLink:(NSString *)link WithTitle:(NSString *)title ToTwitterCompletionSelector:(SEL) completedSelector FailedSelector:(SEL) failedSelector Sender:(id)sender
{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL;
                 NSDictionary *parameters;
                 
                 requestURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
                 parameters = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",title,link],@"status",@"true",@"wrap_links", nil];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:parameters];
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:^(NSData *responseData,
                                                          NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      if(urlResponse.statusCode == 200)
                      {
                          [sender performSelector:completedSelector withObject:nil];
                      }
                  }];
                 
             }
             else
             {
                 [sender performSelector:failedSelector withObject:nil];
             }
             
         }
         else
         {
             [sender performSelector:failedSelector withObject:nil];
         }
     }];
}

-(void) twitterCompletion
{
    NSLog(@"Twitter Share successful");
}

-(void) facebookCompletion
{
    NSLog(@"Facebook Share successful");
}

@end
