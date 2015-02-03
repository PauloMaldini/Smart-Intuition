//
//  CMenuElement.m
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 11.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CMenuElement.h"
#import "kt_library.h"

@implementation CMenuElement

@synthesize place;
@synthesize state;

- (id)   initWithGameController:(CGameController *)_gameController
            WithRect:(SRect)_rect
  WithImageSequences:(SImageSequence *)_imageSequences
           WithColor:(SColor)_color
           WithSpeed:(SSpeed)_speed
  WithScreenSideRect:(SRect)_screenSideRect
WithScreenOnSideRect:(SRect)_screenOnSideRect
{
    self = [super initWithGameController:_gameController WithRect:_rect WithImageSequences:_imageSequences WithColor:_color WithSpeed:_speed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    screenSideRect = _screenSideRect;
    screenOnSideRect = _screenOnSideRect;
    place = mepOffScreen;
    isTouch = false;
    state = 0;
    
    return (self);
}

- (void) appear
{
    speed.y = 5;
}

- (void) hide
{
    speed.y = -5;
}

- (void) move:(GLfloat)deltaTime :(STouchMessage) touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    //Если произошло касание элемента меню
    if (touchMessage.isRight && touchMessage.type == 1 && kt_mlIsRectContainsPoint(rect, touchMessage.newLocation))
        isTouch = true;
    
    //Если касание закончилось (палец убран с экрана)
    if (touchMessage.isRight && touchMessage.type == 2 && kt_mlIsRectContainsPoint(rect, touchMessage.newLocation))
    {
        if (isTouch)
        {
            if (name == @"start")
            {
                [self hide];
                state = 1;
            }
            
            isTouch = false;
        }
    }
    
    //Движение элемента меню
    rect.a.y += speed.y;
    rect.b.y += speed.y;
    rect.c.y += speed.y;
    rect.d.y += speed.y;
    
    if (speed.y > 0 && rect.a.y > screenSideRect.a.y)
    {
        rect.a.y = screenSideRect.a.y;
        rect.b.y = screenSideRect.b.y;
        rect.c.y = screenSideRect.c.y;
        rect.d.y = screenSideRect.d.y;
        place = mepOnScreen;
    }
    
    if (speed.y < 0 && rect.a.y < screenOnSideRect.a.y)
    {
        rect.a.y = screenOnSideRect.a.y;
        rect.b.y = screenOnSideRect.b.y;
        rect.c.y = screenOnSideRect.c.y;
        rect.d.y = screenOnSideRect.d.y;

        place = mepOffScreen;
    }
}

@end
