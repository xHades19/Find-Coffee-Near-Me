//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFMapAnnotation.h"

@protocol SearchViewDelegate <NSObject>

- (void) didSelectRow:(CFMapAnnotation *) cfDictionay;

@end

@interface SearchController : UITableViewController

@property (nonatomic,strong) NSArray * arrData;
@property (nonatomic, weak) id<SearchViewDelegate> delegate;

@end
