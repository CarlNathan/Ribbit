//
//  CameraTableViewController.m
//  Ribbit
//
//  Created by Carl Udren on 1/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "CameraTableViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraTableViewController ()

@end

@implementation CameraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc]init];
                                   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else{
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];

    
    if (self.image ==nil && [self.videoFilePath length] == 0) {
        
    
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
            [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipients containsObject:user.objectId]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //photoselected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        }else{
            //video selected
            self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
            if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
                //save video
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
                }
            }
        }
    [self dismissViewControllerAnimated:YES completion:nil];

    }

#pragma mark - IBActions


- (IBAction)cancel:(id)sender {
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertController* alertView = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                           message:@"Your message is blank.  Please try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alertView addAction:defaultAction];
        [self presentViewController:alertView animated:YES completion:nil];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else{
        //send message
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper Methods

-(void)uploadMessage{
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }
    else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            UIAlertController* alertView = [UIAlertController alertControllerWithTitle:@"An Error has occured!"
                                                                               message:@"Please try sending your message again."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alertView addAction:defaultAction];
            [self presentViewController:alertView animated:YES completion:nil];


        }
        else {
            PFObject *message = [PFObject objectWithClassName:@"Message"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipients"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error){
                    UIAlertController* alertView = [UIAlertController alertControllerWithTitle:@"An Error has occured!"
                                                                                       message:@"Please try sending your message again."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    [alertView addAction:defaultAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                    
                }
                else {
                    //Everything has worked!
                    [self reset];
                }
            }];
        }
    }];
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
@end
