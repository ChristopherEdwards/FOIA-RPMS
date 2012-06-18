BARACSI ; IHS/SD/LSL - CLAIM STATUS INQUIRY (276) ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
DOC ;
 ; IHS/SD/LSL - 09/24/02 - V1.6 Patch 3 - HIPAA
 ;     Created routine.  Called by BARM/ACCM/CSI
 ;;
 Q
 ; *********************************************************************
EN ; EP
 ; Electronic Signature test
 D GIS                         ; Make sure GIS installed
 I '+BARGIS D EXIT Q           ; GIS not installed
 D ^BARVKL0                    ; kill namespace variables
 I '$D(BARUSR) D INIT^BARUTL   ; Initialize BAR environment
 D MSG                         ; Display note
 F  D LOOP Q:'+BARBIL          ; Ask A/R bills loop
 D DISPSUM                     ; Display request summary
 I $D(BARSUM) D ASKDEV         ; Ask print
 D EOP^BARUTL(1)               ; Press return to continue
 D EXIT                        ; Clean up and exit
 Q
 ; *********************************************************************
GIS ; EP
 ; Verify GIS 3.01 patches 2 and 6 are present
 S BARGIS=1
 S BARGIS2=$$INSTALLD("GIS*3.01*2")
 S BARGIS6=$$INSTALLD("GIS*3.01*6")
 I 'BARGIS2!('BARGIS6) D  Q
 . S BARGIS=0
 . W !!,$$CJ^XLFSTR("GIS V3.01 Patches 2 and 6 are required for this option",IOM)
 . I 'BARGIS2 S BARSTRNG="You are missing patch 2"
 . I 'BARGIS6 S BARSTRNG="You are missing patch 6"
 . I 'BARGIS2,'BARGIS6 S BARSTRNG="You are missing patches 2 and 6"
 . W !,$$CJ^XLFSTR(BARSTRNG,IOM)
 . W !,$$CJ^XLFSTR("Please contact you site manager for assistance",IOM)
 . D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
MSG ;
 S $P(BARSTAR,"*",81)=""
 S $P(BARDASH,"-",81)=""
 W !!!,BARSTAR
 W !,"*",?79,"*"
 W !,"* "
 W ?3,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 W ?9,"Not all insurers may be participating in the Claim Status Inquiry.",?79,"*"
 W !,"*",?9,"Check your EDI PAYER LIST (SPE) for a complete list of insurers.",?79,"*"
 W !,"*",?79,"*"
 W !,BARSTAR,!
 Q
 ; ********************************************************************
LOOP ;
 ; Find A/R bill, perform checks, populate holding file, send inquiry
 ; BAREPASS = Patient^DOS Start^DOS End^A/R BILL IEN
 W !
 K BARPAT,BARZ
 S BARBIL=1                    ; Bill Entry Loop Flag
 S BAREPASS=$$GETBIL^BARFPST3  ; Get bills by bill, patient, or DOS
 I BAREPASS=0 S BARBIL=0 Q     ; No bill selected; End loop
 S BARPASS=$P(BAREPASS,U,1,3)  ; Patient^DOS Start^DOS End
 ; If no A/R Bill IEN
 I '+$P(BAREPASS,U,4) D FINDBIL
 Q:'+$P(BAREPASS,U,4)          ; User still not Identify bill
 D DISP                        ; Display Bill data
 D EDIMSG                      ; Set BAREDI=0 if not EDI Payer
 Q:'+BAREDI
 D NOTE                        ; Display bill notes
 D ASK                         ; Ask if user wants to send request
 Q:'+BARSEND                   ; Send Claim Status Request (276) flag
 D SEND                        ; Create entry in 90056.08, call GIS
 Q:BARECLST'>0                 ; Entry creation failed.
 D ACCUM                       ; Accumulate summary data
 Q
 ; ********************************************************************
