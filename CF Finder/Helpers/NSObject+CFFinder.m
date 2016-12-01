//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "NSObject+CFFinder.h"

@implementation NSObject (CFFinder)

-(id)valueOrNil
{
    return [self isMemberOfClass:[NSNull class]] ? nil : [self copy];
}
@end
