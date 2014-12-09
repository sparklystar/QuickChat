//
//  ImageViewController.m
//  Ribbit
//
//  Created by Tung Nguyen on 08/12/14.
//  Copyright (c) 2014 Tung Nguyen. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Error: selector missing!");
    }
}

#pragma mark - Helper methods
- (void)timeout {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
