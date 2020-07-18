class Quiz:
    def __init__(self, module, qn, options, answer_key, quiz_type):
        self.module = module
        self.qn = qn
        self.options = options
        self.answer_key = answer_key
        self.user_answer = list()
        self.quiz_type = quiz_type ##Type 1 is mcq, type 2 is srq.

    def getModule(self):
        return self.module

    def getQuestion(self):
        return self.qn

    def getOptions(self):
        return self.options

    def getAnswerKey(self):
        return self.answer_key

    def getUserAnswer(self): 
        return self.user_answer

    def getQuizType(self):
        return self.quiz_type

    def setUserAnswer(self, user_answer):
        self.user_answer = user_answer
    
    def markAnswer(self):
        if not self.user_answer:
            print("User has yet to input an answer. Marked as wrong")
            return False
        else:
            self.answer_key.sort()
            self.user_answer.sort()
            return self.answer_key == self.user_answer



def create_quiz():
    module = input("Please input the module code for this quiz\n>>>")
    qn = input("Please input your quiz question\n>>>")
    num = input("Please input the number of options, note that you should have 3-6 options\n>>>")
    while not num.isnumeric() or int(num) > 6 or int(num) < 3:
        print("Sorry invalid input for your number of options.")
        num = input("Please input the number of options, note that you should have 3-6 options\n>>>")
    options = list()
    switch = True
    while switch:
        for i in range(int(num)):
            current = input("Please input option {}\n>>>".format(i))
            options.append(current)
        print("The options you inputted are: ")
        for i in range(int(num)):
            print("{}. {}".format(i, options[i]))
        check = input("Is everything correct? If yes, enter Y. If not, enter N\n>>>")
        if (check.upper() == "Y"):
            print("The options are saved")
            switch = False
        else:
            print("We will proceed with re-entering the options.")
    answers = [int(x) for x in input("Enter the integer index(es) of the options that are correct as shown above.\n \
         The inputs are to be separated by a blank space. \
             For example, if 0 and 2 are correct, input: 0 2\n>>>").split()] 
    quiz_type = input("Please input the quiz type. 1 for MCQ, 2 for SRQ.\n>>>")
    while not quiz_type.isnumeric or (int(quiz_type) != 1 and int(quiz_type) != 2):
        print("Sorry invalid input for the quiz type.")
        num = input("Please input the quiz type. 1 for MCQ, 2 for SRQ.\n>>>")
    quiz = Quiz(module, qn, options,answers, quiz_type)
    return quiz

def do_quiz(quiz):
    print(quiz.getQuestion)
    options = quiz.getOptions
    answers = quiz.getAnswerKey
    for i in range(len(options)):
        print("{}. {}".format(i, options[i]))
    if quiz.getQuizType == 1:
        user_answer = input("Please enter the correct option for this question.\n>>>")
    else :
        print("Please enter one or more correction options for this question.")
        user_answer = [int(x) for x in input("Enter the integer index(es) of the options that are correct as shown above.\n \
         The inputs are to be separated by a blank space. \
             For example, if 0 and 2 are correct, input: 0 2\n>>>").split()] 
    quiz.setUserAnswer(user_answer)

A = create_quiz()