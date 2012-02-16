#import <UIKit/UIKit.h>

@interface FDAboutController: UIViewController {
        id mainController;
        UIWebView *webView;
}

@property (retain) id mainController;

- (void) close;

@end

