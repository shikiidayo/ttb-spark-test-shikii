*** Settings ***
Library  AppiumLibrary
Library  BuiltIn
Library    String
Library  DateTime

*** Variables ***
${ANDROID_AUTOMATION_NAME}    UIAutomator2
${ANDROID_APP}                ${CURDIR}/../PythonProject/app-release-edit.apk
${ANDROID_PLATFORM_NAME}      Android
${ANDROID_PLATFORM_VERSION}   %{ANDROID_PLATFORM_VERSION=6}
&{MONTHS}  Jan=January  Feb=February  Mar=March  Apr=April  May=May  Jun=June  Jul=July  Aug=August  Sep=September  Oct=October  Nov=November  Dec=December

*** Keywords ***
Open Application test
      Open Application  http://127.0.0.1:4723/wd/hub  automationName=${ANDROID_AUTOMATION_NAME}   platformName=${ANDROID_PLATFORM_NAME}   app=${ANDROID_APP}    allow-insecure=true

Extract Reminder Parts
    [Arguments]    ${REMINDER_STRING}
    ${removed_text}=    Replace String    ${REMINDER_STRING}    Reminder set for    ${EMPTY}
    ${date_time_parts}=    Split String    ${removed_text}  ,
    ${date_parts}=    Split String    ${date_time_parts[0]}  ' '
    ${date} =    Get Substring    ${date_time_parts[0]}    0    -4
    ${month}=   Get Substring	${date_time_parts[0]}    -3
    ${time}=    Get Substring    ${date_time_parts[2]}    1
    Set Test Variable    ${full_month}    ${MONTHS}[${month}]
    ${year_plus_one}=  Evaluate    ${date_time_parts[1]} + 1
    ${year_minus_one}=  Evaluate    ${date_time_parts[1]} - 1
    ${year}=    Get Substring    ${date_time_parts[1]}    1
    ${date_remove_space}    Get Substring    ${date}    1
    IF    ${date}>=15
        ${new_date}=  Evaluate    ${date} - 1
    ELSE
        ${new_date}=  Evaluate    ${date} + 1
    END
    Set Test Variable    ${year_plus_one}    ${year_plus_one}
    Set Test Variable    ${year_minus_one}    ${year_minus_one}
    Set Test Variable    ${date}    ${date_remove_space}
    Set Test Variable    ${year}    ${year}
    Set Test Variable    ${new_date}    ${new_date}
    Set Test Variable    ${full_month}    ${full_month}
    Set Test Variable    ${month}    ${month}
    Set Task Variable    ${time}    ${time}

*** Test Cases ***
sss
    Extract Reminder Parts    Reminder set for 9 Mar, 2025, 9:00 AM

TC001 Set reminder and edit successfully
      Open Application test
      #First reminder
      Click Element    //android.widget.ImageView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/addToDoItemFAB"]
      Wait Until Element Is Visible    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]
      Input Text    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]    Test
      Wait Until Element Is Visible    //android.widget.Switch[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat"]
      Click Element    //android.widget.Switch[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat"]
      Wait Until Element Is Visible    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/newTodoDateEditText"]
      ${current_date}=    Get Text    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/newToDoDateTimeReminderTextView"]
      Extract Reminder Parts    ${current_date}
      Click Element    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/newTodoDateEditText"]
      Wait Until Element Is Visible    //android.widget.Button[@resource-id="com.avjindersinghsekhon.minimaltodo:id/date_picker_year"]
      Click Element    //android.widget.Button[@resource-id="com.avjindersinghsekhon.minimaltodo:id/date_picker_year"]
      Click Element    //android.widget.TextView[@content-desc="${year_plus_one}"]
      Click Element    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/date_picker_day"]
      Click Element    //android.view.View[@content-desc="${new_date} ${full_month} ${year_plus_one}"]
      Click Element    //android.widget.Button[@resource-id="com.avjindersinghsekhon.minimaltodo:id/ok"]
      ${modified_date}=    Get Text    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/newToDoDateTimeReminderTextView"]
      Should be equal as strings    ${modified_date}    Reminder set for ${new_date} ${month}, ${year_plus_one}, ${time}
      Click Element    //android.widget.ImageView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton"]
      Wait Until Element Is Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test"]
      Element Should Be Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test"]
      Element Should Be Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/todoListItemTimeTextView" and @text="${month} ${new_date}, ${year_plus_one} ${space}${time}"]
      #Second reminder
      Click Element    //android.widget.ImageView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/addToDoItemFAB"]
      Wait Until Element Is Visible    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]
      Input Text    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]    Test2
      Click Element    //android.widget.ImageView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton"]
      Wait Until Element Is Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test2"]
      Element Should Be Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test2"]
      Click Element    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test2"]
      Wait Until Element Is Visible    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]
      #Check edit reminder name
      Clear Text    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]
      Input Text    //android.widget.EditText[@resource-id="com.avjindersinghsekhon.minimaltodo:id/userToDoEditText"]    Test3
      Wait Until Element Is Visible    //android.widget.Switch[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat"]
      Click Element    //android.widget.Switch[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat"]
      Click Element    //android.widget.ImageView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton"]
      Wait Until Element Is Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test3"]
      Element Should Be Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/toDoListItemTextview" and @text="Test3"]
      Element Should Be Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/todoListItemTimeTextView" and @text="${month} ${date}, ${year} ${space}${time}"]
      [Teardown]    Close Application

#TC002 Set reminder failed - Reminder date is invalid Note: Can't access clock element to set time

#TC003 Delete reminder successfully Note: Need to do swipe to delete reminder. It will be super flaky so I will skip this test case

TC004 Switch to dark mode
      Open Application test
      Click Element    //android.widget.ImageView[@content-desc="More options"]
      Wait Until Element Is Visible    //android.widget.ListView/android.widget.LinearLayout[1]
      Click Element    //android.widget.ListView/android.widget.LinearLayout[1]
      Wait Until Element Is Visible    //android.widget.TextView[@text="Night mode is off"]
      Click Element    //android.widget.CheckBox[@resource-id="android:id/checkbox"]
      Wait Until Element Is Visible    //android.widget.TextView[@text="Night mode is on"]
      Click Element    //android.widget.CheckBox[@resource-id="android:id/checkbox"]
      Wait Until Element Is Visible    //android.widget.TextView[@text="Night mode is off"]
      [Teardown]    Close Application

TC004 Access About menu
     Open Application test
     Wait Until Element Is Visible    //android.widget.TextView[@text="You don't have any todos"]
     Click Element    //android.widget.ImageView[@content-desc="More options"]
     Wait Until Element Is Visible    //android.widget.ListView/android.widget.LinearLayout[2]
     Click Element    //android.widget.ListView/android.widget.LinearLayout[2]
     Wait Until Element Is Visible    //android.widget.TextView[@text="Made by Avjinder"]
     Wait Until Element Is Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/aboutVersionTextView"]
     Wait Until Element Is Visible    //android.widget.TextView[@text="You can contact me at"]
     Wait Until Element Is Visible    //android.widget.TextView[@resource-id="com.avjindersinghsekhon.minimaltodo:id/aboutContactMe"]
     [Teardown]    Close Application



