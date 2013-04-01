//
//  BNPieChart.m
//  Survey
//
//  Created by Tyler Neylon on 10/1/09.
//  Copyright 2009 Bynomial.
//

#import "BNPieChart.h"

#import "BNColor.h"

// This determines the distance between the pie chart and the labels,
// or the frame, if no labels are present.
// Examples: if this is 1.0, then they are flush, if it's 0.5, then
// the pie chart only goes halfway from the center point to the nearest
// label or edge of the frame.
#define kRadiusPortion 0.92

#define nFloat(x) [NSNumber numberWithFloat:x]

// Declare private methods.
@interface BNPieChart ()

- (void)initInstance;
- (void)drawSlice:(int)index inContext:(CGContextRef)context;
- (CGGradientRef)newGradientForIndex:(int)index;
- (void)addLabelForLastName;
- (void)getRGBForIndex:(int)index red:(float *)red green:(float *)green blue:(float *)blue;
- (float)approxDistFromCenter:(CGRect)rect;
- (void)moveInLabel:(int)index;
- (void)movePreviousLabelsIn;
- (float)pointAtIndex:(int)index;

@end



@implementation BNPieChart

@synthesize slicePortions, colors;

+ (BNPieChart *)pieChartSampleWithFrame:(CGRect)frame {
	BNPieChart *chart = [[[BNPieChart alloc]
                        initWithFrame:frame] autorelease];
	[chart addSlicePortion:0.1 withName:@"Orange"];
	[chart addSlicePortion:0.2 withName:@"Fandango"];
	[chart addSlicePortion:0.1 withName:@"Blue"];
	[chart addSlicePortion:0.1 withName:@"Cerulean"];
	[chart addSlicePortion:0.3 withName:@"Green"];
	[chart addSlicePortion:0.1 withName:@"Yellow"];
	[chart addSlicePortion:0.1 withName:@"Pink"];
	return chart;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initInstance];
    self.frame = frame;    
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self initInstance];
  }
  return self;
}

- (void)dealloc {
	[slicePortions release];
	[slicePointsIn01 release];
	[sliceNames release];
	[nameLabels release];
	CFRelease(colorspace);
  self.colors = nil;
  [super dealloc];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  
  fontSize = frame.size.width / 20;
  if (fontSize < 9) fontSize = 9;
  
  // Compute the center & radius of the circle.
  centerX = frame.size.width / 2.0;
  centerY = frame.size.height / 2.0;
  radius = centerX < centerY ? centerX : centerY;
  radius *= kRadiusPortion;
  [self setNeedsDisplay];
}

- (void)addSlicePortion:(float)slicePortion withName:(NSString *)name {
	[sliceNames addObject:(name ? name : @"")];
  [slicePortions addObject:nFloat(slicePortion)];
	float sumSoFar = [self pointAtIndex:-1];
	[slicePointsIn01 addObject:nFloat(sumSoFar + slicePortion)];
	[self addLabelForLastName];
}

- (void)drawRect:(CGRect)rect {
	if ([slicePortions count] == 0) {
		NSLog(@"%s -- called with no slicePortions data", __FUNCTION__);
		return;
	}
		
	// Draw a white background for the pie chart.
	// We need to do this since many of our color components have alpha < 1.
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextAddArc(context, centerX, centerY, radius, 0, 2*M_PI, 1);
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillPath(context);
  
  CGContextSaveGState(context);
  float shadowSize = radius / 15.0;
	CGContextSetShadow(context, CGSizeMake(shadowSize, shadowSize), shadowSize);
  CGContextBeginTransparencyLayer(context, NULL);
  for (int i = 0; i < [slicePortions count]; ++i) {
    [self drawSlice:i inContext:context];
  }
  CGContextEndTransparencyLayer(context);
  CGContextRestoreGState(context);
	
	// Draw the glare.
	CGContextBeginPath(context);
	CGContextAddArc(context, centerX, centerY, radius, 0, 2*M_PI, 1);
	CGContextClip(context);
	CGContextBeginPath(context);
	CGContextAddArc(context, centerX - radius * 0.5, centerY - radius * 0.5,
					radius * 1.1, 0, 2*M_PI, 1);
	CGContextClip(context);
	
	// Set up the gradient for the glare.
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0, 1.0};
	CGFloat components[8] = {1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.45};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components,
																 locations, num_locations);
	CGContextDrawLinearGradient(context, gradient,
								CGPointMake(centerX + radius * 0.6, centerY + radius * 0.6),
								CGPointMake(centerX - radius, centerY - radius), 0);
	CGGradientRelease(gradient);
}


