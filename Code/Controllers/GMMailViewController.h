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
}

@property (nonatomic, retain) GMAccount* account;

- (void)switchToAccount:(GMAccount*)account;

@end

@interface GMDelegate : NSObject {
	GMMailViewController* _controller;
}

- (id)initWithGMMailViewController:(GMMailViewController*)controller;

@end

@interface GMManageAccountActionSheetDelegate: GMDelegate <UIActionSheetDelegate>

@end

@interface GMSwitchAccountActionSheetDelegate : GMDelegate <UIActionSheetDelegate> {
	NSArray* _accounts;
}

@property (nonatomic, retain) NSArray* accounts;

@end


@interface GMCreateAccountAlertDelegate : GMDelegate <UIAlertViewDelegate>

@end
