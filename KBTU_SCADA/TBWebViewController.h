//
//  TBWebViewController.h
//  TBClient
//
//  Created by Jason Townes French on 11/8/15.
//  Copyright © 2015 TRU Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, copy) NSString *headerTitle;
-(void) loadUrl:(NSString*)url;
- (instancetype)initWithSections;

@end
