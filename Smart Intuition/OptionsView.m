//
//  OptionsView.m
//  Smart Intuition
//
//  Created by Kostya on 13.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OptionsView.h"


@implementation OptionsView

@synthesize moveSpeedTF;
@synthesize rotateSpeedTF;
@synthesize moveAccelerTF;
@synthesize isTrekSW;
@synthesize isTrekClearSW;
@synthesize readyButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
