//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CFNetworkHelper : NSObject

- (void)getNearbyCFsAtCoordinate:(CLLocationCoordinate2D)coordinate
            withCompletionHandler:(void (^)(NSArray *CFsArray, NSError *error))completionHandler;

-(void)getImageNSDataFromURL:(NSString *)urlString
       withCompletionHandler:(void (^)(NSData *data))completionHandler;

@end
