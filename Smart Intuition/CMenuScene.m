//
//  CMenuScene.m
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CMenuScene.h"
#import "CMenuElement.h"
#import "CSpriteStorage.h"
#import "kt_library.h"
#import "CGameController.h"

@implementation CMenuScene

- (void) dealloc
{
    [menuSpriteStorage dealloc];
    [menuPlist dealloc];
    [super dealloc];
}


- (CMenuScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName
{
    self = [super init];
    
    sectors = nil; //На сектора пространство сцены не разбиваем
    
    name = _name;
    nextSceneName = _nextSceneName;
    gameController = _gameController;
    
    menuPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ui" ofType:@"plist"]];
    menuSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:1 WithTexture:@"ui.png" WithFillType:ftTexture WithGameScene:self];
    
    SRect menuStartRect;
    SRect menuStartOnSideRect;
    SRect menuStartSideRect;
    SImageSequence *menuStartImageSequence = malloc(sizeof(SImageSequence));
    SColor menuStartColor;
    SSpeed menuStartSpeed;
    
    getDataFromPlist(menuPlist, @"button_str", menuSpriteStorage.textureAtlasWidth, menuSpriteStorage.textureAtlasHeight, &menuStartRect, &menuStartImageSequence[0].images[0], &menuStartColor, &menuStartSpeed);
    
    menuStartSideRect = menuStartRect;
    
    menuStartOnSideRect = menuStartRect;
    menuStartOnSideRect.a.y = 0;
    menuStartOnSideRect.b.y = 0;
    menuStartOnSideRect.c.y = menuStartRect.c.y - menuStartRect.a.y;
    menuStartOnSideRect.d.y = menuStartRect.c.y - menuStartRect.a.y;
    
    menuStartRect = menuStartOnSideRect;
    
    CMenuElement *menuStart = [[CMenuElement alloc] initWithGameController:gameController WithRect:menuStartRect WithImageSequences:menuStartImageSequence WithColor:menuStartColor WithSpeed:menuStartSpeed WithScreenSideRect:menuStartSideRect WithScreenOnSideRect:menuStartOnSideRect];
    menuStart.name = @"start";
    [menuStart appear];
    
    [menuSpriteStorage addSprite:menuStart];
 
    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    [menuSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
    CMenuElement *menuStart = (CMenuElement *)[menuSpriteStorage getSpriteByIndex:0];
    if (menuStart.place == mepOffScreen && menuStart.state == 1)
        [gameController setCurrentScene:nextSceneName];
}

- (void) render
{
    [menuSpriteStorage render];
}



@end
