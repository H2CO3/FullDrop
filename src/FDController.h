#import <UIKit/UIKit.h>
#import "DropboxSDK.h"
#import "FDLocalFilesController.h"
#import "FDPublicController.h"
#import "FDAboutController.h"
#import "FDSettingsController.h"
#import "FDFileViewerController.h"
#import "FDInputView.h"

@interface FDController: UIViewController <DBRestClientDelegate, DBLoginControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, FDInputViewDelegate> {
	DBRestClient *restClient;
	DBLoginController *loginController;
	UINavigationController *localFilesController;
	UINavigationController *publicController;
	UINavigationController *aboutController;
	UINavigationController *settingsController;
	FDSettingsController *sc;
	FDAboutController *fdac;
	UITableView *fileList;
	UIActionSheet *actsh;
	NSMutableArray *contents;
	FDLocalFilesController *lfc;
	FDPublicController *fdpc;
	NSString *currDir;
	DBLoadingView *loadingView;
}

- (void) loadRoot;
- (void) loadMetadata: (NSString *) path;
- (void) login;
- (void) showMore;
- (void) showAbout;
- (void) showSettings;
- (void) showFile: (NSString *) path;
- (void) getPublicLinks;
- (void) loadLocal;
- (void) downloadFile: (NSString *) file;
- (void) uploadFile: (NSString *) file toPath: (NSString *) destPath;
- (void) deletePath: (NSString *) path;
- (void) createDirectory: (NSString *) path;
- (void) askForDirectoryName;

@end

