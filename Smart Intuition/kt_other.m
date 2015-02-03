//
//  kt_other.m
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kt_other.h"

void getDataFromPlist(NSDictionary *dict, NSString *key, GLfloat textureAtlasWidth, GLfloat textureAtlasHeight, SRect *posRect, CGRect *texRect, SColor *color, SSpeed *speed)
{
    posRect->a.x = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:0] integerValue];
    posRect->a.y = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:1] integerValue];
    posRect->b.x = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:0] integerValue] + [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:2] integerValue];
    posRect->b.y = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:1] integerValue];
    posRect->c.x = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:0] integerValue];
    posRect->c.y = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:1] integerValue] - [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:3] integerValue];
    posRect->d.x = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:0] integerValue] +[[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:2] integerValue];
    posRect->d.y = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"scr_pos"] objectAtIndex:1] integerValue] - [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:3] integerValue];;
    
    texRect->origin.x = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:0] integerValue]/textureAtlasWidth;
    texRect->origin.y = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:1] integerValue]/textureAtlasHeight;
    texRect->size.width = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:2] integerValue]/textureAtlasWidth;
    texRect->size.height = [[(NSArray *)[(NSDictionary *)[dict objectForKey:key] objectForKey:@"png_get"] objectAtIndex:3] integerValue]/textureAtlasHeight;
    
    color->red = 255;
    color->green = 255;
    color->blue = 255;
    color->alpha = 255;
    
    speed->x = 0;
    speed->y = 0;
}

SColor kt_getDefaultColor(void)
{
    SColor color;
    color.red = 255;
    color.green = 255;
    color.blue = 255;
    color.alpha = 255;
    
    return (color);
}

SSpeed kt_getNullSpeed(void)
{
    SSpeed speed;
    speed.x = 0;
    speed.y = 0;
    
    return(speed);
}



