//
//  CBall.h
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 22.03.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSprite.h"

@interface CPlayer : CSprite
{
    CSprite *radarPlayer;
}

@property (nonatomic, assign) CSprite *radarPlayer;

-(void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

@end
