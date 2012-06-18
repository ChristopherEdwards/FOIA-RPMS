BMCLKID ; IHS/PHXAO/TMJ - IDENTIFIERS FOR REFERRAL LOOKUP 2 ;     
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;IHS/ITSC/FCJ ADDED DISPLAY OF SEC VEND INFO; FX PAT DISPLAY
 ;    Secondary provider exist then will display Date created, 
 ;    apt date, purpose and vendor
 ;
 ;This Routine Displays Lookup for BMCREF Global
 ;The DD(90001,0,"ID","IHS0") Runs this Routine
 ;At Lookup - Displays Date Initiated
 ;            Referral Number
 ;            Patient Name
 ;            Facility or Provider Referred To
 ;            Purpose of Referral
 ;    If Facility Referred to or Purpose are Null Displays UNKNOWN
 ;
 ;
START ; EXTERNAL ENTRY POINT - 
 ; VALUE OF THE NAKED INDICATOR TO BE PROVIDED BY CALLING ROUTINE
 W:$X>50 !
 W ?5,$P(^(0),U,2),$P($G(^(1)),U)
 W " "
 ;FILEMAN VERSION LOOKUP
 S BMCPTDFN=$P(^(0),U,3) S BMCPAT=$P(^DPT(BMCPTDFN,0),U)
 I $G(^DD("VERSION"))>21 D
 . I $G(DZ)["?"!($G(X)=" ")!($G(DINDEX)="B")!($G(DINDEX)="BS1") W $E(BMCPAT,1,15)," "  ;4.0 FCJ ADDED BS1
 . E  W " "
 I $G(^DD("VERSION"))<22 D
 . W $E(BMCPAT,1,15)," "
 ;W @("$E("_DIC_"Y,0),0)") ; reset the naked
 S BMCRFAC=$$FACREF^BMCRLU(Y) W ?55,$E($S(BMCRFAC'="":BMCRFAC,1:"UNKNOWN"),1,25)
 S BMCVST=$P($G(^BMCREF(Y,11)),U,11) S BMCVSTP=$S(BMCVST'="":BMCVST,1:"I")
 W @("$E("_DIC_"Y,0),0)") ; reset the naked
 ;Returns either Estimated or Actual Beg Service Date
 S BMCSVDT=$$AVDOS^BMCRLU(Y,"C") S BMCSVDTP=$S(BMCSVDT'="":BMCSVDT,1:"UNKNOWN SERVICE DATE") W !,?30,BMCSVDTP_" - "_BMCVSTP
 W @("$E("_DIC_"Y,0),0)") ; reset the naked
 ;
 S BMCPURP=$P($G(^BMCREF(Y,12)),U) S BMCPURPP=$S(BMCPURP'="":BMCPURP,1:"Purpose - NONE RECORDED") W ?55,$E(BMCPURPP,1,25)
 W @("$E("_DIC_"Y,0),0)") ; reset the naked
 W !
 S BMCRNUMB=$P(^BMCREF(Y,0),U,2)
 I $P($G(^BMCREF(Y,1)),U)="" D SEC
 ;W @("$E("_DIC_"Y,0),0)") ; reset the naked
XIT ;Kill off Variables no longer needed
 K BMCPAT,BMCPTDFN,BMCPURP,BMCPURPP,BMCRFAC,BMCSVDT,BMCSVDTP
 K BMCRIEN,BMCSEC
 Q
SEC ;ENTRY POINT FR BMCLKID1; DISPLAY THE SECONDARY PROVIDER INFORMATION
 Q:BMCRNUMB=""
 I $D(^BMCREF("S",BMCRNUMB)) S BMCSUF=0 D
 .F  S BMCSUF=$O(^BMCREF("S",BMCRNUMB,BMCSUF)) Q:BMCSUF'?1A.N  D
 ..S BMCSRIEN=0
 ..F  S BMCSRIEN=$O(^BMCREF("S",BMCRNUMB,BMCSUF,BMCSRIEN)) Q:BMCSRIEN'?1N.N  D
 ...S Y=$P(^BMCREF(BMCSRIEN,0),U) D DT^BMCOSUT S BMCSCDT=Y
 ...S Y=$S($P(^BMCREF(BMCSRIEN,11),U,6)'="":$P(^BMCREF(BMCSRIEN,11),U,6),1:$P(^BMCREF(BMCSRIEN,11),U,5)) D DT^BMCOSUT S BMCSRDT=Y
 ...S BMCSVND=""
 ...S:$P(^BMCREF(BMCSRIEN,0),U,7)'="" Y=$P(^BMCREF(BMCSRIEN,0),U,7),BMCSVND=$P(^AUTTVNDR(Y,0),U)
 ...I BMCSVND="",$P(^BMCREF(BMCSRIEN,0),U,8)'="" S Y=$P(^BMCREF(BMCSRIEN,0),U,8),BMCSVND=$P(^DIC(4,Y,0),U)
 ...S BMCSPUR=$$VAL^XBDIQ1(90001,BMCSRIEN,1201)
 ...W ?10,"SEC ",BMCSCDT,"  ",BMCSRDT,"  ",$E(BMCSPUR,1,15),"  ",$E(BMCSVND,1,25)
 ...W !
 K BMCSUF,BMCSRIEN,BMCSCDT,BMCSRDT,BMCSPUR,BMCSVND
 Q
