BRNLKI1 ; IHS/PHXAO/TMJ - IDENTIFIERS FOR DISCLOSURE LOOKUP 2 ; 
 ;;2.0;RELEASE OF INFO SYSTEM;;APR 10, 2003
 ;This Routine Displays Lookup for ^BRNREC Global
 ;This routine is called from ^BRNADD and uses different global
 ;references than ^BRNLKID
 ;
 ;At Lookup - Displays Date Initiated
 ;            Disclosure Number
 ;            Patient Name
 ;            Requesting Party
 ;            Purpose of Disclosure
 ;    If Requesting Party or Purpose are Null Displays UNKNOWN
 ;
START ; EXTERNAL ENTRY POINT - 
 ; PRINT DISPLAY OF RECORDS BEFORE ADDING NEW DISCLOSURE
 W !
 S BRNRDT=$$REFDTI^BRNRLU(BRNRIEN,"S") S BRNRDTP=$S(BRNRDT'="":BRNRDT,1:"UNKNOWN DATE INITIATED") W ?2,BRNRDTP
 W ?11,$P(^BRNREC(BRNRIEN,0),U,2)," "
 S BRNPAT=$P(^DPT(BRNDFN,0),U) W ?18,$E(BRNPAT,1,15)," "
 S BRNRFAC=$$FACREF^BRNRLU(BRNRIEN) W ?50,$E($S(BRNRFAC'="":BRNRFAC,1:"UNKNOWN"),1,30)
 ;Returns either Date of Disclosure or Uknown Date
 S BRNSVDT=$$AVDOS^BRNRLU(BRNRIEN,"S") S BRNSVDTP=$S(BRNSVDT'="":BRNSVDT,1:"UNKNOWN DISCLOSURE DATE") W !,?18,BRNSVDTP
 ;
TEST ;
 ;S BRNPURP=$P($G(^BRNREC(BRNRIEN,0)),U,7) S BRNPURPP=$S(BRNPURP'="":BRNPURP,1:"Purpose - NONE RECORDED") W ?50,$E(BRNPURPP,1,30)
 W ?50,"Purpose:  ",$$VAL^XBDIQ1(90264,BRNRIEN,.07)
 ;W !
 ;S BRNTYP=$P($G(^BRNREC(BRNRIEN,0)),U,4) S BRNTYPP=$S(BRNTYP'="":BRNTYPP,1:"Type - NONE RECORDED") W ?50,$E(BRNTYPP,1,30)
 W !
 W ?18,"Status: ",$$VAL^XBDIQ1(90264,BRNRIEN,.08)
 W ?50,"Type:  ",$$VAL^XBDIQ1(90264,BRNRIEN,.04)
 W !
XIT ;Kill off Variables no longer needed
 K BRNPAT,BRNPTDFN,BRNPURP,BRNPURPP,BRNRFAC,BRNSVDT,BRNSVDTP,BRNRDT,BRNRDTP
 Q
 ;
 ;
