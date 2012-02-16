#import <UIKit/UIKit.h>

@interface FDPublicController: UIViewController {
        id mainController;
        UIWebView *webView;
}

@property (retain) id mainController;

- (void) close;

@end

