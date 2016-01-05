//
//  LoginViewController.m
//  Ribbit
//
//  Created by Carl Udren on 12/25/15.
//  Copyright © 2015 Carl Udren. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([username length] == 0 || [password length] == 0) {
        
        UIAlertController* alertView = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                           message:@"Please enter a username and password."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alertView addAction:defaultAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
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
