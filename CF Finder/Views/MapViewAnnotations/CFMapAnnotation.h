//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CFMapAnnotation: NSObject <MKAnnotation>

@property (nonatomic) NSString *identifier;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSString *address;
@property (nonatomic) NSArray *formattedAddress;
@property (nonatomic) NSString *formattedPhone;;
@property (nonatomic) NSString *categoryName;
@property (nonatomic) NSString *categoryIconURL;
@property (nonatomic) UIImage *categoryIcon;

@end
