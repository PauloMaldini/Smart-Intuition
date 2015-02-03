//
//  CGameController.m
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//
#import "CGameController.h"
#import "CSpriteStorage.h"
#import "CDescrScene.h"
#import "CMenuScene.h"
#import "CGameScene.h"

@implementation CGameController

@synthesize screenX;
@synthesize screenY;

- (void) dealloc
{
    [sceneDict dealloc];
    [super dealloc];
}

- (CGameController *) initWithScreenWidth:(GLfloat)width WithScreenHeight:(GLfloat)height WithDelegate:(id)_delegate
{
    self = [super init];
    
    backingWidth = width;
    backingHeight = height;
    delegate = _delegate;
    
    screenX = 0;
    screenY = backingHeight;
    
    //Создаем словарь сцен
    sceneDict = [[NSMutableDictionary alloc] init];
    //Сцена "Описание"
    [sceneDict setValue:[[CDescrScene alloc] initWithGameController:self WithName:@"descr" WithNextSceneName:@"menu"] forKey:@"descr"];
    //Сцена "Меню"
    [sceneDict setValue:[[CMenuScene alloc] initWithGameController:self WithName:@"menu" WithNextSceneName:@"game"] forKey:@"menu"];
    //Сцена "Игра"
    [sceneDict setValue:[[CGameScene alloc] initWithGameController:self WithName:@"game" WithNextSceneName:@"game"] forKey:@"game"];

    //Первая сцена - описание игры
    currentScene = [sceneDict objectForKey:@"descr"];
    
    return (self);
}

- (void) moveCurrentScene:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    [currentScene move:deltaTime :touchMessage :accelerometerMessage];
}

- (void) renderCurrentScene;
{
    [currentScene render];
}

- (void) setCurrentScene:(NSString *)name
{
    currentScene = (CAbstractScene *)[sceneDict objectForKey:name];
}

- (void) initScene:(NSString *)sceneName
{
    [(CAbstractScene *)[sceneDict objectForKey:sceneName] release];
    
    if (sceneName == @"menu")
        [sceneDict setValue:[[CMenuScene alloc] initWithGameController:self WithName:@"menu" WithNextSceneName:@"game"] forKey:@"menu"];
    else if (sceneName == @"game")
        [sceneDict setValue:[[CGameScene alloc] initWithGameController:self WithName:@"game" WithNextSceneName:@"game"] forKey:@"game"];
}

-(CGSize) getBackingSize
{
    CGSize size;
    size.width = backingWidth;
    size.height = backingHeight;
    
    return (size);
}

- (CGPoint) getCurrentScreenCoords
{
    return CGPointMake(0, 0);
}

- (id) getDelegate
{
    return delegate;
}








@end
