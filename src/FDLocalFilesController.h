#import <UIKit/UIKit.h>
#import "FDFileViewerController.h"

@interface FDLocalFilesController: UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
        id mainController;
        UITableView *fileList;
        NSArray *files;
        NSString *file;
        NSMutableArray *contents;
        NSString *processedFile;
        NSString *currDir;
}

@property (retain) id mainController;

- (void) close;
- (void) readDirectory: (NSString *) directory;
- (void) reloadCurrentDirectory;
- (void) showFile: (NSString *) file;
- (BOOL) itemIsDirectoryAtPath: (NSString *) path;
- (void) loadParent;

@end

