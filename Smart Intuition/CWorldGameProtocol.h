//
//  CWorldGameProtocol.h
//  GLSprite
//
//  Created by Konstantin Tsymbalist on 28.01.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kt_math.h"



//Протокол для общения объектов с главной формой
@protocol CWorldGameProtocol <NSObject>

//Обработка событий акселерометра
- (void) accelerometerProcess: (double)x :(double)y :(double)z;

//Возвращает размеры игровой поверхности
- (CGSize) getBackingSize;

//Делает сцену с именем name активной
- (void) setCurrentScene:(NSString *)name;

//Возвращает текущие координаты экрана в игровом пространстве
- (CGPoint) getCurrentScreenCoords;

//Возвращает указатель на делегат приложения
- (id) getDelegate;
    
@end
