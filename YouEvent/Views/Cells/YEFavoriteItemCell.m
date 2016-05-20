//
//  IGFavoriteItemCell.m
//  YouEvent
//
//  Created by Igor guk on 11.11.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

#import "YEFavoriteItemCell.h"

@interface YEFavoriteItemCell()

@property (nonatomic, weak) IBOutlet UIButton *dotsButton;

@end

@implementation YEFavoriteItemCell

- (IBAction)onDotsTappedAction:(id)sender {
    if (self.onDotsTappedAction) {
        self.onDotsTappedAction();
    }
}

- (void)showDotsButton {
    self.dotsButton.hidden = NO;
}

- (void)hideDotsButton {
    self.dotsButton.hidden = YES;
}

@end
