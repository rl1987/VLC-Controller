//
//  PasswordValidator.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 20/01/14.
//
//

#import "PasswordValidator.h"

@implementation PasswordValidator

- (BOOL)validate:(UITextField *)textField
{
    if ([textField.text length])
        return YES;
    
    return NO;
}

@end
