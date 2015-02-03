//
//  CSlider.m
//  Smart Intuition
//
//  Created by Kostya on 30.08.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSlider.h"
#import "CGameController.h"
#import "kt_library.h"

@implementation CSlider

@synthesize value;

- (CSlider *) initWithGameController:(CGameController *)_gameController
                            WithRect:(SRect)_rect
                  WithImageSequences:(SImageSequence *)_imageSequences
                           WithColor:(SColor)_color
                         WithTapArea:(CGSize)_tapArea
                       WithLeftPoint:(CGPoint)_leftPoint
                      WithRightPoint:(CGPoint)_rightPoint
                       WithLeftValue:(GLfloat)_leftValue
                      WithRightValue:(GLfloat)_rightValue
                    WithDefaultValue:(GLfloat)_value
{
    //Инициализируем члены-данные
    SSpeed _speed;
    _speed.x = 0;
    _speed.y = 0;

    self = [super initWithGameController:_gameController WithRect:_rect WithImageSequences:_imageSequences WithColor:_color WithSpeed:_speed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];

    leftPoint = _leftPoint;
    rightPoint = _rightPoint;
    leftValue = _leftValue;
    rightValue = _rightValue;
    tapArea = _tapArea;
    isTouch = false;
    touchId = -1;
    
    pointDist = sqrtf((rightPoint.x - leftPoint.x)*(rightPoint.x - leftPoint.x) + (rightPoint.y - leftPoint.y)*(rightPoint.y - leftPoint.y));
    cosAlpha = (rightPoint.x - leftPoint.x)/pointDist;
    sinAlpha = (rightPoint.y - leftPoint.y)/pointDist;
    
    //Устанавливаем ползунок на стартовую позицию - левую крайнюю точку
    GLfloat w = rect.b.x - rect.a.x;
    GLfloat h = rect.a.y - rect.c.y;
    
    rect.a.x = leftPoint.x - w/2;
    rect.a.y = leftPoint.y + h/2;
    rect.b.x = rect.a.x + w;
    rect.b.y = rect.a.y;
    rect.c.x = rect.a.x;
    rect.c.y = rect.a.y - h;
    rect.d.x = rect.b.x;
    rect.d.y = rect.c.y;
    
    //Устанавливаем значение слайдера по умолчанию
    [self setSliderValue:_value];
   
    return (self);
}

- (CSlider *) initWithGameController:(CGameController *)_gameController
                            WithRect:(SRect)_rect
                  WithImageSequences:(SImageSequence *)_imageSequences
                           WithColor:(SColor)_color
                           WithPlist:(NSDictionary *)dict
{    
    CGSize _tapArea;
    CGPoint _leftPoint;
    CGPoint _rightPoint;
    GLfloat _leftValue;
    GLfloat _rightValue;
    GLfloat _value;
    
    _tapArea.width = [[(NSArray *)[dict objectForKey:@"tap_area"] objectAtIndex:0] floatValue];
    _tapArea.height = [[(NSArray *)[dict objectForKey:@"tap_area"] objectAtIndex:1] floatValue];
 
    _leftPoint.x = [[(NSArray *)[dict objectForKey:@"scr_line_points"] objectAtIndex:0] floatValue];
    _leftPoint.y = [[(NSArray *)[dict objectForKey:@"scr_line_points"] objectAtIndex:1] floatValue];
    _rightPoint.x = [[(NSArray *)[dict objectForKey:@"scr_line_points"] objectAtIndex:2] floatValue];
    _rightPoint.y = [[(NSArray *)[dict objectForKey:@"scr_line_points"] objectAtIndex:3] floatValue];
    
    _leftValue = [[(NSArray *)[dict objectForKey:@"sld_param_points"] objectAtIndex:0] floatValue];
    _rightValue = [[(NSArray *)[dict objectForKey:@"sld_param_points"] objectAtIndex:1] floatValue];
    
    _value = [[(NSArray *)[dict objectForKey:@"sld_param_points"] objectAtIndex:2] floatValue];
    
    self = [self initWithGameController:_gameController WithRect:_rect WithImageSequences:_imageSequences WithColor:_color WithTapArea:_tapArea WithLeftPoint:_leftPoint WithRightPoint:_rightPoint WithLeftValue:_leftValue WithRightValue:_rightValue WithDefaultValue:_value];
   
    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{    
    //Если произошло касание ползунка
    if (touchMessage.isRight && touchMessage.type == 1)
    {
        //Рассчитываем область касания
        SRect tapRect;
        tapRect.a.x = rect.a.x + (rect.b.x-rect.a.x)/2 - tapArea.width/2;
        tapRect.a.y = rect.a.y - (rect.a.y-rect.c.y)/2 + tapArea.height/2;
        tapRect.b.x = tapRect.a.x + tapArea.width;
        tapRect.b.y = tapRect.a.y;
        tapRect.c.x = tapRect.a.x;
        tapRect.c.y = tapRect.a.y - tapArea.height;
        tapRect.d.x = tapRect.b.x;
        tapRect.d.y = tapRect.c.y;
        
        //Если касание произошло в области тапа, то захватываем ползунок
        if (kt_mlIsRectContainsPoint(tapRect, touchMessage.newLocation))
        {
            isTouch = true;
            touchId = touchMessage.touchId;
        }
    }
    
    //Касание исчезает - освобождаем ползунок
    if (isTouch && touchId == touchMessage.touchId && touchMessage.type == 2)
    {
        isTouch = false;
        touchId = -1;
    }
    
    //Если свайп и ползунок захвачен
    if (touchMessage.isRight && isTouch && touchId == touchMessage.touchId && touchMessage.type == 3)
    {
        GLfloat w = rect.b.x - rect.a.x;
        GLfloat h = rect.a.y - rect.c.y;
        
        rect.a.x = touchMessage.newLocation.x - w/2;        
        if (rect.a.x < leftPoint.x - w/2)
            rect.a.x = leftPoint.x - w/2;
        if (rect.a.x > rightPoint.x - w/2)
            rect.a.x = rightPoint.x - w/2;
        
        rect.b.x = rect.a.x + w;
        rect.c.x = rect.a.x;
        rect.d.x = rect.b.x;
        
        rect.a.y = touchMessage.newLocation.y + h/2;
        if (rect.a.y > rightPoint.y + h/2)
            rect.a.y = rightPoint.y + h/2;
        if (rect.a.y < leftPoint.y + h/2)
            rect.a.y = leftPoint.y + h/2;
        
        rect.b.y = rect.a.y;
        rect.c.y = rect.a.y - h;
        rect.d.y = rect.c.y;
        
        GLfloat centerX = rect.a.x + (rect.b.x - rect.a.x)/2;
        GLfloat centerY = rect.a.y - (rect.a.y - rect.c.y)/2;
        value = leftValue + ABS((rightValue - leftValue))*sqrtf((centerX - leftPoint.x)*(centerX - leftPoint.x) + (centerY - leftPoint.y)*(centerY - leftPoint.y))/pointDist;
    }
}

- (void) setSliderValue: (GLfloat)_value
{
    value = _value;

    CGSize offset;
    offset.width = pointDist*ABS(_value - leftValue)/ABS(rightValue - leftValue)*cosAlpha;
    offset.height = pointDist*ABS(_value - leftValue)/ABS(rightValue - leftValue)*sinAlpha;
   
    kt_mlOffsetPolygon(&rect, offset);
}

- (GLfloat) getSliderValue
{
    return (value);
}








@end
