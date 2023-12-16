// GlobalVariables.m
#import "GlobalVariables.h"

@implementation GlobalVariables

AppDelegate *globalAppDelegate = nil;

+ (void)setGlobalAppDelegate:(AppDelegate *)appDelegate {
    globalAppDelegate = appDelegate;
}

@end
