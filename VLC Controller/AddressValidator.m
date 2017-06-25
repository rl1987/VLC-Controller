#import "AddressValidator.h"

#include <arpa/inet.h>

@implementation AddressValidator

- (BOOL)validate:(UITextField *)textField
{
    const char *cString = [textField.text cStringUsingEncoding:NSASCIIStringEncoding];
    
    struct sockaddr_storage dummy;
    
    BOOL isValidIP4 = inet_pton(AF_INET, cString, &dummy);
    BOOL isValidIP6 = inet_pton(AF_INET6, cString, &dummy);
    
    return isValidIP4 || isValidIP6;
}

@end
