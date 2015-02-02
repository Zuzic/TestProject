//
//  ContactTableViewCell.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "ContactTableViewCell.h"
@interface ContactTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;

@end


@implementation ContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectImageView.image = selected ? [UIImage imageNamed:@"checkImage"] : [UIImage imageNamed:@"uncheckImage"];
}

@end
