import pandas as p
from datetime import datetime
import os
print(os.getcwd())
#read a csv file
df=p.read_csv("C:\\Users\\manog\\OneDrive\\Documents\\etl_proj\\Healthcare Patient Intake ETL Pipeline\\Source_Data\\raw_patient_intake_data.csv")


#combine first and last name to a new column name

df['FullName']=df['FirstName']+' '+df['LastName']

#standard Gender format
def categorize_gender(g):
    if g.upper() in ['F', 'FEMALE', 'WOMAN','WOMEN']:
        return 'Female'
    elif g.upper() in ['M', 'MALE', 'MAN']:
        return 'Male'
    else:
        return 'Other'

df['StandardGender'] = df['Gender'].apply(categorize_gender)

#standard Date format

def categorize_date(date):
    date = str(date).strip()
    try:
        # MM/DD/YYYY
        if p.notnull(date) and '/' in date and date.count('/') == 2:
            return datetime.strptime(date, '%m/%d/%Y').date()
        
        # YYYY-MM-DD
        elif '-' in date and len(date.split('-')[0]) == 4:
            return datetime.strptime(date, '%Y-%m-%d').date()
        
        # MM-DD-YYYY
        elif '-' in date and len(date.split('-')[0]) == 2:
            return datetime.strptime(date, '%m-%d-%Y').date()
        
        # Month DD, YYYY (e.g. October 20, 1970)
        elif ',' in date:
            return datetime.strptime(date.title(), '%B %d, %Y').date()
        
        else:
            return None
    except Exception:
        return None
    
df['DateOfBirth'] = df['DOB'].apply(categorize_date)

#print(df)
#CREATING THE OUTPUT FILE WITH THE MODIFIED DATA
columns_to_save = ['PatientID', 'FirstName', 'LastName', 'FullName','DateOfBirth','Phone']

df.to_csv('C:\\Users\\manog\\OneDrive\\Documents\\etl_proj\\Healthcare Patient Intake ETL Pipeline\\python\\cleaned_Patient_data.csv', columns=columns_to_save, index=False)