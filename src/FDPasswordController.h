#import <UIKit/UIKit.h>
#import "FDController.h"

@interface FDPasswordController: UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableView;
	UITextField *password;
	UINavigationController *fullDropController;
	FDController *fdc;
}

- (BOOL) needsPassword;
- (void) passwordAccepted;
- (void) passwordRejected;

@end
