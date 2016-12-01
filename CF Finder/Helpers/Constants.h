//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//
#import <Foundation/Foundation.h>

// FOURSQUARE
#define SERVICE_HOST     @"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%.2f,%.2f&query=coffee"
#define CLIENT_ID        @"HN0XFLXBGJBPLFCL2NDVNKVSU4BYSVNZBCLIFKJ0YMSN13VW"
#define CLIENT_SECRET    @"5QVQ200QXYUV3XQTKH5OD1RSNLIVLHNI4VHWTOZFY1RQFDAQ"


// UICOLOR FROM RGB
#define UIColorFromRGB(rgbValue) \
            UIColorFromRGBwithAlpha(rgbValue,1.0)

#define UIColorFromRGBwithAlpha(rgbValue,alphaValue) \
            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                             blue:((float)(rgbValue & 0xFF))/255.0 \
                            alpha:alphaValue]


// CF RGB COLORS
#define RGB_RED          0xD0021B
#define RGB_GRAY         0xC7C7C7


// FONTS
#define FONT_HELVETICA_REGULAR          @"HelveticaNeue"
#define FONT_HELVETICA_MEDIUM           @"HelveticaNeue-Medium"
#define FONT_HELVETICA_LIGHT            @"HelveticaNeue-Light"


// OTHER VALUES
#define ONE_MILE @1609344


@interface Constants : NSObject

@end
