APCLV2 ; IHS/CMI/LAB - get values for stat record ;
 ;;2.0;IHS PCC SUITE;**2,4**;MAY 14, 2009
 ;
 ;IHS/TUCSON/LAB - patch 1 - 06/02/97 - added this new routine to 
 ;support additions to the statistical database record
 ;;CMI/LAB - Patch 2 -02/23/98 - modified subroutines ACE and DMNUTR
 ;;to fix problems with the data being passed to the data center
 ;cmi/anch/maw 9/12/2007 code set versioning in WT
 ;
HGBA1C(V) ;EP - called to return value of HGBA1C if done on this visit
 ;V is visit ien
 NEW R
 S R=""
 I '$D(^AUPNVSIT(V)) Q R
 I '$D(^AUPNVLAB("AD",V)) Q R  ;no v labs to check
 I '$D(^ATXLAB("B","DM AUDIT HGB A1C TAX")) Q R
 NEW Y S Y=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0))
 I 'Y Q R  ;no taxonomy to look at
 NEW X,Z
 S X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVLAB(X,0),U) I Z,$D(^ATXLAB(Y,21,"B",Z)) S R=$P(^AUPNVLAB(X,0),U,4)
 Q R
 ;
HTN(P) ;EP - is htn documented for this patient ever?  Y or N retured
 NEW R,X,E,APCLV2
 S R=""
 I '$D(^DPT(P)) Q R
 I $P(^DPT(P,0),U,19) Q R
 I '$D(^AUPNVPOV("AC",P)) Q R  ;no povs on file
 NEW X,E S X=P_"^LAST DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"APCLV2(")
 Q $P($G(APCLV2(1)),U)
 ;
BP(V) ;EP - systolic pressure this visit
 ;V is visit ien
 I '$D(^AUPNVSIT(V)) Q ""
 I '$D(^AUPNVMSR("AD",V)) Q ""
 NEW Y S Y=$O(^AUTTMSR("B","BP",0))
 I 'Y Q ""
 NEW X,Z,R S R=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  I $P(^AUPNVMSR(X,0),U)=Y,'$P($G(^AUPNVMSR(X,2)),U,1) S R=$P(^AUPNVMSR(X,0),U,4)
 Q R
 ;
ACE(V) ;EP - ace inhibitor filled this visit
 ;V is visit ien
 I '$D(^AUPNVSIT(V)) Q ""
 I '$D(^AUPNVMED("AD",V)) Q "N"  ;no v meds to check
 NEW Y S Y=$O(^ATXAX("B","DM AUDIT ACE INHIBITORS",0))
 I 'Y Q ""
 ;CMI/LAB 02/23/98 Patch #2 Modified subroutine to fix problems with
 ;data being passed to the Data Center.
 ;Added R to NEW statement below and added the setting of R=""
 ;in the line that follows
 ;BEG ORG CODE
 ;NEW X,Z
 ;END ORG CODE
 ;BEG NEW CODE
 NEW X,Z,R
 S R=""
 ;END NEW CODE
 S X=0 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVMED(X,0),U) I $D(^ATXAX(Y,21,"B",Z)) S R=1
 Q $S($G(R):"Y",1:"N")
 ;
RW(V) ;EP called to return %recommended weight
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I '$D(^AUPNVMSR("AD",V)) Q ""
 NEW Y S Y=$O(^AUTTMSR("B","WT",0))
 I 'Y Q ""
 NEW X,Z,R S R=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  I $P(^AUPNVMSR(X,0),U)=Y S R=$P(^AUPNVMSR(X,0),U,4)
 S R=$$RW^APCL2A3($P(^AUPNVSIT(V,0),U,5),R,$P(^AUPNVSIT(V,0),U))
 Q R
 ;
DMNUTR(V) ;EP - was dm nutrition educ done on this visit, Y or N
 I '$G(V) Q "N"
 I '$D(^AUPNVSIT(V)) Q "N"
 I '$D(^AUPNVPED("AD",V)) Q "N"
 NEW Y S Y=$O(^ATXAX("B","APCL DM NUTRITION EDUC TOPICS",0))
 I 'Y Q ""
 ;CMI/LAB 02/23/98 Patch #2 - Modified subroutine to fix problems with 
 ;data being passed to the Data Center
 ;Added R to NEW statement below and added the setting of R=""
 ;in the line that follows.
 ;BEG ORG CODE
 ;NEW X,Z
 ;END ORG CODE
 ;BEG NEW CODE
 NEW X,Z,R
 S R=""
 ;END NEW CODE
 S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVPED(X,0),U) I $D(^ATXAX(Y,21,"B",Z)) S R=1
 Q $S($G(R):"Y",1:"N")
 ;
