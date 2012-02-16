#import "FullDrop.h"

int main (int argc, char **argv) {
	
	NSAutoreleasePool *mainPool = [NSAutoreleasePool new];
	int exitCode = UIApplicationMain (argc, argv, @"FullDrop", @"FullDrop");
	[mainPool release];
	
	return exitCode;
	
}

