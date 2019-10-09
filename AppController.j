@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@implementation SlotView : CPView
{
    CPView itemView;
    id delegate @accessors;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 48, 48)];
    if (self)
    {
        _DOMElement.style.background = "#333";
        _DOMElement.style.border = "1px solid #000000";
        _DOMElement.style.borderRadius = "6px";
        _DOMElement.style.boxShadow = "inset 2px 2px 2px rgba(0, 0, 0, 0.4), inset -2px -2px 2px rgba(255, 255, 255, 0.4)";

        [self registerForDraggedTypes:["InventoryDragType"]];

        itemView = nil;
    }
    return self;
}

- (void)mouseDragged:(CPEvent)anEvent
{
    if (itemView == nil)
    {
        return;
    }
    
    [[CPPasteboard pasteboardWithName:CPDragPboard] declareTypes:["InventoryDragType"] owner:self];

    // there's also a dragImage:... method. See the CPView documentation for details.
    [self dragView:itemView
        at:CGPointMake(0, 0)
        offset:CGSizeMakeZero()
        event:anEvent
        pasteboard:nil
        source:self
        slideBack:YES];
}

- (void)pasteboard:(CPPasteboard)aPasteboard provideDataForType:(CPString)aType
{
    if (aType == "InventoryDragType")
    {
        var myData = [CPKeyedArchiver archivedDataWithRootObject: itemView];
        [aPasteboard setData:myData forType:aType];

        if ([delegate respondsToSelector:@selector(isInfiniteSource:)] &&
            [delegate isInfiniteSource:itemView])
        {
        }
        else
        {
            [self unsetItemView];
        }
    }
}

- (void)performDragOperation:(CPDraggingInfo)aSender
{
    var data = [[aSender draggingPasteboard] dataForType:"InventoryDragType"];
    var view = [CPKeyedUnarchiver unarchiveObjectWithData: data];

    [self setItemView:view];
    _DOMElement.style.background = "#333";

    if ([delegate respondsToSelector:@selector(receivedDragWithView:from:)])
    {
        [delegate receivedDragWithView:view from:self];
    }
}

- (void)concludeDragOperation:(id)sender
{
}

- (void)draggingEntered:(CPDraggingInfo)aSender
{
    _DOMElement.style.background = "#0f0";
}

- (void)draggingExited:(CPDraggingInfo)aSender
{
    _DOMElement.style.background = "#333";
}

- (void)draggedView:(CPImage)aView endedAt:(CGPoint)aLocation operation:(CPDragOperation)anOperation
{
    if (anOperation == CPDragOperationNone)
    {
        [self setItemView:itemView];
        _DOMElement.style.background = "#333";
        if ([delegate respondsToSelector:@selector(dragJumpedBack:)])
        {
            [delegate dragJumpedBack:self];
        }
    }
    else
    {
        if ([delegate respondsToSelector:@selector(isInfiniteSource:)] &&
            [delegate isInfiniteSource:itemView])
        {
            [self setItemView:itemView];
        }
    }
}

- (void)setItemView:(CPView)aView
{
    if (itemView)
    {
        [self unsetItemView];
    }
    itemView = aView;
    [itemView setFrameOrigin:CGPointMake(0, 0)];
    [self addSubview:itemView];
}

- (void)unsetItemView
{
    [itemView removeFromSuperview];
    itemView = nil;
}

- (CPView)itemView
{
    return itemView;
}

@end

@implementation ItemView : CPView

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
    _DOMElement.style.background = "#666";
    _DOMElement.style.border = "1px solid #000000";
    _DOMElement.style.borderRadius = "6px";
    _DOMElement.style.boxShadow = "inset 2px 2px 2px rgba(255, 255, 255, 0.4), inset -2px -2px 2px rgba(0, 0, 0, 0.4)";
}

@end


@implementation SlotViewController : CPObject

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)receivedDragWithView:(CPView)itemView from:(SlotView)aSlotView
{
    console.log("received drag with", itemView);
}

- (void)dragJumpedBack:(SlotView)aSlotView
{
    console.log("drag jumped back");
}

- (void)isInfiniteSource:(id)sender
{
    return YES;
}

@end

@implementation MyWindow : CPWindow

- (id)init
{
    self = [self initWithContentRect:CGRectMake(50.0, 50.0, 300.0, 300.0)
                           styleMask:CPHUDBackgroundWindowMask |
                                     CPClosableWindowMask |
                                     CPResizableWindowMask];

    if (self)
    {
        [self setTitle:"Window"];
        var contentView = [self contentView];

        var iv = [[ItemView alloc] init];

        var rows = 5;
        var columns = 5;

        for(var x = 0; x < rows; x++)
        for(var y = 0; y < columns; y++)
        {
            var sv = [[SlotView alloc] init];
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

    var window = [[MyWindow alloc] init];
    [window orderFront:self];
    
    var window = [[MyWindow alloc] init];
    [window orderFront:self];
}

@end
