//
//  ImageViewController.m
//  Ribbit
//
//  Created by Carl Udren on 1/3/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *navTitle = [NSString stringWithFormat:@"Sent From: %@", senderName];
    self.navigationItem.title = navTitle;
    
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }else {
        NSLog(@"Selector missing!");
    }
}


#pragma mark - Helper Methods

-(void)timeout{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
