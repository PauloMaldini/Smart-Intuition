//
//  GameObject.m
//  GLSprite
//
//  Created by User on 07.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSprite.h"
#import "CGameController.h"
#import "kt_library.h"
#import "CSector.h"


@implementation CSprite

@synthesize rect;
@synthesize speed;
@synthesize rotateSpeed;
@synthesize rotateBasePoint;
@synthesize color;
@synthesize image;
@synthesize name;
@synthesize isAccelerometer;
@synthesize camera;
@synthesize sector;
@synthesize isSector;

- (CSprite *) initWithGameController:(CGameController *)_gameController
                            WithRect:(SRect)_rect
                  WithImageSequences:(SImageSequence *)_imageSequences
                           WithColor:(SColor)_color
                           WithSpeed:(SSpeed)_speed
                     WithRotateSpeed:(GLfloat)_rotateSpeed
                 WithRotateBasePoint:(CGPoint)_rotateBasePoint
{
    [super init];
       
    gameController = _gameController;
    rect = _rect;
    color = _color;
    speed = _speed;
    rotateSpeed = _rotateSpeed;
    rotateBasePoint = CGPointMake(_rect.a.x + _rotateBasePoint.x, rect.a.y - _rotateBasePoint.y);
    absoluteTime = 0;
    deltaFI0 = 0;
    
    imageSequences = _imageSequences;
    imageSequenceIndex = 0;
    imageIndex = 0;
    
    name = nil;
    
    isAccelerometer = false;
    
    backingSize = [gameController getBackingSize];
    
    camera = nil;
    
    sector = nil;
    isSector = false;
    
    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    /*if (isAccelerometer && accelerometerMessage.isRight)
    {
        GLfloat s = 100;
        GLfloat a = 0.1;
        if (accelerometerMessage.x > a)
            speed.x = s;
        else if (accelerometerMessage.x < -a)
            speed.x = -s;
        else
            speed.x = 0;
        
        if (accelerometerMessage.y > a)
            speed.y = s;
        else if (accelerometerMessage.y < -a)
            speed.y = -s;
        else
            speed.y = 0;
    }*/
       
    //Двигаем спрайт
    rect.a.x += speed.x*deltaTime;
    rect.a.y += speed.y*deltaTime;
    rect.b.x += speed.x*deltaTime;
    rect.b.y += speed.y*deltaTime;    
    rect.c.x += speed.x*deltaTime;
    rect.c.y += speed.y*deltaTime;
    rect.d.x += speed.x*deltaTime;
    rect.d.y += speed.y*deltaTime;
}

- (void) rotate:(GLfloat)deltaTime
{
    /*if (deltaFI0 != 0)
    {*/
        GLfloat fi = rotateSpeed*deltaTime;
       /* if (ABS(fi) > ABS(deltaFI0))
            fi = deltaFI0;*/
        
        kt_mlRotatePolygon(&rect, CGPointMake(rotateBasePoint.x, rotateBasePoint.y), 3.14*fi/180.0);
        
/*        deltaFI0 -= fi;
    }*/
}

- (void) addValueToDeltaFI0:(GLfloat)value
{
    deltaFI0 += value;
    if (deltaFI0 < 0)
        rotateSpeed = -ABS(rotateSpeed);
    else
        rotateSpeed = ABS(rotateSpeed);
}

-(void) dealloc
{
    free(imageSequences);
    
    [super dealloc];
}

-(NSString *) getName
{
    return(name);
}

- (bool) isOwneredByPointWithX:(GLfloat)x WithY:(GLfloat)y
{
    return (false);
}

- (CGRect) getImage
{
    return (imageSequences[imageSequenceIndex].images[imageIndex]);
}


@end
