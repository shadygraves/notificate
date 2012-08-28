//
//  AppDelegate.m
//  notificate
//
//  Created by Garrett Grice on 8/9/12.
//  Copyright (c) 2012 gmts. All rights reserved.
//

#import "AppDelegate.h"
#import "iTunes.h"

@implementation AppDelegate
@synthesize statusMenu;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"Application has finished launching...");
}

- (void)awakeFromNib {
    // Awaken from thy NIB oh sleepy one
    
    statusBar = [NSStatusBar systemStatusBar];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];

    NSBundle *bundle = [NSBundle mainBundle]; // To find the paths of our files
    statusImage = [[NSImage new] initWithContentsOfFile:[bundle pathForResource:@"cdicon" ofType:@"png"]];
    altStatusImage = [[NSImage new] initWithContentsOfFile:[bundle pathForResource:@"menulet_icon_alt" ofType:@"png"]];
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:altStatusImage];

    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [self listenForItunesChanges];
    
}

- (void)listenForItunesChanges {
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(updateTrackInfo:) name:@"com.apple.iTunes.playerInfo" object:nil];
}

- (void)updateTrackInfo:(NSNotification *)notification {
    
    NSLog(@"iTunes track change notification received...");
    
    NSDictionary *information = [notification userInfo];
    NSLog(@"track information: %@", information);

    /* We only want to display a notification if we are playing */
    if(![[information objectForKey:@"Player State"] isEqualToString:@"Playing"]) {
        return;
    }
    
    /* We are playing something new at this point, so it's time to change
     * the application icon
     */
    [NSApplication sharedApplication].applicationIconImage = [self getArtworkOfPlayingSong];
//    [[[NSApplication sharedApplication] dockTile] set:[information objectForKey:@"Name"]];

    
    
    NSUserNotification *ncenter = [[NSUserNotification alloc] init];
    if(![information objectForKey:@"Name"])
        ncenter.title = @"Untitled Track";
    else
        ncenter.title = [NSString stringWithFormat:@"%@", [information objectForKey:@"Name"] ];
    if([information objectForKey:@"Artist"])
        ncenter.subtitle =  [information objectForKey:@"Artist"];
    if([information objectForKey:@"Album"])
        ncenter.informativeText = [NSString stringWithFormat:@"%@",  [information objectForKey:@"Album"]];
//    ncenter.soundName = NSUserNotificationDefaultSoundName;
    
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:ncenter];

    
}

- (NSImage *) getArtworkOfPlayingSong {
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    NSImage *songArtwork;
    iTunesTrack *currentTrack = [iTunes currentTrack];
    iTunesArtwork *artwork = (iTunesArtwork *)[[[currentTrack artworks] get] lastObject];
    
    if(artwork != nil) {
        songArtwork = [[NSImage alloc] initWithData:[artwork rawData]];
    } else {
        songArtwork = [NSImage imageNamed:@"Image.tiff"];
    }
    
    [songArtwork setSize:NSMakeSize(128,128)];
    return songArtwork;
       
}

-(IBAction)doQuit:(id)sender {
    NSLog(@"Notificate is exiting at request of user...");
    [[NSApplication sharedApplication] terminate:self];
}

#pragma mark -
#pragma mark Notification Center Delegates

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
