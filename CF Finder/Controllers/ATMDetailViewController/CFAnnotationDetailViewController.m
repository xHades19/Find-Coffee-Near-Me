//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//
#import "CFAnnotationDetailViewController.h"
#import "Constants.h"
#import "OtherCFTableViewCell.h"
#import "DetailCFTableViewCell.h"
@import Contacts;

@interface CFAnnotationDetailViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UITableView *otherCFTableView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (unsafe_unretained, nonatomic) BOOL isRegisterNotification;
@end


@implementation CFAnnotationDetailViewController

NSString *const kOtherCFCellIdentifier = @"OtherCFCellIdentifier";
NSString *const kDetailCFCellIdentifier = @"DetailCFCellIdentifier";


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Bar Title
    [self setTitle:self.annotation.name];
    
    // Add UIBarButtonItem events
    [self.actionBarButton setTarget:self];
    [self.actionBarButton setAction:@selector(actionBarButtonPressed:)];
    
    // Fonts
    [self.nameLabel setFont:[UIFont fontWithName:FONT_HELVETICA_MEDIUM size:16]];
    [self.addressLabel setFont:[UIFont fontWithName:FONT_HELVETICA_REGULAR size:12]];
    
    // Text Color
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.addressLabel setTextColor:UIColorFromRGB(RGB_GRAY)];
    
    // Set text
    [self.nameLabel setText:[NSString stringWithFormat:@"%@%@",self.annotation.name, self.annotation.categoryName ? [NSString stringWithFormat:@" (%@)", self.annotation.categoryName] : @""]];
    [self.addressLabel setText:[self.annotation.formattedAddress componentsJoinedByString:@", "]];
    
    // Disable Other CF scroll bounces
    [self.otherCFTableView setBounces:NO];
    
    // Icon
    [self.categoryIconImageView setImage:self.annotation.categoryIcon ? : [UIImage imageNamed:@"unknown"]];
    [self.categoryIconImageView.layer setCornerRadius:5];
    [self.categoryIconImageView setClipsToBounds:YES];
    [self.categoryIconImageView setBackgroundColor:UIColorFromRGB(RGB_GRAY)];
    
    // Scroll View
    [self.imagesScrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, self.imagesScrollView.frame.size.height)];
    [self.imagesScrollView setBounces:NO];
    [self.imagesScrollView setPagingEnabled:YES];
    [self.imagesScrollView setShowsHorizontalScrollIndicator:NO];
    [self.imagesScrollView setShowsVerticalScrollIndicator:NO];
    [self.imagesScrollView setDirectionalLockEnabled:YES];
    [self.imagesScrollView setAlwaysBounceVertical:NO];
    [self.imagesScrollView setScrollsToTop:NO];
    [self.imagesScrollView setDelegate:self];
    
    for (int page = 0; page < self.pageControl.numberOfPages; page++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"image%d",page]]];
        [imageView setCenter:CGPointMake((self.view.frame.size.width * (0.5 + page)), self.imagesScrollView.center.y)];
        [self.imagesScrollView addSubview:imageView];
    }
    
    if (self.isRegisterNotification == NO) {
        NSLog(@"register one time");
        self.isRegisterNotification = YES;
        [self.view addObserver:self
                forKeyPath:@"frame"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:0];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)dealloc {
    [self.view removeObserver:self forKeyPath:@"frame"];
}


#pragma mark - Actions

