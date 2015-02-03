//
//  СTurnControl.h
//  Smart Intuition
//
//  Created by Kostya on 27.09.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSprite.h"

@interface CTurnControl : CSprite
{
    CSprite *destSprite;
}

@property (nonatomic, assign) CSprite *destSprite;

//Инициализация объекта
- (CTurnControl *) initWithGameController:(CGameController *)_gameController
                                 WithRect:(SRect)_rect //Геометрия
                       WithImageSequences:(SImageSequence *)_imageSequences //Набор последовательностей изображений
                                WithColor:(SColor)_color //Цвет
                                WithSpeed:(SSpeed)_speed //Скорость
                           WithDestSprite:(CSprite *)_destSprite; //Спрайт, поворотом которого управляем

//Механика объекта
-(void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage;

@end
