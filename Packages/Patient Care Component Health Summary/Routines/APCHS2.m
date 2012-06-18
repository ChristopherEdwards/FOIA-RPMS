APCHS2 ; IHS/CMI/LAB - PART 2 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;IHS/CMI/LAB - patch 2 fixed AGE subroutine
 ;IHS/CMI/LAB - patch 3 new imm package
 ;cmi/anch/maw 8/28/2007 code set versioning in PHCP
 ;
MEAS ; ******************** MEASUREMENTS * 9000010.01 *******
 ; <SETUP>
 Q:'$D(^AUPNVMSR("AA",APCHSPAT))
 X APCHSBRK
 ; <DISPLAY>
 X APCHSCKP Q:$D(APCHSQIT)  W !
 S APCHSMT="" F APCHSQ=0:0 S APCHSMT=$O(^AUPNVMSR("AA",APCHSPAT,APCHSMT)) Q:APCHSMT=""  S APCHSND2=APCHSNDM D MEASDTYP Q:$D(APCHSQIT)
 ; <CLEANUP>
MEASX K APCHSMT,APCHSMT2,APCHSMT3,APCHSDFN,APCHSND2,APCHSDAT
 Q
MEASDTYP S APCHSMT2=$S($D(^AUTTMSR(APCHSMT,0)):$P(^(0),U,1),1:APCHSMT) S APCHSMT3=APCHSMT2
 S (APCHSIVD,APCHSDFN)="" F  S APCHSIVD=$O(^AUPNVMSR("AA",APCHSPAT,APCHSMT,APCHSIVD)) Q:APCHSIVD=""!(APCHSIVD>APCHSDLM)  S APCHSND2=APCHSND2-1 Q:APCHSND2=-1  D MEASDSP
 I APCHSMT3="" X APCHSCKP Q:$D(APCHSQIT)  W !
 Q
MEASDSP S APCHSDFN=0 F  S APCHSDFN=$O(^AUPNVMSR("AA",APCHSPAT,APCHSMT,APCHSIVD,APCHSDFN)) Q:APCHSDFN'=+APCHSDFN  D
 .Q:$P($G(^AUPNVMSR(APCHSDFN,2)),U,1)  ;entered in error
 .S V=$P(^AUPNVMSR(APCHSDFN,0),U,3) Q:"HI"[$P($G(^AUPNVSIT(V,0)),U,7)  ;exclude inpatient
 .S Y=-APCHSIVD\1+9999999 X APCHSCVD S APCHSDAT=Y X APCHSCKP Q:$D(APCHSQIT)  W:APCHSNPG!(APCHSMT3]"") APCHSMT2 S APCHSMT3="" W ?5,APCHSDAT,?18,$P(^AUPNVMSR(APCHSDFN,0),U,4) D
 ..I $$VAL^XBDIQ1(9000010.01,APCHSDFN,.01)="O2" D
 ...Q:$P(^AUPNVMSR(APCHSDFN,0),U,10)=""
 ...W ?30,"Supplemental O2: ",$P(^AUPNVMSR(APCHSDFN,0),U,10),!
 ..I '$O(^AUPNVMSR(APCHSDFN,5,0)) W ! Q   ;no qualifiers
 ..S C=0,X=0 F  S X=$O(^AUPNVMSR(APCHSDFN,5,X)) Q:X'=+X  S C=C+1
 ..W ?30,"QUALIFIER"_$S(C>1:"'s",1:""),":"
 ..S T=43 S APCHSX=0 F  S APCHSX=$O(^AUPNVMSR(APCHSDFN,5,APCHSX)) Q:APCHSX'=+APCHSX  S Y=$P($G(^AUPNVMSR(APCHSDFN,5,APCHSX,0)),U) I Y W ?T,$P($G(^GMRD(120.52,Y,0)),U,2) S T=T+5
 ..W !
 Q
 ;
IMMUN ; ******************** IMMUNIZATIONS * 9000010.11 *******
 I +$$VER^BILOGO>7.1 D IMMBI2,REF Q  ;IHS/CMI/MWR  8/19/03, for Immunization v8.x
 I $$BI^APCHS11C D IMMBI,REF Q  ;IHS/CMI/LAB - new imm package
 ; <SETUP>
 Q:'$D(^AUPNVIMM("AA",APCHSPAT))
 X APCHSCKP Q:$D(APCHSQIT)  X:'APCHSNPG APCHSBRK
 ; <DISPLAY>
 S APCHSITP="" F APCHSQ=0:0 S APCHSITP=$O(^AUPNVIMM("AA",APCHSPAT,APCHSITP)) Q:APCHSITP=""  D IMMDTYP
 ; <CLEANUP>
