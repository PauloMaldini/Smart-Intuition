//
//  math.c
//  Smart Intuition
//
//  Created by Kostya on 28.09.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#include <stdio.h>
#import <OpenGLES/EAGL.h>
#include <CoreGraphics/CGGeometry.h>
#include "kt_math.h"

void kt_mlRotatePolygon(SRect *rect, CGPoint basePoint, GLfloat corner)
{
    SRect _rect = *rect;
    
    _rect.a.x = basePoint.x + (rect->a.x - basePoint.x)*cosf(corner) - (rect->a.y - basePoint.y)*sinf(corner);
    _rect.a.y = basePoint.y + (rect->a.x - basePoint.x)*sinf(corner) + (rect->a.y - basePoint.y)*cosf(corner);
    
    _rect.b.x = basePoint.x + (rect->b.x - basePoint.x)*cosf(corner) - (rect->b.y - basePoint.y)*sinf(corner);
    _rect.b.y = basePoint.y + (rect->b.x - basePoint.x)*sinf(corner) + (rect->b.y - basePoint.y)*cosf(corner);
    
    _rect.c.x = basePoint.x + (rect->c.x - basePoint.x)*cosf(corner) - (rect->c.y - basePoint.y)*sinf(corner);
    _rect.c.y = basePoint.y + (rect->c.x - basePoint.x)*sinf(corner) + (rect->c.y - basePoint.y)*cosf(corner);
    
    _rect.d.x = basePoint.x + (rect->d.x - basePoint.x)*cosf(corner) - (rect->d.y - basePoint.y)*sinf(corner);
    _rect.d.y = basePoint.y + (rect->d.x - basePoint.x)*sinf(corner) + (rect->d.y - basePoint.y)*cosf(corner);
    
    *rect = _rect;
}

BOOL kt_mlIsRectContainsPoint(SRect rect, CGPoint point)
{
    if (point.x > rect.a.x && point.x < rect.b.x && point.y > rect.c.y && point.y < rect.a.y)
        return (true);
    
    return (false);
}

BOOL kt_mlIsRectsInteract(SRect rectA, SRect rectB)
{
    
    return (false);
}

GLfloat kt_mlRound1(GLfloat value)
{
    //return  (value);
    
    if (value == 0)
        return 0;
    
    GLfloat fraction = ABS(value) - ABS((int)value);
    if (fraction > 0 && fraction <= 0.5)
        fraction = 0.5;
    else if (fraction > 0.5 && fraction <= 0.9999999999999999999)
        fraction = 1;
    else
        fraction = 0;
    
    //GLfloat res = (int)value + ABS(value)/value*fraction;
    
    return ((int)value + ABS(value)/value*fraction);
}

void kt_mlOffsetPolygon(SRect *rect, CGSize offset)
{
    rect->a.x += offset.width;
    rect->b.x += offset.width;
    rect->c.x += offset.width;
    rect->d.x += offset.width;
    
    rect->a.y += offset.height;
    rect->b.y += offset.height;
    rect->c.y += offset.height;
    rect->d.y += offset.height;
}

CGPoint kt_mlGetPolygonCenter(SRect rect)
{
    /*CGPoint center;
    center.x = ;
    center.y = ;
    
    return (center);*/
}



