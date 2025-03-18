*** Settings ***
Library               RequestsLibrary

*** Variables ***
${REQUEST_URL}          https://reqres.in/api/users/

*** Keywords ***
Send request to get user profile with id : "${id}"
    ${response}=    Get    ${REQUEST_URL}${id}    expected_status=anything
    Set Test Variable    ${response}    ${response}

Validate response status code should be "${status_code}"
    Status Should Be    ${status_code}

Validate response body ID should be "${expected_value}"
    Should Be Equal As Strings    ${response.json()}[data][id]   ${expected_value}

Validate response body Email should be "${expected_value}"
    Should Be Equal As Strings    ${response.json()}[data][email]   ${expected_value}

Validate response body Firstname should be "${expected_value}"
    Should Be Equal As Strings    ${response.json()}[data][first_name]   ${expected_value}

Validate response body Lastname should be "${expected_value}"
    Should Be Equal As Strings    ${response.json()}[data][last_name]   ${expected_value}

Validate response body Avatar should be "${expected_value}"
    Should Be Equal As Strings    ${response.json()}[data][avatar]   ${expected_value}

Validate response body should be empty
    Should Be Empty    ${response.json()}

*** Test Cases ***
TC001 Get user profile success
    When Send request to get user profile with id : "12"
    Then Validate response status code should be "200"
    And Validate response body ID should be "12"
    And Validate response body Email should be "rachel.howell@reqres.in"
    And Validate response body Firstname should be "Rachel"
    And Validate response body Lastname should be "Howell"
    And Validate response body Avatar should be "https://reqres.in/img/faces/12-image.jpg"

TC002 Get user profile but user not found
    When Send request to get user profile with id : "1234"
    Then Validate response status code should be "404"
    And Validate response body should be empty
