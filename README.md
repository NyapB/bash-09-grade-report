# 🏷  Student Grade Report Parser

A Bash script that cleans, processes, validates, and ranks student grades from a CSV file.

## 📌 Problem Statement

Rebase instructors receive a spreadsheet of scores and spend an evening calculating averages and rankings by hand. Building grades.sh helps the instructors to take two seconds.

## 🎯 Project Goals

- collect scores for students in their various courses
- calculate the total score per student
- calculate the average per student
- get the rank of each student based on their scores
- give their mentions with respect to their averages

## Setup & Execution

Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/NyapB/bash-09-grade-report
cd bash-09-grade-report
chmod +x grades.sh
```

Run the script by providing the path to a grade CSV file:

```bash
./grades.sh grades.csv
```

## Sample Output

```text
    RANK NAME             HTML  CSS BASH  GIT    AVG MENTION
    Warning: Line 5 skipped (missing score)
    Warning: Line 6 skipped (score 'abs' is not a valid whole number)
        1 Abigail            17   18   16   19  17.50 Très bien
        2 Becky              19   17   15   18  17.25 Très bien
        3 Kerry              13   15   17   20  16.25 Très bien
        4 zero test           9    8   10   12   9.75 Échec
    ------------------------------------------------------------
    Class average: 15.19
    Skipped 2 invalid lines (see warnings above)
```

## 🛠 Tech Stack

bash
Git
GitHub

## 📷 Screenshots

![ bash grade_report ](<assets/images/Screenshot From 2026-11-03 14-28-22.png>)

## 🧠 Challenges Faced

- identifying a file
- looping through to validate the information in the file
- carrying calculations as bash does not work with decimals

## 📚 What I Learned

- strengthen checks using while loops and if statements
- writing cleaner, modular code using helper functions instead of repetitive blocks

## 👨🏽‍💻 Author

Nyap Becky Beri

Junior Fullstack Developer

[beribecky8@gmail.com](mailto:beribecky8@gmail.com)

🌍 Based in Cameroon | Open to remote opportunities
