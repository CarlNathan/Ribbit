//
//  FriendsTableViewController.h
//  Ribbit
//
//  Created by Carl Udren on 12/30/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsTableViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property(nonatomic, strong) NSArray *friends;

@end
