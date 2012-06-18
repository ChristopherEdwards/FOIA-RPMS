BARMPAS2 ; IHS/SD/LSL - Patient Account Statement Print ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**2,4,19,20**;OCT 26, 2005
 ; IHS/SD/LSL - 5/13/03 - V1.7 Patch 2
 ; IHS/SD/LSL - 12/04/03 - V1.7 Patch 4 - IM 11692
 Q
 ;
PRTASK ; EP - MOVED TO ^BARMPAS3
 D PRTASK^BARMPAS3
 Q
COMPUTE ;
 ; computed through tasked option
 Q
 ; ***
PRINT ; EP
 ; Print Patient Account Statements.
 S BARHOLD=0
 F  S BARHOLD=$O(^XTMP("BARPAS"_BARRUNDT,BARHOLD)) Q:'+BARHOLD  D
 . S BARACDA=0
 . F  S BARACDA=$O(^XTMP("BARPAS"_BARRUNDT,BARHOLD,BARACDA)) Q:'+BARACDA  D ACCT
 Q
 ; ***
ACCT ;
 ; For each patient account in XTMP do...
 Q:($D(^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA))'>1)
 ; IHS/SD/PKD 1.8*19 10/6/10 Column Totals requested
 K BARTOTL
 S (BARTOTL("B"),BARTOTL("I"),BARTOTL("P"),BARTOTL("A"),BARTOTL("PR"))="",BARTOTL("IO")=""
 S BARTOTL("DASH")="---------"
 K BARF1
 S BARPG=0
 D PGHDR^BARMPAS3                   ; Patient Acct hdr and demographics
 K BARBILL,BARBILLS
 S BARACBAL=0
 ; IHS/SD/PKD 1.8*19 9/10/10 Added VisitLoc & DOS Sorts 
 ; MOVED THE ORIG CODE TO BARMPAS4 BECAUSE OF ROUTINE SIZE LIMITS
 S VISLOC=""
 F  S VISLOC=$O(^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,VISLOC)) Q:VISLOC=""  D
 . Q:VISLOC="OB"  ; separate Quit because "OB" is not a VISIT LOCATION
 . S BARVDT=""
 . F  S BARVDT=$O(^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,VISLOC,BARVDT)) Q:'BARVDT  D
 . . D GETBIL
 ; VISIT LOCATION = "OB"
 D STMT
 Q:$G(BARF1)
 D AGE                                          ; Age bills
 D SUM                                          ; Print patient trailer
 Q
 ; End of New subscripts for sort
GETBIL S BARBL=0
 F  S BARBL=$O(^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,VISLOC,BARVDT,BARBL)) Q:BARBL=""  D
 . Q:BARBL="OB"  ;	IHS/SD/PKD 1.8*19 ignore "OB", get other bills
 . S BARBNUM=+$$GET1^DIQ(90050.01,BARBL,.01)   ; Only Bill # (no A/B)
 . S BARBILL(BARBNUM,BARBL)=""
 . ; IHS/SD/PKD 1.8*19 Sorts Added for loc/dos
 . S BARBILLS(VISLOC,BARVDT,BARBNUM,BARBL)=""
 Q
STMT S BARBNUM=0
 F  S BARBNUM=$O(BARBILL(BARBNUM)) Q:BARBNUM'>0  D BILEROR
 S BARBNUM=0
 ;IHS/SD/PKD 1.8*19 9/13/10 new Local Array for output:  BARBILLS
 S VISLOC="" F  S VISLOC=$O(BARBILLS(VISLOC)) Q:VISLOC=""  D
 . W !!?5,"LOCATION:  ",VISLOC
 . S BARVDT="" F  S BARVDT=$O(BARBILLS(VISLOC,BARVDT)) Q:'BARVDT  D STMTP
 Q
