//
//  CLightIndicator.h
//  Smart Intuition
//
//  Created by Kostya on 13.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSprite.h"

@interface CLightIndicator : CSprite
{
    CFAbsoluteTime previousTimeMoment; //Предыдущий момент времени
    GLfloat pulseInterval; //Интервал вспышки
    GLfloat frameInterval; //Интервал 
    
    Byte status; //Состояние объекта (0 - индикатор не горит, 1 - загорается, 2 - угасает, 3 - находится в ожидании
    
    BOOL isLight; //Если true, то индикатор светит. Если false, то нет.
    
    BOOL stop; //Если true, то останавливаем мигание. Если false, то продолжаем мигать.
}

@property (nonatomic, assign, setter = light:) BOOL isLight;
@property (nonatomic, assign) GLfloat pulseInterval;

//Инициализация объекта
- (CLightIndicator *) initWithGameController:(CGameController *)_gameController //Протокол для общения с миром игры
                                    WithRect:(SRect)_rect //Геометрия
                          WithImageSequences:(SImageSequence *)_imageSequences; //Набор последовательностей изображений

//Механика объекта
- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

//Команда начать/закончить мигать
- (void) light:(BOOL)_isLight;



@end
