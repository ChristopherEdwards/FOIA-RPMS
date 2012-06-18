ABSPOSF ; IHS/FCS/DRS - Print NCPDP claim ;    [ 09/12/2002  10:08 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;
 ; Directory of ABSPOSF* routines:
 ;
 ; ABSPOSF - main entry points
 ; ABSPOSFA - SORT and PRINT
 ; ABSPOSFB-ABSPOSFD - assemble ABSP() and NCPDP() arrays
 ; ABSPOSFP - the actual printing takes place here
 ; ABSPOSFX - details of the alignment (test print)
 ;
 Q
PRINT ; EP - ; For printing forms at a site which doesn't have ILC A/R:
 ; Option name ABSP NCPDP FORMS PRINT
 ;    prompt for a date range
 ;    and "start at insurer"
 ;    and "are you sure?"
 N PROMPT1,PROMPT2,DEF1,DEF2
 S PROMPT1="Starting with what transaction date? "
 S PROMPT2="  Ending with what transaction date? "
 S DEF1="",DEF2=""
 W !!,"Print NCPDP Pharmacy Claim Forms",!!
 N RANGE S RANGE=$$DTR^ABSPOSU1(PROMPT1,PROMPT2,DEF1,DEF2,1) W !
 I 'RANGE Q
 N X S X=$P(RANGE,U,2) ; go through end of last day, if no time given
 I $P(X,".",2)="" S $P(X,".",2)=24,$P(RANGE,U,2)=X
 ;
 ; Start printing at what insurer?
 ;
 N INSFIRST S INSFIRST=$$INSFIRST Q:"^^"[INSFIRST
 ;
 ; Build ^TMP("ABSPOSF",$J,1,ien57)=""
 W !,"Now building a list of transactions for which to print forms...",!
 K ^TMP("ABSPOSF",$J)
 ; Scan ^ABSPTL("AH",last update date-time,ien57)
 N COUNT S COUNT=0
 N WHEN S WHEN=$P(RANGE,U) ; start at the start time
 F  D  Q:'WHEN  Q:WHEN>$P(RANGE,U,2)  ; scan thru the end time
 . N IEN57 S IEN57=0
 . F  S IEN57=$O(^ABSPTL("AH",WHEN,IEN57)) Q:'IEN57  D
 . . ; Include only transactions whose RESULT WITH REVERSAL = "PAPER"
 . . Q:$$GET1^DIQ(9002313.57,IEN57_",","RESULT WITH REVERSAL")'="PAPER"
 . . ; Exclude:
 . . ;  1. No insurance
 . . N INS S INS=$P(^ABSPTL(IEN57,1),U,6) Q:'INS
 . . N INSNAME S INSNAME=$P($G(^AUTNINS(INS,0)),U) Q:INSNAME=""
 . . ;  3. Insurance name comes before starting point
 . . I INSFIRST]INSNAME Q
 . . I $$UNINS^ABSPOSF(INSNAME) Q  ;names like SELF PAY or UNINSURED
 . . ;  2. Any with a subsequent transaction for the same ENTRY #
 . . N RXIRXR S RXIRXR=$P(^ABSPTL(IEN57,0),U)
 . . I $O(^ABSPTL("B",RXIRXR,IEN57)) Q
 . . ; Succeeded: this transaction deserves a claim form
 . . S ^TMP("ABSPOSF",$J,1,IEN57)=""
 . . S COUNT=COUNT+1
 . S WHEN=$O(^ABSPTL("AH",WHEN)) ; bump up to next transaction time
JOIN ; REPRINT joins here
 W !,"Number of claims: ",COUNT,!
 I 'COUNT Q
 I COUNT>1 D
 . W "Note: because some forms may have two claims on the same page,",!
 . W "you might print fewer than ",COUNT," forms.",!
 N X S X=$$YESNO^ABSPOSU3("Okay to proceed","",0)
 I X'=1 D  Q
 . W !,"Nothing done.",!
 D SORT^ABSPOSFA
 D PRINT^ABSPOSFA
 ; 
 Q
ALIGN ;EP - align NCPDP forms
 ; Option name ABSP NCPDP FORMS ALIGN
 W !,"Test print for NCPDP forms",!
 N POP D ^%ZIS Q:$G(POP)
ALIGN1 U IO
 D ALIGN^ABSPOSFX
 U $P
 I $$YESNO^ABSPOSU3("Print again","NO",1) G ALIGN1
 D ^%ZISC
 Q
REPRINT ;EP - reprint selected NCPDP forms
 ; Option name ABSP NCPDP FORMS REPRINT
 W !!,"Reprint selected NCPDP forms",!!
 W "First, select the patient(s).",!
 N PATARRAY,PAT57,IEN57
 F  S PAT57=$$PAT57 Q:'PAT57  S PATARRAY(PAT57)=""
 I '$O(PATARRAY("")) Q  ; none selected
 W !!,"Choose a transaction date or range of transaction dates",!
 W "for which to reprint NCPDP forms for the selected patient(s).",!
 N RANGE S RANGE=$$DTR^ABSPOSU1(PROMPT1,PROMPT2,DEF1,DEF2,1) W !
 I 'RANGE Q
 N X S X=$P(RANGE,U,2) ; go through end of last day, if no time given
 I $P(X,".",2)="" S $P(X,".",2)=24,$P(RANGE,U,2)=X
 W !,"Gathering the selected transactions..." S COUNT=0
 N WHEN S WHEN=$P(RANGE,U)
 F  D  Q:'WHEN  Q:WHEN>$P(RANGE,U,2)
 . S IEN57=0
 . F  S IEN57=$O(^ABSPTL("AH",WHEN,IEN57)) Q:'IEN57  D
 . . S PAT57=$P(^ABSPTL(IEN57,0),U,6)
 . . Q:'PAT57  Q:'$D(PATARRAY(PAT57))
 . . S ^TMP("ABSPOSF",$J,1,IEN57)="",COUNT=COUNT+1
 . S WHEN=$O(^ABSPTL("AH",WHEN))
 N INSFIRST S INSFIRST=" "
 G JOIN ; up above - to SORT and PRINT
PAT57() ; Lookup patient in 9002313.57 transactions
 N DIC,X,DLAYGO,Y
 S DIC=2,DIC(0)="AMQ"
 S DIC("A")="Reprint for which patient?"
 S DIC("S")="I $D(^ABSPTL(""AC"",Y)"
 D ^DIC W !
 I Y<0 Q $S($D(DTOUT):"^",$D(DUOUT):"^",1:"")
 S Y=+Y
 N IEN57 S IEN57=$O(^ABSPTL("AC",Y,0))
 N DATE1 S DATE1=$P(^ABSPTL(IEN57,0),U,8)\1
 S IEN57=$O(^ABSPTL("AC",Y,""),-1)
 N DATE2 S DATE2=$P(^ABSPTL(IEN57,0),U,8)\1
 W ?10,"Transaction date" I DATE1'=DATE2 W "s" W " "
 S Y=DATE1 X ^DD("DD") W Y
 I DATE1'=DATE2 S Y=DATE2 X ^DD("DD") W " - ",Y
 W !
 Q
ILCPRINT ; EP - ; For printing forms from ILC A/R pre-bill list
 ; Build ^TMP("ABSPOSF",$J,1,ien57)
 W !,"Print NCPDP forms",!
 N INSFIRST S INSFIRST=$$INSFIRST Q:"^^"[INSFIRST
 I INSFIRST]" " D
 . W !,"Note:  if you answer YES to an ""Okay to update bills?"" question,",!
 . W "later on in the ILC A/R system, it will update all the bills,",!
 . W "not only the ones which were printed starting at ",INSFIRST,".",!
 W !,"Gathering claims from the NCPDP Prebill List in the A/R system..."
 K ^TMP("ABSPOSF",$J)
 N PCNDFN S PCNDFN=0
 ; Loop through the ILC A/R Prebilling list for NCPDP forms:
 F  S PCNDFN=$O(^ABSBITMS(9002302,"APRX1",1,PCNDFN)) Q:'PCNDFN  D
 . I INSFIRST]" ",INSFIRST]$$ILCINSNM(PCNDFN) Q  ; starting at later pt
 . N IEN57 S IEN57=0
 . F  S IEN57=$O(^ABSPTL("C",PCNDFN,IEN57)) Q:'IEN57  D
 . . S ^TMP("ABSPOSF",$J,1,IEN57)=""
 W !
 D SORT^ABSPOSFA
 I '$$YESNO^ABSPOSU3("Okay to continue","",0) W !
 D PRINT^ABSPOSFA
 Q
