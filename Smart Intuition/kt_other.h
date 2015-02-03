//
//  kt_other.h
//  Smart Intuition
//
//  Created by Kostya on 17.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//
#ifndef Smart_Intuition_other_h
#define Smart_Intuition_other_h

#import "kt_struct.h"

//Записывает в память данные, полученные из сопроводительного файла
void getDataFromPlist(NSDictionary *dict, NSString *key, GLfloat textureAtlasWidth, GLfloat textureAtlasHeight, SRect *posRect, CGRect *texRect, SColor *color, SSpeed *speed);

//Возвращает значение непрозрачного белого цвета
SColor kt_getDefaultColor(void);

//Возвращает нулевую скорость
SSpeed kt_getNullSpeed(void);


#endif