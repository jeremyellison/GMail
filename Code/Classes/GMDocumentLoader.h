//
//  GMDocumentLoader.h
//  GMail
//
//  Created by Jeremy Ellison on 2/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMDocumentLoader : NSObject {
	NSURL* _url;
	UIWebView* _webView;
	BOOL _loading;
	NSMutableData* _data;
	NSMutableURLRequest* _request;
	NSURLConnection* _connection;
	NSString* _mimeType;
	NSHTTPURLResponse* _response;
}

+ (id)loadDocumentAtURL:(NSURL*)url intoWebView:(UIWebView*)webView;
- (void)loadDocument;

@end
