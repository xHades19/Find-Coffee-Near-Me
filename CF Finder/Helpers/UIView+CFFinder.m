//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "UIView+CFFinder.h"

@implementation UIView (CFFinder)

-(UIView *)superviewOfType:(Class)superviewClass
{
    if (!self.superview){
        return nil;
    }
    if ([self.superview isKindOfClass:superviewClass]){
        return self.superview;
    }
    return [self.superview superviewOfType:superviewClass];
}

@end
