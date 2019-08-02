//
//  AppDelegate+Local.m
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/2/1.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "AppDelegate+Local.h"
#import "UIAlertController+Extension.h"

@interface AppDelegate()

@property (nonatomic, strong) CLLocationManager *localManager;

@end

@implementation AppDelegate (Local)

- (void)useLocal {
    self.localManager = [[CLLocationManager alloc] init];
    self.localManager.delegate = self;
    self.localManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.localManager.distanceFilter = 1000;
    [self.localManager requestWhenInUseAuthorization];
    [self.localManager startUpdatingLocation];
}

static const char *CLLocation_manager = "CLLocation_manager";
- (CLLocationManager *)localManager {
    return  objc_getAssociatedObject(self, CLLocation_manager);
}
- (void)setLocalManager:(CLLocationManager *)localManager {
    objc_setAssociatedObject(self, CLLocation_manager, localManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // CLLocationDegrees lat = locations.lastObject.coordinate.latitude;
    // CLLocationDegrees longt = locations.lastObject.coordinate.longitude;
    [self.localManager stopUpdatingLocation];
    [self resevseGeocode:locations.lastObject];
    
}

- (void)resevseGeocode:(CLLocation *)location {
    CLGeocoder *revBeo = [[CLGeocoder alloc] init];
    [revBeo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"%@",placemarks[0].addressDictionary);
        NSMutableString *str = [[NSMutableString alloc] init];
        for (NSString *key in placemarks[0].addressDictionary) {
            if ([key isEqualToString:@"FormattedAddressLines"]) {
                if ([DataCheck isValidArray:[placemarks[0].addressDictionary objectForKey:key]]) {
                    str = [str stringByAppendingFormat:@"%@：%@\n",key,[placemarks[0].addressDictionary objectForKey:key][0]].mutableCopy;
                }
            } else {
                str = [str stringByAppendingFormat:@"%@：%@\n",key,[placemarks[0].addressDictionary objectForKey:key]].mutableCopy;
            }
        }
        [UIAlertController alertTitle:nil message:str.copy controller:self.window.rootViewController doneText:@"确定" cancelText:nil doneHandle:^{
            
        } cancelHandle:nil];
        NSLog(@"%@",placemarks[0].name);  // 上地三街9号B-401号
        NSLog(@"%@",placemarks[0].thoroughfare); // 上地三街
        NSLog(@"%@",placemarks[0].subLocality); // 海淀区
        NSLog(@"%@",placemarks[0].administrativeArea); // 北京市 (州，省份)
        NSLog(@"%@",placemarks[0].subAdministrativeArea);
        NSLog(@"%@",placemarks[0].ocean);
        NSLog(@"%@",placemarks[0].locality);  // 北京市
    }];
}

@end
