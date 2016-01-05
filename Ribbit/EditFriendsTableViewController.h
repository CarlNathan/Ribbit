//
//  EditFriendsTableViewController.h
//  Ribbit
//
//  Created by Carl Udren on 12/30/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *allusers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

-(BOOL) isFriend:(PFUser *)user;


@end
