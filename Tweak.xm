@interface BrowserToolbar : UIToolbar
-(void)newTab;
@end

@interface TabController : NSObject
-(void)_newTabFromTabViewButton;
- (id)initWithBrowserController:(id)arg1;
@end

NSMutableArray<UIBarButtonItem *> *itemsArray;

%hook TabController
// None of the various init methods were being called for this class for some reason, so decided to use this
- (id)_currentTabs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_newTabFromTabViewButton) name:@"openNewTabFromCustomNewTabButton" object:nil];
    });
	return %orig;
}
-(void)_newTabFromTabViewButton {
	// NSLog(@"_newTabFromTabViewButton");
	%orig;
}
-(void)dealloc {
	%orig;
	// Is this how you do it????
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

%end

%hook BrowserToolbar
-(void)setItems:(id)toolbarItems {

	itemsArray = [toolbarItems mutableCopy];

	UIBarButtonItem *addTabButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTab)];
	[itemsArray insertObject:addTabButton atIndex:3];

	%orig(itemsArray);
}
%new
-(void)newTab {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"openNewTabFromCustomNewTabButton" object:self];
}
%end
