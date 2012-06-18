ABSPOSMZ ; IHS/FCS/DRS - General Inquiry/Report .57; [ 09/12/2002  10:15 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
ASKPHARM() ; EP - Lookup pharmacy (the POS pharmacy, that is)
 ; Return pointer to 9002313.56
 N DIC,X,Y,DINUM,DTIME,DLAYGO
 S DIC=9002313.56,DIC(0)="AEMQ"
 D ^DIC
 Q $S(Y>0:+Y,1:"")
ASKPAT() ; EP - Lookup patient - patient must have a Point of Sale transaction
 ; Return patient IEN, return false if none selected
 N DIC,X,Y,DINUM,DTIME,DLAYGO
 S DIC=2,DIC(0)="AEMQ"
 S DIC("S")="I $D(^ABSPTL(""AC"",Y))"
 D ^DIC
 Q $S(Y>0:+Y,1:"")
ASKRTYPE() ; EP - Lookup result type
 ; Return the name of the result type, null if none selected
 N DIC,X,Y,DINUM,DTIME,DLAYGO
 S DIC=9002313.83,DIC(0)="AEMQ"
 D ^DIC
 Q $S(Y>0:$P(^ABSPF(9002313.83,+Y,0),U),1:"")
OUTPUT() ; EP - ask for output type
 ; Returns one of the codes in OUTMENU, below.  Or "" if no selection.
 N DIR,X,Y
 S DIR(0)="SAO^"
 S DIR("A")="Select style of output: "
 N I,X W !! F I=1:1 S X=$P($T(OUTMENU+I),";",2) Q:X="*"  D
 . S DIR(0)=DIR(0)_X_";"
 . W ?5,$P(X,":"),?10,$P(X,":",2),!
 S DIR("B")=$G(ABSPOSMA("OUTPUT TYPE")) S:DIR("B")="" DIR("B")="S"
 D ^DIR
 Q $S("^^"[Y:"",1:Y)
OUTMENU ;
 ;D:DUR info only
 ;F:Financial Detail
 ;C:Claim - Basic info
 ;S:Transaction Summary only
 ;R:Response info
 ;J:Rejection Codes Detail
 ;*
 ;T:Total Detail
 ;REC:Summary Receipt
 ;PT:Print Template selection
 ;FM:Fileman to customize output
DEFOUT() ; EP - return code of first item in OUTMENU
 N X S X=$T(OUTMENU+1)
 Q $P($P(X,";",2),":")
SORTDATE() ; EP - ask which date to sort by
 ; Returns "T" for transaction date, "R" for released date, or ""
 N DIR,X,Y S DIR(0)="SAO^"
 S DIR("A")="Select by which date? "
 S DIR("B")="T"
 N I,X W !! F I=1:1 S X=$P($T(DATEMENU+I),";",2) Q:X="*"  D
 . S DIR(0)=DIR(0)_X_";"
 . W ?5,$P(X,":"),?10,$P(X,":",2),!
 D ^DIR
 Q $S("^^"[Y:"",1:Y)
DATEMENU ;
 ;T:Transaction date
 ;R:Released date
 ;*
DATES(DEF) ; EP -
 N PR1,PR2,DEF1,DEF2
 S PR1="Starting with "_ABSPOSMA("BY WHICH DATE")_" date: "
 S PR2="   Going thru "_ABSPOSMA("BY WHICH DATE")_" date: "
 S DEF1=$P(DEF,U),DEF2=$P(DEF,U,2)
 ;I ABSPOSMA("BY WHICH DATE")="TRANSACTION" D
 ;. S DEF1=$G(ABSPOSMA("SORT",7,"FR"))
 ;. S DEF2=$G(ABSPOSMA("SORT",7,"TO"))
 ;E  D
 ;. S DEF1=$G(ABSPOSMA("SORT",9999.95,"FR"))
 ;. S DEF2=$G(ABSPOSMA("SORT",9999.95,"TO"))
 I 'DEF2 S DEF2=$E($$NOW^ABSPOS,1,7+1+2+2) ; today (down to the minute)
 I 'DEF1 S DEF1=$$TADD^ABSPOSUD(DEF2\1,-7) ; a week ago
 W !
 Q $$DTR^ABSPOSU1(PR1,PR2,DEF1,DEF2,"T")
MODE() ; EP - ask which mode to run in - Inquiry or Report
 ; Returns "I" for inquiry mode, "R" for report mode, or ""
 N DIR,X,Y S DIR(0)="SAO^"
 S DIR("A")="Inquiry or Report mode? "
 S DIB("B")="I"
 N I,X W !! F I=1:1 S X=$P($T(MODEMENU+I),";",2) Q:X="*"  D
 . S DIR(0)=DIR(0)_X_";"
 . W ?5,$P(X,":"),?10,$P(X,":",2),!
 S DIR("B")=$E($G(ABSPOSMA("MODE"))) S:DIR("B")="" DIR("B")="I"
 D ^DIR
 Q $S("^^"[Y:"",1:Y)
MODEMENU ;
 ;I:Inquiry mode (choose from list)
 ;R:Report mode (just print, no choosing)
 ;*
