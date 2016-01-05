//
//  SignupViewController.m
//  Ribbit
//
//  Created by Carl Udren on 12/25/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        
        UIAlertController* alertView = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                message:@"Please enter a username, password and Email address."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alertView addAction:defaultAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else{
        PFUser *newuser = [PFUser user];
        newuser.username = username;
        newuser.password = password;
        newuser.email = email;
        
        [newuser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error){
                UIAlertController* alertView = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                                   message:[error.userInfo objectForKey:@"error"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alertView addAction:defaultAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
}
@end