#pragma mark private methods

- (void)initInstance {
  // Initialization code
  self.backgroundColor = [UIColor clearColor];
  self.opaque = NO;
  self.slicePortions = [NSMutableArray new];
  slicePointsIn01 = [[NSMutableArray alloc]
                     initWithObjects:nFloat(0.0), nil];
  sliceNames = [NSMutableArray new];
  nameLabels = [NSMutableArray new];
  colorspace = CGColorSpaceCreateDeviceRGB();    
}

- (void)drawSlice:(int)index inContext:(CGContextRef)context {
	CGFloat startAngle = 2 * M_PI * [self pointAtIndex:index];
	CGFloat endAngle = 2 * M_PI * [self pointAtIndex:(index + 1)];
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddArc(path, NULL, centerX, centerY, radius, startAngle, endAngle, 0);
	CGPathAddLineToPoint(path, NULL, centerX, centerY);
	CGPathCloseSubpath(path);
	
	// Draw the shadowed slice.
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGFloat red, green, blue;
	[self getRGBForIndex:index red:&red green:&green blue:&blue];
	CGContextSetRGBFillColor(context, red, green, blue, 0.35);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	// Draw the left-right gradient.
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextClip(context);
	CGGradientRef gradient = [self newGradientForIndex:index];
	CGContextDrawLinearGradient(context, gradient,
                              CGPointMake(centerX + radius, centerY),
                              CGPointMake(centerX - radius, centerY), 0);
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
	// Draw the slice outline.
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextClip(context);
	CGContextAddPath(context, path);
	CGContextSetLineWidth(context, 0.5);
	UIColor* darken = [UIColor colorWithWhite:0.0 alpha:0.2];
	CGContextSetStrokeColorWithColor(context, darken.CGColor);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
	
	CGPathRelease(path);
}

- (CGGradientRef)newGradientForIndex:(int)index {
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0, 1.0};
	CGFloat red, green, blue;
	[self getRGBForIndex:index red:&red green:&green blue:&blue];
	CGFloat components[8] = {red, green, blue, 0.9,
    sqrt(red), sqrt(green), sqrt(blue), 0.15};
	return CGGradientCreateWithColorComponents(colorspace, components,
                                             locations, num_locations);
}

