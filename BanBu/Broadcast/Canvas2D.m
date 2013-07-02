//
//  Canvas2D.m
//  兔丫丫
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Canvas2D.h"

@implementation Canvas2D
@synthesize arrayStrokes,sizeValue,lineColor,tempArray;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrayStrokes=[NSMutableArray array];
        self.tempArray=[NSMutableArray array];
        self.lineColor=[UIColor blackColor];
        self.sizeValue=[NSNumber numberWithInt:5];
      
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

//    CGContextRef context = UIGraphicsGetCurrentContext(); 
//    CGContextSetLineWidth(context, 2.0);//画笔粗细
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB(); 
//    CGFloat components[] = { 1.0, 1.0, 1.0, 1.0}; 
//    CGColorRef color = CGColorCreate(colorspace, components); 
//    CGContextSetStrokeColorWithColor(context, color);//画笔颜色
//    CGContextMoveToPoint(context, 0, 0); 
//    CGContextAddLineToPoint(context, 300, 400); 
//    CGContextStrokePath(context); 
//    CGColorSpaceRelease(colorspace); 
//    CGColorRelease(color); 
    if (self.arrayStrokes){ 
        int arraynum = 0; 
        // each iteration draw a stroke 
        // line segments within a single stroke (path) has the same color and line width 
        for (NSDictionary *dictStroke in self.arrayStrokes) { 
            NSArray *arrayPointsInstroke = [dictStroke objectForKey:@"points"]; 
            UIColor *color = [dictStroke objectForKey:@"color"]; 
            float size = [[dictStroke objectForKey:@"size"] floatValue]; 
            [color set]; // equivalent to both setFill and setStroke 
            //if用来判断是否画点
            if([arrayPointsInstroke count] == 1){
                CGPoint pointStart = CGPointFromString([arrayPointsInstroke objectAtIndex:0]); 
                CGContextRef contextRef = UIGraphicsGetCurrentContext();
                CGContextSetLineWidth(contextRef, size);
                CGContextSetFillColorWithColor(contextRef, color.CGColor);
                CGContextFillEllipseInRect(contextRef, CGRectMake(pointStart.x-size/2, pointStart.y-size/2, size, size));
                CGContextStrokePath(contextRef);
            }
            // draw the stroke, line by line, with rounded joints 
            UIBezierPath* pathLines = [UIBezierPath bezierPath]; 
            CGPoint pointStart = CGPointFromString([arrayPointsInstroke objectAtIndex:0]); 
            [pathLines moveToPoint:pointStart]; 
            for (int i = 0; i < (arrayPointsInstroke.count - 1); i++) 
            { 
                CGPoint pointNext = CGPointFromString([arrayPointsInstroke objectAtIndex:i+1]); 
                [pathLines addLineToPoint:pointNext]; 
            } 
            pathLines.lineWidth = size; 
            pathLines.lineJoinStyle = kCGLineJoinRound; 
            pathLines.lineCapStyle = kCGLineCapRound; 
            [pathLines stroke]; 
            arraynum++; 
        } 
    } 
   
}

// Start new dictionary for each touch, with points and color 
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event 
{ 
    NSMutableArray *arrayPointsInStroke = [NSMutableArray array]; 
    NSMutableDictionary *dictStroke = [NSMutableDictionary dictionary]; 
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"]; 
    [dictStroke setObject:self.lineColor forKey:@"color"]; 
    [dictStroke setObject:self.sizeValue forKey:@"size"];
    
    CGPoint point = [[touches anyObject] locationInView:self]; 
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)]; 
    [self.arrayStrokes addObject:dictStroke]; 
} 

// Add each point to points array 
- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event 
{ 
    CGPoint point = [[touches anyObject] locationInView:self]; 
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self]; 
    NSMutableArray *arrayPointsInStroke = [[self.arrayStrokes lastObject] objectForKey:@"points"]; 
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)]; 
    CGRect rectToRedraw = CGRectMake(
                                     ((prevPoint.x>point.x)?point.x:prevPoint.x)-35, 
                                     ((prevPoint.y>point.y)?point.y:prevPoint.y)-35, 
                                     fabs(point.x-prevPoint.x)+30*5, 
                                     fabs(point.y-prevPoint.y)+30*5 
                                     ); //????????????????改变值后线条好看了
    [self setNeedsDisplayInRect:rectToRedraw];
    
    //清空撤销数组内容
    [tempArray removeAllObjects];
} 

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setNeedsDisplay];
}

- (void)dealloc 
{ 
    [arrayStrokes release]; 
    [super dealloc]; 
} 





















@end
