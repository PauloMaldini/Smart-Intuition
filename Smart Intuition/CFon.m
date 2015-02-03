//
//  CFon.m
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 09.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CFon.h"
#import "CGameController.h"

@implementation CFon

- (id) initWithGameController:(CGameController *)_gameController WithTextureAtlasWidth:(GLfloat)_width WithTextureAtlasHeight:(GLfloat)_height;
{
    backingSize = [_gameController getBackingSize];
    
    rect.a.x = 0;
    rect.a.y = backingSize.height;
    rect.b.x = backingSize.width;
    rect.b.y = backingSize.height;
    rect.c.x = 0;
    rect.c.y = 0;
    rect.d.x = backingSize.width;
    rect.d.y = 0;
    
    color.red = 255;
    color.green = 255;
    color.blue = 255;
    color.alpha = 255;
    
    speed.x = 0;
    speed.y = 0;
    
    SImageSequence *fonImageSequence = malloc(sizeof(SImageSequence));
    fonImageSequence[0].name = @"default";
    fonImageSequence[0].imageCount = 1;
    fonImageSequence[0].images[0].origin.x = 0.0; 
    fonImageSequence[0].images[0].origin.y = 0.0;
    fonImageSequence[0].images[0].size.width = backingSize.width/_width;
    fonImageSequence[0].images[0].size.height = backingSize.height/_height;

    [self initWithGameController:_gameController WithRect:rect WithImageSequences:fonImageSequence WithColor:color WithSpeed:speed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    
    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage) touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    
}

@end
