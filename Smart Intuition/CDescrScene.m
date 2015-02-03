//
//  CDescrScene.m
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CDescrScene.h"
#import "CGameController.h"
#import "CFon.h"
#import "CSpriteStorage.h"
#import "kt_library.h"

@implementation CDescrScene

- (void) dealloc
{
    [descrSpriteStorage dealloc];
    [super dealloc];
}

- (CAbstractScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName 
{
    self = [super init];
    
    name = _name;
    nextSceneName = _nextSceneName;
    gameController = _gameController;
    
    descrSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:1 WithTexture:@"intro.png" WithFillType:ftTexture WithGameScene:self];
    CSprite *descr = [[CFon alloc] initWithGameController:_gameController WithTextureAtlasWidth:descrSpriteStorage.textureAtlasWidth WithTextureAtlasHeight:descrSpriteStorage.textureAtlasHeight];
    [descrSpriteStorage addSprite:descr];

    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    [descrSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
    if (touchMessage.isRight && touchMessage.type == 2)
        if (kt_mlIsRectContainsPoint([descrSpriteStorage getSpriteByIndex:0].rect, touchMessage.newLocation))
        {
            [gameController setCurrentScene:nextSceneName];
        }
}

- (void) render
{
    [descrSpriteStorage render];
}


@end
