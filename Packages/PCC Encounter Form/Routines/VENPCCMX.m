VENPCCMX ; IHS/OIT/GIS - PRINT DEAMON MONITOR 12 Feb 2004 10:12 AM ; 
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 ;
 ;
 ; 
MON ; EP-MONITOR THE PRINT DEAMON
 N %,STOP,LAST,TOT
 S %=+$O(^TMP("VEN TASK",0)),LAST=$G(^TMP("VEN TASK",%))
 I '$D(^TMP("VEN TASK")) G:$$MSG(1) RPT Q
 W !,"The Print Deamon is being monitored"
RPT W !!
 F TOT=1:1 Q:$G(STOP)  D
 . S %=$O(^TMP("VEN TASK",0)) I '% D  Q
 .. S STOP=1
 .. S %=$O(^VEN(7.7,999999999),-1) I '% Q
 .. I '$P($G(^VEN(7.7,%,0)),U,6) W !,"Print Deamon encountered an error: ",$G(^(1))
 .. Q
 . S %=^TMP("VEN TASK",%) I %="" S STOP=1 Q
 . I TOT=60,%=LAST W !,"The Print Deamon appears to be stuck!",!,"It will be shut down now..." D KILLTASK^VENPCCP S STOP=1 Q
 . I TOT=60 S TOT=1,LAST=%
 . W $C(13),?70,$C(13)
 . W %
 . R %:1 E  Q
 . I %="^^" W !,"The Print Deamon has been stopped!" D KILLTASK^VENPCCP S STOP=1 Q
 . I %="" S STOP=1 Q
 . Q
 Q
 ; 
MSG(STATE) ; EP - START THE PRINT DEAMON MSG
 N %,%Y
 I $G(STATE) D
 . W !,"The Print Deamon does not appear to be running at this time!"
 . S %=$O(^VEN(7.7,999999999),-1) I '% Q
 . I '$P($G(^VEN(7.7,%,0)),U,6) W !,"It stopped with this error: ",$G(^(1))
 . Q
 W !,"Want to start the Print Deamon now"
 S %=1 D YN^DICN I %'=1 Q 0
 I $D(^TMP("VEN TASK")) W !,"Print Deamon has been started!" Q 1
 X ("J "_U_"VENPCCP")
 W !,"Attempting to start the Print Deamon...  Please wait"
 H 3
 I $D(^TMP("VEN TASK")) W !,"Print Deamon has been started!" Q 1
 W !,"Unable to start the Print Deamon!  Notify site manager..."
 Q 0
 ; 
STOP ; EP-STOP THE PRINT DEAMON
 I '$D(^TMP("VEN TASK")) W !,"The print deamon is not running at this time!" Q
 N %,%Y,CFIGIEN,PATH
 S CFIGIEN=$$CFG^VENPCCU
 S PATH=$G(^VEN(7.5,CFIGIEN,1))
 S %=$$COUNT^VENPCCP(PATH)
 I %=1 W !,"There is one file waiting to be processed by the Print Deamon" G SS
 I '% S %="no"
 W !,"There are ",%," files waiting to be processed by the Print Deamon"
SS W !,"Want to stop the Print Deamon now"
 S %=1 D YN^DICN I %'=1 Q
 D KILLTASK^VENPCCP K ^TMP("VEN ERROR FLAG")
S1 W !,"The Print Deamon has been stopped!"
 Q
 ; 
START ; EP-START THE PRINT DEAMON
 I $$MSG(0)
 Q
 ; 
RESTART ; EP-CLEAN OUT THE PRINT DIRECTORY AND RESTART THE PRINT DEAMON
 W !,"WARNING!!!",!,"This option will erase all files in the print queue and reset the system"
 W !,"Want to proceed" S %=2 D YN^DICN I %'=1 Q
 N PATH,F,CFIGIEN,%
 S PATH=$G(^VEN(7.5,+$$CFG^VENPCCU,1)) I '$L(PATH) W !,"Unable to find path in config file!.  Request terminated.",!! Q
 S F="*.txt"
 D DEL^VENPCCP(PATH,F) W !,"The Print Directory has been cleaned out.",!!
 D KILLTASK^VENPCCP K ^TMP("VEN ERROR FLAG")
 I $$MSG(0)
 Q
 ; 
AUTO ; EP-AUTOMATICALLY START PCC PLUS PRINT DEAMON
 D KILLTASK^VENPCCP K ^TMP("VEN ERROR FLAG")
 X ("J "_U_"VENPCCP")
 Q
 ; 
