*** Settings ***
Documentation  Gets data from files
Library  ExcelRobot
Library  Collections

*** Keywords ***
Get Excel Data
    [Arguments]  ${filepath}
    open excel  ${filepath}
    ${count} =  get row count  Sheet1
    :for ${element} IN RANGE 0 ${count}
    \  ${rowval} =  get column values  Sheet1  ${element}
    \  log  ${rowval}

*** Test Cases ***
Print CSV
    ${data} =  Get Excel Data  C:\\Users\\Dina\\PycharmProjects\\Weather\\Robot\\Data\\TestData.csv
