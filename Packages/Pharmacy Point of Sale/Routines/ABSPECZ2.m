ABSPECZ2 ; IHS/FCS/DRS - JWS 10:08 AM 22 Jun 1995 ;     [ 09/12/2002  10:00 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;DISPLAY NDC Electronic Claims (by PCN/Patient)
 ;----------------------------------------------------------------------
EN ;EP - option ABSP DISPLAY CLAIMS 1
 N SCRNTXT,ANS,PNAME,PCN,BITEMIEN,LPROMPT,LPROMPT2,IENS
 ;
 D DT^DICRW
 D HOME^%ZIS
 ;
 S SCRNTXT="DISPLAY NDC Electronic Claims (by PCN/VCN/Patient)"
 D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 W !
 ;
 ;Search PROMPT
LP1 S ANS=$$FREETEXT^ABSPOSU2("Billing Item Search (PCN#, VCN#, Patient):  ","",1,2,15,DTIME)
 S ANS=$$UCASE^ABSPOSU9($$CLIP^ABSPOSU9(ANS))
 G:ANS=-1!(ANS="^")!(ANS="^^")!(ANS="") EXIT
 ;
 ;Construct Billing Item List Based on Search PROMPT
 D EN1^ABSPES00(ANS,1000,$$OPENREF($$LIST))
 ; Next line might need a $GET?
 I '@$$LIST@(0) D  G LP1
 .W "    (No Entries Found!)",!
 .D PRESSANY^ABSPOSU5(1,60)
 .D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM)
 .W !
 ;
LP2 D KILL($$LISTANS)
 S LPROMPT(1)="Select Billing Item Record: "
 S ANS=$$LIST^ABSPOSU4("S",$$LIST,$$LISTANS,SCRNTXT,.LPROMPT,1,10,DTIME)
 S ANS=$$UCASE^ABSPOSU9($$CLIP^ABSPOSU9(ANS))
 I ANS="^" D WHEADER^ABSPOSU9(SCRNTXT,IOF,IOM) G LP1
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 ;
 D KILL($$LIST2)
 S BITEMIEN=$G(@$$LIST@(ANS,"I"))
 G:BITEMIEN="" EXIT
 S PNAME=$P(@$$LIST@(ANS,"E"),"  ",1)
 S PCN=$P($G(^ABSBITMS(9002302,BITEMIEN,0)),U,1)
 D EN1^ABSPES01(BITEMIEN,$$OPENREF($$LIST2))
 ; next line might need a $GET
 G:'@$$LIST2@(0) EXIT
 ;
LP3 D KILL($$LISTANS2)
 S LPROMPT2(1)=$$LJBF^ABSPOSU9("Claim Submission Record List:",40)_"PCN #:    "_$$LJBF^ABSPOSU9(PCN,30)
 S LPROMPT2(2)=$J("",40)_"Patient:  "_$$LJBF^ABSPOSU9(PNAME,30)
 ;
 S ANS=$$LIST^ABSPOSU4("S",$$OPENREF($$LIST2),$$OPENREF($$LISTANS2),SCRNTXT,.LPROMPT2,1,10,DTIME)
 G:ANS="^" LP2
 G:ANS=-1!(ANS="^^")!(ANS="") EXIT
 S IENS=$G(@$$LIST2@(ANS,"I"))
 G:IENS="" EXIT
 D DISPLAY^ABSPECZA(SCRNTXT,IENS)
 G LP3
 ;
EXIT ;K ^LIST($J),^LISTANS($J),^LIST2($J),^LISTANS2($J)
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
 D IMPOSS^ABSPOSUE("P","TI","wrong global name",REF,"KILL",$T(+0))
 Q:'OK  ; if they said "ignore", continue, but do not kill global
 K @REF
 Q
