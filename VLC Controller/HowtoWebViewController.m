//
//  HowtoWebViewController.m
//  VLC Controller
//
//  Created by rl1987 on 19/03/17.
//
//

#import "HowtoWebViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface HowtoWebViewController ()

@end

@implementation HowtoWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD show];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // FIXME: This is corner-cutting approach. Implement a GUI that walks the user
    // stepwise through the HTTP interface setup procedure.
    
    NSString *urlString =
    @"https://web.archive.org/web/20161221161508/https://www.howtogeek.com/117261/how-to-activate-vlcs-web-interface-control-vlc-from-a-browser-use-any-smartphone-as-a-remote/";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

@end
