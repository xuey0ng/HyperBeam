import hashlib
a = "Both external and internal users of financial information exist. Therefore, we can classify accounting into two\
branches. Financial accounting provides information to decision makers outside the reporting entity. These are\
investors, creditors, government agencies, and the public. This text focuses on financial accounting. Management\
accounting provides information for Alibaba’s managers. Examples of management accounting information include\
budgets, forecasts, and projections that are used in making strategic decisions for the entity. Managers of Alibaba\
have the ability to determine the form and content of financial information in order to meet their own needs. Internal\
information must still be reliable and relevant for their decision needs.\
You may be doing this course as an accounting student or a non-accounting student. Regardless of your eventual\
career ambitions, knowledge of accounting will help you understand how organizations operate. Many accounting\
graduates work in professional accounting services, typically with public accounting firms. These firms offer\
various services to business and government sectors, such as audit and assurance, taxation advice, consultancy, and\
advisory. Those who venture into the corporate world may work in various accounting functions, from treasury and\
finance, to internal audit and risk management. Even if you are not an accounting student, in almost all lines of work\
and across industries, you will have to make decisions in your day-to-day activities, most of which will require you\
to understand, prepare, or work with some form of financial reporting and budgeting. On a personal level, you may\
also find that accounting helps you manage your own finances and investments better."

hash_obj = hashlib.md5(a.encode())
print(hash_obj.hexdigest())
print(hash(a))