- (void)addLabelForLastName {	
  if ([[sliceNames lastObject] length] == 0) {
		[nameLabels addObject:[NSNull null]];
		return;
	}
		
	NSString* text = [sliceNames lastObject];
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]];

	// Find the angle of the relevant corners.
	float cornerDist[2] = {
		(self.frame.size.width - textSize.width) / 2,
		(self.frame.size.height - textSize.height) / 2};
	float cornerAngles[4];
	cornerAngles[0] = atan2(cornerDist[1], cornerDist[0]);
	cornerAngles[1] = M_PI - cornerAngles[0];
	cornerAngles[2] = cornerAngles[0] + M_PI;
	cornerAngles[3] = cornerAngles[1] + M_PI;
		
	// Find out which wall the center ray will hit.
	int index = [slicePortions count] - 1;
	float rayAngle = ([self pointAtIndex:index] +
					  [self pointAtIndex:(index + 1)]) * M_PI;
	int i;
	for (i = 0; i < 4 && rayAngle > cornerAngles[i]; ++i);
	i = i % 4;  // i might end up as 4 out of the loop
	
	// Find the hit point.  This is the point where the ray hits the frame, inset
	// by half of textSize.  It's the farthest away we can put the center of the
	// text while keeping it within frame and along the ray central to this slice.
	float hitPoint[2];
	float dist = (i % 2 == 0 ? cornerDist[0] : cornerDist[1]);
	if (i > 1) dist *= -1;
	hitPoint[i % 2] = dist;
	float delta[2] = {cos(rayAngle), sin(rayAngle)};
	float t = dist / delta[i % 2];
	hitPoint[1 - (i % 2)] = t * delta[1 - (i % 2)];
	
	int hitOriginX = hitPoint[0] + centerX - textSize.width / 2;
	int hitOriginY = hitPoint[1] + centerY - textSize.height / 2;
	
	// Set up the UILabel for this text.
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(hitOriginX, hitOriginY,
															   textSize.width, textSize.height)];
	label.font = [UIFont boldSystemFontOfSize:fontSize];
	label.text = text;
	CGFloat red, green, blue;
	[self getRGBForIndex:index red:&red green:&green blue:&blue];
  float darkenFactor = 0.87;  // Closer to 0 = closer to black.
  red *= darkenFactor;
  green *= darkenFactor;
  blue *= darkenFactor;
	label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
	label.backgroundColor = [UIColor clearColor];
	[nameLabels addObject:label];
	[self addSubview:label];
	[label release];
	
	// Reposition the labels and/or resize the radius as needed to fit.
	float labelDist = [self approxDistFromCenter:label.frame];
	if (labelDist < radius / kRadiusPortion) {
		radius = labelDist * kRadiusPortion;
		[self movePreviousLabelsIn];
	} else {
		[self moveInLabel:index];
	}
}

- (void)getRGBForIndex:(int)index red:(float *)red green:(float *)green blue:(float *)blue {
  if (colors) {
    BNColor *color = [colors objectAtIndex:(index % [colors count])];
    *red = color.red;
    *green = color.green;
    *blue = color.blue;
    return;
  }
  int i = 6 - index;
	*red = 0.5 + 0.5 * cos(i);
	*green = 0.5 + 0.5 * sin(i);
	*blue = 0.5 + 0.5 * cos(1.5 * i + M_PI / 4.0);	
}

float dist(float x1, float y1, float x2, float y2) {
	return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}

- (float)approxDistFromCenter:(CGRect)rect {
	float x = rect.origin.x;
	float y = rect.origin.y;
	float distance = dist(x, y, centerX, centerY);
	x += rect.size.width;
	float d = dist(x, y, centerX, centerY);
	if (d < distance) distance = d;
	y += rect.size.height;
	d = dist(x, y, centerX, centerY);
	if (d < distance) distance = d;
	x -= rect.size.width;
	d = dist(x, y, centerX, centerY);
	if (d < distance) distance = d;
	return distance;
}

- (void)moveInLabel:(int)index {
	float outerRadius = radius / kRadiusPortion;
	UILabel* label = [nameLabels objectAtIndex:index];
	float distance = [self approxDistFromCenter:label.frame];
	float excessDist = distance - outerRadius;
	if (excessDist < 5.0) return;
	float rayAngle = ([self pointAtIndex:index] +
					  [self pointAtIndex:(index + 1)]) * M_PI;
	label.frame = CGRectOffset(label.frame,
							   (int)(-cos(rayAngle) * excessDist),
							   (int)(-sin(rayAngle) * excessDist));	
}

- (void)movePreviousLabelsIn {
	for (int index = 0; index < [slicePortions count] - 1; ++index) {
		[self moveInLabel:index];
	}
}

- (float)pointAtIndex:(int)index {
	index = (index + [slicePointsIn01 count]) % [slicePointsIn01 count];
	return [(NSNumber*)[slicePointsIn01 objectAtIndex:index] floatValue];
}

@end
