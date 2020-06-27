*** Settings ***
Documentation   Check if rflint reads supported file formats
Library         OperatingSystem
Library         Process
Library         String
Resource        SharedKeywords.robot


*** Test Cases ***
All Supported File Types
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    robot           resource    tsv

.robot And .resource Supported File Types
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    robot           resource

.resource And .tsv Supported File Types
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    resource        tsv

.robot And .tsv Supported File Types
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    robot           tsv

Only .robot Supported File Type
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    robot

Only .resource Supported File Type
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    resource

Only .tsv Supported File Type
    [Template]      Run Rflint And Verify There Are No Errors For Supported File Types
    tsv

Only .txt Unsupported File Type
    [Template]      Run Rflint And Verify That Unsupported File Types Returned Errors
    txt


*** Keywords ***
Run Rflint And Verify There Are No Errors For Supported File Types
    [Arguments]                 @{extensions}
    ${file_types}               Parse File Types    @{extensions}
    Run rf-lint with the following options:
    ...     --filetypes         ${file_types}
    ...     tests/acceptance/filetypes
    FOR     ${file_type}   IN   @{extensions}
            Should Contain      ${result.stdout}    test.${file_type}
    END
    Should Be Empty             ${result.stderr}

Run Rflint And Verify That Unsupported File Types Returned Errors
    [Arguments]                 @{extensions}
    ${file_types}               Parse File Types    @{extensions}
    Run rf-lint with the following options:
    ...     --filetypes         ${file_types}
    ...     tests/acceptance/filetypes
    FOR     ${file_type}   IN   @{extensions}
            Should Contain      ${result.stderr}    rflint: File extension .${file_type} is not supported
    END
    Should Be Empty             ${result.stdout}

Parse File Types
    [Arguments]         @{filetypes}
    ${types}            Set Variable    ${EMPTY}
    FOR     ${index}    ${file_type}    IN ENUMERATE     @{filetypes}
        ${types}        Run Keyword If  ${index}==${0}
        ...             Set Variable    ${file_type}
        ...             ELSE
        ...             Set Variable    ${types},${file_type}
    END
    Log                 Provided filetypes: ${types}
    [Return]            ${types}
