//
//  NTAuthWebViewController.m
//  FeedlyClientExample
//
// Copyright (c) 2014 Naoyuki Takura
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "NTAuthWebViewController.h"
#import "NXOAuth2.h"
#import "NTAppDelegate.h"

@interface NTAuthWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) id successObserver;
@property (strong, nonatomic) id failObserver;

//private method
- (void) p_addOauth2Notification;
- (void) p_getUserProfile:(NXOAuth2Account*)account;
- (void) p_startRequest;
- (void) p_removeOauth2Notification;

@end

@implementation NTAuthWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _webView.delegate = self;
    
    //init notifications
    [self p_addOauth2Notification];
    [self p_startRequest];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    //hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //remove notifications
    [self p_removeOauth2Notification];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_addOauth2Notification {
    //setup notifications for success or fail
    //for success
    self.successObserver = [[NSNotificationCenter defaultCenter]
                            addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                            object:[NXOAuth2AccountStore sharedStore]
                            queue:nil usingBlock:^(NSNotification *notification) {
                                //TODO
                                NSLog(@"Success.");
                                
                                //get authinticate userinfo
                                NSDictionary *dict = notification.userInfo;
                                NXOAuth2Account *account = [dict valueForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
                                //get user profile
                                [self p_getUserProfile:account];
                                
                                //pop navigation controller
                                //                                 [self.navigationController popViewControllerAnimated:YES];
                            }];
    
    //for fail
    self.failObserver = [[NSNotificationCenter defaultCenter]
                         addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                         object:[NXOAuth2AccountStore sharedStore]
                         queue:nil
                         usingBlock:^(NSNotification *note) {
                             //TODO
                             NSLog(@"Fail.");
                             
                             //TODO error message.
                             
                             //pop navigation controller
                             [self.navigationController popViewControllerAnimated:YES];
                             
                         }];

}

- (void)p_startRequest {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:kOauth2ClientAccountType
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       //start authentication request.
                                       [_webView loadRequest:[NSURLRequest requestWithURL:preparedURL]];
                                       
                                   }];
}

- (void)p_getUserProfile:(NXOAuth2Account *)account {
    //get user profile on feedly user
    NSLog(@"account info : %@", account);
    
    NSURL *targetUrl = [NSURL URLWithString:@"https://sandbox.feedly.com/v3/profile"];
    [NXOAuth2Request performMethod:@"GET"
                        onResource:targetUrl
                   usingParameters:nil
                       withAccount:account
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   //TODO
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       NSLog(@"error : %@", error);
                       NSLog(@"response : %@", response);
                       NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                       NSLog(@"response data : %@", jsonString);
                       
                       //
                       if (!error) {
                           //success
                           NSLog(@"get profile success.");
                           //json変換してDictionary型をuserDataとして格納する
                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                           if (dict) {
                               //set user data
                               [account setUserData:dict];
                           }
                           
                           //pop viewcontroller
                           [self.navigationController popViewControllerAnimated:YES];
                           
                       } else {
                           //error
                           NSLog(@"get profile failer.");
                       }
                       
                   }];
    
}

- (void) p_removeOauth2Notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self.successObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.failObserver];
}


#pragma mark - UIWebViewDelegate

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[NXOAuth2AccountStore sharedStore] handleRedirectURL:[request URL]]) {
        return NO;
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
