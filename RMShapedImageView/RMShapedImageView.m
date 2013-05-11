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
    
    // Image might be scaled or translated due to contentMode. We want to convert the view point into an image point first.
    CGPoint imagePoint = [self imagePointFromViewPoint:point];

    BOOL result = [self isAlphaVisibleAtImagePoint:imagePoint];
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

- (CGPoint)imagePointFromViewPoint:(CGPoint)viewPoint
{
    switch (self.contentMode) {
        case UIViewContentModeScaleToFill:
        {
            CGSize imageSize = self.image.size;
            CGSize boundsSize = self.bounds.size;
            viewPoint.x *= (boundsSize.width != 0) ? (imageSize.width / boundsSize.width) : 1;
            viewPoint.y *= (boundsSize.height != 0) ? (imageSize.height / boundsSize.height) : 1;
            return viewPoint;
        }
            break;
        case UIViewContentModeTopLeft:
            return viewPoint;
        default: // TODO: Handle the rest of contentMode values
            return viewPoint;
    }
}

- (BOOL)isAlphaVisibleAtImagePoint:(CGPoint)point
{
    CGRect queryRect;
    {
        CGRect imageRect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        NSInteger pointRectWidth = self.shapedPixelTolerance * 2 + 1;
        CGRect pointRect = CGRectMake(point.x - self.shapedPixelTolerance, point.y - self.shapedPixelTolerance, pointRectWidth, pointRectWidth);
        queryRect = CGRectIntersection(imageRect, pointRect);
        if (CGRectIsNull(queryRect)) return NO;
    }
    
    CGContextRef context;
    unsigned char *data;
    NSUInteger pixelCount;
    {
        // TODO: Wouldn't it be better to use drawInRect:. See: http://stackoverflow.com/questions/15008270/get-alpha-channel-from-uiimage-rectangle
        CGSize querySize = queryRect.size;
        NSUInteger bytesPerPixel = sizeof(unsigned char);
        const NSUInteger bitsPerComponent = 8;
        pixelCount = querySize.width * querySize.height;
        data = (unsigned char*) calloc(pixelCount, bytesPerPixel);
        context = CGBitmapContextCreate(data,
                                        querySize.width,
                                        querySize.height,
                                        bitsPerComponent,
                                        bytesPerPixel * querySize.width,
                                        NULL, // colorspace can be NULL when using kCGImageAlphaOnly. See: http://developer.apple.com/library/mac/#qa/qa1037/_index.html
                                        kCGImageAlphaOnly);
    }

    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -queryRect.origin.x, queryRect.origin.y-(CGFloat)self.image.size.height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)self.image.size.width, (CGFloat)self.image.size.height), self.image.CGImage);
    
    for (int i = 0; i < pixelCount; i++)
    {
        unsigned char alphaChar = data[i];
        CGFloat alpha = alphaChar / 255.0;
        if (alpha > self.shapedTransparentMaxAlpha)
        {
            CGContextRelease(context);
            free(data);
            return YES;
        }
    }
    CGContextRelease(context);
    free(data);
    return NO;
}

- (void)resetPointInsideCache
{
    _previousPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    _previousPointInsideResult = NO;
}

@end
