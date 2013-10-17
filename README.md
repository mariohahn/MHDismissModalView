MHDismissModalView
==================
![alt tag](https://dl.dropboxusercontent.com/u/17911939/Dismiss.gif)

Setup
--------------------

Install MHDismissModalView with a ScrollView 

		
	  [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:self.tableView
                                                                                                                    theme:MHModalThemeWhite]];
                                                                                                                    

Install MHDismissModalView without a ScrollView 

		  [self.navigationController installMHDismissModalViewWithOptions:[[MHDismissModalViewOptions alloc] initWithScrollView:nil theme:MHModalThemeWhite]];

Global Call for all Modal Views (AppDelegate)

[[MHDismissSharedManager sharedDismissManager]installWithTheme:MHModalThemeWhite];





