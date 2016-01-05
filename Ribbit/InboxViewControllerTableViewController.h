//
//  InboxViewControllerTableViewController.h
//  Ribbit
//
//  Created by Carl Udren on 12/21/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewControllerTableViewController : UITableViewController

@property (nonatomic, strong)NSArray *messages;
@property (nonatomic, strong)PFObject *selectedMessage;
@property (nonatomic, strong)MPMoviePlayerController *moviePlayer;

- (IBAction)logOut:(id)sender;

@end
