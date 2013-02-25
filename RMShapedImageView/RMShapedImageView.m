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
//  RMShapedImageView.m
//  RMShapedImageView
//
//  Created by Hermes Pique on 2/21/13.
//  Copyright (c) 2013 Robot Media. All rights reserved.
//

#import "RMShapedImageView.h"

@implementation RMShapedImageView {
    CGPoint _previousPoint;
    BOOL _previousPointInsideResult;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void) initHelper
{
    _previousPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) return NO;
    if (!self.shapedSupported) return YES;
    if (!self.image) return NO;
    if (CGPointEqualToPoint(point, _previousPoint)) return _previousPointInsideResult;
    
    _previousPoint = point;
    BOOL result = [self isAlphaVisibleAtPoint:point];
    _previousPointInsideResult = result;
    return result;
}

#pragma mark - UIImageView

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self resetPointInsideCache];
}

#pragma mark - RMShapedImageView

- (BOOL) shapedSupported
{
    if (!self.image) return YES;
    switch (self.contentMode)
    {
        case UIViewContentModeScaleToFill:
        case UIViewContentModeTopLeft:
            return YES;
        default:
            return NO;
    }
}

#pragma mark - Private

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point
{
    switch (self.contentMode) {
        case UIViewContentModeScaleToFill:
        {
            CGSize imageSize = self.image.size;
            CGSize boundsSize = self.bounds.size;
            point.x *= (boundsSize.width != 0) ? (imageSize.width / boundsSize.width) : 1;
            point.y *= (boundsSize.height != 0) ? (imageSize.height / boundsSize.height) : 1;
        }
            break;
        case UIViewContentModeTopLeft: // Do nothing
            break;
        default: // TODO: Handle the rest of contentMode values
            break;
    }
    
    return [self isAlphaVisibleAtImagePoint:point];
}

- (BOOL)isAlphaVisibleAtImagePoint:(CGPoint)point
{
    CGRect imageRect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    NSInteger pointRectWidth = self.shapedPixelTolerance * 2 + 1;
    CGRect pointRect = CGRectMake(point.x - self.shapedPixelTolerance, point.y - self.shapedPixelTolerance, pointRectWidth, pointRectWidth);
    CGRect queryRect = CGRectIntersection(imageRect, pointRect);
    if (CGRectIsNull(queryRect)) return NO;
    
    // TODO: Do we really need to get the whole color information? See: http://stackoverflow.com/questions/15008270/get-alpha-channel-from-uiimage-rectangle
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = sizeof(unsigned char) * 4;
    NSUInteger bitsPerComponent = 8;
    NSUInteger pixelCount = queryRect.size.width * queryRect.size.height;
    unsigned char *data = (unsigned char*) calloc(pixelCount * 4, sizeof(unsigned char));
    CGContextRef context = CGBitmapContextCreate(data,
                                                 queryRect.size.width,
                                                 queryRect.size.height,
                                                 bitsPerComponent,
                                                 bytesPerPixel * queryRect.size.width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -queryRect.origin.x, queryRect.origin.y-(CGFloat)self.image.size.height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)self.image.size.width, (CGFloat)self.image.size.height), self.image.CGImage);
    CGContextRelease(context);
    
    for (int i = 0; i < pixelCount; i++)
    {
        int j = i * 4;
        unsigned char alphaChar = data[j + 3];
        CGFloat alpha = alphaChar / 255.0;
        if (alpha > self.shapedTransparentMaxAlpha)
        {
            return YES;
        }
    }
    return NO;
}

- (void)resetPointInsideCache
{
    _previousPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    _previousPointInsideResult = NO;
}

@end
