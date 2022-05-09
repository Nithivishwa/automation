*** Settings ***
Library     Lib/commands.py
library     SeleniumLibrary


*** Variables ***
@{POWER}=    SetPower  GetPower
@{PORT_NUM}=    0  1  2  3  4  5  6  7  
@{POWER_MODE}=    0  1
${PORTCOUNT}=    3

*** Test Cases ***
Turn ON Power supply for all 8 ports remotely
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        ${RES}=    RPS send commands    ${POWER}[0]    ${PORTNUM}   ${POWER_MODE}[1]
        Should be equal    ${RES}    ${True}        
    END
    
Verify power supply for all 8 ports is on
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        ${out}=    RPS get power    ${POWER}[1]
        should contain    ${out}     ${PORTNUM}=${POWER_MODE}[1]    
    END

Turn OFF Power supply for all 8 ports remotely
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        ${RES}=    RPS send commands    ${POWER}[0]    ${PORTNUM}   ${POWER_MODE}[0]
        Should be equal    ${RES}    ${True}        
    END

Verify power supply for all 8 ports is OFF
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        ${out}=    RPS get power    ${POWER}[1]
        should contain    ${out}     ${PORTNUM}=${POWER_MODE}[0]    
    END

### Power supply should be ON only to few ports
Turn ON Power supply for only ${PORTCOUNT} ports remotely
    ${COUNT}=    Set Variable     ${PORTCOUNT}
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        Exit For Loop If    ${COUNT} > ${PORTCOUNT}
        ${RES}=    RPS send commands    ${POWER}[0]    ${PORTNUM}   ${POWER_MODE}[1]
        Should be equal    ${RES}    ${True} 
        ${COUNT}=    Evaluate    ${COUNT}+1       
    END
    
Verify power supply for above mentioned ports are on
     ${COUNT}=    Set Variable     ${PORTCOUNT}
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        Exit For Loop If    ${COUNT} > ${PORTCOUNT}
        ${out}=    RPS get power    ${POWER}[1]
        should contain    ${out}     ${PORTNUM}=${POWER_MODE}[1]  
        ${COUNT}=    Evaluate    ${COUNT}+1     
    END

### Power supply should be OFF only to few ports
Turn ON Power supply for only ${PORTCOUNT} ports remotely
    ${COUNT}=    Set Variable     ${PORTCOUNT}
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        Exit For Loop If    ${COUNT} > ${PORTCOUNT}
        ${RES}=    RPS send commands    ${POWER}[0]    ${PORTNUM}   ${POWER_MODE}[0]
        Should be equal    ${RES}    ${True} 
        ${COUNT}=    Evaluate    ${COUNT}+1       
    END
    
Verify power supply for above mentioned ports are OFF
     ${COUNT}=    Set Variable     ${PORTCOUNT}
    FOR    ${PORTNUM}    IN    @{PORT_NUM}
        Exit For Loop If    ${COUNT} > ${PORTCOUNT}
        ${out}=    RPS get power    ${POWER}[1]
        should contain    ${out}     ${PORTNUM}=${POWER_MODE}[0]  
        ${COUNT}=    Evaluate    ${COUNT}+1     
    END

*** Keywords ***
RPS send commands
    [Arguments]    ${command}    ${port1}    ${state1}   
    ${output}=    Send cmds    ${command}    ${port1}    ${state1}  
    RETURN    ${output}

RPS get Power
    [Arguments]    ${command}
    ${output}=    Send cmds    ${command}
    RETURN    ${output}