HC(V) ;EP - return y or n if head circumference done
 ;V is visit ien
 I '$D(^AUPNVSIT(V)) Q ""
 I '$D(^AUPNVMSR("AD",V)) Q "N"
 NEW Y S Y=$O(^AUTTMSR("B","HC",0))
 I 'Y Q ""
 NEW X,Z,R S R=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  I $P(^AUPNVMSR(X,0),U)=Y S R=1
 Q $S($G(R):"Y",1:"N")
 ;
 ;
DISPER(V) ;EP - called to get ER disposition
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I $$CLINIC^APCLV(V,"C")'=30 Q ""
 NEW Y S Y=$O(^AUPNVER("AD",V,0)) I 'Y Q ""
 Q $$VALI^XBDIQ1(9000010.29,Y,.11)
 ;
PBMI ;EP
 NEW %,W,H,B,D,%DT,BDATE,AGE,WD,HD,VALUE,V,ERRC,ERR,BMI,CD,WD,HD,WV,HV,OW,OH
 S ERRC=0
 S VALUE=""
 I $G(EDATE)="" S EDATE=DT
 I $G(P)="" Q "^^^^^^^PATIENT DFN INVALID"
 I '$D(^AUPNPAT(P,0)) Q "^^^^^^^PATIENT DFN INVALID"
 I '$D(^DPT(P,0)) Q "^^^^^^^PATIENT DFN INVALID"
 S AGE=$$AGE^AUPNPAT(P,EDATE)
 S VALUE=""
 I AGE>18,AGE<50 D  Q VALUE
 .S CD=$$FMADD^XLFDT(EDATE,-(5*365))  ;5 yrs
 .S BDATE=$$FMTE^XLFDT($$DOB^AUPNPAT(P))
 .S EDATE=$$FMTE^XLFDT(EDATE)
 .;get last weight on file
 .S V=$$WT(P,BDATE,EDATE)
 .S (W,OW)=$P(V,U,1)  ;weight value
 .I W=""!(W="?") S ERR="NO WEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S WD=$P(V,U,2)  ;weight date
 .I WD<CD S ERR="WARNING: WEIGHT IS GREATER THAN 5 YRS OLD" D ERR
 .S WV=$P(V,U,3)
 .S V=$$HT(P,BDATE,EDATE)
 .S (H,OH)=$P(V,U,1)
 .I H="" S ERR="NO HEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S HD=$P(V,U,2)
 .I HD<CD S ERR="WARNING: HEIGHT IS GREATER THAN 5 YRS OLD" D ERR
 .S HV=$P(V,U,3)
 .S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 .D SETV
 I AGE>49 D  Q VALUE
 .S CD=$$FMADD^XLFDT(EDATE,-(2*365))  ;5 yrs
 .S BDATE=$$FMTE^XLFDT($$DOB^AUPNPAT(P))
 .S EDATE=$$FMTE^XLFDT(EDATE)
 .;get last weight on file
 .S V=$$WT(P,BDATE,EDATE)
 .S (W,OW)=$P(V,U,1)  ;weight value
 .I W=""!(W="?") S ERR="NO WEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S WD=$P(V,U,2)  ;weight date
 .I WD<CD S ERR="WARNING: WEIGHT IS GREATER THAN 2 YRS OLD" D ERR
 .S WV=$P(V,U,3)
 .S V=$$HT(P,BDATE,EDATE)
 .S (H,OH)=$P(V,U,1)
 .I H="" S ERR="NO HEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S HD=$P(V,U,2)
 .I HD<CD S ERR="WARNING: HEIGHT IS GREATER THAN 2 YRS OLD" D ERR
 .S HV=$P(V,U,3)
 .S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 .D SETV
 .Q
 I AGE<19 D  Q VALUE
 .S CD=$$FMADD^XLFDT(EDATE,-365)
 .S BDATE=$$FMTE^XLFDT($$DOB^AUPNPAT(P))
 .S EDATE=$$FMTE^XLFDT(EDATE)
 .S X=$$HTWTSD(P,BDATE,EDATE)
 .I '$P(X,"^") S ERR="NO WEIGHT FOUND ON SAME DAY AS HT ON OR PRIOR TO "_EDATE D ERR Q
 .I '$P(X,"^",4) S ERR="NO HEIGHT FOUND ON SAME DAY AS WT ON OR PRIOR TO "_EDATE D ERR Q
 .S (W,OW)=$P(X,"^"),(H,OH)=$P(X,"^",4)
 .S WD=$P(X,U,2)
 .I WD<CD S ERR="WARNING: WEIGHT IS OVER 1 YEAR OLD" D ERR
 .S WV=$P(X,U,3)
 .S HD=$P(X,U,5)
 .I HD<CD S ERR="WARNING: HEIGHT IS OVER 1 YEAR OLD" D ERR
 .S HV=$P(X,U,6)
 .S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 .D SETV
 .Q
 Q
