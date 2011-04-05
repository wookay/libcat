//
//  GeometryExt.h
//  GridPaper
//
//  Created by Woo-Kyoung Noh on 12/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//


#define _not		!


#pragma mark CGPoint
BOOL CGPointIsZero(CGPoint point) ;
CGPoint CGPointOffset(CGPoint point, CGFloat x, CGFloat y) ;
CGPoint CGPointWithOffset(CGPoint point, CGPoint offset) ;
CGPoint CGPointsDiff(CGPoint from, CGPoint to) ;
CGFloat CGPointsDistance(CGPoint from, CGPoint to) ;
CGPoint CGPointWithScale(CGPoint point, CGFloat scale) ;
CGPoint CGPointDivideByScale(CGPoint point, CGFloat scale) ;
CGPoint CGPointDivideByScaleWithFloorDown(CGPoint point, CGFloat scale) ;
#define CGPointMinusOne		CGPointMake(-1, -1)
#define CGPointIsMinusOne(point)	CGPointEqualToPoint(point, CGPointMinusOne)

#pragma mark CGRect
BOOL CGRectHasPoint(CGRect rect, CGPoint point) ;
CGRect CGRectOriginZero(CGRect rect) ;
CGRect CGRectWithSize(CGSize size) ;
CGRect CGRectWithCenterPoint(CGPoint centerPoint, CGFloat width, CGFloat height) ;
CGRect CGRectExpand(CGRect rect, CGFloat dx, CGFloat dy) ;
CGRect CGRectBottomLeft(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectBottomRight(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectTopLeft(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectTopRight(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectForCenter(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectForRight(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectForTop(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectForBottom(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectAfterBottom(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectAfterBottomLeft(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectAfterBottomRight(CGRect rect, CGFloat width, CGFloat height) ;
CGRect CGRectSideOffset(CGRect rect, CGFloat x, CGFloat y) ;
CGRect CGRectWithOrigin(CGPoint point, CGFloat width, CGFloat height) ;
CGRect CGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y) ;
CGRect CGRectSetOriginPoint(CGRect rect, CGPoint point) ;	
CGRect CGRectWithTwoPoints(CGPoint from, CGPoint to) ;
CGRect CGRectWithScale(CGRect rect, CGFloat scale) ;
CGRect CGRectWithScales(CGRect rect, CGFloat widthScale, CGFloat heightScale) ;
CGRect CGRectForString(NSString* str) ;

CGSize CGSizeTranspose(CGSize size) ;
CGSize CGSizeExpand(CGSize size, CGFloat dx, CGFloat dy) ;

#import <QuartzCore/QuartzCore.h>
NSString* NSStringFromCATransform3D(CATransform3D transform3D) ;

#define SFRect(rect)	NSStringFromCGRect(rect)
#define SFSize(size)	NSStringFromCGSize(size)
#define SFPoint(point)  NSStringFromCGPoint(point)
#define SFAffineTransform(transform)	NSStringFromCGAffineTransform(transform)
#define SFTransform3D(transform3D)		NSStringFromCATransform3D(transform3D)

#define SFRange(range)	[NSString stringWithFormat:@"{location=%d, length=%d}", range.location, range.length]
#define VFPoint(point)	[NSValue valueWithCGPoint:point]
#define VFRect(rect)	[NSValue valueWithCGRect:rect]

#define NSRangeZero (NSMakeRange(0, 0))
#define IS_NOT_FOUND(range)		(range.location == NSNotFound)
#define CGAffineTransformInverse	CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI)

#define kDegreeToRadian 0.017453292519943295769236907684886 
#define kRadianToDegree 57.295779513082320876798154814105
#define degree_to_radian(degree)	((degree)*kDegreeToRadian)
#define radian_to_degree(radian)	((radian)*kRadianToDegree)