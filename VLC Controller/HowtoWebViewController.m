//
//  HowtoWebViewController.m
//  VLC Controller
//
//  Created by rl1987 on 19/03/17.
//
//

#import "HowtoWebViewController.h"

@interface HowtoWebViewController ()

@end

@implementation HowtoWebViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // FIXME: This is corner-cutting approach. Implement a GUI that walks the user
    // stepwise through the HTTP interface setup procedure.
    
    NSString *urlString =
    @"https://www.howtogeek.com/117261/how-to-activate-vlcs-web-interface-control-vlc-from-a-browser-use-any-smartphone-as-a-remote/";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

@end
