//
//  NTAppDelegate.m
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

#import "NTAppDelegate.h"
#import "NXOAuth2.h"

//for Feedly Oauth2(sandbox)
//account type
NSString * const kOauth2ClientAccountType = @"Feedly";
//clientId
static NSString * const kOauth2ClientClientId = @"sandbox";
//Client Secret
static NSString * const kOauth2ClientClientSecret = @"CM786L1D4P3M9VYUPOB8";
//Redirect Url
static NSString * const kOauth2ClientRedirectUrl = @"http://localhost";
//base url
static NSString * const kOauth2ClientBaseUrl = @"https://sandbox.feedly.com";
//auth url
static NSString * const kOauth2ClientAuthUrl = @"/v3/auth/auth";
//token url
static NSString * const kOauth2ClientTokenUrl = @"/v3/auth/token";
//scope url
static NSString * const kOauth2ClientScopeUrl = @"https://cloud.feedly.com/subscriptions";


@implementation NTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (void)initialize {
    
    NSString *authUrl = [kOauth2ClientBaseUrl stringByAppendingString:kOauth2ClientAuthUrl];
    NSString *tokenUrl = [kOauth2ClientBaseUrl stringByAppendingString:kOauth2ClientTokenUrl];
    
    //setup oauth2client
    [[NXOAuth2AccountStore sharedStore] setClientID:kOauth2ClientClientId
                                             secret:kOauth2ClientClientSecret
                                              scope:[NSSet setWithObjects:kOauth2ClientScopeUrl, nil]
                                   authorizationURL:[NSURL URLWithString:authUrl]
                                           tokenURL:[NSURL URLWithString:tokenUrl]
                                        redirectURL:[NSURL URLWithString:kOauth2ClientRedirectUrl]
                                     forAccountType:kOauth2ClientAccountType];

}

@end
