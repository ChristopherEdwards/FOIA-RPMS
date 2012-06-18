ABSPOSN6 ; IHS/FCS/DRS - NCPDP Fms F ILC A/R ;    [ 09/12/2002  10:16 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,23**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;IHS/SD/RLT - 11/07/07 - Patch 23
 ; Updated ICD9 call for CSV.
 ;----------------------------------------------------------------------
 ; The form goes from $Y=0 through $Y=20.
 ;
 ; On the LQ-2170 in the Sitka ISD office, on printer SISD1, this
 ; experiment was run on 04/14/2000:
 ; 1. Put leading edge of paper into the tractor feed.
 ; 2. Press PAU F 3 seconds until "beep" tells you that you're
 ;    in micro-adjust mode.
 ; 3. Microadjust down until the absolute top of form is reached.
 ;    It beeps to tell you that it cannot go any farther.
 ; 3a. At this point, you might want to microadjust up a nudge
 ;    because DATE RX(s) written on lines $y=11, $y=13 are
 ;    right in the middle of the blue line.
 ; 4. Press pause to get out of microadjust mode.
 ; 5. D ABSUD102 (the local version, below) four times.
 ;
 ; Results:
 ; $Y=0 line is F group and cardholder ID no.
 ; $Y=2 F the cardholder name line
 ; $Y=3 diagnosis line, where appropriate
 ; PHARmacy name, address, city-state-zip on lines $Y=5,7,9
 ; Tax ID # on $Y=10, just above
 ; PHARmacy # on $Y=11
 ; DATE RX(s) written on $Y=11 (could microadjust down a nudge)
 ; DATE RX(s) filled on $Y=13
 ; Authorized PHARmacy rep also on $Y=13
 ; RX number 1 is on line $Y=16; number 2 is on $Y=18
 ; PATient name on $Y=5 or $Y=6
 ; DOB,Sex,Relationship on $Y=6
 ; Ingre. cost on $Y=8
 ; Disp. fee on $Y=10
 ; Tax on $Y=12
 ; TOTAL PRICE $Y=14
 ; Ded amt $Y=16
 ; Balance $Y=18
 ; $Y=19 is on the bottom blue line, or just below it on the 
 ;   Copyright line - D not U it!
 ; $Y=20 is on perFation or just below it - D NOT U!
PFM ;EP
 N ISAKCAID,NUM
 I PHARINFO("City/State/ZIP")?.E1"AK"." "5N.E,INSINFO("INS. Co. Name")["MEDICAID" S ISAKCAID=1
 E  S ISAKCAID=0
 U IO
 ;
 ; Each of these $Y=n sections ENDs with a "W !"
 ;
 ; $Y=0
 N X
 I ISAKCAID S X=PHARINFO("Medicaid PHARmacy #")
 E  D
 . S X=INSINFO("Group Number")
 . I X="" S X=INSINFO("Group Name")
 W ?9,$E(X,1,15)
 W ?31,$E($G(INSINFO("Cardholder Number")),1,45)
 W !
 ;
 ; $Y=1
 W !
 ;
 ; $Y=2
 W ?6,$E($G(INSINFO("Cardholder Name")),1,33)
 I $G(INSINFO("Other 3rd Party Coverage")) W ?40,"X"
 E  W ?46,"X"
 W !
 ;
 ; $Y=3
 I $$DIAG W $$DIAGINFO
 W !
 ;
 ; $Y=4
 W !
 ;
 ; $Y=5
 W ?5,$E($G(PHARINFO("Name")),1,23)
 W ?29,$S($L($G(PATINFO("Name")))>19:$E($P($G(PATINFO("Name")),",",1),1,18)_",",1:$E($G(PATINFO("Name")),1,19))
 W !
 ;
 ; $Y=6
 W:$L($G(PATINFO("Name")))>19 ?29,$E($P($G(PATINFO("Name")),",",2,999),1,19)
 W ?49,$E($G(PATINFO("DOB")),4,5)
 W ?52,$E($G(PATINFO("DOB")),6,7)
 W ?55,$E($G(PATINFO("DOB")),2,3)
 W:$G(PATINFO("Sex"))="M" ?58,"X"
 W:$G(PATINFO("Sex"))="F" ?60,"X"
 D
 . S X=INSINFO("Relationship")
 . ; old A/R system: you have a pointer to relationship file
 . ; New A/R system: you have 1, 2, 3, 4 already
 . I $D(^ABSBCOMB) D  ; ^ABSBCOMB on purpose, not ^ABSPCOMB
 . . I X'<1,X'>4 W ?X*3+60,"X"
 . E  D
 . . I $D(^AUTTRLSH(X,0)) S X=$P(^(0),U)
 . . I X="SELF" W ?63,"X"
 . . E  I X="SPOUSE" W ?66,"X"
 . . E  I X="HUSBAND" W ?66,"X"
 . . E  I X="WIFE" W ?66,"X"
 . . E  I X="DAUGHTER" W ?69,"X"
 . . E  I X="SON" W ?69,"X"
 . . E  W ?72,"X"
 W !
 ;
 ; $Y=7
 W ?5,$E($G(PHARINFO("Street")),1,23)
 W !
 ;
 ; $Y=8
 W ?29,$E(INSINFO("INS. Co. Name"),1,25)
 ;Ingredient costs
 ;
 W ?56,$J(DRUGINFO(1,"Ingr. Cost"),7,2)
 I DRUGINFO(0)=2 W ?64,$J(DRUGINFO(2,"Ingr. Cost"),7,2)
 W !
 ;
 ; $Y=9
 ; 
 W ?5,$E($G(PHARINFO("City/State/ZIP")),1,23)
 W ?29,$E(INSINFO("INS. Co. ADDR 1"),1,25)
 W !
 ;
 ; $Y=10
 ;
 I $$TAXID W ?1,"TaxID# ",PHARINFO("Tax ID #")
 W ?29,$E(INSINFO("INS. Co. ADDR 2"),1,25)
 W ?56,$J(DRUGINFO(1,"Disp. Fee"),7,2)
 I DRUGINFO(0)=2 W ?64,$J(DRUGINFO(2,"Disp. Fee"),7,2)
 W !
 ;
 ; $Y=11
 S X=$P($G(^ABSPEI(INSINFO("IEN"),100)),U,12)
 I ISAKCAID S X=PHARINFO("Medicaid PHARmacy #")
 E  I 'X S X=PHARINFO("PHARmacy #")
 E  I X=1,'$$TAXID S X=PHARINFO("Tax ID #")
 E  I X=2 S X=PHARINFO("Medicaid PHARmacy #") ; this might cHe
 E  S X=PHARINFO("PHARmacy #")
 W ?6,$E(X,1,13)
 W ?20,$E($G(DRUGINFO("DATE Written")),4,5)
 W ?23,$E($G(DRUGINFO("DATE Written")),6,7)
 W ?26,$E($G(DRUGINFO("DATE Written")),2,3)
 W ?29,INSINFO("INS. Co. City/State/Zip")
 W !
 ;
 ; $Y=12
 ; tax would go on this line
 W ?55-$L(DIPA("VCN")),"Patient #" ;*1.26*1*
 W !
 ;
 ; $Y=13
 W ?6,$E($G(PHARINFO("Phone")),1,13)
 W ?20,$E($G(DRUGINFO("DATE Filled")),4,5)
 W ?23,$E($G(DRUGINFO("DATE Filled")),6,7)
 W ?26,$E($G(DRUGINFO("DATE Filled")),2,3)
 W ?31,PHARINFO("Representative")
 S X=DIPA("VCN") W ?55-$L(X),X
 W !
 ;
 ; $Y=14  total price
 ;
 W ?56,$J(DRUGINFO(1,"Total Price"),7,2)
 I DRUGINFO(0)=2 W ?64,$J(DRUGINFO(2,"Total Price"),7,2)
 W !
 ;
 ; $Y=15
 ; For some INSurers, print RX 1 DRUG name above the NDC code
 ; actually, START it a little to the left of there
 ;
 I $$DRUGNAME W ?23,DRUGINFO(1,"DRUG Name")
 W !
 ;
 ; $Y=16
 ; Detail F RX 1 and Ded. Amt. in the right hand columns
 W ?4,$E($G(DRUGINFO(1,"RX Number")),1,7)
 W ?12,$E($G(DRUGINFO(1,"N/Refill")),1,2)
 W ?15,$E($G(DRUGINFO(1,"Metric Quantity")),1,5)
 W ?21,$E($G(DRUGINFO(1,"Days Supply")),1,4)
 S DRUGINFO(1,"NDC Code")=$$TRANSNDC(DRUGINFO(1,"NDC Code")) ;*1.26*1*
 I DRUGINFO(1,"NDC Code")?11N D
 .N X S X=DRUGINFO(1,"NDC Code")
 .S X=$E(X,1,5)_"-"_$E(X,6,9)_"-"_$E(X,10,11)
 .S DRUGINFO(1,"NDC Code")=X
 S X=$P($G(DRUGINFO(1,"NDC Code")),"-",1)
NUM S NUM=($L(X)-5) I NUM<0 S X=0_X G NUM
 W ?26,X
 S X=$P($G(DRUGINFO(1,"NDC Code")),"-",2)
NUM4 S NUM=($L(X)-4) I NUM<0 S X=0_X G NUM4
 W ?34,X
 S X=$P($G(DRUGINFO(1,"NDC Code")),"-",3)
NUM2 S NUM=($L(X)-2) I NUM<0 S X=0_X G NUM2
 W ?41,X
 I ISAKCAID S X=DRUGINFO(1,"Presc. Mcaid #")
 E  S X=DRUGINFO(1,"Presc. DEA #")
 W ?44,$E(X,1,8)
 W !
 ;
 ; $Y=17
 I DRUGINFO(0)=2,$$DRUGNAME W ?23,DRUGINFO(2,"DRUG Name")
 W !
 ;
 ; $Y=18
 ; Detail F RX 2 and Balance in the right hand columns
DG2 D:$G(DRUGINFO(0))=2
 .W ?4,$E($G(DRUGINFO(2,"RX Number")),1,7)
 .W ?12,$E($G(DRUGINFO(2,"N/Refill")),1,2)
 .W ?15,$E($G(DRUGINFO(2,"Metric Quantity")),1,5)
 .W ?21,$E($G(DRUGINFO(2,"Days Supply")),1,4)
 .S X=$$TRANSNDC(DRUGINFO(2,"NDC Code")) ; *1.26*1*
 .I X?11N D
 ..S X=$E(X,1,5)_"-"_$E(X,6,9)_"-"_$E(X,10,11)
 ..S DRUGINFO(2,"NDC Code")=X
 .S X=$P($G(DRUGINFO(2,"NDC Code")),"-",1)
NUM1 .S NUM=($L(X)-5) I NUM<0 S X=0_X G NUM1
 .W ?26,X
 .S X=$P($G(DRUGINFO(2,"NDC Code")),"-",2)
NUM5 .S NUM=($L(X)-4) I NUM<0 S X=0_X G NUM5
 .W ?34,X
 .S X=$P($G(DRUGINFO(2,"NDC Code")),"-",3)
NUM3 .S NUM=($L(X)-2) I NUM<0 S X=0_X G NUM3
 .W ?41,X
 .;W ?26,$E($P($G(DRUGINFO(2,"NDC Code")),"-",1),1,5)
 .;W ?34,$E($P($G(DRUGINFO(2,"NDC Code")),"-",2),1,4)
 .;W ?41,$E($P($G(DRUGINFO(2,"NDC Code")),"-",3),1,2)
 .;W ?44,$E($G(DRUGINFO(1,"Prescriber")),1,8)
 .I ISAKCAID S X=DRUGINFO(2,"Presc. Mcaid #")
 .E  S X=DRUGINFO(2,"Presc. DEA #")
 .W ?44,$E(X,1,8)
 W:$G(DRUGINFO(1,"Balance"))'="" ?56,$J(DRUGINFO(1,"Balance"),7,2)
 I DRUGINFO(0)=2 W ?64,$J(DRUGINFO(2,"Balance"),7,2)
 W !
 ;
 ; There is absolutely nothing on these last two lines, but we must
 ; Nline through them in O to position at top of Fm F the
 ; NEXT one.
 ; $Y=19
 W !
 ;
 ; $Y=20
 W !
 Q
TRANSNDC(X) ; Translate NDC code for special cases ; *1.26*1*
 ; output should contain "-" where appropriate
 I ISAKCAID,$TR(X,"-","")="50924055350" Q "A4253-    -  " ; Advantage Test Strips ; *1.26*1*
 Q X
DRUGNAME()         ; Does this INSurer want the DRUG name printed?
 ; We will squeeze it in, but it ain't pretty.
 ;ZW INSINFO,DRUGINFO R ">>>",%,!
 ; first, check F an INSurer-specific setting
 N X S X=$P($G(^ABSPEI(INSINFO("IEN"),100)),U,9)
 I X]"" Q X
 ; I not present, check the system-wide setting
 S X=$P($G(^ABSP(9002313.99,1,"FMS - NCPDP")),U)
 I X]"" Q X
 ; I not present, the default default is No.
 Q 0
