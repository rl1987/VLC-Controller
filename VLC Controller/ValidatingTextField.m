#import "ValidatingTextField.h"

@implementation ValidatingTextField

@synthesize validator = _validator;

- (BOOL)isValid
{
    if (self.validator)
        return [self.validator validate:self];
    else
        return YES;
}

@end
