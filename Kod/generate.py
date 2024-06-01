import csv
import random

file_path = "example.csv"

with open(file_path, mode='w', newline='') as file:
    writer = csv.writer(file)
    
    writer.writerow(["example_id", "example_id"])
    
    counter = 1
    for i in range(1, 60):
        writer.writerow([i, counter])
        if counter == 39:
            counter = 0
        counter += 1
        
    writer.writerow([30, 1])
    
print("Data has been written to", file_path)
