//
//  GMMailViewController.h
//  GMail
//
//  Created by Jeremy Ellison on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Three20/Three20.h>


@interface GMMailViewController : TTViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView* _webView;
	id _account;
	UIButton* _accountButton;
}

@end

@interface GMCreateAccountAlertDelegate : NSObject <UIAlertViewDelegate> {
	GMMailViewController* _controller;
}

- (id)initWithController:(GMMailViewController*)controller;

@end
