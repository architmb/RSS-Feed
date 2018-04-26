//
//  ListHeaderCollectionViewCell.m
//  Personal Capital RSS Feed
//
//  Created by Archit Mendiratta on 4/26/18.
//  Copyright © 2018 Archit Mendiratta. All rights reserved.
//

#import "ListHeader.h"

@implementation ListHeader

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 200)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.layer.cornerRadius = 0.0;
        
        _titleLabel = [UILabel new];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, frame.size.width - 20, 30)];
        _descriptionLabel.textColor = [UIColor blackColor];
        _descriptionLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
        _descriptionLabel.numberOfLines = 2;
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_descriptionLabel];
        
        // Add contstraints for ImageView - Top, Left
        [_imageView.superview addConstraint:[NSLayoutConstraint
                                           constraintWithItem:_imageView.superview
                                           attribute:NSLayoutAttributeLeft
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:_imageView
                                           attribute:NSLayoutAttributeLeft
                                           multiplier:1.0
                                           constant:0.0]];
        [_imageView.superview addConstraint:[NSLayoutConstraint
                                           constraintWithItem:_imageView.superview
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:_imageView
                                           attribute:NSLayoutAttributeTop
                                           multiplier:1.0
                                           constant:0.0]];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];

        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:frame.size.width - 20];
        
        [self addConstraints:@[left, bottom]];
        [_titleLabel addConstraints:@[height, width]];

    }
    
    return self;
}

@end