REF ; display refusals/contraindications from imm package and from PCC
  S APCHY=0 F  S APCHY=$O(^BIPC("AC",APCHSPAT,APCHY)) Q:APCHY'=+APCHY  D
 .S APCHX=0 F  S APCHX=$O(^BIPC("AC",APCHSPAT,APCHY,APCHX)) Q:APCHX'=+APCHX  D
 ..S R=$P(^BIPC(APCHX,0),U,3)
 ..Q:R=""
 ..Q:'$D(^BICONT(R,0))
 ..Q:$P(^BICONT(R,0),U,1)'["Refusal"
 ..S D=$P(^BIPC(APCHX,0),U,4)
 ..Q:D=""
 ..S D=9999999-D
 ..Q:D>APCHSDLM
 ..X APCHSCKP Q:$D(APCHSQIT)
 ..W !,$$VAL^XBDIQ1(9002084.11,APCHX,.02)," -- ",$$VAL^XBDIQ1(9002084.11,APCHX,.03),?60,"(",$$DATE^APCHSMU($P(^BIPC(APCHX,0),U,4)),")"
 ..Q
 .Q
 S APCHSFN=9999999.14,APCHST="" D DISPREF^APCHS3C
 K APCHSFN,APCHST,APCHSS
IMMUNX K APCHSITP,APCHSITX,APCHSITL,APCHSDFN,APCHSDAT,APCHSIVD,APCHSVDF
 K APCHSIMC,APCHSIMR,APCHSN,APCHSIC,APCHSIR
 K APCHSNFL,APCHSNSH,APCHSNAB,APCHSVSC,APCHSITE
 Q
IMMDTYP S APCHSITX=$P(^AUTTIMM(APCHSITP,0),U,2),APCHSITL=$L(APCHSITX) X APCHSCKP Q:$D(APCHSQIT)  W ! X APCHSCKP Q:$D(APCHSQIT)  W APCHSITX S APCHSIVD="" F APCHSQ=0:0 S APCHSIVD=$O(^AUPNVIMM("AA",APCHSPAT,APCHSITP,APCHSIVD)) Q:'APCHSIVD  D IMMDSP
 Q
IMMDSP S APCHSDFN=0 F APCHSQ=0:0 S APCHSDFN=$O(^AUPNVIMM("AA",APCHSPAT,APCHSITP,APCHSIVD,APCHSDFN)) Q:APCHSDFN=""  D IMMDSP2
 Q
IMMDSP2 S Y=-APCHSIVD\1+9999999 X APCHSCVD S APCHSDAT=Y
 S APCHSN=^AUPNVIMM(APCHSDFN,0)
 S APCHSVDF=$P(APCHSN,U,3) D GETSITEV^APCHSUTL S APCHSITE=APCHSNSH
 S X=$P(APCHSN,U,6),Y=.06 D IMMGSET S APCHSIR=APCHSP
 S X=$P(APCHSN,U,7),Y=.07 D IMMGSET S APCHSIC=APCHSP S:APCHSIC]"" APCHSIC="DO NOT REPEAT"
 I APCHSIC]"",APCHSIR]"" S APCHSIR=APCHSIR_"; "
 S APCHSIR=APCHSIR_APCHSIC
 ;modified following line - LAB
 X APCHSCKP Q:$D(APCHSQIT)  W:APCHSNPG APCHSITX W ?(APCHSITL+1),$P(^AUPNVIMM(APCHSDFN,0),U,4),?15,APCHSDAT,?25,$$AGE(APCHSPAT,$P(+^AUPNVSIT(APCHSVDF,0),"."),"P"),?34,APCHSITE,?65,APCHSIR,!
 Q
IMMGSET S Y=$G(^DD(9000010.11,Y,0)),Y=$P(Y,U,3)
 S:'X Y=""
 F APCHSQ=1:1 S APCHSP=$P(Y,";",APCHSQ) Q:APCHSP=""  I $P(APCHSP,":",1)=X S APCHSP=$P(APCHSP,":",2) Q
 Q
 ;
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
 X APCHSCKP Q:$D(APCHSQIT)  X:'APCHSNPG APCHSBRK
 ;
 ;
 ;
 NEW APCH31,APCHIMM,APCHBIER
 S APCH31=$C(31)_$C(31),APCHIMM=""
 D IMMFORC^BIRPC(.APCHIMM,APCHSPAT)
 ;
 W ?3,"IMMUNIZATION FORECAST:",!!
 ;
 D
 .;---> Check for error in 2nd piece of return value.
 .S APCHBIER=$P(APCHIMM,APCH31,2)
 .;---> If there's an error, display it and quit.
 .I APCHBIER]"" X APCHSCKP Q:$D(APCHSQIT)  D  Q
 ..D EN^DDIOL("* "_APCHBIER,"","?5") W !
 .;
 .;---> No error, so take 1st piece of return value and process it.
 .S APCHIMM=$P(APCHIMM,APCH31,1)
 .;
 .NEW APCHX,APCHI F APCHX=1:1 S APCHI=$P(APCHIMM,"^",APCHX) Q:APCHI=""!($D(APCHSQIT))  D
 ..X APCHSCKP Q:$D(APCHSQIT)
 ..W ?3,$P(APCHI,"|"),?23,$P(APCHI,"|",2),?36,$P(APCHI,"|",3),!
 ..Q
 ;
