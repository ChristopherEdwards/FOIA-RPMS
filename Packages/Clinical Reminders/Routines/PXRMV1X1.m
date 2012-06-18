PXRMV1X1 ; SLC/PJH - Export Parameter Definitions; 05/08/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;;
LOAD ; load data into ^TMP (expects ROOT to be defined)
 S I=1 F  S REF=$T(DATA+I) Q:REF=""  S VAL=$T(DATA+I+1) D
 . S I=I+2,REF=$P(REF,";",3,999),VAL=$P(VAL,";",3,999)
 . S @(ROOT_REF)=VAL
 Q
DATA ; parameter data
 ;;4302,"KEY")
 ;;PXRM PROGRESS NOTE HEADERS^1
 ;;4302,"VAL")
 ;;CLINICAL REMINDER ACTIVITY