STMTP  ; added sorts for loc & dos
 F  S BARBNUM=$O(BARBILLS(VISLOC,BARVDT,BARBNUM)) Q:BARBNUM'>0  D  Q:$G(BARF1)
 . ; IHS/SD/PKD 1.8*19 set up temp variables
 . N BARBILLD,BARITOT,BARPTOT,BARATOT,BARPRSP,BARPTAC,BARPRV,BARNON,BARCXL
 . ; IHS/SD/PKD 1.8*20 2/17/11
 . ;S (BARBILLD,BARITOT,BARPTOT,BARATOT,BARPRSP,BARPTAC,BARINSOW)=0
 . S (BARBILLD,BARITOT,BARPTOT,BARATOT,BARPRSP,BARPTAC,BARINSOW,BARCXL)=0
 . D BLDA
 . S BARPBNUM=BARBNUM_" "
 . S BARPBNUM=$O(^BARBL(DUZ(2),"B",BARPBNUM))
 . ; IHS/SD/PKD 1.8.19 Quit only if BILL in error- not if 1 skippable trx on a bill
 . Q:$D(BARBILL("X",BARPBNUM))  ;Trx Error code is now BARBIL("XTR",... pkd
 . ; If bill cancelled (3PB) and no payments or ADJ have been made, quit
 . I BARITOT=0&(BARPTOT=0)&(BARATOT=0)&(BARCXL) Q
 . I BARITOT=0&(BARPTOT=0)&(BARATOT=0)&(BARBILLD=0) Q  ; No amounts period/shouldn't get this far
 . I BARBILLD=0  D  ;If all bills for bill CXL'd, get Amt from "A" bill
 . . N BLIEN,BLA
 . . S BLA=$O(^BARBL(DUZ(2),"B",+BAR(.01)_"A"))
 . . S BLIEN=$O(^BARBL(DUZ(2),"B",BLA,""))
 . . S BARBILLD=$P(^BARBL(DUZ(2),BLIEN,0),U,13)
 . ;D PG^BARMPAS3(1)  IHS/SD/PKD 1.8*19 1/11/11
 . ;  pg overflow on long statements
 . D PG^BARMPAS3(10)  ; IHS/SD/PKD 1.8*21 3/24/11 Statement Page Length
 . Q:$G(BARF1)
 . I $G(BARPRV)="" S BARPRV="***** "
 . W !!,"SERVICE DATE: ",$$SHDT^BARDUTL(BAR(102,"I"))
 . W ?30,"BILL #: ",BARBNUM
 . W ?50,"PROVIDER: ",$E(BARPRV,1,20)
 . W !?6,$J($FN(BARBILLD,"p",2),9)
 . W ?18,$J($FN(BARITOT,"p",2),9),?30,$J($FN(BARPTOT,"p",2),9),?41,$J($FN(BARATOT,"p",2),9)
 . W ?56,$J($FN(BARINSOW,"p",2),9)
 . I (BARPTAC=1!(BARNON=1)!('BARCXL))&(BARPRSP) D
 . . W ?69,$J($FN(BARPRSP,"p",2),9) S BARTOTL("PR")=BARTOTL("PR")+BARPRSP
 . E  W ?74,"**"
 . ;I BARCXL W ?81,"X"  If bill cancelled, write X
 . ;removed from printing
 . ;IHS/SD/PKD 1.8*19 11/2/10 
 . ; May want to exclude some of these amts from totals if bill was cancelled
 . S BARTOTL("B")=BARTOTL("B")+BARBILLD,BARTOTL("I")=BARTOTL("I")+BARITOT
 . S BARTOTL("P")=BARTOTL("P")+BARPTOT,BARTOTL("A")=BARTOTL("A")+BARATOT
 . S BARTOTL("IO")=BARTOTL("IO")+BARINSOW
 ; IHS/SD/PKD 9/13/10 Moved 3 lines to end of tag:  ACCT
 ;Q:$G(BARF1)
 ;D AGE                                          ; Age bills
 ;D SUM                                          ; Print patient trailer
 Q
 ; ***
 ;
BILEROR ;
 ; test to eliminate bills with billed in error
 S BARPBNUM=BARBNUM_" "
 F II=1:1 S BARPBNUM=$O(^BARBL(DUZ(2),"B",BARPBNUM)) Q:(+BARPBNUM'=BARBNUM)  D BILEROR2
 Q
 ; ***
 ;
BILEROR2 ;
 ; test transactions for the bill
 S BARBL=$O(^BARBL(DUZ(2),"B",BARPBNUM,0))
 S BARTRDT=0,BARLPDA=0
 S BARBILDT=$$GET1^DIQ(90050.01,BARBL,7,"I")          ; Billed date
 I BARBILDT'>0 S BARBILL("X",BARPBNUM)="" Q
 F  S BARTRDT=$O(^BARTR(DUZ(2),"AC",BARBL,BARTRDT)) Q:('BARTRDT)!(BARTRDT\1>BARDTE)  D BILEROR3
 Q
 ; ***
 ;
BILEROR3 ;
 K BARTR
 D ENP^XBDIQ1(90050.03,BARTRDT,".01;2;3;3.5;4;6;14;15;101;102;103","BARTR(","I")
 S BARTTYP=BARTR(101,"I")
 I BARTTYP'=39,BARTTYP'=43,BARTTYP'=40,BARTTYP'=49,BARTTYP'=107 Q
 ; Quit if TT is NOT: REFUND; ADJUST ACCT;PMT;BILL NEW;AUTO ADJ
 ; IHS/SD/PKD 9/8/10 - a Transaction w/ Error in it doesn't zero the bill
 ;  ONLY the ERROR TR omitted from the statement
 ;  I BARTR(103)["ERROR" S BARBILL("X",BARPBNUM)="" 
 I BARTR(103)["ERROR" S BARBILL("XTR",BARBL,BARPBNUM,BARTRDT,"TRX ADJ 103 ERR")=""
 Q
 ; ***
 ;
BLDA ;
 S BARPBNUM=BARBNUM_" "
 F II=1:1 S BARPBNUM=$O(^BARBL(DUZ(2),"B",BARPBNUM)) Q:(+BARPBNUM'=BARBNUM)  D BLDA2 Q:$G(BARF1)
 Q
 ; ***
 ;
BLDA2 ;
 ; profile bills from the first bill
 S BARCXL=0
 Q:$D(BARBILL("X",BARPBNUM))    ;donot process bills marked Error
 S BARBL=$O(^BARBL(DUZ(2),"B",BARPBNUM,0))
 K BAR
 D ENP^XBDIQ1(90050.01,BARBL,".01;3;13;15;16;17;17.2;22;101;102;108;112;113;114","BAR(","I")
 S BARBSTAT=BAR(17.2)  ;Bill Status in TPB which can be diff from A/R
 ; IHS/SD/PKD 1.8*19 9/16/10 If bill is in list & has pmts applied, it should print on stmt anyway
 ;Q:BARBSTAT="CANCELLED"
 I BARBSTAT="CANCELLED" S BARCXL=1  ; if cancelled 1.8*19
 S BARPTAC=$S(BARACDA=BAR(3,"I"):1,1:0)  ; PT Resp if INSURER TYPE=NON-BEN or INSURER=SELF 1.8*19
 N D0,X S D0=BAR(3,"I"),BARNON=0
 S X=$$VAL^BARVPM(8)
 I X["NON-BEN"!(BARPTAC'=0) S BARPRSP=BARPRSP+BAR(15,"I"),BARNON=1
 E  S BARINSOW=BARINSOW+BAR(15,"I")  ; Outstanding Insurance Amt 1.8*19 10/13/10 PKD
 ;IHS/SD/PKD 1.8*19 9/3/10 if missing, Find Provider from 3Pbill
 I BAR(113,"I")="" D  ; 
 . N DUZ2,TPBIEN,PRV,DATA
 . S TPIEN=BAR(17,"I"),DUZ2=BAR(22,"I"),PRV=0,BARPRV=""
 . F  S PRV=$O(^ABMDBILL(DUZ2,TPIEN,41,PRV)) Q:'PRV  D  Q:BARPRV'=""  ; DATA=PROVIDER^TYPE
 . . S DATA=^ABMDBILL(DUZ2,TPIEN,41,PRV,0)
 . . Q:$P(DATA,U,2)'="A"&($P(DATA,U,2)'="R")  ; Want Attending(A) or Rendering(R)
 . . S BAR(113,"I")=+DATA
 S:BAR(113,"I")'="" BARPRV=$P($E($P(^VA(200,BAR(113,"I"),0),U,1),1,9),",",1)
 I BAR(113,"I")="" S BARPRV="None"
 I BAR(113,"I")=""&(BAR(114,"I")=901) S BARPRV="Rx POS"  ; Pharmacy
 ; END 1.8*19 get Provider
BILLED D  ; Get Orig Billed Amt
 . Q:BARCXL
 . ; Get Billed Amt from first alpha bill
 . Q:$G(BARORIG(+BAR(.01)))
 . S BARORIG(+BAR(.01))=BAR(13,"I")  ; 1st unCXL bill in series
 . S BARBILLD=BARORIG(+BAR(.01))  ; Orig Bill Amount
 Q:$G(BARF1)
 D BLDA3
 Q
 ; ***
CXL  ;	Use the alphabetically first bill that isn't cancelled FOR BILLED AMT
 ; don't think i need this subroutine ... 
 S BAR("3P LOC")=$$FIND3PB^BARUTL(DUZ(2),BAR)
 Q:BAR("3P LOC")=""                           ; Bill not found 3PB
 S BAR3PDUZ=$P(BAR("3P LOC"),",")
 S BAR3PIEN=$P(BAR("3P LOC"),",",2)
 ; BAR*1.8*19 IHS/SD/PKD 5/10/10 START
 ;S BARBSTAT=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,0),U,4)
 S BARB3PB0=$G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,0))  ; Need 3 pieces
 S BARBSTAT=$P(BARB3PB0,U,4)  ; Bill Status
 Q
 ;
BLDA3 ;
 ; profile this bills transactions
 S BARTRDT=0,BARLPDA=0
 F  S BARTRDT=$O(^BARTR(DUZ(2),"AC",BARBL,BARTRDT)) Q:('BARTRDT)!(BARTRDT\1>BARDTE)  D BLDA4 Q:$G(BARF1)
 Q
 ; ***
 ;
BLDA4 ;
 K BARTR
 ;IHS/SD/AR 1.8*19 5/31/10
 ;S BARINSAM=0,BARPATAM=0,BARADJAM=0
 ;D ENP^XBDIQ1(90050.03,BARTRDT,".01;2;3;3.5;4;6;14;15;101;102;103","BARTR(","I")
 D ENP^XBDIQ1(90050.03,BARTRDT,".01;2;3;3.5;3.6;3.7;4;5;6;14;15;101;102;103","BARTR(","I")
 Q:(BARTR(102,"I")=13)!(BARTR(102,"I")=14)    ;EXCLUDE ADJ CAT DEDUCTIBLE & CO-PAY
 S BARTTYP=BARTR(101,"I")
 I BARTTYP'=39,BARTTYP'=43,BARTTYP'=40,BARTTYP'=49,BARTTYP'=107 S II=II-1 Q
 ;I BARPTAC S BARACBAL=BARACBAL-BARTR(3.5)
 S BARBATCH=BARTR(14,"I")
 S BARITM=BARTR(15,"I")
 S BARCLIN=$$GET1^DIQ(90050.01,BARTR(4,"I"),112)
 S BARCLIN=$E(BARCLIN,1,8)
 S BARITYP=$$GET1^DIQ(90050.02,BARTR(6,"I"),1.08)
 S:BARITYP["MEDICARE" BARTR(6)="MCARE"
 S:BARITYP["MEDICAID" BARTR(6)="MCAID"
 S BARDESC=$E(BARTR(101),1,3)_"/"_$S(BARACDA=BARTR(6,"I"):"PAT",1:$E(BARTR(6),1,5))
 I BARTR(101)["PAY" D
 . S BARBIENS=BARITM_","_BARBATCH_","
 . S BARCHECK=$$GET1^DIQ(90051.1101,BARBIENS,11)
 . S BARDESC=BARDESC_"/"_BARCHECK
 . ;IHS/SD/AR 1.8*19 5/31/10
 . I BARACDA'=BARTR(6,"I") S BARITOT=BARITOT+BARTR(3.6)
 . I BARACDA=BARTR(6,"I") S BARPTOT=BARPTOT+BARTR(3.6)
 ; IHS/SD/PKD 1.8*19 9/9/10 Omit transactions that contain "ERROR" in ADJ TYP
 ;I BARTR(101)["ADJ" S BARATOT=BARATOT+BARTR(3.7)
 I BARTR(101)["ADJ"&('$D(BARBILL("XTR",BARBL,BARPBNUM,BARTRDT))) S BARATOT=BARATOT+BARTR(3.7)
 S BARCRD=$S(+BARTR(2):$J(BARTR(2),8,2),1:"")
 S BARDBT=$S(+BARTR(3):$J(BARTR(3),8,2),1:"")
 ;D PG^BARMPAS3(18)
 Q:$G(BARF1)
 ;IHS/SD/AR 1.8*19 5/31/10
 ;W !,?7,$$SDT^BARDUTL(BARTR(.01,"I")),?30,$E(BARDESC,1,15),?42,BARDBT,?50,BARCRD
 ;I BARPTAC W ?67,$J(BARACBAL,8,2)
 Q
 ; ***
 ;
AGE ; EP
 ; AGE PAST BILLS
 K BARAGE,BARBL
 S (BARBL,BARAGE)=0
 F I=0:1:3 S BARAGE(I)=0  ; set up Age array
 F  S BARBL=$O(^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,"OB",BARBL)) Q:BARBL'>0  D AGE2
 Q
 ; ***
 ;
AGE2 ;
 K BAR
 D ENP^XBDIQ1(90050.01,BARBL,".01;7;7.2;15","BAR(")
 I $D(BARBILL("X",BAR(.01)))  Q  ; billed in error
 S X=BAR(7.2)\30
 S:X>3 X=3
 S BARAGE(X)=BARAGE(X)+BAR(15)
 S BARAGE=BARAGE+BAR(15)
 Q
 ; ***
 ;
SUM ; EP
 ; CALCULATE AND PRESENT SUMMARY
 D PG^BARMPAS3(18)
 ;I (IOSL-20)>$Y F II=$Y:1:(IOSL-20) W !
 S $P(BARLINE,"=",IOM-2)=""
 S $P(BARBAR,"-",IOM-2)=""
 ; IHS/SD/PKD 1.8*19 Add column totals
 ;N TAB W !! F TAB=28,38,48,58,68 W ?TAB,BARTOTL("DASH")
 N TAB W !! F TAB=6,18,30,41,56,69 W ?TAB,BARTOTL("DASH")
 W !,?6,$J($FN(BARTOTL("B"),"p",2),9),?18,$J($FN(BARTOTL("I"),"p",2),9)
 W ?30,$J($FN(BARTOTL("P"),"p",2),9),?41,$J($FN(BARTOTL("A"),"p",2),9)
 W ?56,$J($FN(BARTOTL("IO"),"p",2),9),?69,$J($FN(BARTOTL("PR"),"p",2),9)
 ;IHS/SD/AR 1.8*19 5/31/10
 D PREPAID
 W !!
 W !,BARBAR
 W !,"Pre-payments:"
 N BARCNT1
 S BARCNT1=1
 S BARPPAY=0
 F  S BARPPAY=$O(^XTMP("BAR",$J,"BARMPAS2",BARPPAY)) Q:('BARPPAY)  D
 . W !," ",BARCNT1,". Receipt #",$G(^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"RECEIPT"))
 . W ?30,"$",$J($G(^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"CREDIT")),8)," FOR "
 . W ?43,$$SDT^BARDUTL($G(^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"TODOS")))
 . W ?60,$G(^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"PAYTYPE"))
 . S BARCNT1=BARCNT1+1
 W !,BARBAR
 I BARPTMSG'="" W !,BARPTMSG
 ;IHS/SD/PKD 2/22/11 1.8*20
 D PG^BARMPAS3(18)
 ;IHS/SD/AR 1.8*19 6/02/10
 W !,BARLINE,!,"** SUMMARY by days due**",!,BARBAR
 W !,?1,"0-29 Days",?17,"30-59 Days",?32,"60-89 Days",?47,"90-120+ Days",?66,"TOTAL DUE"
 W !,?1,"$",$J(BARAGE(0),8,2)
 W ?17,"$",$J(BARAGE(1),8,2)
 W ?32,"$",$J(BARAGE(2),8,2)
 W ?47,"$",$J(BARAGE(3),8,2)
 W ?66,"$",$J(BARAGE,9,2)
 W !,BARLINE,!
 ; IHS/SD/PKD 2/22/11 1.8*20  PageBreaks
 D PG^BARMPAS3(10)
 W !,?25,"+++PAYMENT DUE UPON RECEIPT+++",!
 W !,"** Your Insurance has been billed. You may be responsible for all or "
 W !,"a portion of the billed amount based on your scheduled benefits."
 W !,"Statement reflects all transactions up to statement date."
 W !!,"This statement is intended for the above named patient, if you have"
 W !,"received this statement in error please notify us immediately.",!
 Q
 ; ***
 ;
EXIT ; EP
 I $G(BARKILL)=0 K ^XTMP("BARPAS"_BARRUNDT)
 D POUT^BARRUTL
 Q
 ;IHS/SD/AR 1.8*19 6/02/10
PREPAID ;
 K ^XTMP("BAR",$J,"BARMPAS2")
 N BARPPAY,BARCTYPE,BARVAR
 S BARPPAY=0,BARCTYPE=""
 F  S BARPPAY=$O(^BARPPAY(DUZ(2),"E",BARDFN,BARPPAY)) Q:('BARPPAY)  D
 . S BARVAR=$P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,6)
 . S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"RECEIPT")=$P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,1)
 . S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"CREDIT")=$FN($P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,7),"p",2)
 . S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"TODOS")=$P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,13)
 . I ($P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,3)["CC") D
 . . S BARCTYPE=$S(BARVAR="V":"VISA",BARVAR="M":"MASTERCARD",BARVAR="D":"DISCOVER",BARVAR="C":"DINERS CLUB",BARVAR="A":"AMERICAN EXPRESS",1:"NOTFOUND")
 . . S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"PAYTYPE")=BARCTYPE
 . I ($P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,3)["CA") D
 . . S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"PAYTYPE")="CASH"
 . I ($P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,3)["CK") D
 . . S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"PAYTYPE")="CHECK #"_$P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,4)
 . ;IHS/SD/PKD 1.8*19 12/21/10 Forgot Debit Card
 . I ($P($G(^BARPPAY(DUZ(2),BARPPAY,0)),U,3)["DB") S ^XTMP("BAR",$J,"BARMPAS2",BARPPAY,"PAYTYPE")="DEBIT CARD"
 Q