CONTRAS ;
 ;
 N APCHCONT S APCHCONT=""
 ;
 ;---> RPC to retrieve Contraindications.
 D CONTRAS^BIRPC5(.APCHCONT,APCHSPAT)
 ;
 ;---> If APCHBIER has a value, display it and quit.
 S APCHBIER=$P(APCHCONT,APCH31,2)
 I APCHBIER]"" X APCHSCKP Q:$D(APCHSQIT)  D EN^DDIOL("* "_APCHBIER,"","!!?5") G HX
 ;
 ;---> Set APCHC=to a string of Contraindications for this patient.
 N APCHC S APCHC=$P(APCHCONT,APCH31,1)
 I APCHC]"" X APCHSCKP Q:$D(APCHSQIT)  W !
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
 .X APCHSCKP Q:$D(APCHSQIT)  W X,!
 .Q
 ;
 ;
 ;
HX ;
 NEW APCHBIDE,I F I=8,26,27,60,33,44,57 S APCHBIDE(I)=""
 ;call to get imm hx
 D IMMHX^BIRPC(.APCHIMM,APCHSPAT,.APCHBIDE)
 W !?3,"IMMUNIZATION HISTORY:",!
 ;
 S APCHBIER=$P(APCHIMM,APCH31,2)
 I APCHBIER]"" X APCHSCKP Q:$D(APCHSQIT)  D EN^DDIOL("* "_APCHBIER,"","!!?5") Q
 S APCHIMM=$P(APCHIMM,APCH31,1)
 NEW APCHI,APCHV,APCHX,APCHY,APCHZ
 S APCHZ="",APCHV="|"
 F APCHI=1:1 S APCHY=$P(APCHIMM,U,APCHI) Q:APCHY=""!($D(APCHSQIT))  D
 .Q:$P(APCHY,APCHV)'="I"
 .I $P(APCHY,APCHV,4)'=APCHZ X APCHSCKP Q:$D(APCHSQIT)  W ! S APCHZ=$P(APCHY,APCHV,4)
 .NEW X,APCHSDG K %DT S X=$P(APCHY,APCHV,8),%DT="P" D ^%DT S APCHSDG=Y
 .X APCHSCKP Q:$D(APCHSQIT)
 .W ?3,$P(APCHY,APCHV,2),?22,$P(APCHY,APCHV,8),?34,$$AGE(APCHSPAT,APCHSDG,"P"),?45,$E($P(APCHY,APCHV,3),1,20),?66,$P(APCHY,APCHV,5),!
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
 X APCHSCKP Q:$D(APCHSQIT)  X:'APCHSNPG APCHSBRK
 N APCHSARR S APCHSARR=""
 D IMMBI^BIAPCHS(APCHSPAT,.APCHSARR)
 ;first find out if VARICELLA is forecasted
 N N,F S N=0,F=0
 NEW F S (F,N)=0 F  S N=$O(APCHSARR(N)) Q:'N  D
 .Q:APCHSARR(N,0)["IMMUNIZATION HISTORY:"
 .I APCHSARR(N,0)["VARICELLA" S F=1  ;varicella forecast as due
 .Q
 S N=0
 F  S N=$O(APCHSARR(N)) Q:'N  D  X APCHSCKP Q:$D(APCHSQIT)
 .I APCHSARR(N,0)["IMMUNIZATION HISTORY" D
 ..I F S X=$$PHCP(APCHSPAT) I X]"" D
 ...W !,"Patient has a Hx of chicken pox not yet entered as a contraindication"
 ...W !,"in the Immunization Package."
 ...W !,X,!!
 .W APCHSARR(N,0),!
 D KILLALL^BIUTL8()
 Q
PHCP(P) ;EP
 ;is there a personal history of chicken pox or is chicken pox on the problem list
 NEW X,Y,Z,I,G
 S G="",X=0 F  S X=$O(^AUPNPH("AC",P,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNPH(X,0))
 .S I=$P(^AUPNPH(X,0),U)
 .Q:I=""
 .;S I=$P($G(^ICD9(I,0)),U)  ;cmi/anch/maw 8/28/2007 orig line
 .S I=$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 8/28/2007 code set versioning
 .Q:$E(I,1,3)'="052"
 .S G=X
 .Q
 I G Q "Personal History: "_I_" - "_$$VAL^XBDIQ1(9000013,G,.04)
 ;now check problem list
 S X=0 F  S X=$O(^AUPNPH("AC",P,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNPH(X,0))
 .S I=$P(^AUPNPH(X,0),U)
 .Q:I=""
 .S I=$P($G(^ICD9(I,0)),U)
 .Q:$E(I,1,3)'="052"
 .S G=X
 .Q
 I G Q "Problem List: "_I_" - "_$$VAL^XBDIQ1(9000011,G,.05)
 Q ""
