miniRails
==========
###Ruby

Generally, a good way to have a better understanding of something is to take it apart and try to rebuild it.
Sure you might end up with some extra parts, not have nearly as much functionality, and will never use it for any practical purposes... but you end up feeling a wee bit smarter..


####Session Class
Provides methods to store and set cookies and the authenticity tokens for CSRF.

####URLHelper Module
Dynamically creates helper methods to generate urls.

####Router Class
Handles nested routes and sets up regular expressions to match against urls.

####Params Class
Stores passed parameters.

####HTMLHelper Module
convenience methods for creating links and buttons.

####Flash Class
Provides access to a hash that can be set on one page and retrieved on the next.
This class is used in the BaseController

####BaseController Class
Provides various render, redirect, flash and interfaces with instances of the other classes.

It uses the ERB class along with Ruby's binding class to generate rendered content. The binding allows access to all of of methods and variables of the controller instance to be used in the ERB rendering.


##Core Features
+ Controller
+ Template Rendering
+ Router
+ Storing Params and Sessions
+ render partials
+ nested Routing

##Other Stuff
+ WEBrick to simulate
+ Flash
+ CSRF
+ URL Helpers
+ link_to and button_to helpers

## Future Features
+ validations
+ has_many
