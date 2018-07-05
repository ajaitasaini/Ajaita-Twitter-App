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
    self.profileName.text = self.tweet.user.screenName;
    self.tweetContent.text = self.tweet.text;
    //self.profileView.image = self.tweet.user.
    self.profileView.image = nil;
    [self.profileView setImageWithURL:self.tweet.user.profileURL];
    [self.replyButton setTitle:self.tweet.idStr forState: UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
    
    //self.replyButton.titleLabel = self.tweet.idStr;
}

- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState: UIControlStateNormal];
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}

@end
