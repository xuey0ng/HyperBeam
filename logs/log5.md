## Sprint 5

Meeting|Guan Wei|Xue Yong
---|---------|----------
To-do|Refactor codes that do firebase queries for new database structure, Search bar in explore page, Add more fields to Quiz and User class, UI review, Sharing of quiz with other users|Support more pdf layouts, extensively test for corner cases, implement push notification to individuals and subscribers when the master PDF is updated.
29/06/20|Added Google sign-in|Added push notifications to individuals when master PDF is updated
30/06/20|Added FirebaseUserService in provider to allow faster synchronous access of user's data|Added push notifications to subscribers when master PDF is updated
01/07/20|UI fixes and optimisation, applying white filter to background to make the gradient less stark|Added a link to the notification to allow for ease of access
02/07/20|Refactored Module class to allow serialization from modules in NUSMods API|Refactored user-defined package to allow for more PDF layouts to be successfully parsed
03/07/20|Added function to validate module code after each character keyed in by user, added search bar|Fixed a bug where PDFs with symbols such as the em-dash are not having all their highlights being reflected. Improved the runtime of parsing PDFs.
04/07/20|Added expandable text in moduleDetails that allow user to see the details of the module(all the info is obtained from NUSMods API|Fixed a bug where footers within the PDFs disrupted certain highlights. 
05/07/20|Added in-app push notification and its accompanying class. Reduce the number of times in which the NUSMods file is accessed to reduce loading time. Added Scaffold for user profile.Review and submission of peer reviews|Fixed a bug where only the copyright messages from certain PDFs were being parsed.

### Sprint review and retrospective
Discussed the naming of the PDFs as certain users might have renamed their PDFs; in that case, which name should each user view. Another issue we resolved was the implications of deleting a certain quiz, as we were undecided on whether the other users whom have saved the quiz should still retain access to the quiz. For this case, we decided on allowing the creator to decide this within their device settings. Another key concern for the week was regarding our database design, as were deciding how to best link the quizzes to the users, relevant module and PDFs. 