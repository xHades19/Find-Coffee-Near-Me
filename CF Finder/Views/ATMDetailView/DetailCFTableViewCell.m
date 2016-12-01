//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "DetailCFTableViewCell.h"
#import "Constants.h"

@implementation DetailCFTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // Fonts
    [self.leftLabel setFont:[UIFont fontWithName:FONT_HELVETICA_LIGHT size:15]];
    [self.rightLabel setFont:[UIFont fontWithName:FONT_HELVETICA_MEDIUM size:16]];
    
    // Text Color
    [self.leftLabel setTextColor:UIColorFromRGB(RGB_RED)];
    [self.rightLabel setTextColor:UIColorFromRGB(RGB_GRAY)];
}
@end
