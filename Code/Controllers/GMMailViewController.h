//
//  GMMailViewController.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Three20/Three20.h>

@class GMAccount;

@interface GMMailViewController : TTViewController <UIWebViewDelegate> {
	UIWebView* _webView;
	GMAccount* _account;
	UIButton* _accountButton;
	UIBarButtonItem* _backButton;
	UIBarButtonItem* _forwardButton;
}

@property (nonatomic, retain) GMAccount* account;
@property (nonatomic, readonly) UIBarButtonItem* backButton;
@property (nonatomic, readonly) UIBarButtonItem* forwardButton;

- (void)switchToAccount:(GMAccount*)account;
- (void)switchAccountButtonWasPressed:(id)sender;

@end
