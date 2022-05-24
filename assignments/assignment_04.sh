#!/bin/bash

# download gullivers travels
curl https://www.gutenberg.org/files/829/829-0.txt --output travel.txt

# split into 5 equal chunks
split --number=l/5 travel.txt travelsplit

# call python prime loop
python3 prime.py

# move splits into folders
mv travelsplitaa folder1/
mv travelsplitab folder2/
mv travelsplitac folder3/
mv travelsplitad folder5/
mv travelsplitae folder7/
