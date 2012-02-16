#import <UIKit/UIKit.h>
#import "DropboxSDK.h"
#import "FDPasswordController.h"

@interface FullDrop: UIApplication <UIApplicationDelegate> {
	UIWindow *mainWindow;
	FDPasswordController *pwc;
	UINavigationController *passwordController;
}

@end

