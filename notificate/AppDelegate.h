//
//  AppDelegate.h
//  notificate
//
//  Created by Garrett Grice on 8/9/12.
//  Copyright (c) 2012 gmts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ScriptingBridge/ScriptingBridge.h>


@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate> {
    NSStatusBar *statusBar;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *altStatusImage;

}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusMenu;

-(IBAction)doQuit:(id)sender;

@end
