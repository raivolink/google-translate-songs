*** Settings ***
Documentation     Google Translate song lyrics from source to target language.
...               Saves the original and the translated lyrics as text files.
Library           RPA.Browser
Library           OperatingSystem
Task Teardown     Close All Browsers

*** Variables ***
${SONG_NAME}=     %{SONG_NAME=Peaches}
${SOURCE_LANG}=    %{SOURCE_LANG=en}
${TARGET_LANG}=    %{TARGET_LANG=es}
${ORIGINAL_FILE}=    ${OUTPUT_DIR}${/}${SONG_NAME}-${SOURCE_LANG}-original.txt
${TRANSLATION_FILE}=    ${OUTPUT_DIR}${/}${SONG_NAME}-${TARGET_LANG}-translation.txt

*** Keywords ***
Get lyrics
    Open Available Browser    https://www.lyrics.com/lyrics/${SONG_NAME}
    Click Element When Visible    css:.best-matches a
    ${lyrics_element}=    Set Variable    id:lyric-body-text
    Wait Until Element Is Visible    ${lyrics_element}
    ${lyrics}=    Get Text    ${lyrics_element}
    [Return]    ${lyrics}

*** Keywords ***
Translate
    [Arguments]    ${lyrics}
    Go To    https://translate.google.com/#view=home&op=translate&sl=${SOURCE_LANG}&tl=${TARGET_LANG}&text=${lyrics}
    ${translation_element}=    Set Variable    css:.tlid-translation
    Wait Until Element Is Visible    ${translation_element}
    ${translation}=    Get Text    ${translation_element}
    [Return]    ${translation}

*** Keywords ***
Save lyrics
    [Arguments]    ${lyrics}    ${translation}
    Create File    ${ORIGINAL_FILE}    ${lyrics}
    Create File    ${TRANSLATION_FILE}    ${translation}

*** Tasks ***
Google Translate song lyrics from source to target language
    ${lyrics}=    Get lyrics
    ${translation}=    Translate    ${lyrics}
    Save lyrics    ${lyrics}    ${translation}
