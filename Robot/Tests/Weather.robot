*** Settings ***
Library  Collections
Library  REST    http://127.0.0.1:5000
Resource  ../Keywords/Request.robot
Resource  ../Keywords/DataManager.robot

*** Variables ***
${URL} =  http://127.0.0.1:5000
${REQUEST_PATH} =  /
${csv_file_path} =  "C:\\Users\\Dina\\PycharmProjects\\Weather\\Robot\\Data\\TestData.xls"
${city} =  berlin
${country} =  germany
${status_code} =  200
${expected_city} =  berlin
${expected_country} =  germany
${error_message} =  ${EMPTY}

*** Test Cases ***
Check Weather Webservice is working properly
#    ${data} =  read csv file  ${csv_file_path}
#    :FOR  ${} in ${data}
#    \
#    \
    Request.Test Weather Webservice Request  ${city}  ${country}  ${status_code}  ${expected_city}  ${expected_country}  ${error_message}


Check Weather Webservice Returns Error With City Only in Payload
    ${request_body}=  create dictionary  city=${city}
    log  ${request_body}
    ${response} =  post  ${REQUEST_PATH}  ${request_body}
    log  ${response}
    run keyword and continue on failure  should be equal as strings  ${response['status']}  422
    run keyword and continue on failure  should be equal as strings  ${response['body']['message']}  Invalid input fields  ignore_case=True


Check Weather Webservice Returns Error With Country Only in Payload
    ${request_body}=  create dictionary  country=${country}
    log  ${request_body}
    ${response} =  post  ${REQUEST_PATH}  ${request_body}
    log  ${response}
    run keyword and continue on failure  should be equal as strings  ${response['status']}  422
    run keyword and continue on failure  should be equal as strings  ${response['body']['message']}  Invalid input fields  ignore_case=True


Check Weather Webservice Returns Error With Empty Payload
    ${response} =  post  ${REQUEST_PATH}
    log  ${response}
    run keyword and continue on failure  should be equal as strings  ${response['status']}  400
    run keyword and continue on failure  should contain  ${response['body']['message']}  Failed to decode JSON object  ignore_case=True


Check Weather Webservice Returns Error With Extra Keys in Payload
    ${request_body}=  create dictionary  city=${city}  country=${country}  extra=extraValue
    log  ${request_body}
    ${response} =  post  ${REQUEST_PATH}  ${request_body}
    log  ${response}
    run keyword and continue on failure  should be equal as strings  ${response['status']}  422
    run keyword and continue on failure  should be equal as strings  ${response['body']['message']}  Invalid input fields  ignore_case=True

