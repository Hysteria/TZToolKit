//
//  TZViewController.m
//  TZToolKit
//
//  Created by Zhou Hangqing on 03/02/2015.
//  Copyright (c) 2014 Zhou Hangqing. All rights reserved.
//

#import "TZViewController.h"
#import "TZToolKit/TZToolKit.h"

@interface TZViewController ()

@end

@implementation TZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *dimBackgroundImage = tz_dimBackgroundImage(self.view.bounds.size);
    UIImageView *iv = [[UIImageView alloc] initWithImage:dimBackgroundImage];
    [self.view addSubview:iv];
    
    [self setUpLabelsWithTransform];
    [self setUpButtons];
}

- (void)setUpLabelsWithTransform
{
    NSArray *texts = @[@"original", @"rotation", @"scale", @"flipX", @"flipY"];
    CGFloat x = self.view.bounds.size.width * 0.5, y = 20.f, offsetY = 100.f;
    for (int i = 0; i < texts.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
        [self.view addSubview:label];
        label.text = texts[i];
        label.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        [label sizeToFit];
        
        y += offsetY;
        
        switch (i) {
            case 0:
            {
                label.rotation = 45.f;
                label.scale = 1.3f;
                label.flipY = YES;
            }
                break;
            case 1:
            {
                label.rotation = 135.f;
            }
                break;
            case 2:
            {
                label.scale = 3.f;
            }
                break;
            case 3:
            {
                label.flipX = YES;
            }
                break;
            case 4:
            {
                label.flipY = YES;
            }
                break;
                
            default:
                break;
        }
        
        //        NSLog(@"label %d %@", i + 1, label.description);
    }
}

- (void)setUpButtons
{
    CGSize size = self.view.frame.size;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(size.width * 0.5 - 100, size.height - 100, 200, 50);
    [button setTitle:@"Show new view" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showView
{
    CGSize size = self.view.frame.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(size.width * 0.5 - 100, size.height * 0.5 - 100, 200, 200)];
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.9];
    view.tag = 77;
    view.layer.cornerRadius = 10.f;
    view.presentationStyle = TZPresentationPopOver;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 100)];
    label.text = @"Awesome";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 150, 100, 50);
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

}

- (void)dismissView
{
    [[self.view viewWithTag:77] removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
