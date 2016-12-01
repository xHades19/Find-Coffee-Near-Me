//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "CFMapAnnotation.h"

@implementation CFMapAnnotation

-(NSString *)title
{
    return self.name;
}

-(NSString *)subtitle
{
    return self.address;
}

@end
