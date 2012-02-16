#import "FullDrop.h"

@implementation FullDrop

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) options {

	mainWindow = [UIWindow new];
	mainWindow.frame = CGRectMake (0, 0, 320, 480);
	mainWindow.backgroundColor = [UIColor whiteColor];
	[mainWindow makeKeyAndVisible];

	pwc = [FDPasswordController new];
	passwordController = [[UINavigationController alloc] initWithRootViewController: pwc];
	[pwc release];
	[mainWindow addSubview: passwordController.view];

	return YES;

}

- (BOOL) application: (UIApplication *) application handleOpenURL: (NSURL *) url {

	// [self application: [UIApplication sharedApplication] didFinishLaunchingWithOptions: nil];
	
	UIAlertView *av = [UIAlertView new];
	av.title = @"New file";
	NSString *msgString = [[NSString alloc] initWithFormat: @"The file to be opened is located in %@", [url path]];
	av.message = msgString;
	[msgString release];
	[av addButtonWithTitle: @"Dismiss"];
	[av show];
	[av release];

	return YES;
	
}

/*
- (BOOL) applicationDidEnterBackground: (UIApplication *) application {

	// comment out this to support backgrounding! This is only for the testing period,
	// in order not to be annoyed b/c of the need of continuously
	// relaunching the app...
	exit (0);
	
}
*/

@end

