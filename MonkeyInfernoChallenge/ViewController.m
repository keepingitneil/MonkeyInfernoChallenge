//
//  ViewController.m
//  MonkeyInfernoChallenge
//
//  Created by Neil Dwyer on 8/15/14.
//  Copyright (c) 2014 Neil Dwyer. All rights reserved.
//

#import "ViewController.h"
#import "FXBlurView.h"
#import "BlurView.h"
#import "ShareViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *jokeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jokeImage;
@property (weak, nonatomic) IBOutlet BlurView *blurView;

@end

@implementation ViewController
{
    NSUInteger _currentPage;
    NSUInteger _currentIndex;
    
    NSDictionary *_currentFatData;
    NSArray *_currentSkimmedData;
    
    NSString *_currentLink;
    NSString *_currentTitle;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _currentPage = 0;
    _currentIndex = 0;
    
    [self newJoke];
}

-(void) viewWillAppear:(BOOL)animated
{
    _blurView.blurRadius = 8;
    
    [self scaleBlur];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchFromImgur
{
    //e4df7dea7ee72de <--client ID
    //e8026e0930afd42ae421935b087004f335f927ac <--client secret
    _currentIndex = 0;
    
    // Create the request.
    NSString *stringForUrl = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/r/funny/time/%i.json",_currentPage];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringForUrl]];
    [request setValue:@"Client-ID e4df7dea7ee72de" forHTTPHeaderField:@"Authorization"];
    
    // Create url connection and fire request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    _currentPage++;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _currentFatData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _currentSkimmedData = [_currentFatData objectForKey:@"data"];
    
    //0 index to prevent race condition/thread problems, should always be 0 anyways
    [self updateJokeViewsWithIndex:0 Data:_currentSkimmedData];
}


- (IBAction)newJokeButton:(id)sender
{
    [self newJoke];
}

-(void) newJoke
{
    if(!_currentSkimmedData || (_currentIndex >= _currentSkimmedData.count))
    {
        [self fetchFromImgur];
    }
    else
    {
        [self updateJokeViewsWithIndex:_currentIndex Data:_currentSkimmedData];
    }
    
    _currentIndex++;
}

-(void) updateJokeViewsWithIndex:(NSUInteger)index Data:(NSArray *)data
{
    
    NSDictionary *currentJokeDict = [data objectAtIndex:index];
    NSString *title = [currentJokeDict objectForKey:@"title"];
    NSString *imageUrl = [currentJokeDict objectForKey:@"link"];
    _currentLink = imageUrl;
    _currentTitle = title;
    
    UIImage *rawImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    _jokeImage.image = rawImage;
    
    [self scaleBlur];
    
    _jokeLabel.text = title;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"shareSegue"])
    {
        ShareViewController *destinationVC = segue.destinationViewController;
        destinationVC.linkToShare = _currentLink;
        destinationVC.titleToShare = _currentTitle;
        
    }
}

-(void) scaleBlur
{
    float scaleX = 0;
    float scaleY = 0;
    float rawWidth = CGImageGetWidth(_jokeImage.image.CGImage);
    float rawHeight = CGImageGetHeight(_jokeImage.image.CGImage);
    if(_jokeImage.image)
    {
        scaleX = _jokeImage.frame.size.width/rawWidth;
        scaleY = _jokeImage.frame.size.height/rawHeight;
    }
    
    CGRect rectangle;
    if(scaleX >= scaleY)
    {
            rectangle = CGRectMake(_jokeImage.frame.origin.x + (_jokeImage.frame.size.width - rawWidth * scaleY) * .5, _jokeImage.frame.origin.y, _jokeImage.image.size.width * scaleY, _jokeImage.image.size.height * scaleY);
    }
    else
    {
            rectangle = CGRectMake(_jokeImage.frame.origin.x, _jokeImage.frame.origin.y + (_jokeImage.frame.size.height - rawHeight * scaleX) * .5, _jokeImage.image.size.width * scaleX, _jokeImage.image.size.height * scaleX);
    }

    _blurView.frame = rectangle;
    [_blurView setNeedsDisplay];
}




@end
