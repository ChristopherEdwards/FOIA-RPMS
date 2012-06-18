ABSPOSPW ; IHS/FCS/DRS - automatic writeoffs - criteria on form ;    [ 09/12/2002  10:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
PARAMS ; used as a header
 ;N (U,DT,DUZ,IOM,PARAMS) ;
 N FN,DIC,DR,DA,DIQ,ARR,X,DI,Y
 S (FN,DIC)=9002313.99,DR="2270:2280",DA=1,DIQ="ARR",DIQ(0)="IE"
 D EN^DIQ1
 S X=$G(ARR(FN,1,2270.01,"E"))
 I X'?1"ALL".E D
 . W "Insurers: ",X,":   "
 . D PARAMS1("INS","^AUTNINS")
 S X=$G(ARR(FN,1,2270.02,"E"))
 I X'?1"ALL".E D
 . W "A/R types: ",X,":   "
 . D PARAMS1("ARTYP","^ABSBTYP")
 S X=$G(ARR(FN,1,2270.06,"E"))
 I X'?1"ALL".E D
 . W "Clinics: ",X,":   "
 . D PARAMS1("CLINIC","^DIC(40.7)")
 S X=$G(ARR(FN,1,2270.7,"E"))
 I X'?1"ALL".E D
 . W "Primary diagnosis: ",X,":   "
 . D PARAMS1("DIAG","^ICD9")
 W "Balances from $",$J($P(PARAMS,U,3),0,2)
 W " thru $",$J($P(PARAMS,U,4),0,2),"; "
 I $P(PARAMS,U,9) W "no more than ",$P(PARAMS,U,9),"% of original amount.",!
 W "Account age over ",$P(PARAMS,U,5)," days;  "
 W "Date of service no later than " S Y=$P(PARAMS,U,8) X ^DD("DD") W Y,!
 W "Writeoff reason to put with adjustment: ",$G(ARR(FN,1,2270.12,"E")),!
 S X=$G(ARR(FN,1,2270.11,"E"))
 I X'="DON'T CONSIDER" W "Previous payment required: ",X,!
 Q
PARAMS1(SUB,ROOT)  ; $P(PARAMS(SUB,"B",*),U) points to ROOT
 N A S A=0
 F  S A=$O(PARAMS(SUB,"B",A)) Q:'A  D
 . N X S X=$P(@ROOT@(A,0),U)
 . I $X+$L(X)'<$S($G(IOM):IOM-2,1:80-2) W !?5
 . W X
 . I $O(PARAMS(SUB,A)) W ", "
 . E  W !
 I $X>0 W !
 Q
TEMPLNAM(WHICH)    ; WHICH="SORT" or "PRINT"
 I WHICH="PRINT" Q "ABSPOSPW"
 D IMPOSS^ABSPOSUE("P","TI","Bad parameter WHICH="_WHICH,,"TEMPLNAM",$T(+0))
 Q ""
TEMPLNUM(WHICH)    ;
 N NAME S NAME=$$TEMPLNAM(WHICH)
 I WHICH="SORT" Q $O(^DIBT("B",NAME,0))
 I WHICH="PRINT" Q $O(^DIPT("B",NAME,0))
 D IMPOSS^ABSPOSUE("P","TI","Bad parameter WHICH="_WHICH,,"TEMPLNUM",$T(+0))
 Q ""
SEARCH ;
 K ^TMP($J,ROU) S ^TMP($J,ROU)=0
 N L S L="<THIS SHOULDN'T PRINT>"
 N DIC S DIC=9002302
 N FLDS S FLDS="["_$$TEMPLNAM("PRINT")_"]"
 N BY S BY="2,1,@2.8" ;audit insurer, patient, date created ;"["_$$TEMPLNAM("SORT")_"]"
 N FR,TO S (FR,TO)=""
 N DHD S DHD="W ?0 D PARAMS^"_$T(+0)
 N DIASKHD,DIPCRIT,PG ; keep these undef
 N DHIT S DHIT="S ^TMP($J,ROU,D0)="""",^TMP($J,ROU)=^TMP($J,ROU)+1"
 N DIOEND,DCOPIES,IOP,DQTIME ; keep these undef
 N DIS S DIS(0)="I $$INCLUDE^ABSPOSPX" ; screening
 N DISUPNO,DISTOP ; keep these undef
 S BY(0)="^ABSBITMS(9002302,""AF"",",L(0)=2
 S (FR(0,1),TO(0,1))="A" ; only the active accounts
 ;W !,"This is where we call DO EN1^DIP",!
 N NINCLUDE S NINCLUDE=0
 D EN1^DIP
 ;W !,"returned from DO EN1^DIP",!
 Q
EN ;EP - option ABSP WRITEOFF SELECTION
 Q:$$MUSTILC^ABSPOSB
 N ACTIVBAT S ACTIVBAT=$$ACTIVBAT^ABSPOSPX I ACTIVBAT D  H 2 Q
 . W !!,"Batch #",ACTIVBAT," must be dealt with first.",!
 . W "Either post the batch (BE SURE THAT'S REALLY WHAT YOU WANT TO DO!),",!
 . W "or cancel the batch, before running this program to create a new batch.",!
 N ROU S ROU=$T(+0)
 N X D
 . N LOCKREF S LOCKREF="^ABSP(9002313.99,1,""WRITEOFF-SCREEN"")"
 . L +@LOCKREF:0 I '$T D  S X="" Q
 . . W "Someone else is using the Writeoffs program now.",!
 . S X=$$MYSCREEN
 . I X S X=$G(^ABSP(9002313.99,1,"WRITEOFF-SCREEN"))
 . E  S X=""
 . L -@LOCKREF
 I X="" W "Nothing done",! H 2 Q  ; didn't get <F1>E
 N PARAMS M PARAMS=^ABSP(9002313.99,1,"WRITEOFF-SCREEN")
 M PARAMS("INS")=^ABSP(9002313.99,1,"WRITEOFF-SCREEN INSURER")
 M PARAMS("ARTYP")=^ABSP(9002313.99,1,"WRITEOFF-SCREEN ARTYPE")
 M PARAMS("CLINIC")=^ABSP(9002313.99,1,"WRITEOFF-SCREEN CLINIC")
 M PARAMS("DIAG")=^ABSP(9002313.99,1,"WRITEOFF-SCREEN DIAG")
 ;
 D  ; all we want are the "B" indexes of the merged lists
 . N A S A="" F  S A=$O(PARAMS(A)) Q:A=""  D
 . . N B S B="" F  S B=$O(PARAMS(A,B)) Q:B=""  K:B'="B" PARAMS(A,B)
 ;D PARAMS R ">>>",% ; temporary!
 ; If the age of account has been specified, calculate now the
 ; aging date, going back N+1 days
 I $P(PARAMS,U,5) S PARAMS("AGING DATE < THIS")=$$AGECALC
 W !!,"Choose a device for printing a list of the accounts",!
 W "which meet the criteria you've just specified.",!?5
 D SEARCH ; EN1^DIP calls the printing, too
 I '^TMP($J,ROU) D  Q
 . W !,"NO accounts match the given criteria.",!
 W !,"Number of accounts found: ",^TMP($J,ROU),!
 I '$$DOBATCH Q
 ; and we just have to apply it to the list in ^TMP($J,ROU,*)
 W !,"Creating the adjustments batch...",!
 N BATCH S BATCH=$$NEWBATCH^ABSPOSP(1)
 I 'BATCH W "FAILED",! Q
 W "The batch number is ",BATCH,!
 S $P(^ABSP(9002313.99,1,"WRITEOFF-SCREEN BATCH"),U)=BATCH
 N PCNDFN S PCNDFN=0
 N REASON S REASON=$P(PARAMS,U,12)
 I REASON?1N.N S REASON=$P(^ABSADJR(9002320,REASON,0),U,2)
 I REASON="" S REASON="(from write-off selection screen)"
 F  S PCNDFN=$O(^TMP($J,ROU,PCNDFN)) Q:'PCNDFN  D
 . N BAL S BAL=$P(^ABSBITMS(9002302,PCNDFN,3),U)
 . D ADJUST^ABSPOSP(PCNDFN,BATCH,BAL,REASON)
 . W "." W:$X>70 !
 W !!
 W "Batch ",BATCH," has been created.",!
 W "You should inspect it SOON and either POST it or CANCEL it.",!
 W "Either way, take care of it BEFORE running this program again.",!
 W "This is to avoid the situation of generating more than one",!
 W "writeoff adjustment for any accounts.",!!
 D PRESSANY^ABSPOSU5()
 Q
DOBATCH()          ; 
 N PROMPT,DEFAULT,OPT,TIMEOUT
 S PROMPT="Create an ADJUSTMENTS BATCH for these write-offs now?"
 S DEFAULT="NO"
 S OPT=0
 S TIMEOUT=3600*72 ; the kind of thing you might start then go home
 N X S X=$$YESNO^ABSPOSU3(PROMPT,DEFAULT,OPT,TIMEOUT)
 Q +X
AGECALC()          ; 
 N X1 S X1=$P($$NOW,".")
 N X2 S X2=-$P(PARAMS,U,5)
 N X,%H D C^%DTC
 Q X
NOW() N %,%H,%I,X D NOW^%DTC Q %
MYSCREEN()       ; returns 1 if <F1>E (or the equivalent) was used
 ; if the user quits out (<F1>Q or the equivalent), returns 0
 N DDSFILE,DR,DDSPAGE,DDSPARM
 N DDSCHANG,DDSSAVE,DIMSG,DTOUT
 N DA
 S DDSFILE=9002313.99,DA=1
 S DR="[ABSP ABSPOSPW]"
 S DDSPARM="CS"
 D ^DDS
 Q:'$Q
 I $G(DDSSAVE) Q 1
 E  Q 0
