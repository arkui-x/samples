// GlobalVariables.h
#import <Foundation/Foundation.h>

@class AppDelegate;

@interface GlobalVariables : NSObject

+ (void)setGlobalAppDelegate:(AppDelegate *)appDelegate;

@end

extern AppDelegate *globalAppDelegate;
