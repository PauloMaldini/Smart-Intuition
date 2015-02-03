//
//  CGameScene.m
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CGameScene.h"
#import "CSlider.h"
#import "CTurnControl.h"
#import "CPlayer.h"
#import "AppDelegate.h"
#import "CTransfer.h"
#import "CSpriteStorage.h"
#import "CGameController.h"
#import "CCamera.h"
#import "kt_library.h"
#import "kt_struct.h"
#import "CSector.h"
#import "CLightIndicator.h"

@implementation CGameScene

- (void) dealloc
{
    [gameObjectSpriteStorage dealloc];
    [trekSpriteStorage dealloc];
    [panelSpriteStorage dealloc];
    [citySpriteStorage dealloc];
    [obstSpriteStorage dealloc];
    [citySpriteStoragePreview dealloc];
    [obstSpriteStoragePreview dealloc];
    
    [panelPlist dealloc];
    [cityPlist dealloc];
    [gameObjectPlist dealloc];
    [uiDict dealloc];
    
    [super dealloc];
}

- (CGameScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName
{
    self = [super init];
    
    name = _name;
    nextSceneName = _nextSceneName;
    gameController = _gameController;
    
    backingWidth = [gameController getBackingSize].width;
    backingHeight = [gameController getBackingSize].height;
    
    sectorSize.width = WORLD_CELL_COUNT_X*FON_CELL_SIZE_X/SECTOR_COUNT_X;
    sectorSize.height = WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y/SECTOR_COUNT_Y;
    
    //Инициализируем физические характеристики (скорость, ускорение и т.д.)
    maxMoveSpeed = 10;
    maxRotateSpeed = 360;
    moveAcceler = 60;
    currMoveSpeed = 0;
    
    gameController.screenX = 0;
    gameController.screenY = backingHeight;
    
    colliseCount = 0;
    
    sceneState = 1;
    
    //Получаем путь к папке "Documents"
    pathDocsDir = [[NSString alloc] initWithString: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    
#ifdef DEBUG_MODE //В режиме "Отладка" берем ресурсы из папки Documents
    panelPlist = [[NSDictionary alloc] initWithContentsOfFile:[pathDocsDir stringByAppendingString:@"/mod_pan.plist"]];
    panelSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:[pathDocsDir stringByAppendingString:@"/mod_pan.png"] WithFillType:ftTexture WithGameScene:self];

    gameObjectPlist = [[NSDictionary alloc] initWithContentsOfFile:[pathDocsDir stringByAppendingString:@"/mod.plist"]];
    gameObjectSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:[pathDocsDir stringByAppendingString:@"/mod.png"] WithFillType:ftTexture WithGameScene:self];
    
    cityPlist = [[NSDictionary alloc] initWithContentsOfFile:[pathDocsDir stringByAppendingString:@"/city.plist"]];
    citySpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:[pathDocsDir stringByAppendingString:@"/bg_exit.png"] WithFillType:ftTexture WithGameScene:self];

    fonSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:100 WithTexture:[pathDocsDir stringByAppendingString:@"/bg1.png"] WithFillType:ftTexture WithGameScene:self];
    
    purPlist = [[NSDictionary alloc] initWithContentsOfFile:[pathDocsDir stringByAppendingString:@"/purpro0.plist"]];
    purSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:[pathDocsDir stringByAppendingString:@"/purpro0.png"] WithFillType:ftTexture WithGameScene:self];
