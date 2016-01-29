//
//  ViewController.m
//  LoginController
//
//  Created by Thomson on 16/1/28.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import "ViewController.h"
#import "LoginMainViewController.h"

@interface ViewController () <LoginMainViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - LoginMainViewControllerDelegate

- (void)loginFinished
{
    NSLog(@"Finished");
}

- (IBAction)login:(id)sender
{
    [LoginMainViewController showLoginViewController:self];
}

@end
