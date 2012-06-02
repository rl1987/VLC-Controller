#import <UIKit/UIKit.h>

#import "ValidatingTextField.h"

@class ConfigViewController;

@protocol ConfigViewControllerDelegate
@required
- (void)senderViewController:(ConfigViewController *)cvc 
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port;

@end

@interface ConfigViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ValidatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ValidatingTextField *portField;
@property (nonatomic, strong) id <ConfigViewControllerDelegate> delegate;

- (IBAction)okPressed;
- (IBAction)cancelPressed;

@end

