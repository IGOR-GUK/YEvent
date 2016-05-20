//
//  IGViewController.m
//  YouEvent
//
//  Created by Igor guk on 08.11.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

#import "IGViewController.h"
#import "GRKContainerViewController.h"
#import "IGFirstViewController.h"
#import "IGSecondViewController.h"
#import "IGThirdViewController.h"

static NSString * const kSegueBody = @"body";

typedef NS_ENUM(NSInteger, BodyContent) {
    BodyContentZero = 0,
    BodyContentOne,
    BodyContentTwo,
    BodyContentCount
};

@interface IGViewController ()

@property (nonatomic, weak) GRKContainerViewController *bodyContainerViewController;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentSelected:(UISegmentedControl *)sender;

@end

@implementation IGViewController

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if ([identifier isEqual:kSegueBody]) {
        id obj = segue.destinationViewController;
        if ([obj isKindOfClass:GRKContainerViewController.class]) {
            self.bodyContainerViewController = (GRKContainerViewController *)obj;
            [self setBodyContentWithIndex:self.segmentedControl.selectedSegmentIndex animated:YES];
        } else {
            NSLog(@"ERROR: Seque '%@' is of unexpected type: %@", identifier, obj);
        }
    }
}

#pragma mark - Actions

- (IBAction)segmentSelected:(UISegmentedControl *)sender {
    NSLog(@"Selected '%@' at index %d.", [sender titleForSegmentAtIndex:sender.selectedSegmentIndex], (int)sender.selectedSegmentIndex);
    [self setBodyContentWithIndex:self.segmentedControl.selectedSegmentIndex animated:YES];
}

#pragma mark - Body Content

- (void)setBodyContentWithIndex:(NSInteger)index animated:(BOOL)animated {
    NSLog(@"Setting body index to %d", (int)index);
    UIViewController *viewController = nil;
    
    if (self.bodyContainerViewController) {
        switch (index) {
            case BodyContentZero:
            default: {
                static IGFirstViewController *vc = nil;
                if (!vc) {
                    vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(IGFirstViewController.class)];
                }
                viewController = vc;
                break;
            }
            case BodyContentOne: {
                static IGSecondViewController *vc = nil;
                if (!vc) {
                    vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(IGSecondViewController.class)];
                }
                viewController = vc;
                break;
            }
            case BodyContentTwo: {
                IGThirdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(IGThirdViewController.class)];
                viewController = vc;
                break;
            }
        }
        [self.bodyContainerViewController setViewController:viewController animated:animated completion:nil];
    }
}

@end
