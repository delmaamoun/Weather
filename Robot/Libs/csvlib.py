

def read_csv_file(filename):
    data = []
    with open(filename,'rb') as csvfile:
        readrow = csv.reader(csvfile)
        for row in readrow:
            data.append(row)
    return data

if __name__ == '__main__':
    data = read_csv_file("C:\\Users\\Dina\\PycharmProjects\\Weather\\Robot\\Data\\TestData.csv")