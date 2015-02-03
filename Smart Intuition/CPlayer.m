//
//  CBall.m
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 22.03.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CPlayer.h"

@implementation CPlayer

@synthesize radarPlayer;

-(void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    [self rotate:deltaTime];
    
    //Перемещаем изображение на радаре
    
}
@end
