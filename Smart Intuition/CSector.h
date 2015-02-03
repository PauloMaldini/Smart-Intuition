//
//  CSector.h
//  Smart Intuition
//
//  Created by Kostya on 08.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSprite;

@interface CSector : NSObject
{
    CGRect geometry; //Положение и размер сектора
    NSMutableArray *sprites; //Спрайты, находящиеся в данном секторе
    
    CGPoint posInArray; //Позиция сектора в массиве секторов
}

@property (nonatomic, readonly) NSMutableArray *sprites;
@property (nonatomic, readonly) CGPoint posInArray;

//Инициализация
- (CSector *) initWithGeometry:(CGRect)_geometry WithPosInArray:(CGPoint)_posInArray;

//Добавление спрайта в сектор
- (void) addSprite: (CSprite *)sprite;

//Удаление спрайта  из сектора
- (void) removeSprite: (CSprite *)sprite;

@end
