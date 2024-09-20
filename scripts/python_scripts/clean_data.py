import pandas as pd
import os

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define input and output folders
input_folder = os.path.join(script_dir, '../../data/rawData')
output_folder = os.path.join(script_dir, '../../data/cleanedData')

# Create output folder if it doesn't already exist
os.makedirs(output_folder, exist_ok=True)

def clean_data(file_path):
    # Read the CSV file
    df = pd.read_csv(file_path)
    df['retail_id'] = range(1, len(df) + 1)
    df['Description'] = df['Description'].str.replace(',', ' ')
    df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
    
    df = df[df['UnitPrice'] > 0]
    
    return df

# Process each CSV file in the input_folder
for file_name in os.listdir(input_folder):
    if file_name.endswith('.csv'):
        input_file_path = os.path.join(input_folder, file_name)
        cleaned_data = clean_data(input_file_path)
        
         # Save cleaned data to output_folder
        output_file_path = os.path.join(output_folder, file_name)
        cleaned_data.to_csv(output_file_path, index=False)
        print(f"Processed {file_name} and saved to cleanedData.")