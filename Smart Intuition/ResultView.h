//
//  ResultView.h
//  Smart Intuition
//
//  Created by Kostya on 11.11.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface ResultView : UIView
{
    UILabel *resultLabel;
    AppDelegate *delegate;
}

@property (nonatomic, assign) AppDelegate *delegate;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;


@end
