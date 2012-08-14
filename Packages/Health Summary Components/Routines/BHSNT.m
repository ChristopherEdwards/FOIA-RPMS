BHSNT ;IHS/CIA/MGH - Health Summary for NARRATIVE TEXT file ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;===================================================================
 ;VA health summary component for narrative text
 ;Taken from APCHS81
 ; IHS/TUCSON/LAB - PART 2 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;2.0;IHS RPMS/PCC Health Summary;**2,3,8**;JUN 24, 1997
NT ; ******************** NARRATIVE TEXT 9000010.34 ******
 K BHSTXA
 ; <SETUP>
 N BHSPAT,BHSQ,X,Y
 S BHSPAT=DFN
 Q:'$D(^AUPNVNT("AA",BHSPAT))
 ; <DISPLAY>
 D CKP^GMTSUP Q:$D(GMTSQIT)  W !
 S BHSTT="" F BHSQ=0:0 S BHSTT=$O(^AUPNVNT("AA",BHSPAT,BHSTT)) Q:BHSTT=""  D
 .S BHSND2=GMTSNDM D NTDTYP Q:$D(GMTSQIT)
 D WRITE
 ; <CLEANUP>
NTX K BHSTT,BHSTT2,BHSTT3,BHSDFN,BHSND2,BHSDAT,BHSIVD,BHSTXA,APCHWP,APCHX,BHSNDM
 Q
NTDTYP S BHSTT2=$S($D(^AUTTNTYP(BHSTT,0)):$P(^(0),U,1),1:BHSTT) S BHSTT3=BHSTT2
 S (BHSIVD,BHSDFN)="" F  S BHSIVD=$O(^AUPNVNT("AA",BHSPAT,BHSTT,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  S BHSND2=BHSND2-1 Q:BHSND2=-1  D NTDSP
 Q
NTDSP ;
 S BHSDFN=0 F  S BHSDFN=$O(^AUPNVNT("AA",BHSPAT,BHSTT,BHSIVD,BHSDFN)) Q:BHSDFN'=+BHSDFN!($D(GMTSQIT))  S Y=-BHSIVD\1+9999999 D
 .S BHSTXA(BHSIVD,BHSTT,BHSDFN)=""
 Q
 ;
WRITE ;write out Narrative text
 S BHSIVD=0 F  S BHSIVD=$O(BHSTXA(BHSIVD)) Q:BHSIVD=""!($D(GMTSSQIT))  D
 .S BHSTT=0 F  S BHSTT=$O(BHSTXA(BHSIVD,BHSTT)) Q:BHSTT=""!($D(GMTSQIT))  D
 ..S BHSDFN=0 F  S BHSDFN=$O(BHSTXA(BHSIVD,BHSTT,BHSDFN)) Q:BHSDFN'=+BHSDFN!($D(BHSQIT))  D
 ...D CKP^GMTSUP Q:$D(GMTSQIT)
 ...W !,$$FMTE^XLFDT(9999999-BHSIVD),?23,$P(^AUTTNTYP(BHSTT,0),U)
 ... K APCHWP D WP
 ...S APCHX=0 F  S APCHX=$O(APCHWP(APCHX)) Q:APCHX'=+APCHX!($D(GMTSQIT))  D
 ....D CKP^GMTSUP Q:$D(GMTSQIT)
 ....W !?3,APCHWP(APCHX)
 ....Q
 ...Q
 ..Q
 .Q
 Q
WP ;EP - Entry point to print wp fields pass node in APCHWP
 NEW APCHG,APCHX,CNT
 K ^UTILITY($J,"W")
 S APCHX=0
 S DIWL=1,DIWR=70 F  S APCHX=$O(^AUPNVNT(BHSDFN,11,APCHX)) Q:APCHX'=+APCHX  D
 .S X=^AUPNVNT(BHSDFN,11,APCHX,0) D ^DIWP
 .Q
 S (Z,CNT)=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S CNT=CNT+1,APCHWP(CNT)=^UTILITY($J,"W",DIWL,Z,0)
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),APCHG,CNT,APCHX
 Q