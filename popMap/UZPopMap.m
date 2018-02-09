//
//  UZPopMap.m
//  UZPopMap
//
//  Created by 王权伟 on 2018/2/8.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "UZPopMap.h"
#import "UZAppDelegate.h"
#import "NSDictionaryUtils.h"
#import <MapKit/MapKit.h>

@interface UZPopMap ()
{
    NSInteger _cbId;
}
@property(strong, nonatomic) NSMutableDictionary * isMapsInstalledDic;

@end

@implementation UZPopMap

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        
    }
    return self;
}

- (void)dispose {
    //do clean
}

- (void)isMapsInstalled:(NSDictionary *)paramDict {
    
    _cbId = [paramDict integerValueForKey:@"cbId" defaultValue:0];
    
    NSString * isMapsInstalledJSON = @"";
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.isMapsInstalledDic options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
    
        NSLog(@"%@",error);
        
    }else{
        
        isMapsInstalledJSON = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    if (_cbId > 0) {
        [self sendResultEventWithCallbackId:_cbId dataString:isMapsInstalledJSON stringType:kUZStringType_TEXT errDict:error.userInfo doDelete:YES];
    }
    
}

#pragma mark:- 地图调用
- (void)whichMap:(NSDictionary *)paramDict {
    
    _cbId = [paramDict integerValueForKey:@"cbId" defaultValue:0];
    
    //地图类型
    NSString * type = [paramDict objectForKey:@"type"];
    //起始位置 纬度
    NSString * LATITUDE_A = [paramDict objectForKey:@"LATITUDE_A"];
    //起始位置 经度
    NSString *  LONGTITUDE_A = [paramDict objectForKey:@"LONGTITUDE_A"];
    
    //终点位置 纬度
    NSString *  LATITUDE_B = [paramDict objectForKey:@"LATITUDE_B"];
    //终点位置 经度
    NSString *  LONGTITUDE_B = [paramDict objectForKey:@"LONGTITUDE_B"];
    
    if ([type isEqualToString:@"baidu"]) {
        //百度地图
        [self openBaidumapWithLATITUDE_A:LATITUDE_A LONGTITUDE_A:LONGTITUDE_A LATITUDE_B:LATITUDE_B LONGTITUDE_B:LONGTITUDE_B];
    }
    else if ([type isEqualToString:@"gaode"]) {
        //高德地图
        [self openAmapWithLATITUDE_A:LATITUDE_A LONGTITUDE_A:LONGTITUDE_A LATITUDE_B:LATITUDE_B LONGTITUDE_B:LONGTITUDE_B];
    }
    else if ([type isEqualToString:@"tengxun"]) {
        //腾讯地图
        [self openSosomapWithLATITUDE_A:LATITUDE_A LONGTITUDE_A:LONGTITUDE_A LATITUDE_B:LATITUDE_B LONGTITUDE_B:LONGTITUDE_B];
    }
    else if ([type isEqualToString:@"pingguo"]) {
        //apple地图
        [self openApplemapWithLATITUDE_A:LATITUDE_A LONGTITUDE_A:LONGTITUDE_A LATITUDE_B:LATITUDE_B LONGTITUDE_B:LONGTITUDE_B];
    }
    else if ([type isEqualToString:@"guge"]) {
        //谷歌地图
        [self openComgooglemapsWithLATITUDE_A:LATITUDE_A LONGTITUDE_A:LONGTITUDE_A LATITUDE_B:LATITUDE_B LONGTITUDE_B:LONGTITUDE_B];
    }
    else {
        
//        if (_cbId > 0) {
//            [self sendResultEventWithCallbackId:_cbId dataString:isMapsInstalledJSON stringType:kUZStringType_TEXT errDict:error.userInfo doDelete:YES];
//        }
        
    }
    
}

//高德地图
- (void)openAmapWithLATITUDE_A:(NSString *)lat_A LONGTITUDE_A:(NSString *)lon_A LATITUDE_B:(NSString *)lat_B LONGTITUDE_B:(NSString *)lon_B {
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%@&slon=%@&sname=&did=BGVIS2&dlat=%@&dlon=%@&dname=终点位置&dev=0&t=0",lat_A,lon_A,lat_B,lon_B] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self openMap:urlString];
    
}

//百度地图
- (void)openBaidumapWithLATITUDE_A:(NSString *)lat_A LONGTITUDE_A:(NSString *)lon_A LATITUDE_B:(NSString *)lat_B LONGTITUDE_B:(NSString *)lon_B {
    
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@,%@&destination=%@,%@&mode=driving&coord_type=gcj02&src=webapp.navi.yourCompanyName.yourAppName",lat_A,lon_A,lat_B,lon_B] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self openMap:urlString];
    
}

//谷歌地图
- (void)openComgooglemapsWithLATITUDE_A:(NSString *)lat_A LONGTITUDE_A:(NSString *)lon_A LATITUDE_B:(NSString *)lat_B LONGTITUDE_B:(NSString *)lon_B {
    
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=applicationName&x-success=&saddr=%@,%@&daddr=%@,%@&directionsmode=driving",lat_A,lon_A,lat_B,lon_B] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self openMap:urlString];
}

//腾讯地图
- (void)openSosomapWithLATITUDE_A:(NSString *)lat_A LONGTITUDE_A:(NSString *)lon_A LATITUDE_B:(NSString *)lat_B LONGTITUDE_B:(NSString *)lon_B {
    
    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=&fromcoord=%@,%@&type=drive&tocoord=%@,%@&to=终点位置&coord_type=1&policy=0", lat_A, lon_A, lat_B, lon_B] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openMap:urlString];
}

//Apple 地图
- (void)openApplemapWithLATITUDE_A:(NSString *)lat_A LONGTITUDE_A:(NSString *)lon_A LATITUDE_B:(NSString *)lat_B LONGTITUDE_B:(NSString *)lon_B {
    
    //当前位置
    MKMapItem *currentLocation;
    if ([lat_A length] == 0 || [lon_A length] == 0) {
        currentLocation =[MKMapItem mapItemForCurrentLocation];
    }
    else {
        CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake([lat_A doubleValue], [lon_A doubleValue]);
        currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:currentCoordinate addressDictionary:nil]];
    }
    
    //目的地
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lat_B doubleValue], [lon_B doubleValue]);
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    
    [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                               MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    
}

- (void)openMap:(NSString *)url {
    
    //iOS10以后,使用新API
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }];
    } else {
        // Fallback on earlier versions
        //iOS10以前,使用旧API
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark:- 检查地图是否安装
- (BOOL)isAmapInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    
}

- (BOOL)isBaidumapInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    
}

- (BOOL)isSosomapInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sosomap://"]];
    
}

- (BOOL)isGooglemapsInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
    
}

#pragma mark:- 懒加载
- (NSMutableDictionary *)isMapsInstalledDic {
    
    if (_isMapsInstalledDic == nil) {
        
        _isMapsInstalledDic = [NSMutableDictionary dictionary];
        [_isMapsInstalledDic setObject:@([self isAmapInstalled]) forKey:@"gaodeMap"];
        [_isMapsInstalledDic setObject:@([self isBaidumapInstalled]) forKey:@"baiduMap"];
        [_isMapsInstalledDic setObject:@([self isSosomapInstalled]) forKey:@"tengxunMap"];
        [_isMapsInstalledDic setObject:@([self isGooglemapsInstalled]) forKey:@"gugeMap"];
        [_isMapsInstalledDic setObject:@(YES) forKey:@"pingguoMap"];
    }
    
    return _isMapsInstalledDic;
}

@end
