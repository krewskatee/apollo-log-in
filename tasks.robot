*** Settings ***
Documentation       Logs Into Luke's Google Account

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Windows
Library             RPA.HTTP
Library             RPA.Tables
Library             RPA.FileSystem
Library             RPA.Archive
Library             RPA.Dialogs
Library             Collections
Library             RPA.JSON
Library             OperatingSystem
Library             RPA.Robocorp.Vault
Library             String
Library             RequestsLibrary
Library             RPA.Excel.Files


*** Tasks ***
Minimal task
    Set Global Variable    ${iter}    0
    Initialize Run


*** Keywords ***
Initialize Run
    Open Browser

    ${status}    ${value}=    Run Keyword And Ignore Error    Log in

    IF    '${status}' == 'FAIL'
        Close All Browsers
        Initialize Run
    END

Open Browser
    Open Available Browser    https://app.apollo.io/
    Maximize Browser Window

Log in
    ${iter}=    Evaluate    ${iter}+1
    Set Global Variable    ${iter}    ${iter}
    Log To Console    ${iter}
    IF    ${iter}<=2
        ${secret_credentials}=    Get The Secret Credentials
        Wait Until Page Contains Element    //div[text()='Log In with Google']
        Click Element    //div[text()='Log In with Google']
        Wait Until Page Contains Element    //span[text()='Next']
        Sleep    2
        Input Text    identifierId    ${secret_credentials}[username]
        Click Element    //span[text()='Next']
        Wait Until Page Contains Element    //input[@autocomplete="current-password"][1]
        Sleep    2
        Input Text    //input[@autocomplete="current-password"][1]    ${secret_credentials}[password]
        Click Element    //span[text()='Next'][1]
        Sleep    4
    ELSE
        Log In Warning
    END

Get The Secret Credentials
    ${secret}=    Get Secret    account_creds
    ${secret}=    Set Variable    ${secret}
    RETURN    ${secret}

Log In Warning
    Add icon    Warning
    Add heading    We are experiencing issues logging in
    Add submit buttons    buttons=OK    default=OK
    ${result}=    Run dialog    height=300    on_top=True    title=Warning
