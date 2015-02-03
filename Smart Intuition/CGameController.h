//
//  CGameController.h
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CControlMessageStack.h"

#define DEBUG_MODE

@class CAbstractScene;
@class AppDelegate;

@interface CGameController : NSObject 
{
    NSMutableDictionary *sceneDict; //Словарь сцен
    CAbstractScene *currentScene; //Текущая сцена
    
    GLfloat backingWidth; //Ширина экрана
    GLfloat backingHeight; //Высота экрана
    
    GLfloat screenX; //x-координата левого верхнего угла экрана в игровом пространстве
    GLfloat screenY; //y-координата левого верхнего угла экрана в игровом пространстве
    
    id delegate; //Делегат приложения
}

@property (nonatomic, assign) GLfloat screenX;
@property (nonatomic, assign) GLfloat screenY;

//Инициализация
- (CGameController *) initWithScreenWidth:(GLfloat)width WithScreenHeight:(GLfloat)height WithDelegate:(id)_delegate;

//Апдейт текущей сцены
- (void) moveCurrentScene:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

//Рендер текущей сцены
- (void) renderCurrentScene;

//Инициализация конкретной сцены
- (void) initScene:(NSString *)sceneName;

//Возвращает высоту и ширину экрана
- (CGSize) getBackingSize;

//Устанавливает текущую сцену
- (void) setCurrentScene:(NSString *)name;

//Инициализирует сцену
- (void) initScene:(NSString *)sceneName;

//Возвращает указатель на делегат приложения
- (AppDelegate *) getDelegate;



@end
