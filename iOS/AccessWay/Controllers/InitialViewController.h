//
//  InitialViewController.h
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *primaryButton;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTextHeightConstraint;

- (IBAction)primaryButtonDidPress:(id)sender;

@end
