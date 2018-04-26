//
//  CustomTableViewCell.m
//  Personal Capital RSS Feed
//
//  Created by Archit Mendiratta on 4/23/18.
//  Copyright © 2018 Archit Mendiratta. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 100)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.layer.cornerRadius = 0.0;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.contentView.bounds.size.width - 20, 50)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        _titleLabel.numberOfLines = 2;
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

@end
