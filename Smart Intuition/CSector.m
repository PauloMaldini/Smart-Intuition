//
//  CSector.m
//  Smart Intuition
//
//  Created by Kostya on 08.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CSector.h"
#import "CSprite.h"

@implementation CSector

@synthesize sprites;
@synthesize posInArray;

- (CSector *) initWithGeometry:(CGRect)_geometry WithPosInArray:(CGPoint)_posInArray
{
    self = [super init];
    
    sprites = [[NSMutableArray alloc] init];
    geometry = _geometry;
    posInArray = _posInArray;
    
    return (self);
}

- (void) addSprite:(CSprite *)sprite
{
    [sprites addObject:sprite];
    sprite.sector = self;
}

- (void) removeSprite:(CSprite *)sprite
{
    [sprites removeObject:sprite];
}

@end
