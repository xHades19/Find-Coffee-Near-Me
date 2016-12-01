//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "CFNetworkHelper.h"
#import "NSArray+CFFinder.h"
#import "Constants.h"

@implementation CFNetworkHelper

-(void)getNearbyCFsAtCoordinate:(CLLocationCoordinate2D)coordinate
           withCompletionHandler:(void (^)(NSArray *CFsArray, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SERVICE_HOST, CLIENT_ID, CLIENT_SECRET,coordinate.latitude,coordinate.longitude]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if (!error && completionHandler) {
                    NSArray *CFsArray = [NSArray CFsFromServerData:data];
                    completionHandler(CFsArray, error);
                }

            }] resume];
}

-(void)getImageNSDataFromURL:(NSString *)urlString
   withCompletionHandler:(void (^)(NSData *data))completionHandler
{
    NSURL *imageURL = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        if (completionHandler && imageData) {
            completionHandler(imageData);
        }
    });
    
}

@end
