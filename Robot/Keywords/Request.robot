*** Settings ***
Library  Collections
Library  REST    http://127.0.0.1:5000

*** Variables ***
${URL} =  http://127.0.0.1:5000
${REQUEST_PATH} =  /

*** Keywords ***
Test Weather Webservice Request
    [Arguments]  ${city}  ${country}  ${status_code}  ${expected_city}  ${expected_country}  ${error_message}
    ${response} =  Call Weather Webservice Request  ${city}  ${country}
    Validate Response  ${response}  ${status_code}  ${expected_city}  ${expected_country}  ${error_message}

Call Weather Webservice Request
    [Arguments]  ${city}  ${country}
    ${request_body}=  create dictionary  city=${city}  country=${country}
    log  ${request_body}
    ${response} =  post  ${REQUEST_PATH}  ${request_body}
    log  ${response}
    [Return]  ${response}

Validate Response
    [Arguments]  ${response_result}  ${status_code}  ${expected_city}  ${expected_country}  ${error_message}
    log  ${response_result}
    run keyword and continue on failure  should be equal as strings  ${response_result['status']}  ${status_code}
    run keyword if  ${response_result['status']} == 200
    ...  Validate Correct Response  ${response_result}  ${expected_city}  ${expected_country}
    ...  ELSE  Validate Incorrect Response  ${response_result}  ${status_code}  ${error_message}

Validate Correct Response
    [Arguments]  ${response_result}  ${expected_city}  ${expected_country}
    run keyword and continue on failure  should be equal as strings  ${response_result['body']['city']}  ${expected_city}  ignore_case=True
    run keyword and continue on failure  should be equal as strings  ${response_result['body']['country']}  ${expected_country}  ignore_case=True
    run keyword and continue on failure  should be equal as strings  ${response_result['body']['units']}  Celsius  ignore_case=True

Validate Incorrect Response
    [Arguments]  ${response_result}  ${status_code}  ${error_message}
    run keyword and continue on failure  should be equal as strings  ${response_result['body']['message']}  ${error_message}  ignore_case=True
