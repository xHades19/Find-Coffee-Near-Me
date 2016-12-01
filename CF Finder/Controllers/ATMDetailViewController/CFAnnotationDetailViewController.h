//
//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "CFMapAnnotation.h"
#import "CFRootViewController.h"

@interface CFAnnotationDetailViewController : CFRootViewController

@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic) CFMapAnnotation *annotation;
@property (nonatomic) NSArray *nearAnnotations;

@end
