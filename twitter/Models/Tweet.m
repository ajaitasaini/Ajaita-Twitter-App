//
//  Tweet.m
//  twitter
//
//  Created by Ajaita Saini on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

@implementation Tweet

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            dictionary = originalTweet;
        }
        
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        //self.imageURL = [dictionary.allValues[@"media_url_https"]];
    }
    
    NSDictionary *user = dictionary[@"user"];
    self.user = [[User alloc] initWithDictionary:user];
    
    NSString *createdAtOriginalString = dictionary[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    NSDate *currentTime = [NSDate date];
    NSInteger secondsApart = [currentTime secondsFrom:date];
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:-secondsApart];
    
    self.createdAtString = timeAgoDate.timeAgoSinceNow;
    
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
