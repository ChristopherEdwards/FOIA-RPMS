BHSMEA ;IHS/CIA/MGH - Health Summary for Measurements and immunizations ;26-Apr-2011 16:42;DU
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2,3,4,5**;March 17, 2006;Build 9
 ;===================================================================
 ;Taken from APCHS2
 ; IHS/TUCSON/LAB - PART 2 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;2.0;IHS RPMS/PCC Health Summary;**2,3**;JUN 24, 1997
 ;IHS/CMI/LAB - patch 2 fixed AGE subroutine
 ;IHS/CMI/LAB - patch 3 new imm package
 ;Creation of VA health summary components from IHS health summary components
 ;for V measurement file and immunizations
 ;Patch 2 for patch 16 and CVS changes
 ;Patch 3 to fix a bug in the display
 ;Patch 4 added qualifiers for vitals
 ;Patch 5 fixed a bug with items with / in them
 ;
MEAS ; ******************** MEASUREMENTS * 9000010.01 *******
 ; <SETUP>
 N BHSPAT,Y,ARRAY
 S BHSPAT=DFN
 Q:'$D(^AUPNVMSR("AA",BHSPAT))
 ; <DISPLAY>
 D CKP^GMTSUP Q:$D(GMTSQIT)  W !
 S BHSMT="" F BHSQ=0:0 S BHSMT=$O(^AUPNVMSR("AA",BHSPAT,BHSMT)) Q:BHSMT=""  S BHSND2=GMTSNDM D MEASDTYP Q:$D(GMTSQIT)
 D WRTOUT
 ; <CLEANUP>
MEASX K BHSMT,BHSMT2,BHSMT3,BHSDFN,BHSND2,BHSDAT
 Q
MEASDTYP S BHSMT2=$S($D(^AUTTMSR(BHSMT,0)):$P(^(0),U,1),1:BHSMT) S BHSMT3=BHSMT2
 S (BHSIVD,BHSDFN)="" F  S BHSIVD=$O(^AUPNVMSR("AA",BHSPAT,BHSMT,BHSIVD)) Q:BHSIVD=""!(BHSIVD>GMTSDLM)  S BHSND2=BHSND2-1 Q:BHSND2=-1  D MEASDSP
 I BHSMT3="" D CKP^GMTSUP Q:$D(GMTSQIT)  W !
 Q
MEASDSP ;
 ;IHS/MSC/MGH changed lookup o find more than one vital during a visit
 ;Patch 3 fixed a bug in display of items with a / in them
 N DATA,V,T,BHSDAT2
 S BHSDFN="" F  S BHSDFN=$O(^AUPNVMSR("AA",BHSPAT,BHSMT,BHSIVD,BHSDFN)) Q:BHSDFN=""  D
 .Q:$P($G(^AUPNVMSR(BHSDFN,2)),U,1)   ;entered in error
 .S V=$P(^AUPNVMSR(BHSDFN,0),U,3) Q:$P($G(^AUPNVSIT(V,0)),U,7)="H"  ;exclude inpatient
 .S BHSDAT=$P($G(^AUPNVMSR(BHSDFN,12)),U,1) S X=BHSDAT
 .I BHSDAT="" S (X,BHSDAT)=-BHSIVD\1+9999999
 .D REGDTM^GMTSU
 .S BHSDAT2=X
 .S ARRAY(BHSMT2,BHSDAT)=BHSDFN_"^"_BHSDAT2
 Q
WRTOUT ;Write out the vitals
 N I,BHSDAT,BHSDFN,BHSDAT2,BHSMT,BHSX
 D CKP^GMTSUP Q:$D(GMTSQIT)
 S BHSMT2=""
 S BHSMT="" F  S BHSMT=$O(ARRAY(BHSMT)) Q:BHSMT=""  D
 .I BHSMT'=BHSMT2 W !,BHSMT S BHSMT2=BHSMT
 .S BHSDAT="" F  S BHSDAT=$O(ARRAY(BHSMT,BHSDAT)) Q:BHSDAT=""  D
 ..S BHSDFN=$P($G(ARRAY(BHSMT,BHSDAT)),U,1)
 ..S BHSDAT2=$P($G(ARRAY(BHSMT,BHSDAT)),U,2)
 ..;W:GMTSNPG!(BHSMT3]"") BHSMT2 S BHSMT3="" W ?5,BHSDAT2
 ..W ?5,BHSDAT2
 ..S DATA=$P($G(^AUPNVMSR(BHSDFN,0)),U,4)
 ..I $P(DATA,".",2)'="" S DATA=+$J(DATA,0,2)
 ..W ?22,DATA
 ..I '$O(^AUPNVMSR(BHSDFN,5,0)) W ! Q   ;no qualifiers
 ..S C=0,X=0 F  S X=$O(^AUPNVMSR(BHSDFN,5,X)) Q:X'=+X  S C=C+1
 ..W ?32,"QUALIFIER"_$S(C>1:"'s",1:""),":"
 ..S T=45 S BHSX=0 F  S BHSX=$O(^AUPNVMSR(BHSDFN,5,BHSX)) D  Q:BHSX'=+BHSX
 ...S Y=$P($G(^AUPNVMSR(BHSDFN,5,BHSX,0)),U) I Y W ?T,$P($G(^GMRD(120.52,Y,0)),U,2) S T=T+5
 ...W !
 Q
 ;
