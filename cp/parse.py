from transliterate import translit, get_available_language_codes

tree = open('tree.ged', 'r')
data = open('data.pl', 'w')

persons = {}
parents = {}

source = tree.readlines()

current = 0
while current < len(source):
    if source[current][0] == '0' and source[current].find("INDI") != -1:
        uid = source[current][source[current].find("@") + 2:source[current].rfind("@")]
        current += 1
        while source[current][0] == '1' and source[current].find("NAME") == -1:
            current += 1
        name = source[current][7:].replace("/", "").replace("\n", "")
        current += 1
        while source[current][0] == '2':
            current += 1
        sex = source[current][-2]
        persons[uid] = [name, sex]
        while source[current][0] == '1':
            current += 1
        current -= 1
    if source[current][0] == '0' and source[current].find("FAM") != -1:
        current += 2
        father_uid = source[current][source[current].find("@") + 2:source[current].rfind("@")]
        current += 1
        mother_uid = source[current][source[current].find("@") + 2:source[current].rfind("@")]
        current += 1
        if parents.get(persons[father_uid][0]) is None:
            parents[persons[father_uid][0]] = []
        if parents.get(persons[mother_uid][0]) is None:
            parents[persons[mother_uid][0]] = []
        while source[current][0] == '1':
            if source[current].find("CHIL") != -1:
                child_uid = source[current][source[current].find("@") + 2:source[current].rfind("@")]
                parents[persons[father_uid][0]].append(persons[child_uid][0])
                parents[persons[mother_uid][0]].append(persons[child_uid][0])
            current += 1
        current -= 1
    current += 1

for uid in persons:
    string = "sex(\"" + translit(persons[uid][0], reversed=True) + "\", \"" + persons[uid][1] + "\").\n"
    data.write(string)

data.write("\n")

for parent in parents:
    for child in parents[parent]:
        string = "parent(\"" + translit(parent, reversed=True) + "\", \"" + translit(child, reversed=True) + "\").\n"
        data.write(string)
