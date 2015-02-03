//
//  CMenuScene.h
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CAbstractScene.h"

@class CSpriteStorage;

@interface CMenuScene : CAbstractScene
{
    NSDictionary *menuPlist; //Описательный файл к атласу текстур "Меню"
    
    CSpriteStorage *menuSpriteStorage; //Спрайты, реализующие меню
    CSpriteStorage *fonSpriteStorage; //Спрайты, реализующие фон
}

- (CMenuScene *) initWithGameController:(CGameController *)_gameController WithName:(NSString *)_name WithNextSceneName:(NSString *)_nextSceneName;

@end
