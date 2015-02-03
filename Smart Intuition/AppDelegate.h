//
//  AppDelegate.h
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 17.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EAGLView;
@class OptionsView;
@class ResultView;

@interface AppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate>
{
    UIWindow *window;
    EAGLView *glView;
    OptionsView *optionView;
    ResultView *resultView;
    
    
    UIViewController *eaglViewController;
    UIViewController *optionsViewController;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, retain) IBOutlet OptionsView *optionView;
@property (nonatomic, retain) IBOutlet ResultView *resultView;

- (void) showOptions;
- (void) showResult:(short)collisCount;
- (IBAction) showGame;
- (IBAction) didMoveSpeedTFExit;
- (IBAction) didRotateSpeedTFExit;
- (IBAction) didMoveAccelerTFExit;
- (IBAction) touchResultView:(NSSet *)touches withEvent:(UIEvent *)event;


@end
