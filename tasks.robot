*** Settings ***
Documentation       Google Translate song lyrics from source to target language.
...                 Saves the original and the translated lyrics as text files.

Library             RPA.Browser.Selenium
Library             OperatingSystem

Task Teardown       Close All Browsers


*** Variables ***
${SONG_NAME}=           %{SONG_NAME=Peaches}
${SOURCE_LANG}=         %{SOURCE_LANG=en}
${TARGET_LANG}=         %{TARGET_LANG=es}
${ORIGINAL_FILE}=       ${OUTPUT_DIR}${/}${SONG_NAME}-${SOURCE_LANG}-original.txt
${TRANSLATION_FILE}=    ${OUTPUT_DIR}${/}${SONG_NAME}-${TARGET_LANG}-translation.txt


*** Tasks ***
Google Translate song lyrics from source to target language
    ${lyrics}=    Get lyrics
    ${translation}=    Translate    ${lyrics}
    Save lyrics    ${lyrics}    ${translation}


*** Keywords ***
Give Consent
    Click Element If Visible    css=button[aria-label='Consent']

Get lyrics
    Open Available Browser    https://www.lyrics.com/lyrics/${SONG_NAME}    #maximized=True
    Give Consent
    Scroll Element Into View    css:.best-matches a
    Click Element When Visible    css:.best-matches a
    Run Keyword And Ignore Error    Handle Ad
    ${lyrics_element}=    Set Variable    id:lyric-body-text
    Wait Until Element Is Visible    ${lyrics_element}
    ${lyrics}=    Get Text    ${lyrics_element}
    RETURN    ${lyrics}

Translate
    [Arguments]    ${lyrics}
    Go To    https://translate.google.com/#view=home&op=translate&sl=${SOURCE_LANG}&tl=${TARGET_LANG}&text=${lyrics}
    ${translation_element}=    Set Variable    css:span.Q4iAWc    #.tlid-translation
    Wait Until Element Is Visible    ${translation_element}
    ${translation}=    Get Text    ${translation_element}
    RETURN    ${translation}

Save lyrics
    [Arguments]    ${lyrics}    ${translation}
    Create File    ${ORIGINAL_FILE}    ${lyrics}
    Create File    ${TRANSLATION_FILE}    ${translation}

Handle Ad
    Wait Until Page Contains Element    css=#aswift_1
    Select Frame    css=#aswift_1
    Select Frame    css=#ad_iframe
    Click Element    css=#dismiss-button
    Unselect Frame
    Unselect Frame
