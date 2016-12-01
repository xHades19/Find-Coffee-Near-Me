//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "OtherCFTableViewCell.h"
#import "Constants.h"

@implementation OtherCFTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];

    // Fonts
    [self.nameLabel setFont:[UIFont fontWithName:FONT_HELVETICA_MEDIUM size:16]];
    [self.addressLabel setFont:[UIFont fontWithName:FONT_HELVETICA_REGULAR size:16]];
    
    // Text Color
    [self.addressLabel setTextColor:UIColorFromRGB(RGB_GRAY)];
    
    // Corner Radius
    [self.categoryIconImageView.layer setCornerRadius:5];
    [self.categoryIconImageView setClipsToBounds:YES];
    [self.categoryIconImageView setBackgroundColor:UIColorFromRGB(RGB_GRAY)];
}


@end
