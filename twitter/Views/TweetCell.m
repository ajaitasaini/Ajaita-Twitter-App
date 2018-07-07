//
//  TweetCell.m
//  twitter
//
//  Created by Ajaita Saini on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "Tweet.h"
#import "DateTools.h"


@implementation TweetCell

#pragma mark - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark - Set values
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTweet {
    self.profileName.text = self.tweet.user.name;
    [self.profileName sizeToFit];
    self.tweetContent.text = self.tweet.text;
    self.profileView.image = nil;
    [self.profileView setImageWithURL:self.tweet.user.profileURL];
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
    self.screenName.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.dateCreated.text = self.tweet.createdAtString;
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:-159887];
    NSLog(@"Time Ago: %@", timeAgoDate.timeAgoSinceNow);
    
    self.testTextView.text = self.tweet.text;
    self.testTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    CGSize descriptionSize = self.testTextView.contentSize;
    
    [self.heightConstraint setConstant:descriptionSize.height];
    
    [self layoutIfNeeded];
}


#pragma mark - User Input
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
            }
        }];
        
        
    } else {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted){
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeting the following Tweet: %@", tweet.text);
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState: UIControlStateNormal];
            }
        }];
        
        
    } else {
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState: UIControlStateNormal];
            }
        }];
    }
}

@end
