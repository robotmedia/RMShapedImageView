//
//  RMViewController.m
//  RMShapedImageViewDemo
//
//  Created by Hermes Pique on 2/21/13.
//  Copyright (c) 2013 Robot Media. All rights reserved.
//

#import "RMViewController.h"

@implementation RMViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.transformedImageView.transform = CGAffineTransformMakeScale(200, 1);
}

- (IBAction)onGestureRecognized:(id)sender
{
    NSLog(@"Hit");
}

@end
