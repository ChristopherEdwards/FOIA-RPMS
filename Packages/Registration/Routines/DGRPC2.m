DGRPC2 ;ALB/MRL/SCK - CHECK CONSISTENCY OF PATIENT DATA (CONT) ;25 AUG 88@0901
 ;;5.3;Registration;**45,69,108,121,205,218,342,387,470,467,489,505,507**;Aug 13, 1993
 ;
43 ;
44 ;
45 ;
46 ;
47 I DGVT S X=42,DGD=DGP(.362) F I=12:1:14 S X=X+1 I DGCHK[(","_X_","),($P(DGD,"^",I)="Y"),($P(DGD,"^",20)="") D COMB
 S DGLST=$S(DGCHK[",47,":47,DGCHK[",46,":46,DGCHK[",45,":45,DGCHK[",44,":44,1:DGLST)
 D NEXT G @DGLST
48 I DGVT S DGD=DGP(.362) I DGCHK[(",48,"),($P(DGD,"^",17)="Y"),($P(DGD,"^",6)="") S X=48 D COMB
 D NEXT G @DGLST
49 ;
50 ; insurance checks
 I DGCHK[",49,"!(DGCHK[",50,") D  S DGLST=$S(DGCHK["50":50,1:49)
 . N COV,INS,X
 . S X=0,COV=$S($P(DGP(.31),"^",11)="Y":1,1:0)
 . D ALL^IBCNS1(DFN,"INS",2,DT)
 . I COV,'$G(INS(0)) S X=49 ; yes, but none
 . I 'COV,$G(INS(0)) S X=50 ; not yes, but some
 . I DGCHK[(","_X_",") D COMB
 D NEXT G @DGLST
51 D NEXT G @DGLST ; 51 disabled
 S X=$S($D(^DIC(21,+$P(DGP(.32),"^",3),0)):$P(^(0),"^",3),1:"")
 I X="Z"&($P(DGP(.32),"^",5)'=7)&($P(DGP(.32),"^",10)'=7)&($P(DGP(.32),"^",15)'=7)!($P(DGP(.32),"^",5)=7&(X'="Z")) S X=51 D COMB
 ;
52 I $P(DGP(.31),"^",11)']"" S X=52 D COMB ;automatically on
 D NEXT G @DGLST
53 I $P(DGP(.311),"^",15)']"" S X=53 D COMB ;automatically on
 D NEXT G @DGLST
54 ;
55 ;BELOW IS USED BY BOTH 54 & 55
 S DGLST=$S(DGCHK["55":55,1:54)
 I $G(^DPT(DFN,.35)),(^(.35)<+($E(DT,1,3)_"0000")) D NEXT G @DGLST ; patient died before current year
 N DGE S DGE=+$O(^DIC(8.1,"B","SERVICE CONNECTED 50% to 100%",0))
 I $P($G(^DPT(DFN,.3)),U,2)'<50!($P($G(^DIC(8,+$G(^DPT(DFN,.36)),0)),U,9)=DGE) D NEXT G @DGLST ;50-100% SC
 S DGPTYP=$G(^DG(391,+DGP("TYPE"),"S")),DGISYR=$E(DT,1,3)-1_"0000" I '$P(DGPTYP,"^",8)&('$P(DGPTYP,"^",9)) K DGPTYP,DGISYR D NEXT G @DGLST ; screens 8 and 9 off
 D ALL^DGMTU21(DFN,"VSD",DT,"IP")
 I '$P(DGPTYP,"^",8)!(DGCHK'["54") G JUST55 ; screen 8 off OR JUST 55 IN CHK
 S DGFL=0 I $D(DGREL("S")),($$SSN^DGMTU1(+DGREL("S"))']"") S DGFL=1
 I 'DGFL F I=0:0 S I=$O(DGREL("D",I)) Q:'I  I $$SSN^DGMTU1(+DGREL("D",I))']"" S DGFL=1 Q
 I DGFL S X=54 D COMB
JUST55 I DGCHK'["55" D NEXT G @DGLST
 S DGLST=55
 I '$P(DGPTYP,"^",9) D NEXT G @DGLST ; screen 9 off
 D TOT^DGRP9(.DGINC) S DGFL=0
 F DGD="V","S","D" I $D(DGTOT(DGD)) F I=8:1:17 I $P(DGTOT(DGD),"^",I)]"" S DGFL=1 Q
 I 'DGFL N DGAPD,DG55 D  I 'DGAPD&('DG55)  S X=55 D COMB
 . S DGAPD=+$$LST^DGMTU(DFN),DGAPD=+$P($G(^DGMT(408.31,+DGAPD,0)),U,11)
 . S DG55=$$CHECK55(DFN) ; **507, Additional Income Checks
 D NEXT G @DGLST
56 I DGVT S DGD=DGP(.3) I DGCHK[(",56,"),($P(DGD,"^",11)="Y"),($P(DGP(.362),"^",20)="") S X=56 D COMB
 D NEXT G END:$S('+DGLST:1,+DGLST=99:1,1:0)
57 I $P(DGP(.38),U,1) D
 .N X1,X2
 .S X1=$P(DGP(.38),U,2)
 .S X=$P($G(^DG(43,1,0)),U,46) S X2=$S(X:X,1:365) D C^%DTC
 .I X<DT S X=57 D COMB
 D NEXT G @DGLST
58 ;58 - EC Claim - No Gulf/Som Svc
 I $P(DGP(.322),U,13)="Y" D
 . I $P(DGP(.322),U,10)="Y"!($P(DGP(.322),U,16)="Y") Q
 . S X=58 D COMB
 D NEXT G @DGLST
59 ;59 - incomplete Catastrophic Disability info
 I $$HASCAT^DGENCDA(DFN) D
 .I '$P(DGP(.39),"^",2) S X=59 D COMB
 D NEXT G @DGLST
60 ;60 - Location of agent orange exposure unanswered
 I DGVT,$P(DGP(.321),"^",2)="Y",$P(DGP(.321),"^",13)="" S X=60 D COMB
 D NEXT G @DGLST
61 ;61 - Incomplete Phone Number
 I $P(DGP(.13),"^")=""!($P(DGP(.13),"^",2)="") S X=61 D COMB
 D NEXT G @DGLST
62 ;62 - Missing Emergency Contact Name
 I $P(DGP(.33),"^")="" S X=62 D COMB
 D NEXT G @DGLST
63 ;Confidential Address check
 I $P($$CAACT^DGRPCADD(DFN),U) D
 .N DGI,DGERR
 .S DGERR=0
 .F DGI=1,4,5,6 Q:DGERR  I $P(DGP(.141),U,DGI)="" S DGERR=1
 .I DGERR S X=63 D COMB
 D NEXT G @DGLST
64 ;64 - Place of Birth City/State Missing ;**505
 I $P(DGP(0),"^",11)=""!($P(DGP(0),"^",12)="") S X=64 D COMB
 D NEXT G @DGLST
65 ;65 - Mother's Maiden Name Missing ;**505
 I $P(DGP(.24),"^",3)="" S X=65 D COMB
 D NEXT G @DGLST
66 ;66 - Pseudo SSN in use ;**505
 I $P(DGP(0),"^",9)["P" S X=66 D COMB
 D NEXT G @DGLST
99 ; synonymous with END
END I DGNCK S X=99 D COMB
 I DGEDCN S DGCON=0 D TIME^DGRPC
 K C,C1,C2,DGCD,DGD,DGD1,DGD2,DGDATE,DGDEP,DGCHK,DGFL,DGINC,DGISYR,DGLST,DGMS,DGNCK,DGP,DGPTYP,DGREL,DGSCT,DGT,DGTIME,DGTOT,DGVT,I,I2,I2,J,VAIN,X,X1
 G ^DGRPCF
 ;
COMB S DGCT=DGCT+1,DGER=DGER_X_",",DGLST=X Q
 ;
NEXT S I=$F(DGCHK,(","_+DGLST_",")),DGLST=+$E(DGCHK,I,999) S:'DGLST DGLST="END" Q
FIND F I=DGLST:1:99 I DGCHK[(","_I_",") Q
 I DGNCK,(I>17),(I<36) S DGLST=36 G FIND
 I I,I<99 S DGLST=I G @(DGLST_$S(DGLST>42:"",DGLST>17:"^DGRPC1",1:"^DGRPC"))
 G END
 ;
CHECK55(DFN) ;Buisness rules for additional 55-INCOME DATA MISSING checks
 ;  Modeled from DGMTR checks.
 ;  Input  DFN - IEN from PATIENT File #2
 ;
 ;  Output 1 - If Income check passes additional buisness rules
 ;         0 - If Income check fails additional buisness rules
 ;
 N VAMB,VASV,VA,VADMVT,VAEL,VAINDT,DGRTN,DGMED,DG,DG1,DGWARD,DGSRVC
 ;
 S DGRTN=0
 D MB^VADPT I +VAMB(7) S DGRTN=1 G Q55  ; Check if receiving VA Disability
 D SVC^VADPT I +VASV(4) S DGRTN=1 G Q55  ; check if POW status indicated
 I +VASV(9),(+VASV(9,1)=3) S DGRTN=1 G Q55  ; Check if Purple Heart Status is Confirmed
 D GETS^DIQ(2,DFN_",",".381:.383","I","DGMED")
 I $G(DGMED(2,DFN_",",.381,"I")) S DGRTN=1 G Q55  ; Check if eligible for Medicaid
 D ADM^VADPT2 ; Check for current admission to DOM ward 
 I +$G(VADMVT) D  G:DGRTN Q55
 . Q:'$$GET1^DIQ(43,1,16,"I")  ; Has Dom wards?
 . S DGWARD=$$GET1^DIQ(405,VADMVT,.06,"I") ; Get ward location
 . S DGSRVC=$$GET1^DIQ(42,DGWARD,.03,"I") ; Get ward service
 . S:DGSRVC="D" DGRTN=1 ; If ward service is 'D', then return 1
 ;
 ; Additional checks for 0% SC
 D ELIG^VADPT
 I +VAEL(3),'$P(VAEL(3),U,2) D  ; Check if service connected with % of zero
 . I +VAMB(4) S DGRTN=1 Q  ; Check if receiving a VA pension
 . S DG=0 ; Check for secondary eligibilities
 . F  S DG=$O(VAEL(1,DG)) Q:'DG  D  Q:DGRTN
 . . F DG1=2,4,15,16,17,18 I DG=DG1 S DGRTN=1 Q
 ;
Q55 D KVAR^VADPT
 Q $G(DGRTN)
