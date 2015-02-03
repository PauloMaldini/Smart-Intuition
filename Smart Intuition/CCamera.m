//
//  CCamera.m
//  Smart Intuition
//
//  Created by Kostya on 22.11.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CCamera.h"
#import "CSprite.h"

@implementation CCamera

@synthesize speed;
@synthesize position;

- (void) dealloc
{
    
}

- (CCamera *) initWithPosition:(CGPoint)_position WithOpenglPosition:(CGPoint)_openglPosition WithSpeed:(SSpeed)_speed
{
    self = [super init];
    position = _position;
    openglPosition = _openglPosition;
    speed = _speed;
    
    glLoadIdentity();
    glTranslatef((short)openglPosition.x, (short)openglPosition.y, 0);
    
    sprites = [[NSMutableArray alloc] initWithCapacity:0];
    
    return (self);
}

- (void) addSprite:(CSprite *)sprite
{
    [sprites addObject:sprite];
    sprite.camera = self;
}

- (void) removeSprite:(CSprite *)sprite
{
    [sprites removeObject:sprite];
    sprite.camera = nil;
}

- (void) move: (GLfloat)deltaTime
{
    //Вычисляем смещение за дельта-тайм
    GLfloat deltaX = speed.x*deltaTime;
    GLfloat deltaY = speed.y*deltaTime;
    
    //Смещаем позицию
    position.x += deltaX;
    position.y += deltaY;
    
    //Смещаем центр координат OpenGL
    openglPosition.x -= deltaX;
    openglPosition.y -= deltaY;
    
    //Преобразуем видовую матрицу
    glLoadIdentity();
    glTranslatef((short)openglPosition.x, (short)openglPosition.y, 0);
}

- (void) setPosition:(CGPoint)_position
{
    openglPosition.x += (position.x - _position.x);
    openglPosition.y += (position.y - _position.y);
    glLoadIdentity();
    glTranslatef((short)openglPosition.x, (short)openglPosition.y, 0);
    position = _position;
}



@end
