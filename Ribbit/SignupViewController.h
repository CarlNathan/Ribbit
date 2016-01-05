//
//  SignupViewController.h
//  Ribbit
//
//  Created by Carl Udren on 12/25/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;



- (IBAction)signup:(id)sender;

@end
