//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface CFRootViewController : UIViewController

-(void) showMessageWithTitle:(NSString *) title andMessage:(NSString *) message;

-(void) getDirectionFrom:(CLLocationCoordinate2D) userLocation to:(CLLocationCoordinate2D) coffeeLocation;

@end