HTWTSD(P,BDATE,EDATE) ;get last ht / wt on same day
 I '$G(P) Q ""
 NEW APCLWTS,APCLHTS,%,X,APCLWTS1,APCLHTS1,Y
 ;get all hts during time frame
 S %=P_"^ALL MEAS HT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"APCLHTS(")
 S Y=0 F  S Y=$O(APCLHTS(Y)) Q:Y'=+Y  I $P(APCLHTS(Y),U,2)="?"!($P(APCLHTS(Y),U,2)="") K APCLHTS(Y)
 ;set the array up by date
 K APCLHTS1 S X=0 F  S X=$O(APCLHTS(X)) Q:X'=+X  S APCLHTS1($P(APCLHTS(X),U))=X
 ;get all wts during time frame
 S %=P_"^ALL MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"APCLWTS(")
 S Y=0 F  S Y=$O(APCLWTS(Y)) Q:Y'=+Y  I $P(APCLWTS(Y),U,2)="?"!($P(APCLWTS(Y),U,2)="") K APCLWTS(Y)
 ;set the array up by date
 K APCLWTS1 S X=0 F  S X=$O(APCLWTS(X)) Q:X'=+X  S APCLWTS1($P(APCLWTS(X),U))=X
 S APCLCHT="",X=9999999 F  S X=$O(APCLWTS1(X),-1) Q:X=""!(APCLCHT]"")  I $D(APCLHTS1(X))  D
 .S APCLCHT=$P(APCLWTS(APCLWTS1(X)),U,2)_U_$P(APCLWTS(APCLWTS1(X)),U,1)_U_$P(APCLWTS(APCLWTS1(X)),U,5)_U_$P(APCLHTS(APCLHTS1(X)),U,2)_U_$P(APCLHTS(APCLHTS1(X)),U,1)_U_$P(APCLHTS(APCLHTS1(X)),U,5)
 Q APCLCHT
 ;
HT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,APCLARRY,H,E
 S %=P_"^LAST MEAS HT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"APCLARRY(")
 S H=$P($G(APCLARRY(1)),U,2)
 I H="" Q H
 I H["?" Q ""
 S H=H_U_$P(APCLARRY(1),U,1)_U_$P(APCLARRY(1),U,5)
 Q H
 ;
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,APCLLW,X,APCLLN,APCLL,APCLLD,APCLLZ,APCLLX,APCLICD
 K APCLL S APCLLW="" S APCLLX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(APCLLX,"APCLL(")
 S APCLLN=0 F  S APCLLN=$O(APCLL(APCLLN)) Q:APCLLN'=+APCLLN!(APCLLW]"")  D
 .S APCLLZ=$P(APCLL(APCLLN),U,5)
 .I '$D(^AUPNVPOV("AD",APCLLZ)) S APCLLW=$P(APCLL(APCLLN),U,2)_U_$P(APCLL(APCLLN),U,1)_U_$P(APCLL(APCLLN),U,5) Q
 . S APCLLD=0 F  S APCLLD=$O(^AUPNVPOV("AD",APCLLZ,APCLLD)) Q:'APCLLD!(APCLLW]"")  D
 .. ;S APCLICD=$P(^ICD9($P(^AUPNVPOV(APCLLD,0),U),0),U) D  ;cmi/anch/maw 9/12/2007 orig line
 .. S APCLICD=$P($$ICDDX^ICDCODE($P(^AUPNVPOV(APCLLD,0),U)),U,2) D  ;cmi/anch/maw 9/12/2007 csv
 ...I $E(APCLICD,1,3)="V22" Q
 ...I $E(APCLICD,1,3)="V23" Q
 ...I $E(APCLICD,1,3)="V27" Q
 ...I $E(APCLICD,1,3)="V28" Q
 ...I APCLICD>629.9999&(APCLICD<676.95) Q
 ...I APCLICD>61.49&(APCLICD<61.71) Q
 ...S APCLLW=$P(APCLL(APCLLN),U,2)_U_$P(APCLL(APCLLN),U,1)_U_$P(APCLL(APCLLN),U,5)
 ..Q
 Q APCLLW
 ;
ERR ;
 S ERRC=ERRC+1
 NEW C
 S C=$P(VALUE,U,8)
 S $P(C,"|",ERRC)=ERR
 S $P(VALUE,U,8)=C
 Q
 ;
SETV ;
 S $P(VALUE,U,1)=BMI
 S $P(VALUE,U,2)=OH
 S $P(VALUE,U,3)=HD
 S $P(VALUE,U,4)=HV
 S $P(VALUE,U,5)=OW
 S $P(VALUE,U,6)=WD
 S $P(VALUE,U,7)=WV
 Q
