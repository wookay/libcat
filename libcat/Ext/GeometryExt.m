//
//  GeometryExt.m
//  GridPaper
//
//  Created by Woo-Kyoung Noh on 12/08/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "GeometryExt.h"

#pragma mark CGPoint
BOOL CGPointIsZero(CGPoint point) {
	return CGPointEqualToPoint(CGPointZero, point);
}

CGPoint CGPointWithOffset(CGPoint point, CGPoint offset) {
	return CGPointMake(point.x + offset.x, point.y + offset.y);	
}

CGPoint CGPointOffset(CGPoint point, CGFloat x, CGFloat y) {
	return CGPointMake(point.x + x, point.y + y);
}

CGFloat CGPointDiffX(CGPoint from, CGPoint to) {
	return from.x - to.x;
}

CGFloat CGPointDiffY(CGPoint from, CGPoint to) {
	return from.y - to.y;
}

#pragma mark CGRect
BOOL CGRectHasPoint(CGRect rect, CGPoint point) {
	return true == CGRectContainsPoint(rect, point);
}

CGRect CGRectOriginZero(CGRect rect) {
	rect.origin = CGPointZero;
	return rect;
}

CGRect CGRectWithSize(CGSize size) {
	CGRect rect = CGRectZero;
	rect.size = size;
	return rect;
}
CGRect CGRectWithCenterPoint(CGPoint centerPoint, CGFloat width, CGFloat height) {
	return CGRectMake(centerPoint.x - width/2, centerPoint.y - height/2, width, height);
}

CGRect CGRectExpand(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width+dx, rect.size.height+dy);
}

CGRect CGRectBottomLeft(CGRect rect, CGFloat width, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - height, width, height);
}

CGRect CGRectTopLeft(CGRect rect, CGFloat width, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, height);
}

CGRect CGRectTopRight(CGRect rect, CGFloat width, CGFloat height) {
	return CGRectMake(rect.origin.x + rect.size.width - width, rect.origin.y, width, height);
}

CGRect CGRectForCenter(CGRect rect, CGFloat width, CGFloat height) {
	return CGRectMake(rect.origin.x + rect.size.width/2 - width/2, rect.origin.y + rect.size.height/2 - height/2, width, height);
}

CGRect CGRectForRight(CGRect rect, CGFloat width, CGFloat height) {
	return CGRectMake(rect.origin.x + rect.size.width - width, rect.origin.y + (rect.size.height - height)/2 , width, height);
}

CGRect CGRectForBottom(CGRect rect, CGFloat width, CGFloat height) {
	return CGRectMake(rect.origin.x + rect.size.width/2 - width/2, rect.origin.y + rect.size.height - height, width, height);
}

CGRect CGRectSideOffset(CGRect rect, CGFloat x, CGFloat y) {
	return CGRectMake(rect.origin.x - x, rect.origin.y - y, rect.size.width + x*2, rect.size.height + y*2);
}

CGRect CGRectWithOrigin(CGPoint point, CGFloat width, CGFloat height) {
	return CGRectMake(point.x, point.y, width, height);
}

CGRect CGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y) {
	rect.origin = CGPointMake(x, y);
	return rect;
}

CGRect CGRectSetOriginPoint(CGRect rect, CGPoint point) {
	rect.origin = point;
	return rect;
}

CGRect CGRectWithTwoPoints(CGPoint from, CGPoint to) {
	return CGRectWithOrigin(from, to.x-from.x, to.y-from.y);
}

CGRect CGRectWithScale(CGRect rect, CGFloat scale) {
	return CGRectMake(rect.origin.x * scale,
					  rect.origin.y * scale,
					  rect.size.width * scale,
					  rect.size.height * scale);
}

CGRect CGRectWithScales(CGRect rect, CGFloat widthScale, CGFloat heightScale) {
	return CGRectMake(rect.origin.x * widthScale,
					  rect.origin.y * heightScale,
					  rect.size.width * widthScale,
					  rect.size.height * heightScale);
}