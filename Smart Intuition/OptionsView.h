//
//  OptionsView.h
//  Smart Intuition
//
//  Created by Kostya on 13.10.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsView : UIView
{
    UITextField *moveSpeedTF;
    UITextField *rotateSpeedTF;
    UITextField *moveAccelerTF;
    UISwitch *isTrekSW;
    UISwitch *isTrekClearSW;
    UIButton *readyButton;
}

@property (nonatomic, retain) IBOutlet UITextField *moveSpeedTF;
@property (nonatomic, retain) IBOutlet UITextField *rotateSpeedTF;
@property (nonatomic, retain) IBOutlet UITextField *moveAccelerTF;
@property (nonatomic, retain) IBOutlet UISwitch *isTrekSW;
@property (nonatomic, retain) IBOutlet UISwitch *isTrekClearSW;
@property (nonatomic, retain) IBOutlet UIButton *readyButton;

@end
