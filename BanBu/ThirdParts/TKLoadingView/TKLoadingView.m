//
//  LoadingHUDView.m
//  Created by Devin Ross on 7/2/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */
#import "TKLoadingView.h"
#import "NSString+TKCategory.h"
#import "UIView+TKCategory.h"


#define WIDTH_MARGIN 15
#define HEIGHT_MARGIN 6

#define IsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsIOS5 ([[[UIDevice currentDevice] systemVersion] floatValue]>4.4)

@interface TKLoadingView (PrivateMethods)
- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode;
@end


@implementation TKLoadingView
@synthesize radius;
@synthesize delegate;

- (id) initWithTitle:(NSString*)ttl message:(NSString*)msg{
	if(self = [super initWithFrame:CGRectMake(0, 0, 280, 180)]){
		
		radius = 6.0;
		_title = [ttl copy];
		_message = [msg copy];
		_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:IsIOS5?UIActivityIndicatorViewStyleWhite:UIActivityIndicatorViewStyleWhiteLarge];
		_activity.frame = CGRectMake(self.bounds.size.width/2-15, 10, 24, 24);
		[self addSubview:_activity];
		_hidden = YES;
		self.backgroundColor = [UIColor clearColor];
		
	}
	return self;
}
- (id) initWithTitle:(NSString*)ttl{
    if(self = [self initWithTitle:ttl message:nil])
        return self;
    else
        return nil;
}

- (void) drawRect:(CGRect)rect {
	
	if(_hidden) return;
	int width, rWidth, rHeight, x;
	
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:15];
	UIFont *messageFont = [UIFont boldSystemFontOfSize:12];
	
	CGSize s1 = [self calculateHeightOfTextFromWidth:_title font:titleFont width:200 linebreak:UILineBreakModeTailTruncation];
	CGSize s2 = [self calculateHeightOfTextFromWidth:_message font:messageFont width:200 linebreak:UILineBreakModeCharacterWrap];
	
	if([_title length] < 1) s1.height = 0;
	if([_message length] < 1) s2.height = 0;
	
	
	rHeight = (s1.height + s2.height + (HEIGHT_MARGIN*2) + 10 + ([_activity isAnimating]?_activity.frame.size.height:0));
	rWidth = width = (s2.width > s1.width) ? (int) s2.width : (int) s1.width;
	rWidth += WIDTH_MARGIN * 2;
	x = (280 - rWidth) / 2;
	
	if([_activity isAnimating])
	_activity.center = CGPointMake(280/2,HEIGHT_MARGIN + _activity.frame.size.height/2);
	
	
//	NSLog(@"DRAW RECT %d %f",rHeight,self.frame.size.height);
	
	// DRAW ROUNDED RECTANGLE
	[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] set];
	CGRect r = CGRectMake(x, 0, rWidth,rHeight);
	[UIView drawRoundRectangleInRect:r 
						  withRadius:radius 
							   color:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	
	
	// DRAW FIRST TEXT
	[[UIColor whiteColor] set];
	r = CGRectMake(x+WIDTH_MARGIN,([_activity isAnimating]?_activity.frame.size.height:0) + 3 + HEIGHT_MARGIN, width, s1.height);
	CGSize s = [_title drawInRect:r withFont:titleFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	
	
	// DRAW SECOND TEXT
	r.origin.y += s.height;
	r.size.height = s2.height;
	[_message drawInRect:r withFont:messageFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
	
	
}


- (void) setTitle:(NSString*)str{
	[_title release];
	_title = [str copy];
	//[self updateHeight];
	[self setNeedsDisplay];
}
- (NSString*) title{
	return _title;
}

- (void) setMessage:(NSString*)str{
	[_message release];
	_message = [str copy];
	[self setNeedsDisplay];
}
- (NSString*) message{
	return _message;
}

- (void) setRadius:(float)f{
	if(f==radius) return;
	
	radius = f;
	[self setNeedsDisplay];
	
}



+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view title:(NSString *)msg activityAnimated:(BOOL)animated {
	
	for (TKLoadingView *loading in [view subviews]) {
		if ([loading isKindOfClass:[TKLoadingView class]]) 
			[loading removeFromSuperview];
		}
	
	
	TKLoadingView *tk = [[TKLoadingView alloc] initWithTitle:msg];
	[tk showWithActivityAnimating:animated inView:view];
	return [tk autorelease];
}
+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view point:(CGPoint)point title:(NSString *)msg activityAnimated:(BOOL)animated{
    
    
    for (TKLoadingView *loading in [view subviews]) {
		if ([loading isKindOfClass:[TKLoadingView class]])
			[loading removeFromSuperview];
    }
	
	
	TKLoadingView *tk = [[TKLoadingView alloc] initWithTitle:msg];
	[tk showWithActivityAnimating:animated inView:view];
    CGRect rect = tk.frame;
    rect.origin.x = 20;
    rect.origin.y = point.y;
    tk.frame = rect;
    return [tk autorelease];
}
+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view point:(CGPoint)point title:(NSString *)msg activityAnimated:(BOOL)animated duration:(NSTimeInterval)duration{

    
    for (TKLoadingView *loading in [view subviews]) {
		if ([loading isKindOfClass:[TKLoadingView class]])
			[loading removeFromSuperview];
    }
	
	
	TKLoadingView *tk = [[TKLoadingView alloc] initWithTitle:msg];
	[tk showWithActivityAnimating:animated inView:view];
    [tk dismissAfterDelay:duration animated:YES];
    CGRect rect = tk.frame;
    rect.origin.x = 20;
    rect.origin.y = point.y;
    tk.frame = rect;
    return [tk autorelease];
}

+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view title:(NSString *)msg activityAnimated:(BOOL)animated duration:(NSTimeInterval)duration
{
    for (TKLoadingView *loading in [view subviews]) {
		if ([loading isKindOfClass:[TKLoadingView class]]) 
			[loading removeFromSuperview];
    }
	
	TKLoadingView *tk = [[TKLoadingView alloc] initWithTitle:msg];
	[tk showWithActivityAnimating:animated inView:view];
    [tk dismissAfterDelay:duration animated:YES];
	return [tk autorelease];
    
}

+ (BOOL)dismissTkFromView:(UIView *)view animated:(BOOL)animated afterShow:(NSTimeInterval)showTime{
	
	TKLoadingView *tk = nil;
	for (TKLoadingView *loading in [view subviews]) {
		if ([loading isKindOfClass:[TKLoadingView class]]) {
			tk = loading;
		}
	}
	if (tk != nil) {
		[tk dismissAfterDelay:showTime animated:YES];
		return YES;
	} else {
		return NO;
	}
}

- (void) showWithActivityAnimating:(BOOL)animate inView:(UIView *)containerView{
	if(!_hidden) return;
	_hidden = NO;
	if(animate)
		[_activity startAnimating];
	
	if(containerView)
	{
		
		if(!IsIPad)
			[self setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2 )];
		else 
			[self setCenter:CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2-20)];
		[containerView addSubview:self];
	}
	
	
	/*self.alpha = 0.2;
	
	// start a little smaller
	self.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
	// animate to a bigger size
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(popAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.20f];
	self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	self.alpha = 1.0;
	[UIView commitAnimations];*/
	
	
	[self setNeedsDisplay];
	
}




- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object {
	
    methodForExecution = method;
    targetForExecution = [target retain];
    objectForExecution = [object retain];
	
    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	
}

- (void)launchExecution {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    // Start executing the requested task
    [targetForExecution performSelector:methodForExecution withObject:objectForExecution];
	
    // Task completed, update view in main thread (note: view operations should
    // be done only in the main thread)
    [self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	
    [pool release];
}
- (void)cleanUp {
	
    [targetForExecution release];
    [objectForExecution release];
	
    [self dismissAfterDelay:0.0 animated:YES];
}





- (void)popAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // at the end set to normal size
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15f];
	self.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void) stopAnimating{
	if(_hidden) return;
	_hidden = YES;
	[self setNeedsDisplay];
	if([_activity isAnimating])
		[_activity stopAnimating];
	
}

-(void)setActivityAnimating:(BOOL)animate withShowMsg:(NSString *)msg;
{
	if(animate)
		[_activity startAnimating];
	else 
		[_activity stopAnimating];
	[self setTitle:msg];
	[self setNeedsDisplay];
}


- (void) dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animationUse
{
	[self performSelector:@selector(finalDismissWithAnimated:) withObject:[NSNumber numberWithBool:animationUse] afterDelay:delay];
}

-(void)finalDismissWithAnimated:(NSNumber *)animated
{
	

	if ([animated boolValue]) {
		CGRect frame = self.frame;
		frame.origin.y += 10.0;
		
		[UIView beginAnimations:nil context:nil];
		self.alpha = 0.0;
		self.frame = frame;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dismiss)];
		[UIView commitAnimations];
	}
	else {
		[self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
	}
	
	
}

-(void)dismiss{

	[self removeFromSuperview];
	if(delegate&&[delegate respondsToSelector:@selector(tkLoadingViewDidDismiss:)])
			[delegate tkLoadingViewDidDismiss:self];
	
}



- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont 
			constrainedToSize:CGSizeMake(width, FLT_MAX) 
				lineBreakMode:lineBreakMode];
}
- (void) adjustHeight{
	
	CGSize s1 = [_title heightWithFont:[UIFont boldSystemFontOfSize:16.0] 
								 width:200.0 
							 linebreak:UILineBreakModeTailTruncation];
	
	CGSize s2 = [_message heightWithFont:[UIFont systemFontOfSize:12.0] 
								   width:200.0 
							   linebreak:UILineBreakModeCharacterWrap];

	CGRect r = self.frame;
	r.size.height = s1.height + s2.height + 20;
	self.frame = r;
}


- (void) dealloc{
	[_activity release];
	[_title release];
	[_message release];
	[super dealloc];
}

@end