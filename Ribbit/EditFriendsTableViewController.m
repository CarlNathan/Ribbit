//
//  EditFriendsTableViewController.m
//  Ribbit
//
//  Created by Carl Udren on 12/30/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import "EditFriendsTableViewController.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            self.allusers = objects;
            [self.tableView reloadData];
        }
    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allusers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allusers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.allusers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    if ([self isFriend:user]){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (PFUser *friend in self.friends){
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }}
        [friendsRelation removeObject:user];
        }
    else{
        [friendsRelation addObject:user];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
    }
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }

#pragma mark - Helper methods

-(BOOL) isFriend:(PFUser *)user{
    
    for (PFUser *friend in self.friends){
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
    }



@end
