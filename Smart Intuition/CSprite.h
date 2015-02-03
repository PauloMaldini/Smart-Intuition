//
//  GameObject.h
//  GLSprite
//
//  Created by User on 07.01.12.
//  Copyright (c) 2012 __Tsymbalist Konstantin__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CControlMessageStack.h"
#import "kt_struct.h"

@class CGameController;
@class CCamera;
@class CSector;

//Базовый класс для всех спрайтов
@interface CSprite : NSObject
{
    NSString *name; //Имя объекта (для идентификации)

    CGameController *gameController; //Указатель на игровой контроллер
    
    CCamera *camera; //Указатель на камеру
    
    SRect rect; //Геометрия
    SSpeed speed; //Скорость движения
    GLfloat rotateSpeed; //Скорость поворота
    CGPoint rotateBasePoint; //Точка, относительно которой полигон поворачивается. Координаты задаются относительно точки A.
    CGPoint centerPoint; //Центр спрайта
    
    CFAbsoluteTime absoluteTime; //Время последнего вызова функции move
    GLfloat deltaFI0; //Величина угла, на которую необходимо повернуть спрайт
    
    Byte imageSequenceIndex; //Текущая последовательность
    Byte imageIndex; //Текущее изображение в последовательности
    SImageSequence *imageSequences; //Массив последовательностей изображений
    SColor color; //Цвет
    
    int touchId; //Идентификатор касания (используем в мультитач)
    
    bool isAccelerometer; //Если true, то спрайт восприимчив к акселерометру. Если false, то не восприимчив
    
    CGSize backingSize; //Размер экранной области
    
    CSector *sector; //Сектор игрового пространства, в котором находится спрайт
    BOOL isSector; //Если true, то привязывается к сектору. Если false, то нет.
}

@property (nonatomic, assign) SRect rect;
@property (nonatomic, assign) SSpeed speed;
@property (nonatomic, assign) GLfloat rotateSpeed;
@property (nonatomic, assign) CGPoint rotateBasePoint;
@property (nonatomic, assign) SColor color;
@property (nonatomic, assign) NSString* name;
@property (nonatomic, readonly, getter = getImage) CGRect image;
@property (nonatomic, assign) bool isAccelerometer;
@property (nonatomic, assign) CCamera *camera;
@property (nonatomic, assign) CSector *sector;
@property (nonatomic, assign) BOOL isSector;

//Инициализация объекта
- (CSprite *) initWithGameController:(CGameController *)_gameController //Протокол для общения с миром игры
                            WithRect:(SRect)_rect //Геометрия
                  WithImageSequences:(SImageSequence *)_imageSequences //Набор последовательностей изображений
                           WithColor:(SColor)_color //Цвет
                           WithSpeed:(SSpeed)_speed //Скорость перемещения
                     WithRotateSpeed:(GLfloat)_rotateSpeed //Скорость поворота
                 WithRotateBasePoint:(CGPoint)_rotateBasePoint; //Точка поворота

//Механика объекта c использованием deltaTime и скорости
- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

//Механика объекта с использованием смещения
- (void) moveWithOffset:(CGSize)offset;

//Увеличение/уменьшение значения переменной deltaFI0
- (void) addValueToDeltaFI0:(GLfloat)value;

//Поворачивает спрайт на угол, пропорциональный deltaTime, если deltaFI0 != 0
- (void) rotate:(GLfloat)deltaTime;

//Уничтожение объекта
- (void) dealloc;

//Тип объекта
- (NSString *) getName; 

//Принадлежит ли точка (x,y) данному спрайту
- (bool) isOwneredByPointWithX:(GLfloat)x WithY:(GLfloat)y; 

//Геттер для свойства image
- (CGRect) getImage;

@end
