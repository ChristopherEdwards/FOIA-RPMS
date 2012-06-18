ADGPMV10 ; IHS/ADC/PDW/ENM - PATIENT MOVEMENT, CONT. ;  [ 09/17/2002  4:01 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;;MAS VERSION 5.0;
 ;IHS/ANMC/RAM,LJF;
 ; -- changed comment for no inpt activity
 ; -- moved placement of items and removed those not used by IHS
 ;IHS/HQW/WAR renamed to allow use with v5.3 DaySurgery
 ;
CS ;Current Status
 S X=$S('DGPMT:1,DGPMT<4:2,DGPMT>5:2,1:3) ;DGPMT=0 if from pt inq (DGRPD)
 I $O(^DPT(DFN,"DA",0)) W !!,"***NOTE***   This patient has not been converted into the new file structure.",!,"             Inpatient data for this patient is not yet available.",! Q
 ;I '$D(^DGPM("C",DFN)) W !!,"Status      : PATIENT HAS NO INPATIENT OR LODGER ACTIVITY IN THE COMPUTER",*7 D CS2 Q ;IHS orig
 I '$D(^DGPM("C",DFN)) D  Q  ;IHS chgd
 . W !!,"Inpatient Status:  NO ACTIVITY RECORDED IN COMPUTER" D CS2 ;IHS chgd
 ;S A=$S("^3^5^"[("^"_+DGPMVI(2)_"^"):0,1:+DGPMVI(2)) W !!,"Status      : ",$S('A:"IN",1:""),"ACTIVE ",$S("^4^5^"[("^"_+DGPMVI(2)_"^"):"LODGER",1:"INPATIENT") ;IHS orig
 S A=$S("^3^5^"[("^"_+DGPMVI(2)_"^"):0,1:+DGPMVI(2)) W !!,"Inpatient Status:  ",$S('A:"IN",1:""),"ACTIVE ",$S("^4^5^"[("^"_+DGPMVI(2)_"^"):"LODGER",1:"INPATIENT") ;IHS chgd
 G CS1:'A W "-" S X=+DGPMVI(4) I X=1 W "on PASS" G CS1
 I "^2^3^25^26^"[("^"_X_"^") W "on ",$S("^2^26^"[X:"A",1:"U"),"A" G CS1
 I "^13^43^44^45^"[("^"_X_"^") W "ASIH" G CS1
 I X=6 W "OTHER FAC" G CS1
 ;W "on WARD"  ;IHS
 W "on WARD" D IHS  ;IHS
CS1 I +DGPMVI(2)=3,$D(^DGPM(+DGPMVI(17),0)) W ?39,"Discharge Type : ",$S($D(^DG(405.1,+$P(^(0),"^",4),0)):$P(^(0),"^",1),1:"UNKNOWN")
 I "^3^4^5^"'[("^"_+DGPMVI(2)_"^"),$D(^DPT(DFN,"DAC")),($P(^("DAC"),"^",1)="S") W "  (Seriously ill)"
 W !!,$S("^4^5^"'[("^"_+DGPMVI(2)_"^"):"Admitted    ",1:"Checked-in  "),": "_$P(DGPMVI(13,1),"^",2)
 W ?39,$S("^4^5^"[("^"_+DGPMVI(2)_"^"):"Checked-out",+DGPMVI(2)=3:"Discharged ",1:"Transferred"),"    : ",$S("^1^4^"'[("^"_+DGPMVI(2)_"^"):$P(DGPMVI(3),"^",2),$P(DGPMVI(3),"^",2)'=$P(DGPMVI(13,1),"^",2):$P(DGPMVI(3),"^",2),1:"")
 W !,"Ward        : ",$E($P(DGPMVI(5),"^",2),1,26),?39,"Room-Bed       : ",$E($P(DGPMVI(6),"^",2),1,26) I "^4^5^"'[("^"_+DGPMVI(2)_"^") W !,"Provider    : ",$E($P(DGPMVI(7),"^",2),1,26),?39,"Specialty      : ",$E($P(DGPMVI(8),"^",2),1,26)
 D CS2
 ;S DGPMIFN=DGPMVI(13) I +DGPMVI(2)'=4&(+DGPMVI(2)'=5) D ^DGPMLOS W !!,"Admission LOS: ",+$P(X,"^",5),"  Absence days: ",+$P(X,"^",2),"  Pass Days: ",+$P(X,"^",3),"  ASIH days: ",+$P(X,"^",4)  ;IHS
 Q  ;IHS
IHS ; los  ;IHS
 ;S DGPMIFN=DGPMVI(13) I +DGPMVI(2)'=4&(+DGPMVI(2)'=5) D ^DGPMLOS W !!,"Admission LOS: ",+$P(X,"^",5)  ;IHS
 S DGPMIFN=DGPMVI(13) I +DGPMVI(2)'=4&(+DGPMVI(2)'=5) D ^DGPMLOS W ?45,"Admission LOS: ",+$P(X,"^",5)," days" ;IHS
 K A,C,I,J,X
 Q
 ;
CS2 ;-- additional fields for admission screen
 Q:DGPMT'=1
 ;IHS  removed religion, marital status, & eligibility from adm screen
 ;IHS  add here any IHS fields that should be included with adm screen
 Q  ;IHS
 S DGHOLD=$S($D(^DPT(DFN,0)):^(0),1:"")
 W !!,"Religion    : ",$S($D(^DIC(13,+$P(DGHOLD,U,8),0)):$E($P(^(0),U),1,24),1:"")
 W ?39,"Marital Status : ",$S($D(^DIC(11,+$P(DGHOLD,U,5),0)):$P(^(0),U),1:"")
 S DGHOLD=$S($D(^DPT(DFN,.36)):$P(^(.36),U),1:"")
 W !,"Eligibility : ",$S($D(^DIC(8,+$P(DGHOLD,U),0)):$P(^(0),U),1:"")
 S DGHOLD=$S($D(^DPT(DFN,.361)):^(.361),1:"")
 W:$P(DGHOLD,U)]"" " (",$P($P($P(^DD(2,.3611,0),U,3),$P(DGHOLD,U)_":",2),";"),")"
 W:$P(DGHOLD,U)']"" " (NOT VERIFIED)"
 K DGHOLD
 Q
 ;
IN5 ; -- calls IN5^VADPT and sets up array
 S VAHOW=2 D IN5^VADPT F I=1:1:8,13,14,17 S DGPMVI(I)=^UTILITY("VAIP",$J,I)
 S DGPMDCD=+^UTILITY("VAIP",$J,17,1) I $D(DGPMSVC) S DGPMSV=$S($D(^DIC(42,+^UTILITY("VAIP",$J,13,4),0)):$P(^(0),"^",3),1:"")
 S DGPMVI(13,1)=^UTILITY("VAIP",$J,13,1) K VAHOW
 Q
 ;
LODGER ;set-up necessary variables if getting last lodger episode
 ;only need 1,2,13,17 - date/time,TT,check-in IFN,check-out IFN
 S I=$O(^DGPM("ATID4",DFN,I)),I=$O(^(+I,0))
 S X=$S($D(^DGPM(+I,0)):^(0),1:"") I 'X D NULL Q
 I $D(^DGPM(+$P(X,"^",17),0)) S (DGPMDCD,DGPMVI(1))=+^(0),DGPMVI(2)=5,DGPMVI(13)=I,DGPMVI(17)=$P(X,"^",17) Q
 S (DGPMDCD,DGPMVI(17))="",DGPMVI(1)=+X,DGPMVI(2)=4,DGPMVI(13)=I
 Q
NULL S DGPMDCD="" F I=1,2,13,17 S DGPMVI(I)=""
 Q
