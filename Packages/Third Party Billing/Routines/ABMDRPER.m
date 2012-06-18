ABMDRPER ; IHS/ASDST/DMJ - UTILITY TO DISPLAY % COMPLETE SCALE ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; This utility generates a scale which is used to inform the user
 ; of the completion percentage of a job.
 ;
 ; Input Variables: ABMR("R") - Number of Records
 ;                  ABMR      - Current Value
 ;
 ; Entry Points: START - Sets variables, prints scale and starting time.
 ;               CURR  - Prints present completion percentage.
 ;               END   - Prints ending time and kills all variables.
 ;
START ;EP for entering utility
 S ABMR("C%")=.02
 W $$EN^ABMVDF("IOF")
 F ABMR("%I")=.02:.02:1 S ABMR(ABMR("%I"),"%")=ABMR("R")*ABMR("%I")
 U IO(0) S ABMR("%X")="========== PROCESSING ACTIVITY =========="
 W !!,?(40-($L(ABMR("%X"))\2)),ABMR("%X")
 W !!?3,"Total Records to Process.....: ",ABMR("R")
 W !?3,"Currently Processing Record..: 1"
 W !!?3,"Starting Time................: " D NOW^%DTC W $$MDT^ABMDUTL(%)
 S ABMR("%X")="Job Completion Percentage"
 W !!,?(40-($L(ABMR("%X"))\2)),ABMR("%X"),!
 W ?13,0 F ABMR("%I")=10:10:100 W ?($X+3) W:ABMR("%I")=10 " " W ABMR("%I")
 W !?13,"|" F ABMR("%I")=1:1:10 W "----|"
 S ABMR("X%")=13
 Q
 ;
CURR ;EP for writing scale
 Q:ABMR("C%")>1
 F  Q:ABMR(ABMR("C%"),"%")>ABMR  D  Q:'$D(ABMR(ABMR("C%"),"%"))
 .U IO(0)
 .S DX=34,DY=6 X IOXY W ABMR
 .S DY=12,DX=ABMR("X%")+$S(ABMR("C%")'=.02:1,1:0)
 .X IOXY W $$EN^ABMVDF("RVN")
 .I ABMR("C%")#.1'=0 W $S(ABMR("C%")'=".02":"=",1:"|=")
 .E  W "|"
 .W $$EN^ABMVDF("RVF")
 .S ABMR("C%")=ABMR("C%")+.02,ABMR("X%")=ABMR("X%")+1
 Q
END ;EP for cleaning up
 U IO(0)
 W !!?3,"Ending Time..................: " D NOW^%DTC W $$MDT^ABMDUTL(%),!!
 K ABMR
XIT Q
 ;
CHK1 I $G(ABMR("R"))="" G ERR
 Q
CHK2 I $G(ABMR)="" G ERR
 Q
 ;
ERR S ABMR("%XIT")=""
 W !!,*7,"NECESSARY VARIABLES NOT DEFINED!"
 Q
 ;
TEST S ABMR("R")=$P(^AUPNVSIT(0),U,4),ABMR("T")=0 D START F ABMR=1:1 S ABMR("T")=$O(^AUPNVSIT(ABMR("T"))) Q:'ABMR("T")  D CURR
 D END
 Q
