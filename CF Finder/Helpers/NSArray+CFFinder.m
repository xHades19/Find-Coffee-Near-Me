//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "NSArray+CFFinder.h"
#import "NSObject+CFFinder.h"

@implementation NSArray (CFFinder)

+(NSArray *)CFsFromServerData:(NSData *)data
{
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:&error];
    NSArray *response =  [[dictionary objectForKey:@"response"] objectForKey:@"venues"];
    
    if ([response count] < 1) {
        return nil;
    }
    
    
    NSMutableArray *CFsArray = [[NSMutableArray alloc] init];
    
    for (int position = 0; position < [response count]; position ++) {
        NSMutableDictionary *CFDictionary = [[NSMutableDictionary alloc] init];
        
        NSDictionary *responseItem = response[position];
        NSDictionary *location = [responseItem objectForKey:@"location"];
        NSDictionary *contact = [responseItem objectForKey:@"contact"];
        NSArray *categories = [responseItem objectForKey:@"categories"];
                
        [CFDictionary setObject:[responseItem objectForKey:@"id"] ? : [NSNull null]forKey:@"id"];
        [CFDictionary setObject:[responseItem objectForKey:@"name"] ? : [NSNull null]forKey:@"name"];

        [CFDictionary setObject:[location objectForKey:@"address"] ? : [NSNull null] forKey:@"address"];
        [CFDictionary setObject:[location objectForKey:@"formattedAddress"] ? : [NSNull null] forKey:@"formattedAddress"];
        [CFDictionary setObject:[location objectForKey:@"distance"] ? : [NSNull null] forKey:@"distance"];
        [CFDictionary setObject:[location objectForKey:@"lat"] ? : [NSNull null] forKey:@"latitud"];
        [CFDictionary setObject:[location objectForKey:@"lng"] ? : [NSNull null] forKey:@"longitud"];
        
        [CFDictionary setObject:[contact objectForKey:@"formattedPhone"] ? : [NSNull null] forKey:@"formattedPhone"];
        //phone: "+16466026263"
        
        if ([categories count]) {
            NSDictionary *firstCategoryIcon = [categories[0] objectForKey:@"icon"] ;
            [CFDictionary setObject:[categories[0] objectForKey:@"name"] ? : [NSNull null] forKey:@"categoryName"];
            [CFDictionary setObject:[NSString stringWithFormat:@"%@88%@",[firstCategoryIcon objectForKey:@"prefix"], [firstCategoryIcon objectForKey:@"suffix"]] forKey:@"categoryIconURL"];
        }
        
        [CFsArray addObject:CFDictionary];
    }
    
    return CFsArray;
}

@end