-(void)actionBarButtonPressed:(UIBarButtonItem *)button
{
    NSString *street = [[self.annotation.formattedAddress valueForKey:@"description"] componentsJoinedByString:@","];
    // event
    CNMutablePostalAddress *postalAdress = [[CNMutablePostalAddress alloc] init];
    postalAdress.street = street;
    
    NSString * streetName = self.annotation.name;
    
    CNLabeledValue *postalContact = [[CNLabeledValue alloc] initWithLabel:streetName value:postalAdress];
     CNLabeledValue *urlAddressContact = [[CNLabeledValue alloc] initWithLabel:@"map url" value:[NSString stringWithFormat:@"http://maps.apple.com/maps?address=%@", street]];

    
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.contactType = CNContactTypePerson;
    contact.organizationName = self.annotation.name;
    contact.departmentName = street;
    contact.postalAddresses = @[postalContact];
    contact.urlAddresses = @[urlAddressContact];
    
    // create path
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
    
    NSString *path = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@.loc.vcf", street]];;
 
    NSError *error = nil;
    NSData *contactData = [CNContactVCardSerialization dataWithContacts
    :@[contact] error: &error];
    
    if (error == nil) {
        [contactData writeToFile:path atomically:YES];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        UIActivityViewController *acty = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        [self presentViewController:acty animated:YES completion:nil];
    }
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.view && [keyPath isEqualToString:@"frame"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            CGRect oldRect = [change[NSKeyValueChangeOldKey] CGRectValue];
            CGRect newRect = [change[NSKeyValueChangeNewKey] CGRectValue];
            if (!CGRectEqualToRect(newRect,oldRect)) {
                [self.imagesScrollView setContentSize:CGSizeMake(newRect.size.width * 2, self.imagesScrollView.frame.size.height)];
                for (int page = 0; page < self.pageControl.numberOfPages; page++) {
                    UIImageView *imageView = self.imagesScrollView.subviews[page];
                    CGRect frame = imageView.frame;
                    frame.size.width = newRect.size.width;
                    [imageView setFrame:frame];
                    [imageView setCenter:CGPointMake((newRect.size.width * (0.5 + page)), self.imagesScrollView.center.y)];
                    [self.imagesScrollView setContentOffset:CGPointMake((self.imagesScrollView.bounds.size.width * self.pageControl.currentPage + 1), 0) animated:YES];
                }
            }
        }
    }
}


#pragma mark - PageControl

- (IBAction)pageControlValueChanged:(id)sender
{
    [self.imagesScrollView setContentOffset:CGPointMake((self.imagesScrollView.bounds.size.width * self.pageControl.currentPage), 0) animated:YES];
    self.pageControl.currentPage--;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.imagesScrollView]){
        CGFloat pageWidth = self.imagesScrollView.frame.size.width;
        float actualPage = self.imagesScrollView.contentOffset.x / pageWidth;
        self.pageControl.currentPage = lround(actualPage);
    }
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.otherCFTableView]) {
        return 60;
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // table detail
    if ([tableView isEqual:self.detailTableView]) {
       if (indexPath.row == 1) { // phone call
            NSString *cleanedPhoneNumber = [[self.annotation.formattedPhone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedPhoneNumber]];
           if (![[UIApplication sharedApplication] canOpenURL:phoneURL] || ![[UIApplication sharedApplication] openURL:phoneURL]){
               
               [self showMessageWithTitle:@"Xin lỗi" andMessage:@"Thiết bị không thể thực hiện cuộc gọi này!"];
            }
        } else if (indexPath.row == 0) {  // direction
            [self getDirectionFrom:self.userLocation to:self.annotation.coordinate];
        }
    } else { // table other coffee shop
        CFMapAnnotation *mapAnnotation = [self.nearAnnotations objectAtIndex:indexPath.row];
        self.annotation =  mapAnnotation;
        [self viewDidLoad];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.otherCFTableView]) {
        return self.nearAnnotations.count;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.otherCFTableView]) {
        OtherCFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtherCFCellIdentifier];
        CFMapAnnotation *mapAnnotation = [self.nearAnnotations objectAtIndex:indexPath.row];
        [cell.nameLabel setText:mapAnnotation.name];
        [cell.addressLabel setText:mapAnnotation.address];
        [cell.categoryIconImageView setImage:mapAnnotation.categoryIcon ? : [UIImage imageNamed:@"unknown"]];
        return cell;
    }
    DetailCFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCFCellIdentifier];
    [cell.leftLabel setText:indexPath.row == 0 ? @"Chỉ dẫn đường đi" : @"Liên hệ trực tiếp"];
    [cell.rightLabel setText:indexPath.row == 0 ? @"" : self.annotation.formattedPhone ? : @"+00 000 000 0000"];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [tableView isEqual:self.otherCFTableView] ? @"Coffee khác trong phạm vi 2km" : nil;
}

@end
