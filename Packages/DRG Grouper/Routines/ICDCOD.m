ICDCOD ;ALB/ABR/ADL - Inquire to ICD Codes ;04/21/2014
 ;;18.0;DRG Grouper;**7,57**;Oct 20, 2000;Build 7
 ;               
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    DD^%DT              ICR  10003
 ;    EN^DIQ1             ICR  10015
 ;    ^DIR                ICR  10026
 ;               
 ;This routine allows entry of an ICD9 or ICD0 code, and returns the description.
 ;It also alerts the user if it is an inactive code.
 ;
EN ;
 N DIRUT,DTOUT,DUOUT,DIR,DIC,DA,DR,DIQ,X,Y,ICDTMP
DATE D EFFDATE^ICDDRGM G EXIT:$D(DUOUT),EXIT:$D(DTOUT)
 F  S DIR(0)="SO^1:ICD DIAGNOSIS CODE;2:ICD OPERATION/PROCEDURE CODE" D ^DIR Q:Y<0!$D(DIRUT)  D @Y  Q:$D(DTOUT)
 G DATE
 ;
1 ;ICD DIAGNOSIS CODE
 S DIR(0)="PO^80:QAEMI"
 F  W !! S DIR("S")="I $$CSI^ICDEX(80,+Y)=1" D ^DIR K DIR("S") Q:Y<0!$D(DIRUT)  D
 . N ICDASK S DIC=$$ROOT^ICDEX(80),DA=+Y,DR=".01;1.1",DIQ(0)="ENI",DIQ="ICDASK" D EN^DIQ1
 . S ICDTMP=$$ICDDX^ICDCODE(+DA,ICDDATE)
 . W !!,ICDASK(80,DA,.01,"E"),?15,$P(ICDTMP,"^",4)
 . W !,$$VLT^ICDEX(80,+DA,ICDDATE),"     ",$P(ICDTMP,U,18),!  ;add printing of descript disclaimer msg
 . I '$P(ICDTMP,U,10) W "   **CODE INACTIVE" I $P(ICDTMP,U,12)'="" S Y=$P(ICDTMP,U,12) D DD^%DT W " AS OF   ",Y," **",!
 Q
 ;
2 ;ICD OPERATION/PROCEDURE
 S DIR(0)="PO^80.1:QAEMI"
 F  W !! S DIR("S")="I $$CSI^ICDEX(80.1,+Y)=2" D ^DIR K DIR("S") Q:Y<0!$D(DIRUT)  D
 . N ICDASK S DIC=$$ROOT^ICDEX(80.1),DA=+Y,DR=".01;1.1",DIQ(0)="ENI",DIQ="ICDASK" D EN^DIQ1
 . S ICDTMP=$$ICDOP^ICDCODE(+DA,ICDDATE)
 . W !!,ICDASK(80.1,DA,.01,"E"),?15,$P(ICDTMP,"^",5)
 . W !,$$VLT^ICDEX(80.1,+DA,ICDDATE),"     ",$P(ICDTMP,U,14),!  ;add printing of descript disclaimer msg
 . I '$P(ICDTMP,U,10) W "   **CODE INACTIVE" I $P(ICDTMP,U,12)'="" S Y=$P(ICDTMP,U,12) D DD^%DT W " AS OF   ",Y," **",!
 Q
EXIT Q  ;Exit subroutine
INA ; Inquire
 D INQ^ICDEX
 Q
