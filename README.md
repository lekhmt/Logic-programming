# Логическое программирование 
Лабораторные работы и курсовая работа по курсу "Логическое программирование", 3 семестр 

## Лабораторная работа №1
Задание 1: реализовать на языке Prolog предикат удаления из списка всех элементов с заданным значением.

Задание 2: реализовать на языке Prolog предикат слияния упорядоченных списков.

Задание 3: реализовать на языке Prolog работу с реляционным представлением данных. 

## Лабораторная работа №2
Задание: написать и отладить Prolog-программу решения логической задачи в соответствии с номером варианта, проанализировать эффективность, безопасность и непротиворечивость решения. Под эффективностью и безопасностью понимать сведение к минимуму операций перебора и предотвращение зацикливания и комбинаторного взрыва нелогическими средствами языка Prolog. Под непротиворечивостью понимать поиск единственно верного решения (Примечание: каждая из задач лабораторной работы имеет ровно одно решение).

Вариант: 6 человек (назовем их А, Б, В, Г, Д и Е) - кандидаты на посты председателя, заместителя председателя и секретаря правления общества любителей логических задач. Но определить состав этой тройки оказалось не так-то легко. Судите сами: А не хочет входить в состав руководства, если Д не будет председателем. Б не хочет входить в состав руководства, если ему придется быть старшим над В. Б не хочет работать вместе с Е ни при каких условиях. В не хочет работать, если в состав руководства войдут Д и Е вместе. В не будет работать, если Е будет председателем, или если Б будет секретарем. Г не будет работать с В или Д, если ему придется подчиняться тому или другому. Д не хочет быть заместителем председателя. Д не хочет быть секретарем, если в состав руководства войдет Г. Д не хочет работать вместе с А, если Е не войдет в состав руководства. Е согласен работать только в том случае, если председателем будет либо он, либо В. Как они решили эту проблему?

## Лабораторная работа №3
Задание: написать и отладить Prolog-программу решения задачи искусственного интеллекта, используя технологию поиска в пространстве состояний.

Вариант: "расстановка мебели". Площадь разделена на 6 квадратов, 5 из которых заставлены мебелью. Переставить мебель так, чтобы шкаф и кресло поменялись местами, при этом никакие 2 предмета не могут стоять в одном квадрате. 

## Лабораторная работа №4
Задание: познакомиться на практике с методами анализа естественно-языковых текстов в системах логического программирования, реализовать фрагмент естественно-языкового интерфейса к модельной задаче и протестировать его на ряде примеров.

Вариант: реализовать разбор предложений английского языка. В предложениях у объекта могут быть заданы цвет, размер и положение. 

## Курсовая работа
Задания: 
1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM.
2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog. 
3. Реализовать предикат поиска/проверки двоюродного брата. 
4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве.
5. Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. Допускается использовать английский язык в качестве базового.
