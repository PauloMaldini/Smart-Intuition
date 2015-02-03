//
//  CLightIndicator.m
//  Smart Intuition
//
//  Created by Kostya on 13.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CLightIndicator.h"
#import "kt_library.h"

@implementation CLightIndicator

@synthesize isLight;
@synthesize pulseInterval;

- (CLightIndicator *) initWithGameController:(CGameController *)_gameController
                                    WithRect:(SRect)_rect
                          WithImageSequences:(SImageSequence *)_imageSequences
{
    self = [super initWithGameController:_gameController WithRect:_rect WithImageSequences:_imageSequences WithColor:kt_getDefaultColor() WithSpeed:kt_getNullSpeed() WithRotateSpeed:0 WithRotateBasePoint:CGPointMake(0, 0)];
    
    previousTimeMoment = 0;
    
    status = 0;
    
    pulseInterval = 0.0;
    
    frameInterval = 0.005;
    
    return (self);
}

- (void) move:(GLfloat)deltaTime :(STouchMessage)touchMessage :(SAccelerometerMessage)accelerometerMessage
{
    if (isLight)
    {
        if (status == 1)
        {
            if (CFAbsoluteTimeGetCurrent() - previousTimeMoment >= frameInterval)
            {
                imageIndex++;
                if (imageIndex == imageSequences[imageSequenceIndex].imageCount - 1)
                {
                    if (stop)
                    {
                        status = 0;
                        imageIndex = 0;
                        isLight = false;
                    }
                    status = 2;
                }
                
                previousTimeMoment = CFAbsoluteTimeGetCurrent();
            }
        }
        else if (status == 2)
        {
            if (CFAbsoluteTimeGetCurrent() - previousTimeMoment >= frameInterval)
            {
                imageIndex--;
                if (!imageIndex)
                {
                    status = 3;
                    if (stop)
                    {
                        status = 0;
                        isLight = false;
                    }
                }
                
                previousTimeMoment = CFAbsoluteTimeGetCurrent();
            }
        }
        else if (status == 3)
        {
            if (CFAbsoluteTimeGetCurrent() - previousTimeMoment >= pulseInterval)
            {
                status = 1;
                previousTimeMoment = CFAbsoluteTimeGetCurrent();
            }
            
            if (stop)
            {
                status = 0;
                isLight = false;
            }
        }
    }
}

- (void) light:(BOOL)_isLight
{
    if (_isLight)
    {
        status = 1;
        imageIndex = 0;
        stop = false;
        isLight = _isLight;
        previousTimeMoment = CFAbsoluteTimeGetCurrent();
    }
    else
        stop = true;
}

@end
