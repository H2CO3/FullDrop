#import <UIKit/UIKit.h>

@interface FDFileViewerController: UIViewController {
        NSString *fileToShow;
        id mainController;
        UIWebView *webView;
        UITextView *textView;
}

@property (retain) NSString *fileToShow;
@property (retain) id mainController;

- (void) close;
- (BOOL) fileIsTextFile: (NSString *) file;
- (void) openInIFile;

@end
