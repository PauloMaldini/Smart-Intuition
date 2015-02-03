//
//  СTurnControl.m
//  Smart Intuition
//
//  Created by Kostya on 27.09.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CTurnControl.h"
#import "kt_library.h"
#import "CGameController.h"

@implementation CTurnControl

@synthesize destSprite;

- (CTurnControl *) initWithGameController:(CGameController *)_gameController
                 WithRect:(SRect)_rect 
       WithImageSequences:(SImageSequence *)_imageSequences
                WithColor:(SColor)_color
                WithSpeed:(SSpeed)_speed
           WithDestSprite:(CSprite *)_destSprite;
{
    self = [super initWithGameController:_gameController WithRect:_rect WithImageSequences:_imageSequences WithColor:_color WithSpeed:_speed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    destSprite = _destSprite;
    
    return (self);
}

-(void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    //Если свайп принадлежит области контроллера поворота, то меням угол на величину, пропорциональную длине свайпа
    if (touchMessage.isRight && touchMessage.type == 3 && kt_mlIsRectContainsPoint(rect, touchMessage.newLocation) && kt_mlIsRectContainsPoint(rect,touchMessage.oldLocation))
    {
        [destSprite addValueToDeltaFI0:touchMessage.oldLocation.x - touchMessage.newLocation.x];
    }
}

@end
