#import <UIKit/UIKit.h>

#import "ValidatingTextField.h"

@class ConfigViewController;

@protocol ConfigViewControllerDelegate
@required
- (void)configViewController:(ConfigViewController *)cvc 
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port
                    password:(NSString *)password;

@end

@interface ConfigViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ValidatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ValidatingTextField *portField;
@property (nonatomic, strong) id <ConfigViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)okPressed;
- (IBAction)cancelPressed;

@end

