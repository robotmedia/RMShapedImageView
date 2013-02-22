/*
 Copyright 2013 Robot Media SL (http://www.robotmedia.net)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
//
//  RMShapedImageViewTests.m
//  RMShapedImageViewTests
//
//  Created by Hermes Pique on 2/21/13.
//  Copyright (c) 2013 Robot Media. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RMShapedImageView.h"

@interface RMShapedImageViewTests : SenTestCase

@end

@implementation RMShapedImageViewTests {
    RMShapedImageView *_view;
    
}

- (UIImage*) transparentImageWithSize:(CGSize)size withOpaqueRect:(CGRect)opaqueRect
{
    CGRect rect = CGRectMake(0, 0, size.width, size.width);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, opaqueRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setUp
{
    [super setUp];
}

- (void) testInitWithFrame
{
    _view = [[RMShapedImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    STAssertNotNil(_view, @"");
}

- (void) testInitWithCoder
{
    _view = [[RMShapedImageView alloc] initWithCoder:nil];
    STAssertNotNil(_view, @"");
}

- (void)testPointInsideImageNil
{
    _view = [[RMShapedImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    BOOL result = [_view pointInside:CGPointMake(0, 0) withEvent:nil];
    STAssertFalse(result, @"");
}

- (void)testPointInsideOutside
{
    _view = [[RMShapedImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    BOOL result = [_view pointInside:CGPointMake(-50, -50) withEvent:nil];
    STAssertFalse(result, @"");
}

- (void)testPointInsideYES
{
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    _view = [[RMShapedImageView alloc] initWithFrame:imageRect];
    CGRect opaqueRect = CGRectMake(10, 10, 10, 10);
    _view.image = [self transparentImageWithSize:imageRect.size withOpaqueRect:opaqueRect];
    CGPoint point = CGPointMake(CGRectGetMidX(opaqueRect), CGRectGetMidY(opaqueRect));
    BOOL result = [_view pointInside:point withEvent:nil];
    STAssertTrue(result, @"");
}

- (void)testPointInsideNO
{
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    _view = [[RMShapedImageView alloc] initWithFrame:imageRect];
    _view.image = [self transparentImageWithSize:imageRect.size withOpaqueRect:CGRectZero];
    CGPoint point = CGPointMake(CGRectGetMidX(imageRect), CGRectGetMidY(imageRect));
    BOOL result = [_view pointInside:point withEvent:nil];
    STAssertFalse(result, @"");
}


@end
