//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DateTools.h"
#import "TTTAttributedLabel.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TTTAttributedLabelDelegate>
@property (strong, nonatomic) NSArray *tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *cellTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) TTTAttributedLabel *attributedLabel;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    [self.cellTableView insertSubview:self.refreshControl atIndex:0];
    
    self.cellTableView.dataSource = self;
    self.cellTableView.delegate = self;
    self.cellTableView.rowHeight = 200;
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    
    self.attributedLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink; //
    self.attributedLabel.delegate = self;
    
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetArray = tweets;
            for (Tweet *dictionary in tweets) {
                NSString *text = dictionary.text;
                NSLog(@"%@", text);
            }
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.cellTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.tweet = self.tweetArray[indexPath.row];
    [cell setTweet];
    
    self.attributedLabel.text = cell.tweet.text;
    cell.tweet.text = self.attributedLabel.text;
    
    
    return cell;
}

- (void)beginRefresh {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetArray = tweets;
            for (Tweet *dictionary in tweets) {
                NSString *text = dictionary.text;
                NSLog(@"%@", text);
            }
            [self.cellTableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            
        }
        [self.refreshControl endRefreshing];
        
    }];
}

- (void)didTweet:(Tweet *)tweet {
    [self beginRefresh];
}

- (IBAction)logoutButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}



@end
