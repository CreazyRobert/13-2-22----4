


#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView


@synthesize titleLabel=_titleLabel, disclosureButton=_disclosureButton, delegate=_delegate, section=_section;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
//        self.backgroundColor =[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];

        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];

        _delegate = delegate;        
        self.userInteractionEnabled = YES;
        
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 15.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        _titleLabel = label;
        
        
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( 280, 5.0, 35.0, 35.0);
//        [button setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateSelected];
//        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor clearColor];
        [self addSubview:button];
        _disclosureButton = button;

        
        
        UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        aLabel.backgroundColor=[UIColor blackColor];
        [self addSubview:aLabel];
        [aLabel release];
        UILabel *aLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, 320, 1)];
        aLabel1.backgroundColor=[UIColor blackColor];

        [self addSubview:aLabel1];
        [aLabel1 release];

        
        // Set the colors for the gradient layer.
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
//            color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
//            [colors addObject:(id)[color CGColor]];

            color =[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color =[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color =[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
   
        
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
    }
    
    return self;
}


-(void)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}




@end
