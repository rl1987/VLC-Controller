#import "PortValidator.h"

@implementation PortValidator

- (BOOL)validate:(UITextField *)textField
{
    BOOL answer;
    
    NSRegularExpression *regex = 
    [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+$" 
    options:NSRegularExpressionAnchorsMatchLines error:NULL];
    
    NSUInteger numberOfMatches = 
    [regex numberOfMatchesInString:textField.text 
                           options:NSRegularExpressionAnchorsMatchLines 
                             range:NSMakeRange(0, [textField.text length])];
    
    if (numberOfMatches != 1)
    {
        answer = NO;
        return answer;
    }
    
    answer = ([textField.text intValue]<65535 && 
              [textField.text intValue]>=1);  
    
    return answer;
}

@end
