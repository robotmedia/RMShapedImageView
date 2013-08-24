RMShapedImageView
=================
[![Build Status](https://travis-ci.org/robotmedia/RMShapedImageView.png)](https://travis-ci.org/robotmedia/RMShapedImageView)

A `UIImageView` subclass that ignores touches on transparent pixels, based on [OBShapedButton](https://github.com/ole/OBShapedButton) by Ole Begemann. 

`RMShapedImageView` does it magic by overriding `pointInside:withEvent:`. This method is called to determine if a touch is inside the view. In our case, we only want to return `YES` if the corresponding pixels are not transparent (`alpha > 0`).

Usage
-----

1. Add [`RMShapedImageView.h`](https://github.com/robotmedia/RMShapedImageView/blob/master/RMShapedImageView/RMShapedImageView.h) and [`RMShapedImageView.m`](https://github.com/robotmedia/RMShapedImageView/blob/master/RMShapedImageView/RMShapedImageView.m) to your project.
2. Replace your `UIImageView` with `RMShapedImageView` either in code or Interface Builder (by setting the Class of your `UIImageView` to `RMShapedImageView`).
3. Profit! 

Configuration
-------------

Touches are inexact things and querying the alpha value of a single pixel might be too strict, even more so if the image is scaled down. Furthermore, if the image has shadows you might also want to ignore touches on them. `RMShapedImageView` has two configuration options to work around these problems:

* `shapedTransparentMaxAlpha`: maximum alpha value that will be considered transparent. 0 by default.
* `shapedPixelTolerance`: number of pixels around the point that will be examined. If at least one of them has alpha bigger than `shapedTransparentMaxAlpha` `pointInside:withEvent:` will return `YES`. 0 by default.

License
-------

 Copyright 2013 [Robot Media SL](http://www.robotmedia.net)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
