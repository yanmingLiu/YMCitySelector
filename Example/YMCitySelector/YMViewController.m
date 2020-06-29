//
//  YMViewController.m
//  YMCitySelector
//
//  Created by yanmingLiu on 06/29/2020.
//  Copyright (c) 2020 yanmingLiu. All rights reserved.
//

#import "YMViewController.h"
#import "YMCitySelector.h"

@interface YMViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation YMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)choose:(id)sender {
    
    YMCitySelector *vc = [[YMCitySelector alloc] init];
    [vc show];
    
    vc.callback = ^(NSString * _Nonnull province, NSString * _Nonnull city, NSString * _Nonnull area) {
      
        self.label.text = [NSString stringWithFormat:@"%@  %@  %@",province, city, area];
    };
}

- (IBAction)defaultdata:(id)sender {
    YMCitySelector *vc = [[YMCitySelector alloc] init];
    [vc show];
    
    [vc fillDefaultWithProvince:@"四川省" city:@"成都市" area:@"武侯区"];
    
}


@end
