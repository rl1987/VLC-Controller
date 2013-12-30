#import <Foundation/Foundation.h>

// Abstract class. Don't instantiate.

@interface InputValidator : NSObject

- (BOOL)validate:(UITextField *)textField;

@end
