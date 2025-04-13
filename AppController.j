@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import <Chino/KCSlotView.j>

@implementation ItemView : KCStyledView

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 48, 48)];
    if (self)
    {
        [self stylize];
    }
    return self;
}

- (id)initWithCoder:(CPCoder)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self stylize];
    }
    return self;
}

- (id)stylize
{
    
    [self setBackgroundColor:[CPColor grayColor]];
    [self setStyleRounded];
    [self setStyleEmbossed];
}

@end


@implementation SlotViewController : CPObject
{
    BOOL infiniteSource @accessors;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setInfiniteSource: NO];
    }
    return self;
}

- (void)receivedDragWithView:(CPView)itemView from:(SlotView)aSlotView
{
    CPLog.info("received drag with", itemView);
}

- (void)dragJumpedBack:(SlotView)aSlotView
{
    CPLog.info("drag jumped back");
}

- (BOOL)isInfiniteSource:(id)sender
{
    return [self infiniteSource];
}

@end


@implementation SlotWindow : CPWindow

- (id)initWithRows:(int)rowNum andColumns:(int)colNum
{
    self = [self initWithContentRect:CGRectMake(50.0, 50.0, rowNum * 52 + 20, colNum * 52 + 20)
                           styleMask:CPHUDBackgroundWindowMask |
                                     CPClosableWindowMask |
                                     CPResizableWindowMask];

    if (self)
    {
        [self setTitle:"SlotWindow"];
        var contentView = [self contentView];

        var iv = [[ItemView alloc] init];


        for(var x = 0; x < rowNum; x++)
        for(var y = 0; y < colNum; y++)
        {
            var sv = [[KCSlotView alloc] init];
            [sv setFrameOrigin: CGPointMake(10 + x * 52, 10 + y * 52)];

            var svc = [[SlotViewController alloc] init];
            [sv setDelegate: svc];
            [contentView addSubview: sv];
        }
        [sv setItemView: iv];
    }
    return self;
}

@end

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [theWindow orderFront:self];

    var window = [[SlotWindow alloc] initWithRows:5 andColumns:5];
    [window orderFront:self];
    
    var window = [[SlotWindow alloc] initWithRows:7 andColumns:7];
    [window orderFront:self];
}

@end