TAXID() ; Does this INSurer want the tax id # printed?
 N X S X=$P($G(^ABSPEI(INSINFO("IEN"),100)),U,13)
 I X]"" Q X
 ; no INSurer-specific setting, so look F system-wide setting
 S X=$P($G(^ABSP(9002313.99,1,"FMS - NCPDP")),U,4)
 I X]"" Q X
 ; I not present, the default default is No.
 Q 0
DIAG() ; Does this INSurer wnat the diagnosis printed?
 ; first, check an INSurer-specific setting
 N X S X=$P($G(^ABSPEI(INSINFO("IEN"),100)),U,11)
 I X]"" Q X
 ; I not present, check the system-wide setting
 S X=$P($G(^ABSP(9002313.99,1,"FMS - NCPDP")),U,2)
 I X]"" Q X
 ; I not present, the default default is No.
 Q 0
DIAGINFO()         ; return diagnosis INFO to be printed
 N X
 N DIAGCODE S DIAGCODE=$$DIAGCODE(1)
 I DIAGCODE D
 . ;RLT - 11/07/07 - Patch 23
 . ;N % S %=$G(^ICD9(DIAGCODE,0))
 . ;S X=$P(%,U)_" "_$P(%,U,3)
 . N % S %=$$ICDDX^ICDCODE(DIAGCODE)
 . S X=$P(%,U,2)_" "_$P(%,U,4)
 E  S X=""
 Q X
