//
//  LoadingHUDView.h
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

#import <UIKit/UIKit.h>

@protocol TKLoadingViewDelegate;

@interface TKLoadingView : UIView {
	UIActivityIndicatorView *_activity;
	BOOL _hidden;

	NSString *_title;
	NSString *_message;
	float radius;
	
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	
	id<TKLoadingViewDelegate> delegate;
}
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *message;
@property (assign,nonatomic) float radius;
@property (nonatomic,assign) id<TKLoadingViewDelegate> delegate;



- (id) initWithTitle:(NSString*)title message:(NSString*)message;
- (id) initWithTitle:(NSString*)title;

- (void) showWithActivityAnimating:(BOOL)animate inView:(UIView *)containerView;
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object;
- (void) stopAnimating;
-(void) setActivityAnimating:(BOOL)animate withShowMsg:(NSString *)msg;
- (void) dismissAfterDelay:(NSTimeInterval)delay animated:(BOOL)animationUse;

+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view title:(NSString *)msg activityAnimated:(BOOL)animated;
+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view point:(CGPoint)point title:(NSString *)msg activityAnimated:(BOOL)animated;
+ (BOOL)dismissTkFromView:(UIView *)view animated:(BOOL)animated afterShow:(NSTimeInterval)showTime;
+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view title:(NSString *)msg activityAnimated:(BOOL)animated duration:(NSTimeInterval)duration;
+ (TKLoadingView *)showTkloadingAddedTo:(UIView *)view point:(CGPoint)point title:(NSString *)msg activityAnimated:(BOOL)animated duration:(NSTimeInterval)duration;
@end

@protocol TKLoadingViewDelegate<NSObject>

- (void)tkLoadingViewDidDismiss:(TKLoadingView *)tkLoadingView;

@end
