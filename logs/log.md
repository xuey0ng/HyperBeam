## Sprint 1

Meeting|Guan Wei|Xue Yong
---|--------|--------
To-do|Quiz Creation, Upload of .pdf files, Checklist Creation| Have backend ready to (pre-)process pdfs and output highlight statistics|
01/06/20|Implemented progressChart, User can add and delete Task in progress chart| Created Textstore, able to store and hash user highlights and preproccessed pdf|
02/06/20|Progress Chart shows the list of completed and uncompleted tasks| Created PDFpos, able to preprocess pdf to prepare for highlight statistics|
03/06/20|Implemented create Quiz function. Implemented view quiz which shows the quiz questons. Refactored dataRepo| Created the GetHighlights, able to obtain coordinates and content of highlights|
04/06/20|Added function to upload pdf files, added time stamp for scheduled quiz, change layout of homepage to bottom widget to avoid cluttering|
05/06/20|Fixed user authentication & establish connection to firebase storage| Started work on Statistic, in order to process the user highlight statistics|
06/06/20|Added quiz scheduler|Fixed alighnment issues that arose when parsing different pdfs|
07/06/20|Review and added quizName to quiz class|
Sprint review and retrospective| Now that the skeleton is done. Priority is to get a feature fully implement before proceeding to the next one. Starting from Quiz, then PDF upload and lastly Progress chart. All UI to be implemented first. Decide on using a demo screen for app frates that cannot be implemented yet due to lack of backend script. 
Newly added backlog:
-Allow user to upvote/ downvote answers (We stay true to our objective and will not provide model answers/ answers endorsed by tutor)
-Upload of pdf by Google drive (if most users use it) or support upload via other platforms and means too
