//
//  DetailViewController.h
//  AutolayoutTableView
//
//  Created by Snow Wu on 10/22/15.
//  Copyright © 2015 Tencent Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

