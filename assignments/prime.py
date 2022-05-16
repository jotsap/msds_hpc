#!/usr/bin/env python

# To take input from the user
import os

# ALTERNATE: Take input from the user
# num = int(input("Enter a number: "))

num = 8

for i in range(1,num):
    if (i == 1):
        os.mkdir("folder"+str(i))
        continue
    elif (i == 2):
        os.mkdir("folder"+str(i))
        continue
    elif (i % 2) == 0:
        continue
    elif (num % i) != 0:
        os.mkdir("folder"+str(i))
        continue
    else:
        continue
