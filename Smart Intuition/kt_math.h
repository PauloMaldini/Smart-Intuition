//
//  math.h
//  Smart Intuition
//
//  Created by Kostya on 28.09.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#ifndef Smart_Intuition_math_h
#define Smart_Intuition_math_h

#import "kt_struct.h"


//Поворачивает прямоугольник
void kt_mlRotatePolygon(SRect *rect, CGPoint basePoint, GLfloat corner);

//Проверяет, принадлежит ли точка прямоугольнику
BOOL kt_mlIsRectContainsPoint(SRect rect, CGPoint point);

//Определяет, пересекаются ли два прямоугольника
BOOL kt_mlIsRectsInteract(SRect rectA, SRect rectB);

//Округление
GLfloat kt_mlRound1(GLfloat value);

//Смещение полигона
void kt_mlOffsetPolygon(SRect *rect, CGSize offset);

//Подсчет координат центра полигона
CGPoint kt_mlGetPolygonCenter(SRect rect);



#endif
