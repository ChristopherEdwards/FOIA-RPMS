ABSPECZ3 ; IHS/FCS/DRS - JWS 01:51 PM 12 Sep 1995 ;      [ 09/12/2002  10:01 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;DISPLAY NDC Electronic Claims (by Response Status)
 ;----------------------------------------------------------------------
EN ;EP - option ABSP DISPLAY RESPONSES 1
 N SCRNTXT,ANS,PNAME,PCN,BITEMIEN,LPROMPT,LPROMPT2,IENS
 N SDATE,EDATE,RSPCODE
 ;
 D DT^DICRW
 D HOME^%ZIS
 ;
 S SCRNTXT="DISPLAY NDC Electronic Claims (by Response Status)"
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
 ;
 ;Start DATE PROMPT
 S (SDATE,EDATE)=""
LP1 S ANS=$$DATE^ABSPOSU1("Claims Transmitted On - Start DATE:  ",SDATE,1,"","DT","E",DTIME)
 G:ANS=-1!(ANS="^")!(ANS="^^")!(ANS="") EXIT
 S SDATE=ANS
 ;
 ;End DATE PROMPT
LP2 S ANS=$$DATE^ABSPOSU1("Claims Transmitted On - End DATE:  ",EDATE,1,SDATE,"DT","E",DTIME)
 I ANS="^" D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM) G LP1
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 S EDATE=ANS
 ;
 ;Response Status PROMPT
LP3 S ANS=$$SET^ABSPOSU3("Select Response Status","R",1,"V","R:Rejected Medication;P:Payable Medication;C:Captured Medication;D:Duplicate Medication",DTIME)
 I ANS="^" D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM) G LP2
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 S RSPCODE=ANS
 ;
 ;Construct Billing ITEM List Based on Search PROMPT
 D KILL($$LIST)
 ;S ^JON=SDATE_U_EDATE_U_RSPCODE
 D EN1^ABSPES02(SDATE,EDATE,RSPCODE,1000,$$OPENREF($$LIST))
 ; next line may need a $GET
 I '@$$LIST@(0) D  G LP1 ; 03/12/2001 added '
 .W "    (No Entries Found!)",!
 .D PRESSANY^ABSPOSU5(1,60)
 .D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 .W !
 ;
LP4 D KILL($$LISTANS)
 S LPROMPT(1)="NDC Electronic Claim Response List:"
 S ANS=$$LIST^ABSPOSU4("S",$$OPENREF($$LIST),$$OPENREF($$LISTANS),SCRNTXT,.LPROMPT,1,10,DTIME)
 I ANS="^" D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM) G LP1
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 S IENS=$G(@$$LIST@(ANS,"I"))
 G:IENS="" EXIT
 D DISPLAY^ABSPECZA(SCRNTXT,IENS)
 G LP4
 ;
EXIT ;K ^LIST($J),^LISTANS($J)
 Q
ROU() Q $T(+0)
Q() Q """"
C() Q ","
LIST() Q "^TMP("_$$Q_$$ROU_$$Q_$$C_$J_$$C_$$Q_"LIST"_$$Q_")"
LIST2() Q "^TMP("_$$Q_$$ROU_$$Q_$$C_$J_$$C_$$Q_"LIST2"_$$Q_")"
LISTANS() Q "^TMP("_$$Q_$$ROU_$$Q_$$C_$J_$$C_$$Q_"LISTANS"_$$Q_")"
LISTANS2() Q "^TMP("_$$Q_$$ROU_$$Q_$$C_$J_$$C_$$Q_"LISTANS2"_$$Q_")"
OPENREF(X)         Q $E(X,1,$L(X)-1)_","
KILL(REF)          ; safety - make sure it's really an ^TMP node
 N OK S OK=0
 I REF=$$LIST S OK=1
 I REF=$$LIST2 S OK=1
 I REF=$$LISTANS S OK=1
 I REF=$$LISTANS2 S OK=1
 I 'OK D IMPOSS^ABSPOSUE("P","TI","wrong global name",REF,"KILL",$T(+0))
 Q:'OK  ; if they said "ignore", continue, but do not kill global
 K @REF
 Q
