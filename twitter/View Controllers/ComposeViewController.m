//
//  ComposeViewController.m
//  twitter
//
//  Created by Ajaita Saini on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.composeTweetText.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapTweet:(id)sender {
    [[APIManager shared]postStatusWithText:self.composeTweetText.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTweetText.text stringByReplacingCharactersInRange:range withString:text];
    
    if (newText.length < characterLimit){
        self.charactersLeftText.text = [NSString stringWithFormat: @"%lu",(140 - newText.length)];
    } else {
        self.charactersLeftText.text = @"Not enough characters";
    }
    
    // The new text should be allowed? True/False
    return newText.length < characterLimit;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
