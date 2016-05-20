//
//  IGTableViewController.m
//  YouEvent
//
//  Created by Igor Guk on 24.10.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

#import "YEMainMenuViewController.h"
#import "SWRevealViewController.h"
#import "YEServerManager.h"
#import "YECategoryListViewController.h"

@interface YEMainMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *categoriesArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YEMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoriesArray = [NSMutableArray array];
    [self getCategoriesFromServer];
    UIImage *image = [UIImage imageNamed:@"bgMenu1"];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:image];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSData *imageDataBackground = [[NSUserDefaults standardUserDefaults]objectForKey:@"backgroundMenu"];
    UIImage *imageBackground = [UIImage imageWithData:imageDataBackground];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:imageBackground];
}

#pragma mark - API

- (void)getCategoriesFromServer {
    __weak YEMainMenuViewController *weakSelf = self;
    
    [[YEServerManager sharedManager] getCategoriesWithOrder:[self.categoriesArray count]
                                                  onSuccess:^(NSArray *categories, YEStatusCode statusCode) {
                                                      [weakSelf.categoriesArray addObjectsFromArray:categories];
                                                      [weakSelf.tableView reloadData];
                                                  }
                                                  onFailure:^(NSError *error, YEStatusCode statusCode) {
                                                      NSLog(@"error = %@, code = %ld ", [error localizedDescription], (long)statusCode);
                                                  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.separatorColor = [UIColor clearColor];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"title";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    YECategory *category = [self.categoriesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = category.title?: @"";
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    if ([segue.identifier isEqual:@"star"]) {
        destViewController.title = @"Избранное";
    } else {
        if ([segue.identifier isEqual:@"list"]) {
            YECategory *category = [self.categoriesArray objectAtIndex:indexPath.row];
            destViewController.title = [(category.title?:@"") capitalizedString];
        }
    }
}

- (IBAction)vkButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://vk.com/youevent"]];
}

- (IBAction)googlePlusButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://plus.google.com/+YoueventNetwork"]];
}

@end
