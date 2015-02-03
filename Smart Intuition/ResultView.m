//
//  ResultView.m
//  Smart Intuition
//
//  Created by Kostya on 11.11.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ResultView.h"
#import "AppDelegate.h"
#import "EAGLView.h"
#import "CGameController.h"

@implementation ResultView

@synthesize resultLabel;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    glLoadIdentity();
    glTranslatef(-160, -240, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    CGameController *gameController = delegate.glView.gameController;
    [gameController initScene:@"menu"];
    [gameController initScene:@"game"];
    [gameController setCurrentScene:@"menu"];
    [delegate.window addSubview:delegate.glView];
    [delegate.glView startAnimation];
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
