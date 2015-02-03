//
//  CGameScene.h
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CAbstractScene.h"

#define WORLD_CELL_COUNT_X 3
#define WORLD_CELL_COUNT_Y 3
#define FON_CELL_SIZE_X 288.0
#define FON_CELL_SIZE_Y 448.0
#define CELL_COUNT_IN_FON_CELL_X 9
#define CELL_COUNT_IN_FON_CELL_Y 14
#define TREK_POINT_DIST 20.0
#define TREK_POINT_SIZE 4
#define SECTOR_COUNT_X 10
#define SECTOR_COUNT_Y 10

@class CSlider;
@class CTurnControl;
@class CPlayer;
@class CSpriteStorage;
@class CSprite;
@class CCamera;
@class CSector;
@class CLightIndicator;

@interface CGameScene : CAbstractScene
{
    NSDictionary *panelPlist; //Сопроводительный файл панели
    NSDictionary *cityPlist; //Сопроводительный файл городов
    NSDictionary *gameObjectPlist; //Сопроводительный файл игровых объектов
    NSDictionary *uiDict; //Сопроводительный файл пользовательского интерфейса
    NSDictionary *purPlist; //Сопроводительный файл мгающего индикатора
    
    CSpriteStorage *gameObjectSpriteStorage; //Игровые объекты
    CSpriteStorage *trekSpriteStorage; //Спрайты трека
    CSpriteStorage *panelSpriteStorage; //Спрайты, реализующие панель
    CSpriteStorage *citySpriteStorage; //Спрайты, реализующие город
    CSpriteStorage *fonSpriteStorage; //Спрайты, реализующие фон
    CSpriteStorage *obstSpriteStorage; //Спрайты, реализующие препятствия
    CSpriteStorage *transferSpriteStorage; //Спрайты, реализующие переходы
    CSpriteStorage *obstSpriteStoragePreview; //Спрайты, реализующие предпросмотр препятствий
    CSpriteStorage *citySpriteStoragePreview; //Спрайты, реализующие предпросмотр игровых объектов
    CSpriteStorage *radarSpriteStorage; //Спрайты, реализующие радар
    CSpriteStorage *purSpriteStorage; //Спрайты, реализующие индикатор близости препятствия
    
    //CSector *sectors[SECTOR_COUNT_Y][SECTOR_COUNT_X]; //Массив секторов, на которые разбито игровое пространство
    
    CCamera *camera; //Камера
    
    CPlayer *playerSprite; //Игрок
    CSprite *playerRadarSprite; //Игрок на радаре
    //CSprite *cursSprite; //Курсора игрока
    CSprite *panHorSprite; //Горизонтальная панель (скорость поворота)
    CSprite *panVerSprite; //Вертикальная панель (скорость перемещения)
    CSlider *speedSliderSprite; //Ползунок, меняющий величину скорости
    CSlider *turnSpeedSliderSprite; //Ползунок, меняющий величину скорости поворота
    //CTurnControl *turnControlSprite; //Контроллер поворота
    CSprite *citySpriteStart; //Точка входа
    CSprite *citySpriteFinish; //Точка выхода
    CSprite *radarSprite; //Радар
    CLightIndicator *indicatorSprite; //Инидикатор близости препятствия
    
    GLfloat maxMoveSpeed; //Максимальная скорость перемещения
    GLfloat maxRotateSpeed; //Максимальная скорость вращения
    GLfloat moveAcceler; //Ускорение перемещения
    GLfloat currMoveSpeed; //Текущая скорость перемещения
    GLfloat makedBySliderMoveSpeed; //Скорость, установленная слайдером
    BOOL isTrek; //Выводить ли трек
    BOOL isTrekClean; //Очистить трек
    

    GLfloat translateX; //x-координата функции glTranslate (для скроллинга)
    GLfloat translateY; //y-координата функции glTranslate (для скроллинга)
    
    CGPoint lastTrekPoint; //Координаты последнего пункта трека
    
    GLfloat backingWidth; //Ширина экрана
    GLfloat backingHeight; //Высота экрана
    
    short colliseCount; //Количество столкновений с препятствиями
    
    Byte obstMap[CELL_COUNT_IN_FON_CELL_Y*WORLD_CELL_COUNT_Y][CELL_COUNT_IN_FON_CELL_X*WORLD_CELL_COUNT_X]; //Карта препятствий
    
    NSString *pathDocsDir;
}

//Инициализация сцены
- (CGameScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName;

//Генерация трека
- (void) drawTrek: (CGPoint)point;

//Генерация фона
- (void) drawFon;

//Скроллинг пространства
- (void) scroll:(double)deltaTime;

//Достигли финиша
- (void) doFinish;

//Генерация препятствий
- (void) createObstakles;

//Проверка на столкновения в 9-ти секторах
- (void) processCollisionsWithObst;

//Генерация карты препятствий для предпросмотра
- (void) createObstaklesPreview;

//Инициализация игровых спрайтов
- (void) initGameSprites;

//Инициализация радара
- (void) initRadar;

//Установка позиции игрока на радаре
- (void) setPlayerRadarPosition;

//Разбивка пространства на сектора
- (void) createSectors;

//Управление миганием индикатора в зависимости от расстояния до препятствия
- (void) updateFrequenceWinking;


@end
