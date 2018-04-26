//
//  ListHeaderCollectionViewCell.h
//  Personal Capital RSS Feed
//
//  Created by Archit Mendiratta on 4/26/18.
//  Copyright © 2018 Archit Mendiratta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end
