BHSHS2 ;IHS/CIA/MGH - Health Summary Driver for ashtma, dental, RCIS and behavioral health ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;===================================================================
 ;This is the driving routine for VA health summaries to be made from
 ;the asthma registry, dental, behavioral health, and referred care
 ;Redone for conversion to VA health summary
 ;Taken from APCHS9
 ; IHS/TUCSON/LAB - PART 9 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;02
 ;;2.0;IHS RPMS/PCC Health Summary;**3,8,10**;JUN 24, 1997
 ;
AST ;EP - called from component
 ;*************** ASTHMA REGISRY **********************
 NEW X,S,BHSPAT
 S BHSPAT=DFN
 S X="BATSUM" X ^%ZOSF("TEST") I '$T Q
 ;asthma dx ever or asthma on pl or ast
 NEW D,P,A
 S A=$O(^AUPNVAST("AA",BHSPAT,0)) I A G AST1
 S A=$$PLAST^BATU(BHSPAT) I A]"" G AST1
 S A=$$DXAST^BATU(BHSPAT) I A G AST1
 Q
AST1 ;
 ;Routine that will find and display the ashtma registry data
 D REG^BHSASM
 Q
DENTAL ;EP -called from component
 ; ********** DENTAL SERVICES * 9002001 **********
 NEW X,BHSPAT,ADEPAT
 S (BHSPAT,ADEPAT)=DFN
 S X="ADERVW" X ^%ZOSF("TEST") I $T G START^BHSDEN ; <SETUP>
 Q:'$D(^ADESVC(BHSPAT))
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ; <DISPLAY>
 W "<DENTAL SERVICES DISPLAY ROUTINE MISSING!>",!
 ; <CLEANUP>
DENTALX K X
 Q
 ;
 ;
MHSS ;EP ********* MENTAL HEALTH/SOCIAL SERVICES * 9002011
 NEW X,BHSPAT
 S BHSPAT=DFN
 I +$D(^XUSEC("AMHZHS",DUZ)) D
 .S X="AMHHS" X ^%ZOSF("TEST") I $T G MH^BHSBH ; <SETUP>
 Q:'$D(^AMHREC("AC",BHSPAT))
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ; <DISPLAY>
 W "<MH/SS DISPLAY ROUTINE MISSING!>",!
 ; <CLEANUP>
MHSSX ;MHSS EXIT
 K X
 Q
CHR ;EP ********* CHR COMPONENT * 90002
 NEW X,BHSPAT
 S BHSPAT=DFN
 S X="BCHDHS" X ^%ZOSF("TEST") I $T G CHR^BHSBCH ; <SETUP>
 Q:'$D(^BCHR("AC",BHSPAT))
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ; <DISPLAY>
 W "<CHR DISPLAY ROUTINE MISSING!>",!
 ; <CLEANUP>
CHRX ;CHR EXIT
 K X
 Q
MCIS ; *********** MANAGED CARE MIS * 90001
 NEW X,BHSPAT
 S BHSPAT=DFN
 S X="BMCHS"
 X ^%ZOSF("TEST") I $T G HS^BHSRCIS ; write mcis summary
 G:'$D(^BMCREF("D",BHSPAT)) MCISX ; exit if no referrals for patient
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W "<MCIS DISPLAY ROUTINE MISSING!>",!
MCISX ;MCIS EXIT
 Q
