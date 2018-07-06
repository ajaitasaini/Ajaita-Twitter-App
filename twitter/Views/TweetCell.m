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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet {
    self.profileName.text = self.tweet.user.name;
    self.tweetContent.text = self.tweet.text;
    //self.profileView.image = self.tweet.user.
    self.profileView.image = nil;
    [self.profileView setImageWithURL:self.tweet.user.profileURL];
    //[self.replyButton setTitle:self.tweet.idStr forState: UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
    self.screenName.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.dateCreated.text = self.tweet.createdAtString;
    
    
    
//    label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
//    label.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
//    
//    label.text = self.tweet.text;
//    self.tweetContent.text = label.text;

    
    //NSDate *timeAgoDate = self.tweet.createdAtString;
    //NSDate *timeAgoDate = self.tweet;
    //NSDateFormatter
    //lnbllrihlgbckgself.dateCreated.text = self.tweet.createdAtString;
    //createdAtString;
    //self.userActivity.userInfo.
    
    //self.replyButton.titleLabel = self.tweet.idStr;
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:-159887];
    NSLog(@"Time Ago: %@", timeAgoDate.timeAgoSinceNow);
}

- (void)calculateTime {
    NSArray *time = [self.tweet.createdAtString componentsSeparatedByString:@"/"];
    
}

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
