//
//  CFon.h
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 09.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CControlMessageStack.h"
#import "CSprite.h"

@class CGameController;

@interface CFon : CSprite
{
    
}

- (id) initWithGameController:(CGameController *)_gameController WithTextureAtlasWidth:(GLfloat)_width WithTextureAtlasHeight:(GLfloat)_height;
- (void) move:(GLfloat)deltaTime :(STouchMessage) touchMessage :(SAccelerometerMessage)accelerometerMessage; 

    
@end
