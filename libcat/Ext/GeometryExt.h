//
//  GeometryExt.h
//  GridPaper
//
//  Created by Woo-Kyoung Noh on 12/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _not		!


#pragma mark CGPoint
BOOL CGPointIsZero(CGPoint point) ;
CGPoint CGPointOffset(CGPoint point, CGFloat x, CGFloat y) ;
CGPoint CGPointWithOffset(CGPoint point, CGPoint offset) ;
CGFloat CGPointDiffX(CGPoint from, CGPoint to) ;
CGFloat CGPointDiffY(CGPoint from, CGPoint to) ;	
#define CGPointMinusOne	CGPointMake(-1, -1)

#pragma mark CGRect
CGRect CGRectExpand(CGRect rect, CGFloat dx, CGFloat dy) ;
CGRect CGRectOriginZero(CGRect rect) ;
CGRect CGRectWithSize(CGSize size) ;
CGRect CGRectWithCenterPoint(CGPoint centerPoint, CGFloat width, CGFloat height) ;
BOOL CGRectHasPoint(CGRect rect, CGPoint point) ;

#define SFRect(rect)	NSStringFromCGRect(rect)
#define SFSize(size)	NSStringFromCGSize(size)
#define SFPoint(point)  NSStringFromCGPoint(point)
#define SFRange(range)	[NSString stringWithFormat:@"{location=%d, length=%d}", range.location, range.length]
#define VFPoint(point)	[NSValue valueWithCGPoint:point]

#define NSRangeZero (NSMakeRange(0, 0))
#define IS_NOT_FOUND(range)		(range.location == NSNotFound)
#define CGAffineTransformInverse	CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI)

#define kDegreeToRadian 0.017453292519943295769236907684886 
#define kRadianToDegree 57.295779513082320876798154814105
#define to_radian(x)	((x)*kDegreeToRadian)