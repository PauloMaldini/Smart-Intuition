//
//  AppDelegate.m
//  Smart Intuition
//
//  Created by Konstantin Tsymbalist on 17.02.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "AppDelegate.h"
#import "EAGLView.h"
#import "OptionsView.h"
#import "ResultView.h"

@implementation AppDelegate

@synthesize window;
@synthesize glView;
@synthesize optionView;
@synthesize resultView;

- (void)dealloc
{
	[window release];
	[glView release];
	
	[super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
    //Подключаем акселерометр
    /*[[UIAccelerometer sharedAccelerometer] setUpdateInterval: 1.0/50.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];*/

    //Поехали
    sleep(1);
    resultView.delegate = self;
    [glView setDelegate:self];
    [glView createGameController];
	[glView startAnimation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [glView stopAnimation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [glView stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    [glView accelerometerProcess:acceleration.x :acceleration.y :acceleration.z];
}

- (void) showOptions
{
    /*optionView.moveSpeedTF.text = [NSString stringWithFormat:@"%1.2f", glView.maxMoveSpeed];
    optionView.rotateSpeedTF.text = [NSString stringWithFormat:@"%1.2f", glView.maxRotateSpeed];
    optionView.moveAccelerTF.text = [NSString stringWithFormat:@"%1.2f", glView.moveAcceler];
    [optionView.isTrekSW setOn:glView.isTrek];
    [optionView.isTrekClearSW setOn:glView.isTrekClean];*/

    [glView stopAnimation];
    [window addSubview:optionView];
}

- (void) showResult:(short)collisCount
{
    [glView stopAnimation];
    resultView.resultLabel.text = [NSString stringWithFormat:@"%d", collisCount];
    [window addSubview:resultView];
}

- (void) showGame
{
    /*glView.isTrek = [optionView.isTrekSW isOn];
    glView.isTrekClean = [optionView.isTrekClearSW isOn];*/
    [window addSubview:glView];
    [glView startAnimation];
}

- (IBAction) didMoveSpeedTFExit
{
    [optionView.moveSpeedTF resignFirstResponder];
    //glView.maxMoveSpeed = [optionView.moveSpeedTF.text doubleValue];
}

- (IBAction) didRotateSpeedTFExit
{
    [optionView.moveSpeedTF resignFirstResponder];
    //glView.maxRotateSpeed = [optionView.rotateSpeedTF.text doubleValue];
    //glView.playerSprite.rotateSpeed = [optionView.rotateSpeedTF.text doubleValue];
}


- (IBAction) didMoveAccelerTFExit
{
    [optionView.moveAccelerTF resignFirstResponder];
    //glView.moveAcceler = [optionView.moveAccelerTF.text doubleValue];
}

- (IBAction) touchResultView:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}






@end
