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

CGRect CGRectExpand(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width+dx, rect.size.height+dy);
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