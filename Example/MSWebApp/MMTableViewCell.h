//
//  MMTableViewCell.h
//  MSWebApp
//
//  Created by Dylan on 2016/8/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UILabel *vLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end
