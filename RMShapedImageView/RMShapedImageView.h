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
//  RMShapedImageView.h
//  RMShapedImageView
//
//  Created by Hermes Pique on 2/21/13.
//  Copyright (c) 2013 Robot Media. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A UIImageView subclass that ignores touches on transparent pixels, based on OBShapedButton by Ole Begemann.
 
 RMShapedImageView does it magic by overriding pointInside:withEvent:. This method is called to determine if a touch is inside the view. In our case, we only want to return YES if the corresponding pixels are not transparent.
 */
@interface RMShapedImageView : UIImageView

/** Number of pixels around the point that will be examined. If at least one of them has alpha bigger than shapedTransparentMaxAlpha pointInside:withEvent: will return YES. 0 by default.
 */
@property (nonatomic, assign) NSUInteger shapedPixelTolerance;

/** Maximum alpha value that will be considered transparent. 0 by default.
 */
@property (nonatomic, assign) CGFloat shapedTransparentMaxAlpha;

/** Returns YES if shape is supported, NO otherwise. If shape is not supported pointInside:withEvent: will return the same than super.
 */
@property (nonatomic, readonly) BOOL shapedSupported;

@end
