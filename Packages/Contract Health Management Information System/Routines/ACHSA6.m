ACHSA6 ; IHS/ITSC/TPF/PMF - ENTER DOCUMENTS (7/8)-(EST. COST, MED DATA) ;JUL 10, 2008 
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**14,19**;JUN 11,2001
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;
A1 ; Input estimated charges.
 W !!,"Estimated Charges: "
 I ACHSESDO]"" S X=ACHSESDO,X2="2$" D FMT^ACHS W "// "
 D READ^ACHSFU
 I $D(ACHSQUIT) D END^ACHSA Q
 G C1^ACHSA5:$D(DUOUT)
 I Y?1"?".E W "  Enter The ",$S($D(ACHSBLKF):"Dollar Amount To Be Obligated",1:"Approximate Cost of Treatment") G A1
 I Y="" G A3:ACHSESDO W *7,"  Must Have Amount" G A1
 S:$E(Y)="$" Y=$E(Y,2,999)
 F  S %=$F(Y,",") Q:'%  S Y=$E(Y,1,%-2)_$E(Y,%,99)
 I '(Y?1N.N1"."2N!(Y?1N.N))!($L(Y)>10) W *7,"  ??" G A1
 S Y=$J(Y,1,2)
 ;
 ;GET 'NORMAL MAX' AND 'ABSOLUTE MAX' FOR OBLIGATION TYPE
 S ACHS=$P($G(^ACHSF(DUZ(2),"N",ACHSTYP,0)),U,2,3)
 I ACHS,Y'>ACHS S ACHSESDO=Y G A3
 I Y>$P(ACHS,U,2) W !!,*7,"The OBLIGATION LIMIT for this type of document is " S X=$P(ACHS,U,2) D FMT^ACHS W ".",!!,"Enter a lesser amount of money or exit the document.",!! G A1
 W *7 S (S,X)=Y
A2 ; Confirm amount obligated.
 W !!?4
 S X=S,X2="2$"
 D FMT^ACHS
 S Y=$$DIR^XBDIR("Y","  Are You Sure This Is Correct","NO")
 I $D(DTOUT) D END^ACHSA Q
 G A1:$D(DUOUT),A1:'Y
 S ACHSESDO=S
 ;
A3 ; Enter Referral Medical Priority Code
 I '$$AVAIL^ACHSUUP(ACHSESDO,ACHSACFY,ACHSCFY) W !!,"This amount exceeds your funds available." G A1
 W !
 S DIR(0)="9002080.01,81",DIR("??")="^D DISPMPC^ACHSA6"
 S:ACHSRMPC]"" DIR("B")=ACHSRMPC
 D ^DIR
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 S ACHSRMPC=$G(Y)
 ;
A4 ; Enter additional referral data.
 I (ACHSTYP=2)!$D(ACHSBLKF)!$D(ACHSSLOC) G ^ACHSA7
 S Y=$$DIR^XBDIR("Y","Enter ADDITIONAL REFERRAL DATA NOW","N")
 I $D(DTOUT) D END^ACHSA Q
 G ^ACHSA7:'Y       ;ENTER DOCUMENTS (8/8)-(CONFIRM & RECORD)
 G A1:$D(DUOUT)
 D KDIR
 ;
RPHY ; Enter the Referral Physician.
 ;MUST USE FILE 200 TO BE SAC COMPLIANT
 S ACHS200=$S($G(^DD(9002080.01,80,0))["VA(200,":1,1:0)
 S DIC=$S(ACHS200:200,1:"^DIC(6,"),DIC(0)="AEMQZ",DIC("A")="REFERRAL PHYSICIAN: "
 I 'ACHS200 S DIC("S")="I '$D(^(""I""))"
 I 'ACHS200,ACHSRPHY>0 S DIC("B")=$P($G(^DIC(16,ACHSRPHY,0)),U)
 D ^DIC
 K DIC
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 ;S ACHSRPHY=$S($D(Y):+Y,1:"")  ;ACHS*3.1*19
 S ACHSRPHY=$S(+Y>0:+Y,1:"")   ;ACHS*3.1*19
 ;
RCOI ; Enter Referral Cause Of Injury.
 S DIR(0)="9002080.01,82"
 S:ACHSRCOI]"" DIR("B")=$P(ACHSRCOI,U,2)
 D ^DIR
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 S ACHSRCOI=$G(Y)
 ;