INSFIRST() ; returns where to start printing or "" or "^" or "^^" to cancel
 N RET
 S RET=$$YESNO^ABSPOSU3("Print for all insurers","YES",0)
 I RET=1 Q " " ; start at beginning, then
 I RET'=0 Q RET ; back out
 ; No, don't start at beginning
 S RET=$$FREETEXT^ABSPOSU2("Print forms alphabetically starting where"," ",1,1,30) W !
 Q RET
ILCINS(PCNDFN) ; EP - get the ILC insurer IEN
 N X S X=$P($G(^ABSBITMS(9002302,PCNDFN,0)),U,4) ; int. audit ins.
 I 'X S X=1
 I '$D(^ABSBITMS(9002302,PCNDFN,"INSCOV1",X,1)) Q
 S X=$P(^ABSBITMS(9002302,PCNDFN,"INSCOV1",X,1),U,2)
 I X S INSIEN=X
 Q
ILCINSNM(PCNDFN) ; EP - get the ILC insurer name
 Q $P(^ABSBITMS(9002302,PCNDFN,0),U,3) ; easy - AUDIT INSURER field
UNINS(NAME) ; EP - is it an uninsured kind of pseudo-insurance
 I NAME?1"SELF".E Q 1
 I NAME?1"UNINS".E Q 1
 Q 0
