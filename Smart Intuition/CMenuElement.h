//
//  CMenuElement.h
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 11.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSprite.h"

enum EMenuElementPlace {mepOnScreen, mepOffScreen};

@interface CMenuElement : CSprite
{
    SRect screenSideRect; //Позиция на экране
    SRect screenOnSideRect; //Позиция вне экрана
    
    enum EMenuElementPlace place; //Маркер позиции
    
    bool isTouch; //Если true, значит произошло касание по элементу меню
    
    Byte state; //0 - не нажимали, 1 - нажали на кнопку
}

@property (nonatomic, readonly) enum EMenuElementPlace place;
@property (nonatomic, readonly) Byte state;

//Инициализация
- (id) initWithGameController:(CGameController *)_gameController
                     WithRect:(SRect)_rect
           WithImageSequences:(SImageSequence *)_imageSequences
                    WithColor:(SColor)_color
                    WithSpeed:(SSpeed)_speed
           WithScreenSideRect:(SRect)_screenSideRect
         WithScreenOnSideRect:(SRect)_screenOnSideRect;

//Появление на экране
- (void) appear; 
//Уход с экрана
- (void) hide; 
//Механика
- (void) move:(GLfloat)deltaTime :(STouchMessage) touchMessage :(SAccelerometerMessage)accelerometerMessage; 

@end