RALR ; Enter Referral Alcohol Related?.
 S DIR(0)="9002080.01,83"
 S:ACHSRALR]"" DIR("B")=ACHSRALR
 D ^DIR
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 S ACHSRALR=$G(Y)
 ;
RDX ; Enter Referral ICD DX codes.
 S DIR(0)="9002080.184,.01"
 F ACHS=1:1 S DIR("A")=$P($G(^DD(9002080.184,.01,0)),U)_" # "_ACHS_" " S:$D(ACHSRDX(ACHS)) DIR("B")=$P(ACHSRDX(ACHS),U,2) D ^DIR K DIR("B") Q:$D(DIRUT)  S ACHSRDX(ACHS)=Y
 I $D(DUOUT)!(X="@") F %=ACHS:1 Q:'$D(ACHSRDX(%))  K ACHSRDX(%)
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 ;
RDXN ; Enter Referral Diagnosis (DX) Narrative.
 S DIR(0)="9002080.01,85"
 S:ACHSRDXN]"" DIR("B")=ACHSRDXN
 D ^DIR
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 S ACHSRDXN=$G(Y)
 ;
RPX ; Enter Referral ICD PROCEDURE codes.
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 2 LINES
 ;I $D(ACHSRPX) F ACHS=1:1 Q:'$D(ACHSRPX(ACHS))  S ACHSRPX(ACHS)=$S(ACHSRPX(ACHS)["ICD":"ICD."_$P($G(^ICD0(+ACHSRPX(ACHS),0)),U),1:"CPT."_$P($G(^ICPT(+ACHSRPX(ACHS),0)),U))
 I $D(ACHSRPX) F ACHS=1:1 Q:'$D(ACHSRPX(ACHS))  S ACHSRPX(ACHS)=$S(ACHSRPX(ACHS)["ICD":"ICD."_$P($$ICDOP^ICDCODE(+ACHSRPX(ACHS)),U,2),1:"CPT."_$P($$CPT^ICPTCOD(+ACHSRPX(ACHS)),U,2))
 S DIR(0)="9002080.186,.01"
 F ACHS=1:1 S DIR("A")=$P($G(^DD(9002080.186,.01,0)),U)_" # "_ACHS_" " S:$D(ACHSRPX(ACHS)) DIR("B")=$P(ACHSRPX(ACHS),";") D ^DIR K DIR("B") Q:$D(DIRUT)  S ACHSRPX(ACHS)=Y
 I $D(DUOUT)!(X="@") F %=ACHS:1 Q:'$D(ACHSRPX(%))  K ACHSRPX(%)
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 ;
RPXN ; Enter Referral Procedure (PX) Narrative.
 S DIR(0)="9002080.01,87"
 S:ACHSRPXN]"" DIR("B")=ACHSRPXN
 D ^DIR
 G A1:$D(DUOUT),KDIR:$D(DTOUT)
 D KDIR
 S ACHSRPXN=$G(Y)
 G ^ACHSA7
 ;
 ;
KDIR ;
 K DIR,DIRUT
 W !!
 Q
 ;
DISPMPC ;EP - From call to DIR, display medical priorities
 W !!
 S %=0
 F  S %=$O(^DD(9002080.01,81,21,%)) Q:'%  W !,$G(^DD(9002080.01,81,21,%,0)) I $G(^DD(9002080.01,81,21,%+1,0))[" - " Q:'$$DIR^XBDIR("E","Press RETURN...")
 Q
 ;
NODE ;EP - To set 0th node of Referral medical data multiples.
 ; Called from ^ACHSA7.  Here because of size of ACHSA7.
 ; ACHSDIEN must be defined.
 I $D(ACHSRDX) S:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,4,0)) ^ACHSF(DUZ(2),"D",ACHSDIEN,4,0)=$$ZEROTH^ACHS(9002080,100,84)
 I $D(ACHSRPX) S:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,6,0)) ^ACHSF(DUZ(2),"D",ACHSDIEN,6,0)=$$ZEROTH^ACHS(9002080,100,86)
 Q
 ;
