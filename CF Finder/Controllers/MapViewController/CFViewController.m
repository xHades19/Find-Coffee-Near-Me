//
//  Find Coffee Near Me
//
//  Created by xHadesvn on 06/09/16.
//  Copyright © 2016 xHadesvn. All rights reserved.
//

#import "CFViewController.h"

#import "CFNetworkHelper.h"
#import "CFMapAnnotation.h"
#import "CFPinAnnotationView.h"
#import "CFAnnotationDetailViewController.h"
#import "Constants.h"
#import "SearchController.h"
#import "NSObject+CFFinder.h"
#import "UIView+CFFinder.h"

@interface CFViewController () <MKMapViewDelegate, UISearchResultsUpdating, UITableViewDelegate, SearchViewDelegate>
{
    CLLocationManager *locationManager;
    CFMapAnnotation *selectedAnnotation;
    BOOL firstTime;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *cfsArray;
@property (nonatomic) CFNetworkHelper *CFHelper;
@property (nonatomic, strong) SearchController *search;
@property (nonatomic, strong) UISearchController *searchControl;
@end


@implementation CFViewController

NSString *const kAnnotationViewIdentifier = @"AnnotationViewIdentifier";
NSString *const kCFAnnotationDetailSegue = @"CFAnnotationDetailSegue";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init store the annotations
    self.cfsArray = [NSMutableArray array];
    
    [self initLocationManager];
    
    // Navigation Bar Title
    [self setTitle:@"Find Coffee Near Me"];
    
    // Add UIBarButtonItem events
    [self.searchBarButton setTarget:self];
    [self.searchBarButton setAction:@selector(searchBarButtonPressed:)];
    [self.locationBarButton setTarget:self];
    [self.locationBarButton setAction:@selector(locationBarButtonPressed:)];
    
    // Map View
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    
    // CF Helper
    self.CFHelper = [[CFNetworkHelper alloc] init];

    
    firstTime = YES;
}


