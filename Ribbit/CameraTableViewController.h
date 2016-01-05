//
//  CameraTableViewController.h
//  Ribbit
//
//  Created by Carl Udren on 1/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *videoFilePath;
@property (nonatomic, strong)NSArray *friends;
@property (nonatomic, strong)PFRelation *friendsRelation;
@property (nonatomic, strong)NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

-(void)uploadMessage;
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

@end