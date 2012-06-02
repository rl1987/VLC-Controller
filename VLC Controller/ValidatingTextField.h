#import <UIKit/UIKit.h>

#import "AddressValidator.h"
#import "PortValidator.h"

@interface ValidatingTextField : UITextField

@property (nonatomic,strong) InputValidator *validator;

- (BOOL)isValid;

@end
