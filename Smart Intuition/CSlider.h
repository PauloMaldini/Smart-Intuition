//
//  CSlider.h
//  Smart Intuition
//
//  Created by Kostya on 30.08.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSprite.h"

@interface CSlider : CSprite
{
    
    CGPoint leftPoint; //Левая граница на экране
    CGPoint rightPoint; //Правая граница на экране
    float value; //Значение от 0 до 1, определяемое положением ползунка
    bool isTouch; //Было ли касание ползунка
    GLfloat leftValue; //Крайнее левое значение
    GLfloat rightValue; //Крайнее правое значение
    CGSize tapArea; //Зона захвата ползунка тапом
    GLfloat pointDist; //Расстояние между левой и правой границей слайдера на экране
    GLfloat cosAlpha; //Запоминаем косинус угла наклона слайдера
    GLfloat sinAlpha; //Запоминаем синус угла наклона слайдера
}

@property (nonatomic, getter = getSliderValue, setter = setSliderValue:) float value;

//Инициализация объекта
- (CSlider *) initWithGameController:(CGameController *)_gameController //Игровой контроллер
                            WithRect:(SRect)_rect //Геометрия
                  WithImageSequences:(SImageSequence *)_imageSequences //Набор последовательностей изображений
                           WithColor:(SColor)_color //Цвет
                         WithTapArea:(CGSize)_tapArea //Зона захвата ползунка тапом
                       WithLeftPoint:(CGPoint)_leftPoint //Экранные координаты крайней левой точки
                      WithRightPoint:(CGPoint)_rightPoint //Экранные координаты крайней правой точки
                       WithLeftValue:(GLfloat)_leftValue //Значение ползунка в крайней левой точке
                      WithRightValue:(GLfloat)_rightValue //Значение ползунка в крайней правой точке
                    WithDefaultValue:(GLfloat)_value; //Значение ползунка по умолчанию

//Инициализация объекта на основе plist-файла, разработанного совместно с Костей
- (CSlider *) initWithGameController:(CGameController *)_gameController //Игровой контроллер
                            WithRect:(SRect)_rect //Геометрия
                  WithImageSequences:(SImageSequence *)_imageSequences //Набор последовательностей изображений
                           WithColor:(SColor)_color //Цвет
                           WithPlist:(NSDictionary *)dict; //Файл с настройками характеристик ползунка

//Механика объекта
- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

//Возвращает значение ползунка
- (GLfloat) getSliderValue;

//Устанавливает значение ползунка
- (void) setSliderValue: (GLfloat)_value;







@end
