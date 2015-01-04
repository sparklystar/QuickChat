//
//  LoginViewController.m
//  Ribbit
//
//  Created by Tung Nguyen on 06/12/14.
//  Copyright (c) 2014 Tung Nguyen. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.username.delegate = self;
    self.password.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (IBAction)login:(id)sender {
    NSString *username = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure you entered username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

# pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
