//
//  IGListViewController.m
//  YouEvent
//
//  Created by Igor guk on 11.11.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

#import "YECategoryListViewController.h"
#import "YEFavoriteItemCell.h"
#import "SWRevealViewController.h"
#import "IGViewController.h"

static const CGFloat kIGCellHeightCollapsed = 222.0f;
static const CGFloat kIGCellHeightExpanded = 361.0f;
static const CGFloat kRearViewRevealOverdraw = 0.f;

@interface YECategoryListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *pathOfExpandedCell;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *sideBarButtonMenu;

@end

@implementation YECategoryListViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarButtonMenu setTarget:self.revealViewController];
        [self.sideBarButtonMenu setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    revealViewController.rearViewRevealOverdraw = kRearViewRevealOverdraw;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YEFavoriteItemCell *cell = (YEFavoriteItemCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self isCellExpandedAtIndexPath:indexPath]) {
        [cell hideDotsButton];
    } else {
        [cell showDotsButton];
    }
    
    cell.onDotsTappedAction = ^{
        self.pathOfExpandedCell = indexPath;
        [self.tableView reloadData];
    };
    return cell;
}

- (BOOL)isCellExpandedAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isThisExpandedCell = self.pathOfExpandedCell && [self.pathOfExpandedCell isEqual:indexPath];
    return isThisExpandedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = kIGCellHeightCollapsed;
    if ([self isCellExpandedAtIndexPath:indexPath]) {
        height = kIGCellHeightExpanded;
    }
    return height;
}

@end
