//
//  iSignageAppDelegate.h
//  iSignage
//
//  Created by iMac on 16/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iSignageViewController;

@interface iSignageAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iSignageViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iSignageViewController *viewController;

@end

