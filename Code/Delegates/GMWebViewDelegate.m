//
//  GMWebViewDelegate.m
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "GMWebViewDelegate.h"
#import "GMDocumentLoader.h"
#import "GMAccount.h"

@implementation GMWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[webView isLoading]];
	// if the request URL contains "ServiceLogin", we should try to log them in. when we get there.
	[_controller.backButton setEnabled:[webView canGoBack]];
	[_controller.forwardButton setEnabled:[webView canGoForward]];
	
	//Hack to save cookies. Clean this up?
	[_controller.account saveCookies];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"REquest to load: %@", request);
	//view=att
	NSURL* url = [request URL];
	NSString* urlString = [url absoluteString];
	NSRange range = [urlString rangeOfString:@"view=att"];
	if (NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
		return YES;
	}
	NSLog(@"Load this document");
	[GMDocumentLoader loadDocumentAtURL:url intoWebView:webView];
	
	return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	// -999 seems to be the error we get when we stop the loading manually
	if ([error code] != -999) {
		TTAlert([error localizedDescription]);
	}
}

@end
