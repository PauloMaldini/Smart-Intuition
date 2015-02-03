//
//  kt_struct.h
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#ifndef Smart_Intuition_kt_struct_h
#define Smart_Intuition_kt_struct_h

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <CoreGraphics/CGGeometry.h>

//Прямоугольник
typedef struct _SRect
{
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
} SRect;

//Массив изображений
typedef struct _SImageSequence
{
    NSString *name;    //Наименование
    CGRect images[10]; //Массив текстурных координат изображений
    Byte imageCount;   //Кол-во изображений
} SImageSequence;

//Цвет
typedef struct _SColor
{
    short red;
    short green;
    short blue;
    GLfloat alpha;
} SColor;

//Скорость
typedef struct _SSpeed
{
    GLfloat x; //Составляющая скорости по оси x
    GLfloat y; //Составляющая скорости по оси y
} SSpeed;





#endif