IMMUN ; ******************** IMMUNIZATIONS * 9000010.11 *******
 N BHSPAT,BHSP,BHSQ,Y
 S BHSPAT=DFN
 I +$$VER^BILOGO>7 D IMMBI2 Q  ;IHS/CMI/MWR  8/19/03, for Immunization v8.x
 I $$BI D IMMBI Q  ;IHS/CMI/LAB - new imm package
 ; <SETUP>
 Q:'$D(^AUPNVIMM("AA",BHSPAT))
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ; <DISPLAY>
 S BHSITP="" F BHSQ=0:0 S BHSITP=$O(^AUPNVIMM("AA",BHSPAT,BHSITP)) Q:BHSITP=""  D IMMDTYP
 ; <CLEANUP>
REF ;Patch 2 display refusals/contraindications
 S BHY=0 F  S BHY=$O(^BIPC("AC",BHSPAT,BHY)) Q:BHY'=+BHY  D
 .S BHX=0 F  S BHX=$O(^BIPC("AC",BHSPAT,BHY,BHX)) Q:BHX'=+BHX  D
 ..S R=$P(^BIPC(BHX,0),U,3)
 ..Q:R=""
 ..Q:'$D(^BICONT(R,0))
 ..Q:$P(^BICONT(R,0),U,1)'["Refusal"
 ..S D=$P(^BIPC(BHX,0),U,4)
 ..Q:D=""
 ..S D=9999999-D
 ..Q:D>GMTSDLM
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,$$VAL^XBDIQ1(9002084.11,BHX,.02)," -- ",$$VAL^XBDIQ1(9002084.11,BHX,.03),?60,"(",$$DATE^BHSMU($P(^BIPC(BHX,0),U,4)),")"
 ..Q
 .Q
 S BHSFN=9999999.14,BHST="" D DISPREF^BHSRAD
 K BHSFN,BHST,BHSS
IMMUNX K BHSITP,BHSITX,BHSITL,BHSDFN,BHSDAT,BHSIVD,BHSVDF,BHX,BHY,R,D
 K BHSIMC,BHSIMR,BHSN,BHSIC,BHSIR
 K BHSNFL,BHSNSH,BHSNAB,BHSVSC,BHSITE
 Q
IMMDTYP S BHSITX=$P(^AUTTIMM(BHSITP,0),U,2),BHSITL=$L(BHSITX) D CKP^GMTSUP Q:$D(GMTSQIT)  D
 .W ! D CKP^GMTSUP Q:$D(GMTSQIT)  W BHSITX S BHSIVD=""
 .F BHSQ=0:0 S BHSIVD=$O(^AUPNVIMM("AA",BHSPAT,BHSITP,BHSIVD)) Q:'BHSIVD  D IMMDSP
 Q
IMMDSP S BHSDFN=0 F BHSQ=0:0 S BHSDFN=$O(^AUPNVIMM("AA",BHSPAT,BHSITP,BHSIVD,BHSDFN)) Q:BHSDFN=""  D IMMDSP2
 Q
IMMDSP2 S X=-BHSIVD\1+9999999 D REGDT4^GMTSU S BHSDAT=X
 S BHSN=^AUPNVIMM(BHSDFN,0)
 S BHSVDF=$P(BHSN,U,3) D GETSITEV^BHSUTL S BHSITE=BHSNSH
 S X=$P(BHSN,U,6),Y=.06 D IMMGSET S BHSIR=BHSP
 S X=$P(BHSN,U,7),Y=.07 D IMMGSET S BHSIC=BHSP S:BHSIC]"" BHSIC="DO NOT REPEAT"
 I BHSIC]"",BHSIR]"" S BHSIR=BHSIR_"; "
 S BHSIR=BHSIR_BHSIC
 ;modified following line - LAB
 D CKP^GMTSUP Q:$D(GMTSQIT)  W:GMTSNPG BHSITX W ?(BHSITL+1),$P(^AUPNVIMM(BHSDFN,0),U,4),?15,BHSDAT,?25,$$AGE(BHSPAT,$P(+^AUPNVSIT(BHSVDF,0),"."),"P"),?34,BHSITE,?65,BHSIR,!
 Q
