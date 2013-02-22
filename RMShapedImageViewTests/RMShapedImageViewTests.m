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

- (void)testPointInsideTwice
{
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    _view = [[RMShapedImageView alloc] initWithFrame:imageRect];
    CGRect opaqueRect = CGRectMake(10, 10, 10, 10);
    _view.image = [self transparentImageWithSize:imageRect.size withOpaqueRect:opaqueRect];
    CGPoint point = CGPointMake(CGRectGetMidX(opaqueRect), CGRectGetMidY(opaqueRect));
    [_view pointInside:point withEvent:nil];
    BOOL result = [_view pointInside:point withEvent:nil];
    STAssertTrue(result, @"");
}

- (void)testSetImage
{
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    _view = [[RMShapedImageView alloc] initWithFrame:imageRect];
    _view.image = [self transparentImageWithSize:imageRect.size withOpaqueRect:CGRectZero];
}

- (void)testSetImageNil
{
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    _view = [[RMShapedImageView alloc] initWithFrame:imageRect];
    _view.image = nil;
}

- (void)testShapedSupportedImageNil
{
    _view = [[RMShapedImageView alloc] init];
    STAssertTrue(_view.shapedSupported, @"");
}

- (void)testShapedSupportedImageNotNil
{
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    _view = [[RMShapedImageView alloc] initWithFrame:imageRect];
    _view.image = [self transparentImageWithSize:imageRect.size withOpaqueRect:CGRectZero];

    [self _testShapedSupportedWithContentMode:UIViewContentModeScaleToFill expected:YES];
    [self _testShapedSupportedWithContentMode:UIViewContentModeScaleAspectFit expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeScaleAspectFill expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeRedraw expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeCenter expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeTop expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeBottom expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeLeft expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeTopLeft expected:YES];
    [self _testShapedSupportedWithContentMode:UIViewContentModeTopRight expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeBottomLeft expected:NO];
    [self _testShapedSupportedWithContentMode:UIViewContentModeBottomRight expected:NO];
}

#pragma mark - Helpers

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

- (void)_testShapedSupportedWithContentMode:(UIViewContentMode)contentMode expected:(BOOL)expected
{
    _view.contentMode = contentMode;
    BOOL result = _view.shapedSupported;
    STAssertEquals(expected, result, @"%d", contentMode);
}

@end
