//
//  IGFavoriteItemCell.h
//  YouEvent
//
//  Created by Igor guk on 11.11.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YEFavoriteItemCell : UITableViewCell

@property (nonatomic, copy) void(^onDotsTappedAction)(void);

- (void)showDotsButton;
- (void)hideDotsButton;

@end