#endif
    
    //Создаем камеру
    SSpeed cameraSpeed;
    cameraSpeed.x = 0;
    cameraSpeed.y = 0;
    camera = [[CCamera alloc] initWithPosition:CGPointMake(0, 0) WithOpenglPosition:CGPointMake(-160, -240) WithSpeed:cameraSpeed];
   
    //Параметры трека
    isTrek = true;
    isTrekClean = false;
    
    //Создаем текстурный атлас "Панель управления"
    if (!panelPlist)
        panelPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mod_pan" ofType:@"plist"]];
    if (!panelSpriteStorage)
        panelSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:@"mod_pan.png" WithFillType:ftTexture WithGameScene:self];
    
    //Создаем текстурный атлас "Игровые объекты"
    if (!gameObjectPlist)
        gameObjectPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mod" ofType:@"plist"]];
    if (!gameObjectSpriteStorage)
        gameObjectSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:@"mod.png" WithFillType:ftTexture WithGameScene:self];
    
    //Создаем текстурный атлас "Город"
    if (!cityPlist)
        cityPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
    if (!citySpriteStorage)
        citySpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:@"bg_exit.png" WithFillType:ftTexture WithGameScene:self];
    
    //Создаем текстурный атлас "Фон"
    if (!fonSpriteStorage)
        fonSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:100 WithTexture:@"bg1.png" WithFillType:ftTexture WithGameScene:self];
    
    //Создаем текстурный атлас ui
    if (!purPlist)
        purPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"purpro0" ofType:@"plist"]];
    if (!purSpriteStorage)
        purSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:@"purpro0.png" WithFillType:ftTexture WithGameScene:self];
    
    //Создаем хранилище спрайтов трека
    trekSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10000 WithTexture:@"" WithFillType:ftColor WithGameScene:self];
    
    //Создаем хранилище спрайтов радара
    radarSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:10 WithTexture:@"" WithFillType:ftColor WithGameScene:self];
    
    //Спрайты панели
    //Горизонтальная платформа для ползунка управления скоростью поворота
    SRect panelRect;
    SImageSequence *panelImageSequence = malloc(sizeof(SImageSequence));
    SColor panelColor;
    SSpeed panelSpeed;
    
    getDataFromPlist(panelPlist, @"pan_hor", panelSpriteStorage.textureAtlasWidth, panelSpriteStorage.textureAtlasHeight, &panelRect, &panelImageSequence[0].images[0], &panelColor, &panelSpeed);
    
    panHorSprite = [[CSprite alloc] initWithGameController:gameController WithRect:panelRect WithImageSequences:panelImageSequence WithColor:panelColor WithSpeed:panelSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    panHorSprite.name = @"pan_hor";
    [panelSpriteStorage addSprite:panHorSprite];
    
    [camera addSprite:panHorSprite];
    
    //Вертикальная платформа ползунка для управления скоростью движения
    panelImageSequence = malloc(sizeof(SImageSequence));
    
    getDataFromPlist(panelPlist, @"pan_vert", panelSpriteStorage.textureAtlasWidth, panelSpriteStorage.textureAtlasHeight, &panelRect, &panelImageSequence[0].images[0], &panelColor, &panelSpeed);
        
    panVerSprite = [[CSprite alloc] initWithGameController:gameController WithRect:panelRect WithImageSequences:panelImageSequence WithColor:panelColor WithSpeed:panelSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    panVerSprite.name = @"pan_vert";
    [panelSpriteStorage addSprite:panVerSprite];
    
    [camera addSprite:panVerSprite];
    
    //Ползунок поворота
    SRect turnSpeedSliderRect;
    SImageSequence *turnSpeedSliderImageSequence = malloc(sizeof(SImageSequence));
    SColor turnSpeedSliderColor;
    SSpeed turnSpeedSliderSpeed;
    
    getDataFromPlist(panelPlist, @"ui_direct_control", panelSpriteStorage.textureAtlasWidth, panelSpriteStorage.textureAtlasHeight, &turnSpeedSliderRect, &turnSpeedSliderImageSequence[0].images[0], &turnSpeedSliderColor, &turnSpeedSliderSpeed);
    
    turnSpeedSliderSprite = [[CSlider alloc] initWithGameController:gameController WithRect:turnSpeedSliderRect WithImageSequences:turnSpeedSliderImageSequence WithColor:turnSpeedSliderColor WithPlist:[panelPlist objectForKey:@"ui_direct_control"]];
    turnSpeedSliderSprite.name = @"turnSpeedSlider";
    
    [panelSpriteStorage addSprite:turnSpeedSliderSprite];
    
    [camera addSprite:turnSpeedSliderSprite];
    
    //Ползунок скорости
    SRect speedSliderRect;
    SImageSequence *speedSliderImageSequence = malloc(sizeof(SImageSequence));
    SColor speedSliderColor;
    SSpeed speedSliderSpeed;
    
    getDataFromPlist(panelPlist, @"ui_speed_control", panelSpriteStorage.textureAtlasWidth, panelSpriteStorage.textureAtlasHeight, &speedSliderRect, &speedSliderImageSequence[0].images[0], &speedSliderColor, &speedSliderSpeed);
    
    speedSliderSprite = [[CSlider alloc] initWithGameController:gameController WithRect:speedSliderRect WithImageSequences:speedSliderImageSequence WithColor:speedSliderColor WithPlist:[panelPlist objectForKey:@"ui_speed_control"]];
    speedSliderSprite.name = @"speedSlider";
    
    [panelSpriteStorage addSprite:speedSliderSprite];
    
    [camera addSprite:speedSliderSprite];
        
    /* SRect turnControlRect;
    SImageSequence *turnControlImageSequence = malloc(sizeof(SImageSequence));
    SColor turnControlColor;
    SSpeed turnControlSpeed;
    
    getDataFromPlist(panelPlist, @"turn_control", panelSpriteStorage.textureAtlasWidth, panelSpriteStorage.textureAtlasHeight, &turnControlRect, &turnControlImageSequence[0].images[0], &turnControlColor, &turnControlSpeed);
        
    turnControlSprite = [[CTurnControl alloc] initWithGameController:gameController WithRect:turnControlRect WithImageSequences:turnControlImageSequence WithColor:turnControlColor WithSpeed:turnControlSpeed WithDestSprite:nil];
    turnControlSprite.name = @"turnControl";
    [panelSpriteStorage addSprite:turnControlSprite];*/
    
    
    //Игровые спрайты
    SImageSequence *playerImageSequence = malloc(sizeof(SImageSequence));
    SColor playerColor;
    SSpeed playerSpeed;
    SRect playerRect;
    
    getDataFromPlist([gameObjectPlist objectForKey:@"mod_types"], @"model", gameObjectSpriteStorage.textureAtlasWidth, gameObjectSpriteStorage.textureAtlasHeight, &playerRect, &playerImageSequence[0].images[0], &playerColor, &playerSpeed);
    
    GLfloat playerH = playerRect.a.y - playerRect.c.y;
    playerRect.a.y = backingHeight - ((backingHeight - (panVerSprite.rect.a.y - panVerSprite.rect.c.y)) - playerH)/2;
    playerRect.b.y = playerRect.a.y;
    playerRect.c.y = playerRect.a.y - playerH;
    playerRect.d.y = playerRect.c.y;
    
    playerSprite = [[CPlayer alloc] initWithGameController:gameController WithRect:playerRect WithImageSequences:playerImageSequence WithColor:playerColor WithSpeed:playerSpeed WithRotateSpeed:maxRotateSpeed WithRotateBasePoint:CGPointMake(8, 16)];
    
    playerSprite.name = @"player";
    playerSprite.isSector = true;
    
    [gameObjectSpriteStorage addSprite:playerSprite];
    
    [camera addSprite:playerSprite];
    
    //turnControlSprite.destSprite = playerSprite;
    
    //[playerSprite rotate:50];
        
    //Спрайты городов
    SImageSequence *cityImageSequence1 = malloc(sizeof(SImageSequence));
    SImageSequence *cityImageSequence2 = malloc(sizeof(SImageSequence));
    SColor cityColor;
    SSpeed citySpeed;
    SRect cityRect;
    
    //City 1
    cityImageSequence1->images[0].origin.x = 0;
    cityImageSequence1->images[0].origin.y = 0;
    cityImageSequence1->images[0].size.width = 200/citySpriteStorage.textureAtlasWidth;
    cityImageSequence1->images[0].size.height = 200/citySpriteStorage.textureAtlasHeight;
    
    cityRect.a.x = 0;
    cityRect.a.y = 200;
    cityRect.b.x = cityRect.a.x + 200;
    cityRect.b.y = cityRect.a.y;
    cityRect.c.x = cityRect.a.x;
    cityRect.c.y = cityRect.a.y - 200;
    cityRect.d.x = cityRect.b.x;
    cityRect.d.y = cityRect.c.y;
    
    cityColor.red = 255;
    cityColor.green = 255;
    cityColor.blue = 255;
    cityColor.alpha = 255;
    
    citySpeed.x = 0;
    citySpeed.y = 0;
    
    citySpriteStart = [[CSprite alloc] initWithGameController:gameController WithRect:cityRect WithImageSequences:cityImageSequence1 WithColor:cityColor WithSpeed:citySpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    
    citySpriteStart.name = @"city1";
    
    [citySpriteStorage addSprite:citySpriteStart];
    
    //City 2
    cityImageSequence2->images[0].origin.x = 0;
    cityImageSequence2->images[0].origin.y = 0;
    cityImageSequence2->images[0].size.width = 200/citySpriteStorage.textureAtlasWidth;
    cityImageSequence2->images[0].size.height = 200/citySpriteStorage.textureAtlasHeight;
    
    cityRect.a.x = WORLD_CELL_COUNT_X*FON_CELL_SIZE_X - 200;
    cityRect.a.y = WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y;
    cityRect.b.x = cityRect.a.x + 200;
    cityRect.b.y = cityRect.a.y;
    cityRect.c.x = cityRect.a.x;
    cityRect.c.y = cityRect.a.y - 200;
    cityRect.d.x = cityRect.b.x;
    cityRect.d.y = cityRect.c.y;
    
    cityColor.red = 255;
    cityColor.green = 255;
    cityColor.blue = 255;
    cityColor.alpha = 255;    
    
    citySpriteFinish = [[CSprite alloc] initWithGameController:gameController WithRect:cityRect WithImageSequences:cityImageSequence2 WithColor:cityColor WithSpeed:citySpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    
    citySpriteFinish.name = @"city2";
    
    [citySpriteStorage addSprite:citySpriteFinish];
    
    SRect rect;
    SImageSequence *imageSequence;
    SColor color;
    SSpeed speed;
    
    //Фон заполняем заранее
    for (int x = 0; x < WORLD_CELL_COUNT_X; x++)
    {
        for (int y = 1; y <= WORLD_CELL_COUNT_Y; y++)
        {
            rect.a.x = x*FON_CELL_SIZE_X;
            rect.a.y = y*FON_CELL_SIZE_Y;
            rect.b.x = rect.a.x + FON_CELL_SIZE_X;
            rect.b.y = rect.a.y;
            rect.c.x = rect.a.x;
            rect.c.y = rect.a.y - FON_CELL_SIZE_Y;
            rect.d.x = rect.b.x;
            rect.d.y = rect.c.y;
            
            imageSequence = malloc(sizeof(SImageSequence));
            imageSequence[0].name = @"default";
            imageSequence[0].imageCount = 1;
            imageSequence[0].images[0].origin.x = 0;
            imageSequence[0].images[0].origin.y = 0;
            imageSequence[0].images[0].size.width = FON_CELL_SIZE_X/fonSpriteStorage.textureAtlasWidth;
            imageSequence[0].images[0].size.height = FON_CELL_SIZE_Y/fonSpriteStorage.textureAtlasHeight;
            
            color.red = 255;
            color.green = 255;
            color.blue = 255;
            color.alpha = 255;
            
            speed.x = 0;
            speed.y = 0;
            
            CSprite *cellSprite = [[CSprite alloc] initWithGameController:gameController WithRect:rect WithImageSequences:imageSequence WithColor:color WithSpeed:speed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
            [fonSpriteStorage addSprite:cellSprite];
        }
    }
    
    //Создаем препятствия
    uiDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ui" ofType:@"plist"]];
    obstSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:1000 WithTexture:@"ui.png" WithFillType:ftTexture WithGameScene:self];
    [self createObstakles];
    [self createObstaklesPreview]; //Генерируем спрайты предпросмотра препятствий
    
    //Создаем спрайт "Переход"
    transferSpriteStorage = [[CSpriteStorage alloc] initWithSpriteCount:1 WithTexture:@"" WithFillType:ftColor WithGameScene:self];
    CTransfer *transfer = [[CTransfer alloc] initWithGameController:gameController];
    [transferSpriteStorage addSprite:transfer];
    [camera addSprite:transfer];
    
    //Создаем радар
    [self initRadar];
    
    //Разбиваем игровое пространство на сектора
    [self createSectors];
    
    //Создаем индикатор близости
    SRect lampRect;
    SImageSequence *lampImageSequence = malloc(sizeof(SImageSequence));
    //lampImageSequence[0].imageCount
    SColor lampColor;
    SSpeed lampSpeed;
    
    for (Byte f = 7; f >= 1; f--)
        getDataFromPlist(purPlist, [NSString stringWithFormat:@"frame%d",f], purSpriteStorage.textureAtlasWidth, purSpriteStorage.textureAtlasHeight, &lampRect, &lampImageSequence[0].images[7-f], &lampColor, &lampSpeed);
    
    lampImageSequence[0].imageCount = 7;
    
    indicatorSprite = [[CLightIndicator alloc] initWithGameController:gameController WithRect:lampRect WithImageSequences:lampImageSequence];
    
    indicatorSprite.camera = camera;
    
    [purSpriteStorage addSprite:indicatorSprite];
   
    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{        
    //В зависимости от состояния сцены апдейтим те или иные спрайты
    switch (sceneState)
    {
        case 1: //Предпросмотр карты
            [citySpriteStoragePreview move:deltaTime :touchMessage :accelerometerMessage];
            [obstSpriteStoragePreview move:deltaTime :touchMessage :accelerometerMessage];
            
            //Если коснулись экрана, то переходим к игре
            if (touchMessage.isRight && touchMessage.type == 2)
            {
                [camera setPosition:CGPointMake(-60, -225)];
                
                lastTrekPoint.x = playerSprite.rotateBasePoint.x + camera.position.x;
                lastTrekPoint.y = playerSprite.rotateBasePoint.y + camera.position.y;
                
                sceneState = 2;
            }
    
            break;
       
        case 2: //Игра
        {
            //Проверяем, достигли ли финиша
            SRect playerRect = playerSprite.rect;
            kt_mlOffsetPolygon(&playerRect, CGSizeMake(camera.position.x, camera.position.y));
            if (kt_mlIsRectContainsPoint(citySpriteFinish.rect, playerRect.a) && kt_mlIsRectContainsPoint(citySpriteFinish.rect, playerRect.b) && kt_mlIsRectContainsPoint(citySpriteFinish.rect, playerRect.c) && kt_mlIsRectContainsPoint(citySpriteFinish.rect, playerRect.d))
            {
                [self doFinish];
            }
            
            //Проверяем, коснулись ли экрана и нужно ли соответственно тормозить или двигать игрока
            /*if (touchMessage.isRight && touchMessage.type == 2 && !kt_mlIsRectContainsPoint(turnControlSprite.rect, touchMessage.newLocation))
            {
                if (currMoveSpeed)
                    currMoveSpeed = 0;
                else
                    currMoveSpeed = 120;
            }*/

            playerSprite.rotateSpeed = -turnSpeedSliderSprite.value;
            GLfloat dist = sqrtf((playerSprite.rect.a.x - playerSprite.rect.c.x)*(playerSprite.rect.a.x - playerSprite.rect.c.x) + (playerSprite.rect.a.y - playerSprite.rect.c.y)*(playerSprite.rect.a.y - playerSprite.rect.c.y));
            SSpeed speed;
            speed.x = speedSliderSprite.value*(playerSprite.rect.a.x - playerSprite.rect.c.x)/dist;
            speed.y = speedSliderSprite.value*(playerSprite.rect.a.y - playerSprite.rect.c.y)/dist;
            camera.speed = speed;
            
            [camera move:deltaTime];
            [self processCollisionsWithObst];
            
            //Рисуем трек
            if (isTrekClean)
            {
                [trekSpriteStorage clear];
                isTrekClean = false;
            }
    
            if (isTrek)
            {
                CGPoint location;
                location.x = playerSprite.rotateBasePoint.x + camera.position.x;
                location.y = playerSprite.rotateBasePoint.y + camera.position.y;
                [self drawTrek:location];
            }
            
            [self setPlayerRadarPosition];
            
            [self updateFrequenceWinking];
            
            [fonSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [citySpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [trekSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [obstSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [gameObjectSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [panelSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [transferSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [radarSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
            [purSpriteStorage move:deltaTime :touchMessage :accelerometerMessage];
           
            break;
        }
            
        case 3: //Вывод результата
            ;
            
        default: break;
    }
}

- (void) render
{
    switch (sceneState)
    {
        case 1:
            [citySpriteStoragePreview render];
            [obstSpriteStoragePreview render];
            
            break;
            
        case 2:
            [fonSpriteStorage render];
            [citySpriteStorage render];
            [trekSpriteStorage render];
            [obstSpriteStorage render];
            [gameObjectSpriteStorage render];
            [panelSpriteStorage render];
            [radarSpriteStorage render];
            [purSpriteStorage render];
            [transferSpriteStorage render];
            
            break;
 
        default:
            break;
    }
}

- (void) drawTrek: (CGPoint)point
{
    SRect rect;
    CGPoint point0;
    CGFloat r = sqrtf((point.x - lastTrekPoint.x)*(point.x - lastTrekPoint.x) + (point.y - lastTrekPoint.y)*(point.y - lastTrekPoint.y));
    while (r/TREK_POINT_DIST >= 1.0)
    {
        point0.x = lroundf(lastTrekPoint.x + (point.x - lastTrekPoint.x)*TREK_POINT_DIST/r);
        point0.y = lroundf(lastTrekPoint.y + (point.y - lastTrekPoint.y)*TREK_POINT_DIST/r);
        
        rect.a.x = point0.x - TREK_POINT_SIZE/2;
        rect.a.y = point0.y + TREK_POINT_SIZE/2;
        rect.b.x = point0.x + TREK_POINT_SIZE/2;
        rect.b.y = point0.y + TREK_POINT_SIZE/2;
        rect.c.x = point0.x - TREK_POINT_SIZE/2;
        rect.c.y = point0.y - TREK_POINT_SIZE/2;
        rect.d.x = point0.x + TREK_POINT_SIZE/2;
        rect.d.y = point0.y - TREK_POINT_SIZE/2;
        
        SImageSequence *trekImageSequence = malloc(sizeof(SImageSequence));
        SColor trekColor;
        SSpeed trekSpeed;
        
        trekImageSequence[0].name = @"default";
        trekImageSequence[0].imageCount = 1;
        trekImageSequence[0].images[0].origin.x = 0;
        trekImageSequence[0].images[0].origin.y = 0;
        trekImageSequence[0].images[0].size.width = 0;
        trekImageSequence[0].images[0].size.height = 0;
        
        trekColor.red = 0;
        trekColor.green = 255;
        trekColor.blue = 0;
        trekColor.alpha = 255;
        
        trekSpeed.x = 0;
        trekSpeed.y = 0;
        
        CSprite *trek = [[CSprite alloc] initWithGameController:gameController WithRect:rect WithImageSequences:trekImageSequence WithColor:trekColor WithSpeed:trekSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
        [trekSpriteStorage addSprite:trek];
        
        
        lastTrekPoint = point0;
        
        //Вычисляем расстояние между текущей точкой и последним пунктом трека
        r = sqrtf((point.x - lastTrekPoint.x)*(point.x - lastTrekPoint.x) + (point.y - lastTrekPoint.y)*(point.y - lastTrekPoint.y));
    }
}

- (void) drawFon
{
    GLfloat X = (short)gameController.screenX;
    GLfloat Y = (short)gameController.screenY;
    
    //Удаляем предыдущие полигоны фона
    [fonSpriteStorage clear];
    
    //Считаем кол-во ячеек фона, которые нужно отрисовать
    short cellCountX = (int)(backingWidth/FON_CELL_SIZE_X) + 2;
    short cellCountY = (int)(backingHeight/FON_CELL_SIZE_Y) + 2;
    
    //Отрисовываем полигоны
    SRect rect;
    SImageSequence *imageSequence;
    SColor color;
    SSpeed speed;
    
    GLfloat lastX, lastY;
    
    lastX = (int)(X/FON_CELL_SIZE_X)*FON_CELL_SIZE_X;
    
    for (short x = 0; x < cellCountX; x++)
    {
        lastY = (int)(Y/FON_CELL_SIZE_Y + 1)*FON_CELL_SIZE_Y;
        for (short y = 0; y < cellCountY; y++)
        {
            rect.a.x = lastX;
            rect.a.y = lastY;
            rect.b.x = rect.a.x + FON_CELL_SIZE_X;
            rect.b.y = rect.a.y;
            rect.c.x = rect.a.x;
            rect.c.y = rect.a.y - FON_CELL_SIZE_Y;
            rect.d.x = rect.b.x;
            rect.d.y = rect.c.y;
            
            imageSequence = malloc(sizeof(SImageSequence));
            imageSequence[0].name = @"default";
            imageSequence[0].imageCount = 1;
            imageSequence[0].images[0].origin.x = 0;
            imageSequence[0].images[0].origin.y = 0;
            imageSequence[0].images[0].size.width = FON_CELL_SIZE_X/fonSpriteStorage.textureAtlasWidth;
            imageSequence[0].images[0].size.height = FON_CELL_SIZE_Y/fonSpriteStorage.textureAtlasHeight;
            
            color.red = 255;
            color.green = 255;
            color.blue = 255;
            color.alpha = 255;
            
            speed.x = 0;
            speed.y = 0;
            
            if (lastX/FON_CELL_SIZE_X >= 0 && lastX/FON_CELL_SIZE_X < WORLD_CELL_COUNT_X && lastY/FON_CELL_SIZE_Y - 1 >= 0 && lastY/FON_CELL_SIZE_Y - 1 < WORLD_CELL_COUNT_Y)
            {
                CSprite *cellSprite = [[CSprite alloc] initWithGameController:gameController WithRect:rect WithImageSequences:imageSequence WithColor:color
                                                         WithSpeed:speed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
                [fonSpriteStorage addSprite:cellSprite];
            }
            
            lastY -= FON_CELL_SIZE_Y;
        }
        lastX += FON_CELL_SIZE_X;
    }
}

- (void) scroll:(double)deltaTime
{
    //Ускорение
    /*makedBySliderMoveSpeed = maxMoveSpeed*speedSliderSprite.value;
    
    if (currMoveSpeed != makedBySliderMoveSpeed)
    {
        if (currMoveSpeed < makedBySliderMoveSpeed)
        {
            if (currMoveSpeed + deltaTime*moveAcceler > makedBySliderMoveSpeed)
                currMoveSpeed = makedBySliderMoveSpeed;
            else
                currMoveSpeed += deltaTime*moveAcceler;
        }
        else if (currMoveSpeed > makedBySliderMoveSpeed)
        {
            if (currMoveSpeed + deltaTime*moveAcceler < makedBySliderMoveSpeed)
                currMoveSpeed = makedBySliderMoveSpeed;
            else
                currMoveSpeed -= deltaTime*moveAcceler;
        }
    }
    currMoveSpeed = 120;*/

    
    //Вычисляем текущую скорость
    GLfloat speedX = currMoveSpeed*(playerSprite.rect.a.x - playerSprite.rect.c.x)/sqrt((playerSprite.rect.a.y - playerSprite.rect.c.y)*(playerSprite.rect.a.y - playerSprite.rect.c.y) + (playerSprite.rect.a.x - playerSprite.rect.c.x)*(playerSprite.rect.a.x - playerSprite.rect.c.x));
    GLfloat speedY = currMoveSpeed*(playerSprite.rect.a.y - playerSprite.rect.c.y)/sqrt((playerSprite.rect.a.y - playerSprite.rect.c.y)*(playerSprite.rect.a.y - playerSprite.rect.c.y) + (playerSprite.rect.a.x - playerSprite.rect.c.x)*(playerSprite.rect.a.x - playerSprite.rect.c.x));
    
   
    //Вычисляем смещение за дельта-тайм
    GLfloat deltaX = speedX*deltaTime;
    GLfloat deltaY = speedY*deltaTime;
    
    //Необходимо ограничить смещение в случае выхода объекта за границу игровой площади
    SRect rect = playerSprite.rect;
    if (rect.a.x + deltaX > WORLD_CELL_COUNT_X*FON_CELL_SIZE_X)
        deltaX = WORLD_CELL_COUNT_X*FON_CELL_SIZE_X - rect.a.x;
    if (rect.b.x + deltaX > WORLD_CELL_COUNT_X*FON_CELL_SIZE_X)
        deltaX = WORLD_CELL_COUNT_X*FON_CELL_SIZE_X - rect.b.x;
    
    if (rect.a.x + deltaX < 0)
        deltaX = -rect.a.x;
    if (rect.b.x + deltaX < 0)
        deltaX = -rect.b.x;
    
    if (rect.a.y + deltaY > WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y)
        deltaY = WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y - rect.a.y;
    if (rect.b.y + deltaY > WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y)
        deltaY = WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y - rect.b.y;

    if (rect.a.y + deltaY < 0)
        deltaY = -rect.a.y;
    if (rect.b.y + deltaY < 0)
        deltaY = -rect.b.y;
    
    
    gameController.screenX += deltaX;
    gameController.screenY += deltaY;
    
    translateX -= deltaX;
    translateY -= deltaY;
    
    //Cмещаем панель управления
    for (short i = 0; i < panelSpriteStorage.count; i++)
    {
        SRect rect = [panelSpriteStorage getSpriteByIndex:i].rect;
        rect.a.x += deltaX;
        rect.a.y += deltaY;
        rect.b.x += deltaX;
        rect.b.y += deltaY;
        rect.c.x += deltaX;
        rect.c.y += deltaY;
        rect.d.x += deltaX;
        rect.d.y += deltaY;
        [panelSpriteStorage getSpriteByIndex:i].rect = rect;
    }
    
    //Смещаем игрока
    rect = playerSprite.rect;
    rect.a.x += deltaX;
    rect.a.y += deltaY;
    rect.b.x += deltaX;
    rect.b.y += deltaY;
    rect.c.x += deltaX;
    rect.c.y += deltaY;
    rect.d.x += deltaX;
    rect.d.y += deltaY;
    playerSprite.rect = rect;
        
    CGPoint rotateBasePoint;
    rotateBasePoint = playerSprite.rotateBasePoint;
    rotateBasePoint.x += deltaX;
    rotateBasePoint.y += deltaY;
    playerSprite.rotateBasePoint = rotateBasePoint;
    
    //Смещаем переход
    for (short i = 0; i < transferSpriteStorage.count; i++)
    {
        SRect rect = [transferSpriteStorage getSpriteByIndex:i].rect;
        rect.a.x += deltaX;
        rect.a.y += deltaY;
        rect.b.x += deltaX;
        rect.b.y += deltaY;
        rect.c.x += deltaX;
        rect.c.y += deltaY;
        rect.d.x += deltaX;
        rect.d.y += deltaY;
        [transferSpriteStorage getSpriteByIndex:i].rect = rect;
    }

   
    //Двигаем камеру
    glLoadIdentity();
    glTranslatef((short)(translateX), (short)(translateY), 0);    
}

- (void) doFinish
{
    [(AppDelegate *)[gameController getDelegate] showResult:colliseCount];
}

- (void) createObstakles
{
    short MAP_COLS = CELL_COUNT_IN_FON_CELL_X*WORLD_CELL_COUNT_X;
    short MAP_ROWS = CELL_COUNT_IN_FON_CELL_Y*WORLD_CELL_COUNT_Y;
    
    Byte r = 2; //Радиус препятствия
    Byte n = 12; //Кол-во препятствий
    CGPoint freeCellCoords[MAP_ROWS*MAP_COLS]; //Массив координат ячеек для случайной выборки центра препятствия
    short freeCellCount;
    
    for (short i = 0; i < MAP_ROWS * MAP_COLS; i++) //Очищаем массив
    {
        Byte row = i / MAP_COLS;
        Byte col = i % MAP_COLS;
        
        if (col < r - 1 || col > MAP_COLS - r || row < r - 1 || row > MAP_ROWS - r)
            obstMap[row][col] = 255; //Эти ячейки не учавствуют в выборе центра препятствия
        else
            obstMap[row][col] = 0;
    }
    
    //Для того чтобы препятствие случайно не закрыло стартовую и конечную точки, запрещаем центр препятствий в этих двух точках
    for (int i = 0; i < 8; i++)
        for (int j = 0; j < 8; j++)
            obstMap[i][j] = 255;
    
    for (int i = MAP_ROWS - 8; i < MAP_ROWS; i++)
        for (int j = MAP_COLS - 8; j < MAP_COLS; j++)
            obstMap[i][j] = 255;
    
    obstMap[MAP_ROWS - 2][MAP_COLS - 2] = 255;
    
    for (Byte i = 1; i <= n; i++) //Цикл, равный кол-ву препятствий
    {
        //Заполняем массив freeCellCoords координатами ячеек-кандидатов на роль центра препятствия
        freeCellCount = 0;
        for (short j = 0; j < MAP_ROWS * MAP_COLS; j++)
        {
            if (obstMap[j / MAP_COLS][j % MAP_COLS] == 0)
            {
                freeCellCoords[freeCellCount].x = j % MAP_COLS;
                freeCellCoords[freeCellCount].y = j / MAP_COLS;
                freeCellCount++;
            }
        }
        
        if (freeCellCount)
        {
            //Выбираем ячейку для центра препятствия в случайном порядке
            short cellIndex = arc4random()%freeCellCount;
            Byte cellX = freeCellCoords[cellIndex].x;
            Byte cellY = freeCellCoords[cellIndex].y;
            
            //Заполняем ячейки вокруг центра препятствия с радиусом r
            for (short row = cellY - (r - 1); row <= cellY + (r - 1); row++)
                for (short col = cellX - (r - 1); col <= cellX + (r - 1); col++)
                    obstMap[row][col] = 1;
            
            //Ячейки, близлежащие к препятствию, не должны учавствовать в выборке центра для следующего препятствия
            for (short row = cellY - (2*r - 1); row <= cellY + (2*r - 1); row++)
                for (short col = cellX - (2*r - 1); col <= cellX + (2*r - 1); col++)
                    if (row >= 0 && row < MAP_ROWS && col >= 0 && col < MAP_COLS && obstMap[row][col] == 0)
                        obstMap[row][col] = 255;
        }
    }
    
    //На основе карты препятствий создаем спрайты для них
    SRect obstPointRect;
    SImageSequence *obstPointImageSequence; 
    SColor obstPointColor;
    SSpeed obstPointSpeed;
    
    for (short i = 0; i < MAP_ROWS * MAP_COLS; i++)
    {
        Byte row = i / MAP_COLS;
        Byte col = i % MAP_COLS;
        
        if (obstMap[row][col] == 1)
        {
            obstPointImageSequence = malloc(sizeof(SImageSequence));
            
            getDataFromPlist(uiDict, @"obst", obstSpriteStorage.textureAtlasWidth, obstSpriteStorage.textureAtlasHeight, &obstPointRect, &obstPointImageSequence[0].images[0], &obstPointColor, &obstPointSpeed);
            
            GLfloat obstW = obstPointRect.b.x - obstPointRect.a.x;
            GLfloat obstH = obstPointRect.a.y - obstPointRect.c.y;

            
            obstPointRect.a.x = 32*col;
            obstPointRect.a.y = 32*row + obstH;
            obstPointRect.b.x = obstPointRect.a.x + obstW;
            obstPointRect.b.y = obstPointRect.a.y;
            obstPointRect.c.x = obstPointRect.a.x;
            obstPointRect.c.y = obstPointRect.a.y - obstH;
            obstPointRect.d.x = obstPointRect.a.x + obstW;
            obstPointRect.d.y = obstPointRect.a.y - obstH;
            
            obstPointColor.red   = 255;
            obstPointColor.green = 255;
            obstPointColor.blue  = 255;
            
            CGPoint rotateBasePoint;
            rotateBasePoint.x = obstW/2;
            rotateBasePoint.y = obstH/2;
            
            obstPointColor.alpha = 0;
           
            CSprite *obstPoint = [[CSprite alloc] initWithGameController:gameController WithRect:obstPointRect WithImageSequences:obstPointImageSequence WithColor:obstPointColor WithSpeed:obstPointSpeed WithRotateSpeed:0 WithRotateBasePoint:rotateBasePoint];
            
            obstPoint.name = @"obst";
            obstPoint.isSector = true;
                        
            [obstSpriteStorage addSprite:obstPoint];
        }
    }
}

- (void) processCollisionsWithObst
{
    SRect playerRect = playerSprite.rect;
    kt_mlOffsetPolygon(&playerRect, CGSizeMake(camera.position.x, camera.position.y));
    
    short playerSectorX = playerSprite.sector.posInArray.x;
    short playerSectorY = playerSprite.sector.posInArray.y;
    
    for (short sectorX = playerSectorX - 1; sectorX <= playerSectorX + 1; sectorX++)
    {
        for (short sectorY = playerSectorY - 1; sectorY <= playerSectorY + 1; sectorY++)
        {
            if (sectorX >= 0 && sectorX < SECTOR_COUNT_X && sectorY >= 0 && sectorY < SECTOR_COUNT_Y)
            {
                CSector *sector = sectors[sectorY][sectorX];
                for (int i = 0; i < sector.sprites.count; i++)
                {
                    CSprite *sprite = (CSprite *)[sector.sprites objectAtIndex:i];
                    if (sprite.name == @"obst")
                    {
                        SRect obstRect = sprite.rect;
                        SColor obstColor = sprite.color;
                        
                        if (!obstColor.alpha)
                        {
                            if (kt_mlIsRectContainsPoint(obstRect, playerRect.a) || kt_mlIsRectContainsPoint(obstRect, playerRect.b)) //Произошло столкновение
                            {
                                //Делаем препятствие видимым на 100%
                                obstColor.alpha = 255;
                                sprite.color = obstColor;
                                
                                //Генерируем вспышку
                                CTransfer *trans = (CTransfer *)[transferSpriteStorage getSpriteByIndex:0];
                                
                                SSpeed s;
                                s.x = 100000;
                                s.y = 300;
                                [trans flashWithSpeed:s WithAlpha:150 WidthRed:255 WithGreen:255 WithBlue:255];
                                
                                colliseCount++;
                                
                                currMoveSpeed = 0;
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void) createObstaklesPreview
{
    //Вычисляем размер ячейки, на которые разбит экран
    GLfloat cellSizeX = backingWidth/(CELL_COUNT_IN_FON_CELL_X*WORLD_CELL_COUNT_X);
    GLfloat cellSizeY = backingHeight/(CELL_COUNT_IN_FON_CELL_Y*WORLD_CELL_COUNT_Y);
    
    //Инициализируем хранилища спрайтов
    obstSpriteStoragePreview = [[CSpriteStorage alloc] initWithSpriteCount:1000 WithTexture:@"ui.png" WithFillType:ftTexture WithGameScene:self];
    citySpriteStoragePreview = [[CSpriteStorage alloc] initWithSpriteCount:2 WithTexture:@"bg_exit.png" WithFillType:ftTexture WithGameScene:self];
        
    //Генерируем точки входа и выхода
    SImageSequence *cityImageSequence1 = malloc(sizeof(SImageSequence));
    SImageSequence *cityImageSequence2 = malloc(sizeof(SImageSequence));
    SColor cityColor;
    SSpeed citySpeed;
    SRect cityRect;
    
    //City 1
    cityImageSequence1->images[0].origin.x = 0;
    cityImageSequence1->images[0].origin.y = 0;
    cityImageSequence1->images[0].size.width = 200/citySpriteStoragePreview.textureAtlasWidth;
    cityImageSequence1->images[0].size.height = 200/citySpriteStoragePreview.textureAtlasHeight;
    
    cityRect.a.x = 0;
    cityRect.a.y = cellSizeY*7;
    cityRect.b.x = cityRect.a.x + cellSizeX*7;
    cityRect.b.y = cityRect.a.y;
    cityRect.c.x = cityRect.a.x;
    cityRect.c.y = cityRect.a.y - cellSizeY*7;
    cityRect.d.x = cityRect.b.x;
    cityRect.d.y = cityRect.c.y;
    
    cityColor.red = 255;
    cityColor.green = 255;
    cityColor.blue = 255;
    cityColor.alpha = 255;
    
    citySpeed.x = 0;
    citySpeed.y = 0;
    
    CSprite *cityStart = [[CSprite alloc] initWithGameController:gameController WithRect:cityRect WithImageSequences:cityImageSequence1 WithColor:cityColor WithSpeed:citySpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    
    cityStart.name = @"city1";
    
    [citySpriteStoragePreview addSprite:cityStart];
    
    //City 2
    cityImageSequence2->images[0].origin.x = 0;
    cityImageSequence2->images[0].origin.y = 0;
    cityImageSequence2->images[0].size.width = 200/citySpriteStoragePreview.textureAtlasWidth;
    cityImageSequence2->images[0].size.height = 200/citySpriteStoragePreview.textureAtlasHeight;
    
    cityRect.a.x = backingWidth - cellSizeX*7;
    cityRect.a.y = backingHeight;
    cityRect.b.x = backingWidth;
    cityRect.b.y = cityRect.a.y;
    cityRect.c.x = cityRect.a.x;
    cityRect.c.y = cityRect.a.y - cellSizeY*7;
    cityRect.d.x = cityRect.b.x;
    cityRect.d.y = cityRect.c.y;
    
    cityColor.red = 255;
    cityColor.green = 255;
    cityColor.blue = 255;
    cityColor.alpha = 255;
        
    CSprite *cityFinish = [[CSprite alloc] initWithGameController:gameController WithRect:cityRect WithImageSequences:cityImageSequence2 WithColor:cityColor WithSpeed:citySpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    
    cityFinish.name = @"city2";
    
    [citySpriteStoragePreview addSprite:cityFinish];
    
    //Генерируем препятствия
    for (int x = 0; x < CELL_COUNT_IN_FON_CELL_X*WORLD_CELL_COUNT_X; x++)
    {
        for (int y = 0; y < CELL_COUNT_IN_FON_CELL_Y*WORLD_CELL_COUNT_Y; y++)
        {
            SRect obstPointRect;
            SImageSequence *obstPointImageSequence;
            SColor obstPointColor;
            SSpeed obstPointSpeed;
          
            if (obstMap[y][x] == 1)
            {
                obstPointImageSequence = malloc(sizeof(SImageSequence));
                    
                getDataFromPlist(uiDict, @"obst", obstSpriteStoragePreview.textureAtlasWidth, obstSpriteStoragePreview.textureAtlasHeight, &obstPointRect, &obstPointImageSequence[0].images[0], &obstPointColor, &obstPointSpeed);
                    
                //GLfloat obstW = obstPointRect.b.x - obstPointRect.a.x;
                //GLfloat obstH = obstPointRect.a.y - obstPointRect.c.y;
                                   
                obstPointRect.a.x = cellSizeX*x;
                obstPointRect.a.y = cellSizeY*y + cellSizeY;
                obstPointRect.b.x = obstPointRect.a.x + cellSizeX;
                obstPointRect.b.y = obstPointRect.a.y;
                obstPointRect.c.x = obstPointRect.a.x;
                obstPointRect.c.y = obstPointRect.a.y - cellSizeY;
                obstPointRect.d.x = obstPointRect.a.x + cellSizeX;
                obstPointRect.d.y = obstPointRect.a.y - cellSizeY;
                    
                obstPointColor.red   = 255;
                obstPointColor.green = 255;
                obstPointColor.blue  = 255;
                    
                obstPointColor.alpha = 255;
                    
                CSprite *obstPoint = [[CSprite alloc] initWithGameController:gameController WithRect:obstPointRect WithImageSequences:obstPointImageSequence WithColor:obstPointColor WithSpeed:obstPointSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
                    
                obstPoint.name = @"obst";
                    
                [obstSpriteStoragePreview addSprite:obstPoint];
            }
        }
    }
}

- (void) initRadar
{
    //Создаем спрайты радара
    //Поле
    SImageSequence *radarImageSequence = malloc(sizeof(SImageSequence));
    SColor radarColor;
    SSpeed radarSpeed;
    SRect radarRect;
    
    GLfloat radarH = panVerSprite.rect.a.y - panHorSprite.rect.a.y;
    GLfloat radarW = radarH*(FON_CELL_SIZE_X*WORLD_CELL_COUNT_X)/(FON_CELL_SIZE_Y*WORLD_CELL_COUNT_Y);
    
    radarRect.a.x = 0;
    radarRect.a.y = panHorSprite.rect.a.y + radarH;
    radarRect.b.x = radarRect.a.x + radarW;
    radarRect.b.y = radarRect.a.y;
    radarRect.c.x = radarRect.a.x;
    radarRect.c.y = radarRect.a.y - radarH;
    radarRect.d.x = radarRect.b.x;
    radarRect.d.y = radarRect.c.y;
    
    radarImageSequence[0].name = @"default";
    radarImageSequence[0].imageCount = 1;
    radarImageSequence[0].images[0].origin.x = 0;
    radarImageSequence[0].images[0].origin.y = 0;
    radarImageSequence[0].images[0].size.width = 0;
    radarImageSequence[0].images[0].size.height = 0;
    
    radarColor.red = 255;
    radarColor.green = 255;
    radarColor.blue = 255;
    radarColor.alpha = 100;
    
    radarSpeed.x = 0;
    radarSpeed.y = 0;
    
    radarSprite = [[CSprite alloc] initWithGameController:gameController WithRect:radarRect WithImageSequences:radarImageSequence WithColor:radarColor WithSpeed:radarSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    [radarSpriteStorage addSprite:radarSprite];
    
    [camera addSprite:radarSprite];
    
    //Вход
    SImageSequence *radarCityImageSequence = malloc(sizeof(SImageSequence));
    SColor radarCityColor;
    SSpeed radarCitySpeed;
    SRect radarCityRect;
    
    GLfloat radarCityWidth = radarW*(citySpriteStart.rect.b.x - citySpriteStart.rect.a.x)/(FON_CELL_SIZE_X*WORLD_CELL_COUNT_X);
    GLfloat radarCityHeight = radarH*(citySpriteStart.rect.a.y - citySpriteStart.rect.c.y)/(FON_CELL_SIZE_Y*WORLD_CELL_COUNT_Y);
    
    radarCityRect.a.x = radarRect.a.x;
    radarCityRect.a.y = radarRect.c.y + radarCityHeight;
    radarCityRect.b.x = radarCityRect.a.x + radarCityWidth;
    radarCityRect.b.y = radarCityRect.a.y;
    radarCityRect.c.x = radarCityRect.a.x;
    radarCityRect.c.y = radarCityRect.a.y - radarCityHeight;
    radarCityRect.d.x = radarCityRect.b.x;
    radarCityRect.d.y = radarCityRect.c.y;
    
    radarCityImageSequence[0].name = @"default";
    radarCityImageSequence[0].imageCount = 1;
    radarCityImageSequence[0].images[0].origin.x = 0;
    radarCityImageSequence[0].images[0].origin.y = 0;
    radarCityImageSequence[0].images[0].size.width = 0;
    radarCityImageSequence[0].images[0].size.height = 0;
    
    radarCityColor.red = 255;
    radarCityColor.green = 0;
    radarCityColor.blue = 0;
    radarCityColor.alpha = 100;
    
    radarCitySpeed.x = 0;
    radarCitySpeed.y = 0;
    
    CSprite *radarCity = [[CSprite alloc] initWithGameController:gameController WithRect:radarCityRect WithImageSequences:radarCityImageSequence WithColor:radarCityColor WithSpeed:radarCitySpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    [radarSpriteStorage addSprite:radarCity];
    
    [camera addSprite:radarCity];
    

    //Выход
    radarCityImageSequence[0].name = @"default";
    radarCityImageSequence[0].imageCount = 1;
    radarCityImageSequence[0].images[0].origin.x = 0;
    radarCityImageSequence[0].images[0].origin.y = 0;
    radarCityImageSequence[0].images[0].size.width = 0;
    radarCityImageSequence[0].images[0].size.height = 0;

    kt_mlOffsetPolygon(&radarCityRect, CGSizeMake(radarW - radarCityWidth, radarH - radarCityHeight));
    
    radarCity = [[CSprite alloc] initWithGameController:gameController WithRect:radarCityRect WithImageSequences:radarCityImageSequence WithColor:radarCityColor WithSpeed:radarCitySpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    [radarSpriteStorage addSprite:radarCity];
    
    [camera addSprite:radarCity];

    //Игрок
    SImageSequence *radarPlayerImageSequence = malloc(sizeof(SImageSequence));
    SColor radarPlayerColor;
    SSpeed radarPlayerSpeed;
    SRect radarPlayerRect;
    
    GLfloat radarPlayerWidth = 4;
    GLfloat radarPlayerHeight = 4;
    
    radarPlayerRect.a.x = 0;
    radarPlayerRect.a.y = 0;
    radarPlayerRect.b.x = radarPlayerRect.a.x + radarPlayerWidth;
    radarPlayerRect.b.y = radarPlayerRect.a.y;
    radarPlayerRect.c.x = radarPlayerRect.a.x;
    radarPlayerRect.c.y = radarPlayerRect.a.y - radarPlayerHeight;
    radarPlayerRect.d.x = radarPlayerRect.b.x;
    radarPlayerRect.d.y = radarPlayerRect.c.y;
    
    radarPlayerImageSequence[0].name = @"default";
    radarPlayerImageSequence[0].imageCount = 1;
    radarPlayerImageSequence[0].images[0].origin.x = 0;
    radarPlayerImageSequence[0].images[0].origin.y = 0;
    radarPlayerImageSequence[0].images[0].size.width = 0;
    radarPlayerImageSequence[0].images[0].size.height = 0;
    
    radarPlayerColor.red = 0;
    radarPlayerColor.green = 0;
    radarPlayerColor.blue = 255;
    radarPlayerColor.alpha = 100;
    
    radarPlayerSpeed.x = 0;
    radarPlayerSpeed.y = 0;
    
    [self setPlayerRadarPosition];
    
    playerRadarSprite = [[CSprite alloc] initWithGameController:gameController WithRect:radarPlayerRect WithImageSequences:radarPlayerImageSequence WithColor:radarPlayerColor WithSpeed:radarPlayerSpeed WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    [radarSpriteStorage addSprite:playerRadarSprite];
    
    [camera addSprite:playerRadarSprite];
}

- (void) setPlayerRadarPosition
{
    GLfloat playerRadarW = playerRadarSprite.rect.b.x - playerRadarSprite.rect.a.x;
    GLfloat playerRadarH = playerRadarSprite.rect.a.y - playerRadarSprite.rect.c.y;
    
    SRect playerRadarRect = playerRadarSprite.rect;
    
    playerRadarRect.a.x = radarSprite.rect.c.x + (radarSprite.rect.b.x - radarSprite.rect.a.x)*(playerSprite.rotateBasePoint.x + camera.position.x)/(WORLD_CELL_COUNT_X*FON_CELL_SIZE_X) - playerRadarW/2;
    playerRadarRect.a.y = radarSprite.rect.c.y + (radarSprite.rect.a.y - radarSprite.rect.c.y)*(playerSprite.rotateBasePoint.y + camera.position.y)/(WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y) + playerRadarH/2;
    playerRadarRect.b.x = playerRadarRect.a.x + playerRadarW;
    playerRadarRect.b.y = playerRadarRect.a.y;
    playerRadarRect.c.x = playerRadarRect.a.x;
    playerRadarRect.c.y = playerRadarRect.a.y - playerRadarH;
    playerRadarRect.d.x = playerRadarRect.b.x;
    playerRadarRect.d.y = playerRadarRect.c.y;
    
    playerRadarSprite.rect = playerRadarRect;
}

- (void) createSectors
{
    sectors = malloc(sizeof(CSector**)*SECTOR_COUNT_Y);
    for (int y = 0; y < SECTOR_COUNT_Y; y++)
    {
        sectors[y] = malloc(sizeof(CSector *)*SECTOR_COUNT_X);
        for (int x = 0; x < SECTOR_COUNT_X; x++)
            sectors[y][x] = [[CSector alloc] initWithGeometry:CGRectMake(x*(WORLD_CELL_COUNT_X*FON_CELL_SIZE_X/SECTOR_COUNT_X), y*(WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y/SECTOR_COUNT_Y), WORLD_CELL_COUNT_X*FON_CELL_SIZE_X/SECTOR_COUNT_X, WORLD_CELL_COUNT_Y*FON_CELL_SIZE_Y/SECTOR_COUNT_Y) WithPosInArray:CGPointMake(x, y)];
    }
}

- (void) updateFrequenceWinking
{
    short playerSectorX = playerSprite.sector.posInArray.x;
    short playerSectorY = playerSprite.sector.posInArray.y;
    
    GLfloat R = 100;
    
    //Определяем расстояние до ближайшего препятствия
    for (short sectorX = playerSectorX - 1; sectorX <= playerSectorX + 1; sectorX++)
    {
        for (short sectorY = playerSectorY - 1; sectorY <= playerSectorY + 1; sectorY++)
        {
            if (sectorX >= 0 && sectorX < SECTOR_COUNT_X && sectorY >= 0 && sectorY < SECTOR_COUNT_Y)
            {
                CSector *sector = sectors[sectorY][sectorX];
                for (int i = 0; i < sector.sprites.count; i++)
                {
                    CSprite *sprite = (CSprite *)[sector.sprites objectAtIndex:i];
                    if (sprite.name == @"obst" && sprite.color.alpha == 0)
                    {
                        //SRect obstRect = sprite.rect;
                        GLfloat r1 = sqrtf((sprite.rotateBasePoint.x - (playerSprite.rotateBasePoint.x + camera.position.x))*(sprite.rotateBasePoint.x - (playerSprite.rotateBasePoint.x + camera.position.x)) + (sprite.rotateBasePoint.y - (playerSprite.rotateBasePoint.y + camera.position.y))*(sprite.rotateBasePoint.y - (playerSprite.rotateBasePoint.y + camera.position.y)));
                        if (r1 < R)
                            R = r1;
                    }
                }
            }
        }
    }
    
    //Если расстояние больше 0, то устанавливаем частоту мигания индикатора
    if (R > 0 && R < 100)
    {
        indicatorSprite.pulseInterval = R*0.005;
        if (!indicatorSprite.isLight)
            indicatorSprite.isLight = true;
    }
    else
    {
        indicatorSprite.isLight = false;
    }
}


@end
