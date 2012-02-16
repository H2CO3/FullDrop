#import "FDInputView.h"

@implementation FDInputView

@synthesize delegate = delegate;
@synthesize title = title;

- (id) init {

	self = [super init];
	alertView = [UIAlertView new];
	alertView.message = @"\n\n";
	alertView.delegate = self;
	[alertView addButtonWithTitle: @"Cancel"];
	[alertView addButtonWithTitle: @"OK"];
	textField = [UITextField new];
	textField.frame = CGRectMake (30, 50, 225, 30);
	textField.backgroundColor = [UIColor whiteColor];
	textField.adjustsFontSizeToFitWidth = YES;
	textField.delegate = self;
	[alertView addSubview: textField];
	
	return self;
	
}

- (void) show {

	[textField becomeFirstResponder];
	alertView.title = self.title;
	[alertView show];
	
}

- (void) alertView: (UIAlertView *) theAlertView didDismissWithButtonIndex: (int) index {

	if (index == 1) {
	
		[self.delegate inputView: self didReceiveInput: [textField.text retain]];
		
	}
	
}

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {

	[theTextField resignFirstResponder];
	return YES;
	
}

@end

