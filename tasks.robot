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
    Open Browser

    ${status}    ${value}=    Run Keyword And Ignore Error    Log in

    IF    '${status}' == 'FAIL'
        Close All Browsers
        Open Browser
    END


*** Keywords ***
Open Browser
    Open Available Browser    https://app.apollo.io/
    Maximize Browser Window

Log in
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
    Click Element    id:searcher

Get The Secret Credentials
    ${secret}=    Get Secret    account_creds
    ${secret}=    Set Variable    ${secret}
    RETURN    ${secret}