IMMGSET S Y=$G(^DD(9000010.11,Y,0)),Y=$P(Y,U,3)
 S:'X Y=""
 F BHSQ=1:1 S BHSP=$P(Y,";",BHSQ) Q:BHSP=""  I $P(BHSP,":",1)=X S BHSP=$P(BHSP,":",2) Q
 Q
 ;
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
 ;-----------
AGE(DFN,D,F) ;(DFN) Given DFN, return Age. ; AUPN*93.2*3
 I '$G(DFN) Q -1
 I '$D(^DPT(DFN,0)) Q -1
 I $$DOB^AUPNPAT(DFN)<0 Q -1
 S:$G(D)="" D=DT
 S:$G(F)="" F="Y"
 NEW %
 S %=$$FMDIFF^XLFDT(D,$$DOB^AUPNPAT(DFN))
 I F="Y" Q %\365.25
 ;beginning Y2K
 ;NEW %1 S %1=%\365.25,%=$S(%1>2:%1_" YRS",%<31:%1_" DYS",1:%\30_" MOS") ;Y2000
 NEW %1 S %1=%\365.25,%=$S(%1>2:%1_" YRS",%<31:%_" DYS",1:%\30_" MOS") ;Y2000
 ;end Y2000
 Q %
 ;
 ;
IMMBI ;IHS/CMI/LAB - new subroutine for new imm package
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ;
 ;
 ;
 NEW APCH31,APCHIMM,APCHBIER
 S APCH31=$C(31)_$C(31),APCHIMM=""
 D IMMFORC^BIRPC(.APCHIMM,BHSPAT)
 ;
 W ?3,"IMMUNIZATION FORECAST:",!!
 ;
 D
 .;---> Check for error in 2nd piece of return value.
 .S APCHBIER=$P(APCHIMM,APCH31,2)
 .;---> If there's an error, display it and quit.
 .I APCHBIER]"" D CKP^GMTSUP Q:$D(GMTSQIT)  D  Q
 ..D EN^DDIOL("* "_APCHBIER,"","?5") W !
 .;
 .;---> No error, so take 1st piece of return value and process it.
 .S APCHIMM=$P(APCHIMM,APCH31,1)
 .;
 .NEW APCHX,APCHI F APCHX=1:1 S APCHI=$P(APCHIMM,"^",APCHX) Q:APCHI=""!($D(GMTSQIT))  D
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W ?3,$P(APCHI,"|"),?23,$P(APCHI,"|",2),?36,$P(APCHI,"|",3),!
 ..Q
 ;
CONTRAS ;
 ;
 N APCHCONT S APCHCONT=""
 ;
 ;---> RPC to retrieve Contraindications.
 D CONTRAS^BIRPC5(.APCHCONT,BHSPAT)
 ;
 ;---> If APCHBIER has a value, display it and quit.
 S APCHBIER=$P(APCHCONT,APCH31,2)
 I APCHBIER]"" D CKP^GMTSUP Q:$D(GMTSQIT)  D EN^DDIOL("* "_APCHBIER,"","!!?5") G HX
 ;
 ;---> Set APCHC=to a string of Contraindications for this patient.
 N APCHC S APCHC=$P(APCHCONT,APCH31,1)
 I APCHC]"" D CKP^GMTSUP Q:$D(GMTSQIT)  W !
 ;
 ;---> Build Listmanager array from APCHC string.
 ;
 F I=1:1 S Y=$P(APCHC,U,I) Q:Y=""  D
 .;---> Build display line for this Contraindication.
 .N V S V="|",X="      "
 .S:I=1 X=X_"* Contraindications:" S X=$$PAD(X,28)
 .;
 .;---> Display "Vaccine:  Date  Reason"
 .S X=X_$P(Y,V,2)_":",X=$$PAD(X,40)_$P(Y,V,4)
 .S X=$$PAD(X,53)_$P(Y,V,3)
 .;---> Set formatted Contraindication line and index in ^TMP.
 .D CKP^GMTSUP Q:$D(GMTSQIT)  W X,!
 .Q
 ;
 ;
 ;