FINDBIL ;
 ; ^BARPST2 sets ^TMP($J,"B",BARCNT,BILL IEN)=""
 S BARASK=1
 S BARCNT=$$EN^BARPST2(BARPASS)  ; Count bills for DOS range
 I 'BARCNT D  Q                  ; No bills found  
 . W *7
 . W !,"No bills found in this date range!"
 I BARCNT=1 D  Q                 ; One bill found for DOS range
 . S $P(BAREPASS,U,4)=$O(^BARTMP($J,"B",BARCNT,""))
 ; More than one bill found for DOS range, display, ask user to select
 D HIT^BARFPST3(BARPASS)         ; List bills for DOS range
 D ASKLIN^BARFPST3 Q:'+BARASK    ; Ask user to select one 
 S $P(BAREPASS,U,4)=$O(^BARTMP($J,"B",BARLIN,""))  ; A/R Bill IEN
 Q
 ; ********************************************************************
DISP ;
 ; Get and Display data
 S BARDFN=$P(BAREPASS,U)
 S BARBL=$P(BAREPASS,U,4)
 D GETS^DIQ(90050.01,BARBL,".01;3;13;15;17.2;18;101;102;108;114","IE","TMP")
 M BARINQ=TMP(90050.01,BARBL_",")
 K TMP
 S BARIENS=BARINQ(108,"I")_","_BARDFN_","
 S BARINQ("HRN")=$$GET1^DIQ(9000001.41,BARIENS,.02)
 S:BARINQ("HRN")="" BARINQ("HRN")="no HRN"
 W $$EN^BARVDF("IOF")
 W !!?4,"Patient: ",$E(BARINQ(101,"E"),1,30)," [",BARINQ("HRN"),"]",?54,"Bill: ",$E(BARINQ(.01,"E"),1,20)
 W !,"A/R Account: ",$E(BARINQ(3,"E"),1,30),?47,"Bill Status: ",$E(BARINQ(17.2,"E"),1,20)
 W !!,"Visit Date",?13,"Visit Type",?35,"Date Billed",?49,"Amount Billed",?65,"Current Balance"
 W !,BARDASH
 W !,$$SDT^BARDUTL(BARINQ(102,"I"))        ; Visit Date
 W ?13,$E(BARINQ(114,"E"),1,20)            ; Visit Type
 W ?35,$$SDT^BARDUTL(BARINQ(18,"I"))       ; Date Billed
 W ?49,$J($FN(BARINQ(13,"E"),",",2),13)    ; Amount Billed
 W ?65,$J($FN(BARINQ(15,"E"),",",2),15)    ; Current Balance
 Q
 ; ********************************************************************
EDIMSG ;
 ; Check EDI Payer list and Write various EDI messages
 K BARMSG,BARMSG2
 S BAREDI=0
 D EDICHK
 I $G(BARMSG)]"" D  Q
 . W !!?16,"**UNABLE TO REQUEST CLAIM STATUS FOR THIS BILL**"
 . W !?((80-$L(BARMSG))/2),BARMSG
 . I $G(BARMSG2)]"" W !?((80-$L(BARMSG2))/2),BARMSG2
 S BAREDI=1
 Q
 ; ********************************************************************
