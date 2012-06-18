ABMDTCD ; IHS/ASDST/DMJ - Table Maintenance of 3P CODES ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM18516
 ;    Added code for Delayed Reason Code
 ;
 S U="^"
 W !
SEL ;
 K DIR,ABM
 S DIR(0)="SO^1:CONDITION CODES;2:OCCURRENCE CODES;3:OCCURRENCE SPAN CODES;4:SPECIAL PROGRAM CODES;5:VALUE CODES;6:BILL TYPE;7:DELAYED REASON CODES"
 S DIR("A")="Select Desired Code" D ^DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABM=$S(Y=1:"C",Y=2:"O",Y=3:"S",Y=4:"I",Y=5:"V",Y=6:"B",1:"U")
 ;
 S ABM("TITL")=$S(ABM="C":"CONDITION CODE",ABM="O":"OCCURRENCE CODE",ABM="S":"OCCURRENCE SPAN CODE",ABM="I":"SPECIAL PROGRAM CODE",ABM="B":"BILL TYPE",ABM="U":"DELAYED REASON CODES",1:"VALUE CODE")
 W !
 K DIR S DIR(0)="S^1:EDIT;2:ADD;3:QUIT",DIR("B")=1,DIR("A")="Desired Action" D ^DIR
 G XIT:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!(Y=3),ADD:Y=2
 ;
EDIT W !! K DIC S DIC="^ABMDCODE(",DIC("A")="Select "_ABM("TITL")_" to Edit: ",DIC(0)="QZEAM",DIC("S")="I $P(^(0),U,2)=ABM" D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G EDIT
 S DA=+Y
 S DIE="^ABMDCODE(",DR=".03;.04" D ^ABMDDIE K DR G XIT:$D(ABM("DIE-FAIL"))
 G EDIT
 ;
ADD S ABM("D")="^ABMDCODE(",ABM("D0")="QZEM",ABM("DS")="I $P(^(0),U,2)=ABM"
 K DIR
 S DIR("?",1)="Enter a number which will be a new "_ABM("TITL")_"."
 S DIR("?",2)=""
 S DIR("?")="(NOTE: Existing Codes are displayed by entering ""??"")"
 W !!
 S DIR(0)="FOA^1:3"
 S DIR("A")="Enter the CODE to be Added: "
 S DIR("??")="^S X=""??"",DIC=ABM(""D""),DIC(0)=ABM(""D0""),DIC(""S"")=ABM(""DS"") D ^DIC"
 D ^DIR
 G XIT:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!(X="")
 I $D(^ABMDCODE("AC",ABM,Y))=10 W !!?10,*7,"This CODE already exists!",!?5,"CODE: ",Y," - ",$P(^ABMDCODE($O(^(Y,"")),0),U,3) G ADD
 S ABM("Y")=Y
 W !!
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you wish to Add "_Y_" as a New "_ABM("TITL")
 D ^DIR
 G XIT:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!(X="")!(Y'=1)
 W !! S DIC="^ABMDCODE(",DIC(0)="L",X=ABM("Y"),DIC("DR")=".02////"_ABM_";.03;.04" K DD,DO D FILE^DICN
 I +Y>0 D
 . I +ABM("Y"),$E(ABM("Y"))=0 S ^ABMDCODE("AC",ABM,+ABM("Y"),+Y)=""
 . I +ABM("Y"),$L(ABM("Y"))<2 S ^ABMDCODE("AC",ABM,"0"_ABM("Y"),+Y)=""
 . W !!,"(Record has been Added)"
 E  W !!,*7,"** WARNING: Record was NOT Added! **"
 G ADD
 ;
XIT K ABM,DIR,DIC,DIE
 Q
