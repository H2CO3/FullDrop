#import <UIKit/UIKit.h>
#import "DropboxSDK.h"

@interface FDSettingsController: UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UISwitch *passwordEnabled;
	UITableView *tableView;
	UITextField *password;
	id mainController;
}

@property (assign) id mainController;

- (void) done;
- (void) close;

@end