#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (firstTime && [self.mapView isEqual:mapView]) {
        [self centerMapUserCurrentLocation:userLocation];
        [self updateNearbyCFsAtCoordinate:userLocation.coordinate];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!firstTime && [self.mapView isEqual:mapView]) {
        [self updateNearbyCFsAtCoordinate:self.mapView.centerCoordinate];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    CFPinAnnotationView *customPinView;
    if (![annotation isMemberOfClass:[MKUserLocation class]]) {
        customPinView = (CFPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationViewIdentifier];
        
        if (!customPinView) {
            customPinView = [[CFPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:kAnnotationViewIdentifier];
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailButton setImage:[[UIImage imageNamed:@"rightGrayArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                          forState:UIControlStateNormal];
            [detailButton addTarget:self
                             action:@selector(annotationCalloutViewPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = detailButton;
        }
    }
    return customPinView;
}


#pragma mark - Actions

-(void)searchBarButtonPressed:(UIBarButtonItem *)button
{
    // search event
    self.search =[[SearchController alloc] init];
    self.search.delegate = self;
    
    _searchControl =[[UISearchController alloc] initWithSearchResultsController:_search];
    _searchControl.searchResultsUpdater =self;
    _searchControl.hidesNavigationBarDuringPresentation = NO;
    _searchControl.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    [self.navigationController presentViewController:_searchControl animated:YES completion:nil];

}

-(void)locationBarButtonPressed:(UIBarButtonItem *)button
{
    [self centerMapUserCurrentLocation:self.mapView.userLocation];
    [self updateNearbyCFsAtCoordinate:self.mapView.userLocation.coordinate];
}

-(void)annotationCalloutViewPressed:(UIButton *)calloutButton
{
    CFPinAnnotationView *pinAnnotationView = (CFPinAnnotationView *)[calloutButton superviewOfType:[CFPinAnnotationView class]];
    if (pinAnnotationView) {
        selectedAnnotation = pinAnnotationView.annotation;
        [self performSegueWithIdentifier:kCFAnnotationDetailSegue sender:self];
    }
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kCFAnnotationDetailSegue]){
        CFAnnotationDetailViewController * viewController = (CFAnnotationDetailViewController *) segue.destinationViewController;
        [viewController setAnnotation:selectedAnnotation];
        [viewController setNearAnnotations:[self annotationListWithout:selectedAnnotation distanceLessThan:ONE_MILE]];
        [viewController setUserLocation:self.mapView.userLocation.coordinate];
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Bản đồ"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:nil action:nil]];
    }
}


#pragma mark - MapView update

-(void)centerMapUserCurrentLocation:(MKUserLocation *)userLocation
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

-(void)updateNearbyCFsAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.CFHelper getNearbyCFsAtCoordinate:coordinate
                        withCompletionHandler:^(NSArray *CFsArray, NSError *error) {
                            if (!error && CFsArray) {
                                [self updateMapWithResponse:CFsArray];
                            }
                        }];
}

- (void)updateMapWithResponse:(NSArray *)CFsArray
{
    MKCoordinateRegion region;
    if (firstTime) {
        firstTime = NO;
        region.span.latitudeDelta = 0.05;
        region.span.longitudeDelta = 0.05;
        region.center = self.mapView.userLocation.coordinate;
    }
    else{
        region = self.mapView.region;
    }
    

    for (int i = 0; i < CFsArray.count; i++) {
        NSDictionary *CF = CFsArray[i];
        
        NSString *identifier = [[CF objectForKey:@"id"] valueOrNil];
        double latitud = [[CF objectForKey:@"latitud"] doubleValue];
        double longitud = [[CF objectForKey:@"longitud"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitud, longitud);
        
        
        if (![self annotationIdentifierInMapView:identifier] && [self coordinate:coordinate inRegion:region]) {
            CFMapAnnotation *mapAnnotation = [[CFMapAnnotation alloc] init];
            mapAnnotation.identifier = identifier;
            mapAnnotation.coordinate = coordinate;
            mapAnnotation.name = [[CF objectForKey:@"name"] valueOrNil];
            mapAnnotation.address = [[CF objectForKey:@"address"] valueOrNil];
            mapAnnotation.distance = [[CF objectForKey:@"distance"] valueOrNil];
            mapAnnotation.formattedAddress = [[CF objectForKey:@"formattedAddress"] valueOrNil];
            mapAnnotation.formattedPhone = [[CF objectForKey:@"formattedPhone"] valueOrNil];
            mapAnnotation.categoryIconURL = [[CF objectForKey:@"categoryIconURL"] valueOrNil];
            mapAnnotation.categoryName = [[CF objectForKey:@"categoryName"] valueOrNil];
            
            if (mapAnnotation.categoryIconURL) {
                [self.CFHelper getImageNSDataFromURL:mapAnnotation.categoryIconURL
                                withCompletionHandler:^(NSData *data) {
                                    mapAnnotation.categoryIcon = [[UIImage imageWithData:data] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                                }
                 ];
            }
            
            if (![self.cfsArray containsObject:mapAnnotation])
                  [self.cfsArray addObject:mapAnnotation];
    
            [self.mapView addAnnotation:mapAnnotation];
        }
    }
}


#pragma mark - Helpers

-(void)initLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

- (BOOL)coordinate:(CLLocationCoordinate2D)coord inRegion:(MKCoordinateRegion)region
{
    CLLocationCoordinate2D center = region.center;
    MKCoordinateSpan span = region.span;
    
    BOOL result = YES;
    result &= cos((center.latitude - coord.latitude)*M_PI/180.0) > cos(span.latitudeDelta/2.0*M_PI/180.0);
    result &= cos((center.longitude - coord.longitude)*M_PI/180.0) > cos(span.longitudeDelta/2.0*M_PI/180.0);
    return result;
}

-(BOOL)annotationIdentifierInMapView:(NSString *)identifier
{
    for (CFMapAnnotation *mapAnnotation in self.mapView.annotations) {
        if (![mapAnnotation isMemberOfClass:[MKUserLocation class]] && [identifier isEqual:mapAnnotation.identifier]) {
            return YES;
        }
    }
    return NO;
}

-(NSArray *)annotationListWithout:(CFMapAnnotation *)annotation distanceLessThan:(NSNumber *)distance
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@ AND identifier != %@ AND distance <= %@", [CFMapAnnotation class],annotation.name, distance];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [[self.mapView.annotations filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}

#pragma mark - Search Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString * string =searchController.searchBar.text;
    
    if (searchController.searchResultsController) {
        SearchController * search =(SearchController *)searchController.searchResultsController;
    
        NSArray *filtered = [self.cfsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", string]];
        search.arrData = filtered;
        [search.tableView reloadData];
    }
}

- (void) didSelectRow:(CFMapAnnotation *) cfDictionay {
    selectedAnnotation = cfDictionay;
    self.searchControl.active = NO;
    self.definesPresentationContext = NO;
    [self performSegueWithIdentifier:kCFAnnotationDetailSegue sender:self];
}


@end
