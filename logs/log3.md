## Sprint 3

Meeting|Guan Wei|Xue Yong
---|---------|----------
To-do|Allow user to quiz results and its history, allow sharing of quizzes, UI design, reference quiz answer to pdf| Complete the file upload/download from Cloud Storage, the updating of Firebase, and the custom python runtime on App Engine
15/06/20|Sorted out app navigation routes| Built the Dockerfile image for the custom python runtime
16/06/20|Added quiz result summary page|Updated the algorithm for Cloud Storage manipulation
17/06/20|Redesigned homePage UI|Amended User Defined Classes to include hashing of pdf files for comparision on server
18/06/20|Redesigned moduleDetails and quiz UI|Added Firebase comparision and updating functionality
19/06/20|Added score field in Quiz|Implemented push notifications to allow for notifications during user pdf upload
20/06/20|Tested app on device to ensure that the documentSnapshots and documentQueries in the 'Module' collection are correctly referenced|Did initial testing of the previous functionalities locally 
21/06/20|Added function to upload PDF, Added PDF viewer(Obtain master PDF button), added URI to PDF files field in Quiz|Deployed application to google app engine

### Sprint review and retrospective 
App design and general workflow is generally ok. Main issue now is the user experience. Does the user 
1. Read pdf
2. Craft questions
3. Annotate on the pdf (answers to the questions as hgihlights on pdf)
4. Upload the pdf and set quiz schedule (let's say 2 weeks)
5. 2 weeks later, attempt quiz
This prompts the question: Does the user answer the question through the form of open-ended question?
Main issue to tackle: How does this specific workflow help students in their revision? PDF annotation is
a great way to differentiate the product but how can the process of annotating PDF be included in the user
flow such that it gives a smooth user experience? How does using PDF annotations as answer to quiz/flashcard
help in enhancing students' learning.
Sharing of quizzes and user interaction will be pushed to Milestone 3

Aim for next week:
* In app PDF viewer and re-deployment of backend script 
* Milestone 2 submission