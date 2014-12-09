//
//  FriendsViewController.h
//  Ribbit
//
//  Created by Tung Nguyen on 07/12/14.
//  Copyright (c) 2014 Tung Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

@end
