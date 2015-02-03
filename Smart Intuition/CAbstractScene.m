//
//  CAbstractScene.m
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CAbstractScene.h"
#import "CSprite.h"
#import "CSpriteStorage.h"
#import "kt_library.h"

@implementation CAbstractScene

@synthesize nextScene;
@synthesize sectors;
@synthesize sectorSize;

- (CAbstractScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName
{return (nil);}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage{};
- (void) render{};

@end