DIAGCODE(N)        ; right now, just get FSI BILLING DIAGNOSIS else primary diag
 ; from V POV else first V POV - how mmany times has this been re/written?
 ; return pointer to ^ICD9(
 N X S X=$O(^ABSBV(VSTIEN,"FSICD9",0)) I X Q $P(^ABSBV(VSTIEN,"FSICD9",X,0),U)
 N STOP,RET S STOP=0,RET=""
 S X=0 F  S X=$O(^AUPNVPOV("AD",VSTIEN,X)) Q:'X  D  Q:STOP
 . I $P(^AUPNVPOV(X,0),U,12)="P" S RET=$P(^(0),U),STOP=1 Q
 . I RET="" S RET=$P(^AUPNVPOV(X,0),U)
 Q RET
FIX749 ;
 D FIX749A(1)
 I DRUGINFO(0)=2 D FIX749A(2)
 Q
FIX749A(X)         ; cHe dispense fee from $7.49 to $10.00
 Q:DRUGINFO(X,"Disp. Fee")'=7.49
 S DRUGINFO(X,"Disp. Fee")=10
 S DRUGINFO(X,"Total Price")=DRUGINFO(X,"Total Price")-7.49+10
 S DRUGINFO(X,"Balance")=DRUGINFO(X,"Balance")-7.49+10
 Q
ABSUD102 ; temp hack of test pattern
 ; trying to get NCPDP Fms to run on SPAT2 printer
 N POP D ^%ZIS Q:$G(POP)
 U IO
 N I F I=0:1:20 W "$Y=",$Y," " D 1 W !
 D ^%ZISC
 Q
1 ;
 F  Q:$X>75  D
 . I $X#5=($Y#5) W $X#10
 . E  I $X#1 W "."
 . E  W " "
 Q
