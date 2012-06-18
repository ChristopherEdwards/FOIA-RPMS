AMHPAR01 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED Mar 03, 2006@10:07:20 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;;
LOAD ; load data into ^TMP (expects ROOT to be defined)
 S I=1 F  S REF=$T(DATA+I) Q:REF=""  S VAL=$T(DATA+I+1) D
 . S I=I+2,REF=$P(REF,";",3,999),VAL=$P(VAL,";",3,999)
 . S @(ROOT_REF)=VAL
 Q
DATA ; parameter data
 ;;1,"KEY")
 ;;AMHBH DAYS BACK^1
 ;;1,"VAL")
 ;;365
