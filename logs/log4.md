## Sprint 4

Meeting|Guan Wei|Xue Yong
---|---------|----------
To-do|Implement WillPopScope to enforce certain navigation when user presses back button. Initial design for 'At a glance' widget and Explore page.|Rehaul code to support uploading of the master pdf with differing shades depending on number of users who highlighted it.  
-|Implement uploading of PDR files and downloading of master PDF files. Add functionality to view past Quiz results|Change the docker container environment. Smoother data flows within the backend.
22/06/20|Implemented WillPopScope to determine what happens when the user clicks on back button| Added logging functionality to the backend code
23/06/20|Implemented quizAttempt class that record attempts on the quiz as well as its design.|Changed existing code to support the upcoming master pdf generation.
24/06/20|Added Explore page that shows all the quizzes in repository|Fixed bugs on the server stemming from system dependencies
25/06/20|Added UI for 'At a glance' on Homepage, tested the app with different user accounts, quiz types and PDF documents|Created a html page to view messages received by the server.
26/06/20|Changed the PDF viewer to launch browser instead as default built-in PDF viewer in flutter does not render highlights in PDF|Changed the upload function to fix an issue where documents are not hashing properly.
27/06/20|Added additional document fields in 'User' collection|Deployed a newer version of the application on the server and performed unit testing.
28/06/20|Finished video as well as first draft of README for milestone 2 submission|Finished the first draft of README for milestone 2 submission

### Sprint review and retrospective

Functionalities and features are mostly runnable. Focus for next week should be more on User Experience such as data validation and error screen for the user in the case where the master PDF file is not ready for download and the user attempts to download it. 
In order to provide more value to the user, we could explore how we could make use of the fact that the user can annotate and add comments to the PDF note. One possible way the app can value-add to user experience is perhaps the user can share the annotations and comments to their friends too.
