## Sprint 6

Meeting|Guan Wei|Xue Yong
---|---------|----------
To-do|Redesign firestore database to support sharing of quizzes, push notifications and centralise master PDF based on module instead of quiz. Add ratings, viewing of master and viewing of user PDF.|Optimise User App experience through integrating more backend functions
06/07/20|Finalised class of the various objects such as Quiz and PDFs.|Created poll notifications for user quiz reminders.
07/07/20|Added 2 additional collections at root level; masterPDFMods and Reminders|Changed app engine scripts to support firestore changes to accomodate for changes in the app.
08/07/20|Refactored and added new functions to DataRepo class to support the retriving and writing of data to collections with several layers.|Fixed bugs returning errors in certain situation in the backend.
09/07/20|Added function to view all Master PDfs in a module and its UI|Picked up the relevant technology stacks for cloud scheduler, cloud tasks and cloud functions in preparation for a refactoring of quiz reminders.
10/07/20|Added function to view all PDFs user has previously uploaded. Uploader of a PDF can now link his PDF to quizzes made by him.|Refactored parts of the quiz reminders to support push notifications.
11/07/20|Added ratings to quizzes.|Implemented the cloud tasks api in preparation for a task queue to send quiz reminders.
12/07/20|UI optimisation and fixed the bug on route navigation ( back button was not working as intended). Added function to add reminders during quiz creation.|Implemented the cloud scheduler api to call on certains cloud functions to check of changes in the firestore.

### Sprint review and retrospective
We were given the green light to start on our user testing. We also discussed how our current solution tackles on initial problem statement.