EDICHK ;
 I $P($G(^BARAC(DUZ(2),BARINQ(3,"I"),0)),U)'["AUTNINS" D  Q
 . S BARMSG="**"_BARINQ(3,"E")_" is not an Insurer.**"
 I '$D(^BAR(90052.06,DUZ(2),DUZ(2),1,BARINQ(3,"I"))) D  Q
 . S BARMSG="**"_BARINQ(3,"E")_" is not in the EDI PAYER LIST.**"
 . S BARMSG2="**Please check Site Parameters.**"
 I $D(^BAR(90052.06,DUZ(2),DUZ(2),1,BARINQ(3,"I"))) D  Q
 . S BARINQ("EDIPYR")=$G(^BAR(90052.06,DUZ(2),DUZ(2),1,BARINQ(3,"I"),0))
 . I '+$P(BARINQ("EDIPYR"),U,2) D  Q
 .. S BARMSG="**"_BARINQ(3,"E")_" does not have an EDI Effective Date.**"
 .. S BARMSG2="**Please check the EDI PAYER LIST in Site Parameters.**"
 . I $P(BARINQ("EDIPYR"),U,2)>DT D  Q
 .. S BARMSG="**"_BARINQ(3,"E")_" cannot accept claim requests until "_$$SDT^BARDUTL($P(BARINQ("EDIPYR"),U,2))_".**"
 .. S BARMSG2="**Please check the EFFECTIVE DATE of the EDI PAYER LIST in Site Parameters.**"
 . I +$P(BARINQ("EDIPYR"),U,3),$P(BARINQ("EDIPYR"),U,3)<DT D  Q
 .. S BARMSG="**"_BARINQ(3,"E")_" STOPPED accepting claim requests on "_$$SDT^BARDUTL($P(BARINQ("EDIPYR"),U,3))_".**"
 .. S BARMSG2="**Please check the END DATE of the EDI PAYER LIST in Site Parameters.**"
 Q
 ; ********************************************************************
NOTE ;
 K BARNOTE
 S BARCNT=1
 W !!!
 I $D(^BARECLST("BILL",DUZ(2),BARBL)) D
 . S BARTRC=$O(^BARECLST("BILL",DUZ(2),BARBL,""),-1)   ; Most recent req
 . S BARRQDT=$$GET1^DIQ(90056.08,BARTRC,.04)          ; Request Date
 . S BARRPDT=$$GET1^DIQ(90056.08,BARTRC,101)          ; Response Date
 . S BARNOTE(BARCNT)=BARINQ(.01,"E")_" was last submitted for status on "_BARRQDT
 . S BARCNT=BARCNT+1
 . I BARRPDT="" S BARNOTE(BARCNT)="and a response has yet to be received."
 . E  S BARNOTE(BARCNT)="and a response was received on "_BARRPDT
 . S BARCNT=BARCNT+1
 I BARINQ(15,"I")<.01 D
 . S BARNOTE(BARCNT)=BARINQ(.01,"E")_" does NOT have a positive balance."
 I $D(BARNOTE) D
 . I $O(BARNOTE(""),-1)>1 W $$EN^BARVDF("RVN"),"NOTES:",$$EN^BARVDF("RVF")
 . E  W $$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 . S BARCNT=0
 . F  S BARCNT=$O(BARNOTE(BARCNT)) Q:'+BARCNT  D
 .. W ?8,BARNOTE(BARCNT),!
 Q
 ; ********************************************************************
ASK ;
 ; Ask user if they want to send the request
 S BARSEND=0
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Do you wish to send this bill for status to "_BARINQ(3,"E")
 S DIR("B")="Yes"
 D ^DIR
 K DIR
 I Y=1 S BARSEND=1
 Q
 ; ********************************************************************
SEND ;
 ; Create entry in A/R EDI CLAIM STATUS File and call GIS
 S BARINQ("PYR")=$P($P(^BARAC(DUZ(2),BARINQ(3,"I"),0),U),";")
 S BARINQ("PYRID")=$P($G(^AUTNINS(BARINQ("PYR"),0)),U,8)
 K DIC,DA,X,Y
 S DIC="^BARECLST("
 S DIC(0)="LZE"
 S X=$O(^BARECLST("B",""),-1)
 S X=X+1
 S DINUM=X
 S DIC("DR")=".02///^S X=BARINQ(.01,""E"")"
 S DIC("DR")=DIC("DR")_";.03////^S X=DUZ(2)"
 S DIC("DR")=DIC("DR")_";.04////^S X=DT"
 S DIC("DR")=DIC("DR")_";.05///^S X=BARINQ(""PYRID"")"
 K DD,DO
 D FILE^DICN
 S BARECLST=+Y
 I Y'>0 D  Q
 . W !!!,"*****UNABLE TO PROCESS REQUEST FOR ",BARINQ(.01,"E"),"*****"
 . W !,"*****COULD NOT CREATE ENTRY IN A/R EDI CLAIM STATUS FILE*****"
 ;D GEN276^BAR276(BARECLST)            ;Returns INHF
 S BARINHF=""
 I '$D(INHF) S BARINHF="*****GIS TRIGGER EVENT NOT IN PLACE*****"
 I $D(INHF),'+INHF S BARINHF="*****"_INHF_"*****"
 I $G(BARINHF)]"" D  Q
 . S DA=BARECLST
 . S DIK="^BARECLST("
 . D ^DIK
 . W !!!,$$CJ^XLFSTR("*****UNABLE TO PROCESS REQUEST FOR "_BARINQ(.01,"E")_" *****",IOM)
 . W !?((80-$L(BARINHF))/2),BARINHF
 . S BARECLST=0
 W ". . . SENT"
 Q
 ; ********************************************************************
