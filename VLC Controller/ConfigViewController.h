#import <UIKit/UIKit.h>

#import "ValidatingTextField.h"

@interface ConfigViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ValidatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ValidatingTextField *portField;
@property (strong, nonatomic) IBOutlet ValidatingTextField *passwordField;

- (IBAction)okPressed;
- (IBAction)cancelPressed;

@end

