//
//  MMTableViewCell.m
//  MSWebApp
//
//  Created by Dylan on 2016/8/26.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "MMTableViewCell.h"

@implementation MMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, .7)];
    lineView.backgroundColor = [UIColor colorWithRed:231/255. green:231/255. blue:231/255. alpha:1.0];
    [self.contentView addSubview:lineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
