#import <UIKit/UIKit.h>

@class FDInputView;

@protocol FDInputViewDelegate

- (void) inputView: (FDInputView *) inputView didReceiveInput: (NSString *) input;

@end

@interface FDInputView: NSObject <UIAlertViewDelegate, UITextFieldDelegate> {
	UIAlertView *alertView;
	UITextField *textField;
	id <FDInputViewDelegate> delegate;
	NSString *title;
}

@property (assign) id <FDInputViewDelegate> delegate;
@property (retain) NSString *title;

- (void) show;

@end