HX ;
 NEW APCHBIDE,I F I=8,26,27,60,33,44,57 S APCHBIDE(I)=""
 ;call to get imm hx
 D IMMHX^BIRPC(.APCHIMM,BHSPAT,.APCHBIDE)
 W !?3,"IMMUNIZATION HISTORY:",!
 ;
 S APCHBIER=$P(APCHIMM,APCH31,2)
 I APCHBIER]"" D CKP^GMTSUP Q:$D(GMTSQIT)  D EN^DDIOL("* "_APCHBIER,"","!!?5") Q
 S APCHIMM=$P(APCHIMM,APCH31,1)
 NEW APCHI,APCHV,APCHX,APCHY,APCHZ
 S APCHZ="",APCHV="|"
 F APCHI=1:1 S APCHY=$P(APCHIMM,U,APCHI) Q:APCHY=""!($D(GMTSQIT))  D
 .Q:$P(APCHY,APCHV)'="I"
 .I $P(APCHY,APCHV,4)'=APCHZ D CKP^GMTSUP Q:$D(GMTSQIT)  W ! S APCHZ=$P(APCHY,APCHV,4)
 .NEW X,BHSDG K %DT S X=$P(APCHY,APCHV,8),%DT="P" D ^%DT S BHSDG=Y
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W ?3,$P(APCHY,APCHV,2),?22,$P(APCHY,APCHV,8),?34,$$AGE(BHSPAT,BHSDG,"P"),?45,$E($P(APCHY,APCHV,3),1,20),?66,$P(APCHY,APCHV,5),!
 .I $P(APCHY,APCHV,6)]"" W ?22,"Reaction: ",$P(APCHY,APCHV,6),!
 .Q
 ;----------
 K APCHIMM,APCHY,APCHV,APCHBIDE,APCHZ
 Q
 ;
 ;
 ;----------
PAD(D,L,C) ;EP
 ;---> Pad the length of data to a total of L characters
 ;---> by adding spaces to the end of the data.
 ;     Example: S X=$$PAD("MIKE",7)  X="MIKE   " (Added 3 spaces.)
 ;---> Parameters:
 ;     1 - D  (req) Data to be padded.
 ;     2 - L  (req) Total length of resulting data.
 ;     3 - C  (opt) Character to pad with (default=space).
 ;
 Q:'$D(D) ""
 S:'$G(L) L=$L(D)
 S:$G(C)="" C=" "
 Q $E(D_$$REPEAT^XLFSTR(C,L),1,L)
 ;
 ;
 ;----------
IMMBI2 ;EP
 ;---> Call to Immunization Package v8.x to build local array of formatted
 ;---> lines for Imm Health Summary Component.  ;IHS/CMI/MWR 8/19/03
 ;---> Mike Remillard
 ;
 D CKP^GMTSUP Q:$D(GMTSQIT)  D CKP^GMTSUP
 N BHSARR S BHSARR=""
 D IMMBI^BIAPCHS(BHSPAT,.BHSARR)
 ;IHS/MSC/MGH
 ;Changes for APCH patch 14 included in patch 1
 N N,F
 S N=0,F=0
 F  S N=$O(^BHSARR(N)) Q:'N  D
 .Q:BHSARR(N,0)["IMMUNIZATION HISTORY:"
 .I BHSARR(N,0)["VARICALLA" S F=1    ;varicella forecast as due
 .Q
 S N=0
 F  S N=$O(BHSARR(N)) Q:'N  D  D CKP^GMTSUP Q:$D(GMTSQIT)
 .I BHSARR(N,0)["IMMUNIZATION HISTORY" D
 ..I F S X=$$PHCP(BHSPAT) I X]"" D
 ...W !,"Patient has a HX of chicken pox not yet entered as a contraindication"
 ...W !,"in the Immunization Package."
 ...W !,X,!!
 .W BHSARR(N,0),!
 D KILLALL^BIUTL8()
 Q
PHCP(P) ;EP
 ;is there a personal history of chicken pox or is chicken pox on the problem list
 NEW X,Y,Z,I,G
 S G="",X=0 F  S X=$O(^AUPNPH("AC",P,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNPH(X,0))
 .S I=$P(^AUPNPH(X,0),U)
 .Q:I=""
 .;S I=$P($G(^ICD9(I,0)),U)
 .S I=$P($$ICDDX^ICDCODE(I),U,2) ;code set versioning
 .Q:$E(I,1,3)'="052"
 .S G=X
 .Q
 I G Q "Personal History: "_I_" - "_$$VAL^XBDIQ1(9000013,G,.04)
 ;now check problem list
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNPROB(X,0))
 .S I=$P(^AUPNPROB(X,0),U)
 .Q:I=""
 .S I=$P($G(^ICD9(I,0)),U)
 .Q:$E(I,1,3)'="052"
 .S G=X
 .Q
 I G Q "Problem List: "_I_" - "_$$VAL^XBDIQ1(9000011,G,.05)
 Q ""
