//
//  SocialSingleton.h
//  PortalPhysics
//
//  Created by Neil Dwyer on 6/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialSingleton : NSObject <UIAlertViewDelegate>

+(SocialSingleton *)sharedInstance;

-(void) shareLink:(NSString *)link WithTitle:(NSString *)title ToFacebookCompletionSelector:(SEL) completedSelector FailedSelector:(SEL)failedSelector Sender:(id)sender;

-(void) shareLink:(NSString *)link WithTitle:(NSString *)title ToTwitterCompletionSelector:(SEL) completedSelector FailedSelector:(SEL) failedSelector Sender:(id)sender;

@end
