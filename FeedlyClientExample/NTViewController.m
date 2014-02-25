//
//  NTViewController.m
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

#import "NTViewController.h"
#import "NXOauth2.h"
#import "objc/message.h"

@interface NTViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *authTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation NTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //set datasource
    _authTableView.dataSource = self;

    //tableview inset
    _authTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //reload account data
    [_authTableView reloadData];
    [super viewWillAppear:animated];
}

- (IBAction)editAction:(id)sender {
    if (_authTableView.editing) {
        [_authTableView setEditing:NO animated:YES];
        _editButton.title = @"Edit";

    } else {
        [_authTableView setEditing:YES animated:YES];
        _editButton.title = @"Done";
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"accountViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NXOAuth2Account *account = [[[NXOAuth2AccountStore sharedStore] accounts] objectAtIndex:indexPath.row];
    NSDictionary *userData = (id)account.userData;
    NSString *name = [NSString stringWithFormat:@"%@:%d", [userData objectForKey:@"fullName"], indexPath.row ];
    cell.textLabel.text = name;
    
    cell.detailTextLabel.text = account.identifier;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of account
    return [[[NXOAuth2AccountStore sharedStore] accounts] count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accounts];
    for (NXOAuth2Account *account in accounts) {
        if ([account.identifier isEqualToString:cell.detailTextLabel.text]) {
            //delete account
            [[NXOAuth2AccountStore sharedStore] removeAccount:account];
            break;
        }
    }
    
    //delete tableview cell
    NSArray *deleteIndexs = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:deleteIndexs withRowAnimation:UITableViewRowAnimationFade];
}



@end
