//
//  CAbstractScene.h
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CControlMessageStack.h"

@class CGameController;
@class CSector;

@interface CAbstractScene : NSObject
{
    CGameController *gameController; //Указатель на игровой контроллер
    NSString *name; //Имя сцены
    NSString *nextSceneName; //Имя следующей сцены
    Byte sceneState; //Состояние сцены
    CSector ***sectors; //Двумерный массив секторов, на которые разбито игровое пространство
    CGSize sectorSize; //Ширина и высота сектора
}

@property (nonatomic, retain) NSString *nextScene;
@property (nonatomic, readonly) CSector ***sectors;
@property (nonatomic, readonly) CGSize sectorSize;

//Инициализация
- (CAbstractScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName;

//Движение
- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

//Рендеринг
- (void) render;

@end
