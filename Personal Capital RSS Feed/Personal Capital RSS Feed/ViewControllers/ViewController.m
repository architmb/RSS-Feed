//
//  ViewController.m
//  Personal Capital RSS Feed
//
//  Created by Archit Mendiratta on 4/21/18.
//  Copyright © 2018 Archit Mendiratta. All rights reserved.
//

#import "ViewController.h"
#import "ListCell.h"
#import "ListHeader.h"

@interface ViewController ()

@property (strong,nonatomic) UICollectionViewFlowLayout *layout;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIWebView *webView;

@property (strong,nonatomic) NSMutableArray *titles;
@property (strong,nonatomic) NSMutableArray *images;
@property (strong,nonatomic) NSMutableArray *links;

@property (strong,nonatomic) NSString *firstTitle;
@property (strong,nonatomic) NSString *firstImage;
@property (strong,nonatomic) NSString *firstLink;
@property (strong,nonatomic) NSString *firstItemDescription;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self configureNavBar];
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [self configureHeaderView];
    [self configureCollectionView];
    
    self.titles = [NSMutableArray array];
    self.images = [NSMutableArray array];
    self.links = [NSMutableArray array];
    self.firstItemDescription = @"";
    self.firstTitle = @"";
    self.firstImage = @"";
    self.firstLink = @"";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *items = [self getItemNodes];
    });
}

// Create the Navigation Bar
- (void) configureNavBar {
    self.navigationItem.title = @"Research & Insights";
    UIBarButtonItem* refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onTapRefresh:)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    self.navigationItem.leftBarButtonItem = nil;
    
}

// Create the Back Button for Web View
- (void) configureBackButton {
    self.navigationItem.title = @"Research & Insights";
    UIBarButtonItem* backBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapBack:)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = backBtn;
}
-(void)onTapBack: (UIBarButtonItem*)item {
    [_webView removeFromSuperview];
    [self configureNavBar];
    [self.collectionView reloadData];
}

// Refreshed the RSS Feed
-(void)onTapRefresh:(UIBarButtonItem*)item{
    self.titles = [NSMutableArray array];
    self.images = [NSMutableArray array];
    self.links = [NSMutableArray array];
    self.firstTitle = @"";
    self.firstLink = @"";
    self.firstImage = @"";
    self.firstItemDescription = @"";
    
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 0)];
    [self.collectionView deleteSections:indexSet];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *items = [self getItemNodes];
    });
}

// Creates the Top Article Image / Title / Description
- (void) configureHeaderView {
    [_layout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 250)];
}

// List of Articles
- (void) configureCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50) collectionViewLayout:_layout];
    //self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[ListCell class] forCellWithReuseIdentifier:@"TrackCell"];
    [self.collectionView registerClass:[ListHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.collectionView];
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TrackCell";
    ListCell *cell = (ListCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // get the track
    NSString *text = [self.titles objectAtIndex:indexPath.row];
    NSString *imageURL = [self.images objectAtIndex:indexPath.row];
    
    // populate the cell
    cell.titleLabel.text = text;
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            UIImage *image = [UIImage imageWithData:data];
            [cell.imageView setImage:image];
        });
    });
    
    //cell.backgroundColor = [UIColor blueColor];
    // return the cell
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2 - 20, 150);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

// Opens the web page to a given link
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[self.links objectAtIndex:indexPath.row], @"?displayMobileNavigation=0"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    [self configureBackButton];
    [self.view addSubview:_webView];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ListHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                  UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        headerView.titleLabel.text = self.firstTitle;
        headerView.descriptionLabel.text = self.firstItemDescription;
        
        NSString *imageURL = self.firstImage;
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                UIImage *image = [UIImage imageWithData:data];
                [headerView.imageView setImage:image];
            });
        });
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray  *) getItemNodes {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSURL * url = [NSURL URLWithString:@"https://www.personalcapital.com/blog/feed/?cat=3,891,890,68,284"];
    NSData * data = [[NSData alloc] initWithContentsOfURL:url];
    NSString * response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *regexStr = @"<item>(?s)(.*?)<\/item>";
    NSError *error;
    NSInteger i = 0;
    
    while (i < [response length]) {
        NSRegularExpression *testRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
        if( testRegex == nil ) NSLog( @"Error making regex: %@", error );
        NSTextCheckingResult *result = [testRegex firstMatchInString:response options:0 range:NSMakeRange(i, [response length]-i)];
        //   NSLog(@"result == %@",result);
        NSRange range = [result rangeAtIndex:1];
        if (range.location == 0) {
            break;
        }
        
        NSString *item = [response substringWithRange:range];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.collectionView performBatchUpdates:^{
                // Figure out where that item is in the array
                [array addObject:item];
                if ([array count] == 1) {
                    self.firstTitle = [self getTitle:item];
                    self.firstImage = [self getImageLink:item];
                    self.firstLink = [self getLink:item];
                    self.firstItemDescription = [self getDescription:item];
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
                } else {
                    [_titles addObject:[self getTitle:item]];
                    [_images addObject:[self getImageLink:item]];
                    [_links addObject:[self getLink:item]];
                    
                    int lastRow = [_titles count] - 1;
                    NSMutableArray *indexes = [NSMutableArray array];
                    [indexes addObject:[NSIndexPath indexPathForItem:lastRow inSection:0]];
                    [self.collectionView insertItemsAtIndexPaths:indexes];
                    
                }
            } completion:nil];
        });
        
        i = range.location + range.length;
    }
    
    return array;
}

- (NSString *) getTitle: (NSString *) item {
    NSString *regexStr = @"<title>(.*?)<\/title>";
    NSError *error;
    NSRegularExpression *titleRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [titleRegex firstMatchInString:item options:0 range:NSMakeRange(0, [item length])];
    NSRange range = [result rangeAtIndex:1];
    NSString *title = [item substringWithRange:range];
    if (title != nil) {
        title = [title stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
        title = [title stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];
        title = [title stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"’"];
        title = [title stringByReplacingOccurrencesOfString:@"&#124;" withString:@"|"];
    }
    return range.location == 0 ? @"" : title;
}

- (NSString *) getLink: (NSString *) item {
    NSString *regexStr = @"<link>(.*?)<\/link>";
    NSError *error;
    NSRegularExpression *linkRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [linkRegex firstMatchInString:item options:0 range:NSMakeRange(0, [item length])];
    NSRange range = [result rangeAtIndex:1];
    return range.location == 0 ? @"" : [item substringWithRange:range];
}

- (NSString *) getImageLink: (NSString *) item {
    NSString *regexStr = @"<media:content url=\"(.*?)\"";
    NSError *error;
    NSRegularExpression *imageRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [imageRegex firstMatchInString:item options:0 range:NSMakeRange(0, [item length])];
    NSRange range = [result rangeAtIndex:1];
    NSString *imageURL = [item substringWithRange:range];
    return range.location == 0 ? @"" : imageURL;
}

- (NSString *) getDescription: (NSString *) item {
    NSString *regexStr = @"<description><!\\[CDATA\\[<p>(.*?)<\/p>\\]\\]><\/description>";
    NSError *error;
    NSRegularExpression *descRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [descRegex firstMatchInString:item options:0 range:NSMakeRange(0, [item length])];
    NSRange range = [result rangeAtIndex:1];
    NSString *description = [item substringWithRange:range];
    NSLog(@"description: %@", description);
    return range.location == 0 ? @"" : description;
}


@end
