//
//  InboxViewControllerTableViewController.m
//  Ribbit
//
//  Created by Carl Udren on 12/21/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import "InboxViewControllerTableViewController.h"
#import "ImageViewController.h"

@interface InboxViewControllerTableViewController ()

@end

@implementation InboxViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current User %@", currentUser);

    }else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    }
    }

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"recipients" equalTo:[[PFUser currentUser] objectId]];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            else {
                //Messages do exist
                self.messages = objects;
                [self.tableView reloadData];
            }
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}


- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    return cell;
}


#pragma mark - Table View Delegate


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showImage"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;

    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else {
        //video file
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        
        //add movie player to view controller
        
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
        //[self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
    
    //delete recipients
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipients"]];
    if ([recipientIds count] == 1) {
        //delete message
        [self.selectedMessage deleteInBackground];
    }else{
        //delete recipient
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipients"];
        [self.selectedMessage saveInBackground];
    }
}
@end