ACCUM ;
 ; BARSUM(A/R ACCOUNT)=BILL CNT^AMT BILLED
 S $P(BARSUM(BARINQ(3,"E")),U)=$P($G(BARSUM(BARINQ(3,"E"))),U)+1
 S $P(BARSUM(BARINQ(3,"E")),U,2)=$P($G(BARSUM(BARINQ(3,"E"))),U,2)+BARINQ(13,"I")
 S $P(BARTOT,U)=$P($G(BARTOT),U)+1
 S $P(BARTOT,U,2)=$P($G(BARTOT),U,2)+BARINQ(13,"I")
 Q
 ; ********************************************************************
DISPSUM ;
 ; Display Summary when user is done entering bills
 I '$D(BARSUM) D  Q
 . W !!!?18,"No bills were submitted for a claim status."
 W $$EN^BARVDF("IOF")
 W ?6,"* * * * S U M M A R Y   O F   S U B M I T T E D   B I L L S * * * *"
 W !!,"ACCEPTED TRANSMISSIONS",?60,$$MDT2^BARDUTL(DT)
 W !!,"A/R Account",?40,"Bill cnt",?51,"Amount Billed"
 W !,"-----------",?40,"---------",?50,"---------------",!
 S BARAC=""
 F  S BARAC=$O(BARSUM(BARAC)) Q:BARAC=""  D
 . W !,BARAC
 . W ?40,$J($FN($P(BARSUM(BARAC),U),",",0),9)
 . W ?50,$J($FN($P(BARSUM(BARAC),U,2),",",2),15)
 W !,?40,"---------",?50,"---------------"
 W !,"TOTALS"
 W ?40,$J($FN($P(BARTOT,U),",",0),9)
 W ?50,$J($FN($P(BARTOT,U,2),",",2),15)
 Q
 ; ********************************************************************
ASKDEV ;
 ; Ask if user wants to print summary
 W !!
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Would you like to print this summary page?"
 S DIR("B")="Yes"
 D ^DIR
 K DIR
 Q:Y<1
 ; Select device
 S %ZIS="N"
 S %ZIS("A")="Enter DEVICE: "
 D ^%ZIS Q:POP
 I $D(IO("S")) S IOP=ION D ^%ZIS
 D DISPSUM
 D ^%ZISC
 Q
 ; ********************************************************************
 ;
INSTALLD(BAR) ; EP
 ; Verify GIS Patch 2 and 6 present
 N DIC,X,Y
 S X=$P(BAR,"*")
 S DIC="^DIC(9.4,"
 S DIC(0)="FM"
 S D="C"
 D IX^DIC
 I Y<1 Q 0
 ; 2nd look up version
 S DIC=DIC_+Y_",22,"
 S X=$P(BAR,"*",2)
 D ^DIC
 I Y<1 Q 0
 ; 3rd look up patch
 S DIC=DIC_+Y_",""PAH"","
 S X=$P(BAR,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; *********************************************************************
 ;
EXIT ; EP
 ; Exit, kill local variables
 D ^BARVKL0                    ; kill namespace variables
 Q
