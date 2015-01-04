//
//  InboxViewController.m
//  Ribbit
//
//  Created by Tung Nguyen on 06/12/14.
//  Copyright (c) 2014 Tung Nguyen. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        [self retrieveMessages];
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    NSString *fileType = [message objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"image"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"video"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileURL = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileURL;
        [self.moviePlayer prepareToPlay];
        
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientids"]];
    NSLog(@"Recipients: %@", recipientIds);
    
    if ([recipientIds count] == 1) {
        [self.selectedMessage deleteInBackground];
    } else {
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
    }
}

#pragma mark - Helper methods
- (void)retrieveMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.messages = objects;
            [self.tableView reloadData];
            NSLog(@"Retrieved %d messages", (int)[self.messages count]);
        }
        
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

@end
