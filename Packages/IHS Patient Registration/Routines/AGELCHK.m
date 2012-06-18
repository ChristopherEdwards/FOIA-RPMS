AGELCHK ; IHS/ASDS/EFG - TRIBE-QUANTUM-BEN CODE CONSISTENCY CHECKER ;  
 ;;7.1;PATIENT REGISTRATION;**4,5**;AUG 25,2005
 ;
 ; ****************************************************************
 ; This will return AG("ER",9)="" if the entry is inconsistant
 ; If AGWM is set=1 then messages will be writen out
 ; DFN is required
 ; ****************************************************************
 ;
SET ;
 S:'$D(AGWM) AGWM=0
 ;AGWM is to be set prior if Writing Messages is desired
 K AG("ER",9)
 I $D(^AUPNPAT(DFN,11)) D
 . S AG11=^AUPNPAT(DFN,11)
 . S AGB=$P(AG11,U,11)          ;CLASS/BENEFICIARY
 . S AGTP=$P(AG11,U,8)          ;TRIBE OF MEMBERSHIP
 . S AGQT=$P(AG11,U,9)          ;TRIBE QUANTUM
 . S AGQI=$P(AG11,U,10)         ;INDIAN BLOOD QUANTUM
 . S AGEL=$P(AG11,U,12)         ;ELIGIBILITY STATUS
 E  D  G EXIT
 . S AG("ER",9)=""
 . W:AGWM !,"< Missing Eligibility, Beneficiary, Tribal Information >"
S ;
TRIBE ;
 ;I $L(AGTP),$D(^AUTTTRI(AGTP,0)),$P(^(0),U,4)="N" S AGT=$P(^AUTTTRI(AGTP,0),U,2)
 I $L(AGTP),$D(^AUTTTRI(AGTP,0)),($P(^(0),U,4)="N"!($P(^(0),U,4)="")) S AGT=$P(^AUTTTRI(AGTP,0),U,2)  ;IHS/SD/TPF AG*7.1*4 IM23957
 E  D  G ELIG
 . S AG("ER",9)=""
 . S AGT=0
 . W:AGWM !,"<< INVALID old TRIBE >>"
 S AGT=+AGT
 S AGB=+AGB
 G:+AGB=1 IND                        ;BEN = Indian
 F I=6,18,32,33,8 I +AGB=I G NON
 ;all other BEN and tribe combinations are acceptable
 G ELIG
 ;****************************************************************
IND ;check BEN=1 TR'=000,970
 I AGT>0,AGT'=970 G ELIG
 E  D
 . S AG("ER",9)=""
 . W:AGWM !,"<< Native American requires Valid Indian Tribe >>"
 G ELIG
 ;****************************************************************
NON ;BEN - NON INDIAN TR=000,970
 I AGB=8,((AGT=0)!(AGT=999)!(AGT=970)) G ELIG
 E  I AGB=8 D  G ELIG
 . S AG("ER",9)=""
 . W:AGWM !,"< 'OTHER' Ben/Class requires 'Non-Indian' or 'Unspecified' Tribe >"
 I ((AGT=0)!(AGT=970)) G ELIG
 E  D
 . ;I AGT=990 Q  ;IHS/SD/TPF H5933
 . S AG("ER",9)=""
 . W:AGWM !,"< 'Non-Indian' Ben/Class requires 'Non-Indian' Tribe >"
 G ELIG
 ;****************************************************************
ELIG ;Check Eligibility
 I AGEL']"" D
 . S AG("ER",9)=""
 . W:AGWM !,"< Eligibility Missing >"
 I ((AGB=1)!(AGB=3)!(AGB=4)),AGEL="I" D
 . S AG("ER",9)=""
 . W:AGWM !,"< Ben/Class selected should be Eligible for care >"
TRBQT ;
 ;Check Tribe and Indian Quantum consistency
 ;I AGT=990,("NONE")[AGQI Q  ;IHS/SD/TPF H5933
 S AGTF=1
 I ((AGT=0)!(AGT=970)) S AGTF=0
 I AGT=999 F AGZ=6,8,18,32,33 S:AGB=AGZ AGTF=0
 I AGTF,AGEL="I" W:AGWM !,"< WARNING ... Valid Tribe should be Eligible for Care >",*7
 S AGQF=0
 I "UNKNOWN,NONE"'[AGQI S AGQF=1
 I AGTF=AGQF
 E  D
 . S AG("ER",9)=""
 . W:AGWM !,"< Tribe Selected and Indian Quantum are Inconsistent >"
QTCHK ;
 ;Check Quantums consistency
 I '$G(AGSITE),'$D(^AGFAC(DUZ(2))) Q
 I $G(AGSITE),'$D(^AGFAC(AGSITE)) Q
 I $P(^AGFAC($S($D(AGSITE):AGSITE,1:DUZ(2)),0),"^",2)'="Y" G END
 G:AGQT=AGQI END
 I "UNKNOWN,NONE"'[AGQI,"UNKNOWN,NONE"'[AGQT
 E  D
 . S AG("ER",9)=""
 . W:AGWM !,"< Quantums are Inconsistent >"
END ;
EXIT ;return to calling program
 K AGT,AG11,AGB,AGEL,AGWM,AGTF,AGQF
 Q
