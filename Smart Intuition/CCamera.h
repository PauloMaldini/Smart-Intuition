//
//  CCamera.h
//  Smart Intuition
//
//  Created by Kostya on 22.11.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kt_struct.h"

@class CSprite;

@interface CCamera : NSObject
{
    CGPoint position;
    CGPoint openglPosition;
    SSpeed speed;
    
    NSMutableArray *sprites;
}

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, assign) SSpeed speed;

//Инициализация
- (CCamera *) initWithPosition:(CGPoint)_position WithOpenglPosition:(CGPoint)_openglPosition WithSpeed:(SSpeed)speed;

//Привязка спрайта
- (void) addSprite:(CSprite *)sprite;

//Отвязка спрайта
- (void) removeSprite:(CSprite *)sprite;

//Движение
- (void) move: (GLfloat)deltaTime;

//Установка позиции
- (void) setPosition:(CGPoint)_position;

@end
