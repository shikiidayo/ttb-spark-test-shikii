*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${LOGIN_URL}      https://the-internet.herokuapp.com/login

*** Keywords ***
Open Browser To Login with username : "${username}" and password : "${password}"
    Open Browser    ${LOGIN_URL}    chrome
    Input Text      id=username    ${username}
    Input Text      id=password    ${password}
    Click Button    //*[@id="login"]/button

Validate text should be shown as "${text}"
    Wait Until Page Contains    ${text}

Click logout
    Click Element    //i[@class='icon-2x icon-signout']

*** Test Cases ***
TC001 Login success
    When Open Browser To Login with username : "tomsmith" and password : "SuperSecretPassword!"
    Then Validate text should be shown as "You logged into a secure area!"
    And Click logout
    And Validate text should be shown as "You logged out of the secure area!"
    [Teardown]    Close Browser

TC002 Login failed - Password incorrect
    When Open Browser To Login with username : "tomsmith" and password : "Password!"
    Then Validate text should be shown as "Your password is invalid!"
    [Teardown]    Close Browser

TC003 Login failed - Username not found
    When Open Browser To Login with username : "tomholland" and password : "Password!"
    Then Validate text should be shown as "Your username is invalid!"
    [Teardown]    Close Browser