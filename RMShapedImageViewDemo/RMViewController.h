//
//  RMViewController.h
//  RMShapedImageViewDemo
//
//  Created by Hermes Pique on 2/21/13.
//  Copyright (c) 2013 Robot Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMShapedImageView.h"

@interface RMViewController : UIViewController

@property (weak, nonatomic) IBOutlet RMShapedImageView *transformedImageView;

- (IBAction)onGestureRecognized:(id)sender;

@end
