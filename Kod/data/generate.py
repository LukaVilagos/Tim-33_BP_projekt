import csv
import random

# File path to save the CSV file
file_path = "rezervacija_ljubimac.csv"

# Open the CSV file in write mode
with open(file_path, mode='w', newline='') as file:
    writer = csv.writer(file)
    
    # Write the header
    writer.writerow(["rezervacija_id", "ljubimac_id"])
    
    counter = 1
    # Write data for the first range
    for i in range(1, 60):
        writer.writerow([i, counter])
        if counter == 39:
            counter = 0
        counter += 1
        
    writer.writerow([30, 1])
    
    # Write data for the second range
print("Data has been written to", file_path)
