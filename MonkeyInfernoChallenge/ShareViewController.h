//
//  ShareViewController.h
//  MonkeyInfernoChallenge
//
//  Created by Neil Dwyer on 8/15/14.
//  Copyright (c) 2014 Neil Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *linkToShare;
@property (nonatomic, strong) NSString *titleToShare;

@end
