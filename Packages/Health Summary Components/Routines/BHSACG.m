BHSACG ;IHS/CIA/MGH - Supplement for anti-coag  ;10-Dec-2010 16:54;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**4**;March 17, 2006;Build 13
 ;===================================================================
 ; IHS/CMI/LAB - ; ANTI-COAG SUPPLEMENT
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;Copy of APCHSACG
 ;
 ;BJPC v2.0 patch 1
S(Y,F,C,T) ;EP - set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("BHSACG",$J,"DCS",0),U)+1,$P(^TMP("BHSACG",$J,"DCS",0),U)=%
 S ^TMP("BHSACG",$J,"DCS",%)=X
 Q
CTR(X,Y) ;EP - Center
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EP(DFN) ;PEP - ANTI-COAG supplement
 NEW BHX,BHQUIT,BHSX,BHEDUC,BHV,BHSS,BHPG,BHSIG,BHSP,BHSQUIT
 NEW X,Y,Z,A,I,B,E,T
 D EP2(DFN)
W ;write out array
 W:$D(IOF) @IOF
 K BHQUIT
 S BHPG=0
 S BHX=0 F  S BHX=$O(^TMP("BHSACG",$J,"DCS",BHX)) Q:BHX'=+BHX!($D(BHSQUIT))  D
 .W !,^TMP("BHSACG",$J,"DCS",BHX)
 .Q
 K ^TMP("BHSACG",$J,"DCS")
 I $D(BHSQUIT) S GMTSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W,M,T,T1,T2,T3
 Q
EP2(DFN) ;EP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("BHSACG",$J,"DCS"
 K ^TMP("BHSACG",$J,"DCS")
 S ^TMP("BHSACG",$J,"DCS",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array
 NEW A,B,C,D,E,G,S,T,V,Y,Z,X,D,N,C,F,I
 NEW BHSDX,BHV,BHEDS,BHSS,BHSSGY,BHMEDS,BHCOMB,BHD,BHY
 ;S X=BHSHDR D S(X)
 S X=$$CTR("ANTICOAGULATION PATIENT CARE SUPPLEMENT",80) D S(X)
 S X="Report Date: "_$$FMTE^XLFDT(DT) D S(X)
 S X="Patient's Name: "_$P(^DPT(DFN,0),U),$E(X,50)="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X,1)
 S X="Sex: "_$$SEX^AUPNPAT(DFN),$E(X,15)="DOB: "_$$DOB^AUPNPAT(DFN,"E")_"     Age: "_$$AGE^AUPNPAT(DFN) D S(X) ;S Y=$$VAL^XBDIQ1(90181.01,DFN,.02)
 S X="DESIGNATED PRIMARY CARE PROVIDER: "_$$VAL^XBDIQ1(9000001,DFN,.14) D S(X)
INDIC ;get all dxs
 K BHSDX
 S X="Indication for Anticoagulation Therapy: " D S(X,1)
 S X=DFN_"^ALL DX [BJPC AC THRPY INDIC DXS"_";DURING "_$$FMADD^XLFDT($$DOB^AUPNPAT(DFN))_"-"_DT S E=$$START1^APCLDF(X,"BHSDX(")
 S X=0 F  S X=$O(BHSDX(X)) Q:X'=+X  S D=$P(BHSDX(X),U),BHSDX("I",(9999999-D),+$P(BHSDX(X),U,4))=BHSDX(X)  ;reorder by date
 S D=0 F  S D=$O(BHSDX("I",D)) Q:D'=+D  D
 .S I=0 F  S I=$O(BHSDX("I",D,I)) Q:I'=+I  D
 ..S C=$P(BHSDX("I",D,I),U,2)
 ..Q:$D(BHSDX("D",C))  ;already had that dx
 ..S BHSDX("D",C)=""
 ..S N=$$VAL^XBDIQ1(9000010.07,I,.04)
 ..K ^UTILITY($J,"W") S X=N,DIWL=0,DIWR=55 D ^DIWP
 ..S X="    "_C,$E(X,13)=^UTILITY($J,"W",0,1,0),$E(X,70)=$$D1^APCHSMU((9999999-D)) D S(X)
 .I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,13)=^UTILITY($J,"W",0,F,0) D S(X)
INRGOAL ;most recent goal from V ANTICOAG
 S X="INR Goal     "_$P($$MRGOAL(DFN),U,2) D S(X,1)  ;_"   (noted: "_$$D1^APCHSMU($P($$MRGOAL(DFN),U,1))_")" D S(X,1)
 S X="    Duration of Anticoagulation Therapy",$E(X,60)=$P($$MRDUR(DFN),U,2) D S(X) ;_"  (noted: "_$$D1^APCHSMU($P($$MRDUR(DFN),U,1))_")" D S(X)
 S X="    Duration of Anticoagulation Therapy Start Date",$E(X,60)=$$D1^APCHSMU($P($$MRSTART(DFN),U,1)) D S(X)
 S X="    Duration of Anticoagulation Therapy End Date",$E(X,60)=$$D1^APCHSMU($P($$MREND(DFN),U,1)) D S(X)
CLN ;
 K BHV
 S BHV="BHV"
 D ALLV^APCLAPIU(DFN,$$FMADD^XLFDT(DT,-100),DT,.BHV)
 S X="ANTICOAGULATION CLINIC VISITS (LAST 100 DAYS):" D S(X,1)
 I '$O(BHV(0)) S X="No Anticoagulation clinic visits on file in the past 100 days" D S(X) G INR
 S C=0,G=0 F  S C=$O(BHV(C)) Q:C'=+C  D
 .S V=$P(BHV(C),U,5)
 .S S=$$CLINIC^APCLV(V,"C")
 .Q:S'="D1"
 .S G=G+1
 .S X=$$D1^APCHSMU($$VD^APCLV(V)),$E(X,20)=$$PRIMPROV^APCLV(V,"N") D S(X)
 I 'G S X="No Anticoagulation clinic visits on file in the past 100 days" D S(X)
INR ;get all INR lab tests
 S X="INR VALUES AND MEDICATIONS: (LAST 100 DAYS)" D S(X,1)
 S X="Date",$E(X,13)="INR Value",$E(X,24)="Medication",$E(X,64)="Provider" D S(X)
 K BHV
 S BHV="BHV"
 D ALLLAB^APCLAPIU(DFN,$$FMADD^XLFDT(DT,-100),DT,$O(^ATXLAB("B","BJPC INR LAB TESTS",0)),$O(^ATXAX("B","BJPC INR LAB LOINCS",0)),"INR",.BHV)
 ;get all INR meds in APCHM
 K BHMEDS
 D GETMEDS^APCHSMU1(DFN,$$FMADD^XLFDT(DT,-160),DT,"BGP CMS WARFARIN MEDS",,,"WARFARIN",.BHMEDS)
 ;now to list the INR tests in inverse order and try to figure out if they were on a med at that time
COMBBYDT ;combine the inrs and meds inverse by date
 K APCHCOMB
 N X,C,D,V,I,BHVV,M,O
 S X=0,C=0 F  S X=$O(BHV(X)) Q:X'=+X  D
 .S D=$P(BHV(X),U)
 .S C=C+1
 .S V=$P(BHV(X),U,3)
 .S I=$P(BHV(X),U,4)
 .S O="???"
 .I I S O=$$VAL^XBDIQ1(9000010.09,I,1202)
 .S BHCOMB((9999999-D),C)=D_U_V_U_U_O
 ;get any meds on this date
 S X=0,C=0 F  S X=$O(BHMEDS(X)) Q:X'=+X  D
 .S D=$P(BHMEDS(X),U)
 .S C=C+1
 .S M=$P(BHMEDS(X),U,4)
 .S V=$E($P(BHMEDS(X),U,2),1,30)_"  Qty: "_$P(^AUPNVMED(M,0),U,6)_"  Days: "_$P(^AUPNVMED(M,0),U,7)
 .S O="???"
 .I M S O=$$VAL^XBDIQ1(9000010.14,M,1202)
 .I $D(BHCOMB((9999999-D))) D  I 1
 ..;FIND 1st empty one and use it
 ..S Y=0,G=0 F  S Y=$O(APCHCOMB((9999999-D),Y)) Q:Y'=+Y!(G)  D
 ...I $P(BHCOMB((9999999-D),Y),U,3)="" S $P(BHCOMB((9999999-D),Y),U,3)=V,$P(BHCOMB((9999999-D),Y),U,5)=O
 .E  S BHCOMB((9999999-D),C)=D_U_U_V_U_U_O
 ;now write it out to tmp
 K BHV,BHMEDS
 S BHD=0 F  S BHD=$O(BHCOMB(BHD)) Q:BHD'=+BHD  D
 .S BHY=0 F  S BHY=$O(BHCOMB(BHD,BHY)) Q:BHY'=+BHY  D
 ..S BHVV=BHCOMB(BHD,BHY)
 ..S BHSS=""
 ..S BHSS=$$D1^APCHSMU($P(BHVV,U,1))
 ..S $E(BHSS,13)=$P(BHVV,U,2)
 ..;S $E(BHSS,64)=$E($P(V,U,5),1,15)
 ..;get med in strings of 34 characters
 ..S X=$P(BHVV,U,3)
 ..I X]"" D  I 1
 ...K ^UTILITY($J,"W") S DIWL=0,DIWR=38 D ^DIWP
 ...S X="",$E(BHSS,24)=^UTILITY($J,"W",0,1,0),$E(BHSS,64)=$E($P(BHVV,U,5),1,15) D S(BHSS)
 ...I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,24)=^UTILITY($J,"W",0,F,0) D S(X)
 ..E  S $E(BHSS,64)=$E($P(BHVV,U,5),1,15) D S(BHSS)
LAB ;
 S X="MOST RECENT RELATED LAB TESTS:" D S(X,1)
 S X="Date",$E(X,15)="Test",$E(X,50)="Results" D S(X)
URIN ;last urinalysis on file and its children
 K BHV,BHMEDS
 S BHV=$$LASTACUR(BHSPAT,$$DOB^AUPNPAT(BHSPAT),DT)
 I BHV="" S X="No Urinalysis Tests on File" D S(X) G CBC
 I $P(BHV,U,2)["CPT" D  G CBC  ;display date of cpt
 .S X=$$D1^APCHSMU($P(BHV,U)),$E(X,15)=$P(BHV,U,2)_" "_$P(BHV,U,3) D S(X)
 ;NOW DISPLAY ALL TESTS ON THIS ACCESSION
 S L=$P(BHV,U,6),A=$P($G(^AUPNVLAB(L,0)),U,6)
 I A]"" D  I 1
 .S X=$$D1^APCHSMU($P(BHV,U,1)),$E(X,15)=$$VAL^XBDIQ1(9000010.09,L,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,L,.04) D S(X)
 .S Y=0 F  S Y=$O(^AUPNVLAB("ALR0",A,Y)) Q:Y'=+Y  D
 ..Q:$P($G(^AUPNVLAB(Y,12)),U,8)'=L  ;not a child of the urinalysis
 ..S X="",$E(X,15)=$$VAL^XBDIQ1(9000010.09,Y,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,Y,.04) D S(X)
 E  S X=$$D1^APCHSMU($P(BHV,U,1)),$E(X,15)=$$VAL^XBDIQ1(9000010.09,L,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,L,.04) D S(X)
CBC ;
 D S(" ")
 K BHV
 S BHV=$$LASTACCB(BHSPAT,$$DOB^AUPNPAT(BHSPAT),DT)
 I BHV="" S X="No CBC Tests on File" D S(X) G FOBT
 I $P(BHV,U,2)["CPT" D  G FOBT  ;display date of cpt
 .S X=$$D1^APCHSMU($P(BHV,U)),$E(X,15)=$P(BHV,U,2)_" "_$P(BHV,U,3) D S(X)
 ;NOW DISPLAY ALL TESTS ON THIS ACCESSION
 S L=$P(BHV,U,6),A=$P($G(^AUPNVLAB(L,0)),U,6)
 I A]"" D  I 1
 .S X=$$D1^APCHSMU($P(BHV,U,1)),$E(X,15)=$$VAL^XBDIQ1(9000010.09,L,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,L,.04) D S(X)
 .S Y=0 F  S Y=$O(^AUPNVLAB("ALR0",A,Y)) Q:Y'=+Y  D
 ..Q:$P($G(^AUPNVLAB(Y,12)),U,8)'=L  ;not a child of the urinalysis
 ..S X="",$E(X,15)=$$VAL^XBDIQ1(9000010.09,Y,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,Y,.04) D S(X)
 E  S X=$$D1^APCHSMU($P(BHV,U,1)),$E(X,15)=$$VAL^XBDIQ1(9000010.09,L,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,L,.04) D S(X)
FOBT ;
 D S(" ")
 K BHV
 S BHV=$$LASTACFO(BHSPAT,$$DOB^AUPNPAT(BHSPAT),DT)
 I BHV="" S X="No FOBT Tests on File" D S(X) G VITK
 I $P(BHV,U,2)["CPT" D  G VITK  ;display date of cpt
 .S X=$$D1^APCHSMU($P(BHV,U)),$E(X,15)=$P(BHV,U,2)_" "_$P(BHV,U,3) D S(X)
 ;NOW DISPLAY ALL TESTS ON THIS ACCESSION
 S L=$P(BHV,U,6)
 S X=$$D1^APCHSMU($P(BHV,U,1)),$E(X,15)=$$VAL^XBDIQ1(9000010.09,L,.01),$E(X,50)=$$VAL^XBDIQ1(9000010.09,L,.04) D S(X)
VITK ;
 S X="VITAMIN K PRESCRIPTION IN THE PAST YEAR:" D S(X,1)
 S X="Date",$E(X,15)="Medication/Sig",$E(X,50)="Provider" D S(X)
 K BHMEDS
 D GETMEDS^APCHSMU1(DFN,$$FMADD^XLFDT(DT,-365),DT,,,,"PHYTONADIONE",.BHMEDS)
 I '$O(BHMEDS(0)) S X="No Vitamin K medications dispensed in the past 365 days" D S(X) G PTED
 S BHY=999999 F  S BHY=$O(BHMEDS(BHY),-1) Q:BHY=""  S M=$P(BHMEDS(BHY),U,4) D
 .S X=$$D1^APCHSMU($P(BHMEDS(BHY),U)),$E(X,15)=$E($P(BHMEDS(BHY),U,2),1,30),$E(X,50)=$$VAL^XBDIQ1(9000010.14,M,1202) D S(X)
 .S BHSIG=$P(^AUPNVMED(M,0),U,5) D SIG
 .S X=BHSSGY
 .K ^UTILITY($J,"W") S DIWL=0,DIWR=60 D ^DIWP
 .S X="",$E(X,15)=^UTILITY($J,"W",0,1,0) D S(X)
 .I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,15)=^UTILITY($J,"W",0,F,0) D S(X)
PTED ;
 S X="PATIENT EDUCATION RELATED TO ANTICOAGULATION IN THE PAST YEAR:" D S(X,1)
 S X="Date",$E(X,15)="Topic",$E(X,50)="Provider" D S(X)
 K BHEDUC
 D EDUC(DFN,$$FMADD^XLFDT(DT,-365),DT,.BHEDUC)
 S Y=0 F  S Y=$O(BHEDUC(Y)) Q:Y'=+Y  D
 .S X=$$D1^APCHSMU($P(BHEDUC(Y),U)),$E(X,15)=$$VAL^XBDIQ1(9000010.16,$P(BHEDUC(Y),U,2),.01),$E(X,50)=$$EDPRV($P(BHEDUC(Y),U,2)) D S(X)
 D S("  ")
 Q
EDPRV(I) ;
 NEW Z,V
 S Z=$$VAL^XBDIQ1(9000010.16,I,.05) I Z]"" Q Z
 S Z=$$VAL^XBDIQ1(9000010.16,I,1204) I Z]"" Q Z
 S V=$P(^AUPNVPED(I,0),U,3)
 Q $$PRIMPROV^APCLV(V,"N")
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S BHSSGY="" F BHSP=1:1:$L(BHSIG," ") S X=$P(BHSIG," ",BHSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(BHSIG," ",BHSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S BHSSGY=BHSSGY_X_" "
 Q
MRGOAL(P) ;PEP - most recent INR goal and date
 I $G(P)="" Q ""
 I '$D(^AUPNVACG("AA",P)) Q ""
 NEW X,Y,D,R,I,Z,S
 S R=""
 S D=0 F  S D=$O(^AUPNVACG("AA",P,D)) Q:D'=+D!(R]"")  D
 .S X=0 F  S X=$O(^AUPNVACG("AA",P,D,X)) Q:X'=+X!(R]"")  D
 ..S I=0 F  S I=$O(^AUPNVACG("AA",P,D,X,I)) Q:I'=+I  D
 ...Q:$P($G(^AUPNVACG(I,0)),U,4)=""
 ...S Z=$P(^AUPNVACG(I,0),U,4)
 ...I Z=3 S S=$P(^AUPNVACG(I,0),U,5)_" - "_$P(^AUPNVACG(I,0),U,6)
 ...I Z'=3 S S=$$VAL^XBDIQ1(9000010.51,I,.04)
 ...S R=$$VD^APCLV($P(^AUPNVACG(I,0),U,3))_"^"_S
 Q R
MRDUR(P) ;PEP - most recent duration and date
 I $G(P)="" Q ""
 I '$D(^AUPNVACG("AA",P)) Q ""
 NEW X,Y,D,R,I,Z
 S R=""
 S D=0 F  S D=$O(^AUPNVACG("AA",P,D)) Q:D'=+D!(R]"")  D
 .S X=0 F  S X=$O(^AUPNVACG("AA",P,D,X)) Q:X'=+X!(R]"")  D
 ..S I=0 F  S I=$O(^AUPNVACG("AA",P,D,X,I)) Q:I'=+I  D
 ...Q:$P($G(^AUPNVACG(I,0)),U,7)=""
 ...S Z=$$VAL^XBDIQ1(9000010.51,I,.07)
 ...S R=$$VD^APCLV($P(^AUPNVACG(I,0),U,3))_"^"_Z
 Q R
MRSTART(P) ;PEP - most recent duration and date
 I $G(P)="" Q ""
 I '$D(^AUPNVACG("AA",P)) Q ""
 NEW X,Y,D,R,I,Z
 S R=""
 S D=0 F  S D=$O(^AUPNVACG("AA",P,D)) Q:D'=+D!(R]"")  D
 .S X=0 F  S X=$O(^AUPNVACG("AA",P,D,X)) Q:X'=+X!(R]"")  D
 ..S I=0 F  S I=$O(^AUPNVACG("AA",P,D,X,I)) Q:I'=+I  D
 ...Q:$P($G(^AUPNVACG(I,0)),U,8)=""
 ...S Z=$$VAL^XBDIQ1(9000010.51,I,.08)
 ...S R=$P(^AUPNVACG(I,0),U,8)_"^"_Z
 Q R
MREND(P) ;PEP - most recent duration and date
 I $G(P)="" Q ""
 I '$D(^AUPNVACG("AA",P)) Q ""
 NEW X,Y,D,R,I,Z
 S R=""
 S D=0 F  S D=$O(^AUPNVACG("AA",P,D)) Q:D'=+D!(R]"")  D
 .S X=0 F  S X=$O(^AUPNVACG("AA",P,D,X)) Q:X'=+X!(R]"")  D
 ..S I=0 F  S I=$O(^AUPNVACG("AA",P,D,X,I)) Q:I'=+I  D
 ...;Q:$P($G(^AUPNVACG(I,0)),U,9)=""
 ...S Z=$$VAL^XBDIQ1(9000010.51,I,.09)
 ...S R=$P(^AUPNVACG(I,0),U,9)_"^"_Z
 Q R
EDUC(P,BDATE,EDATE,DATA) ;EP pass back array of all asthma educ topics
 ;any topic that begins with ASM or 493
 K DATA
 I '$G(P) Q
 NEW BHE,X,E,%,G,A,N,D,I,BHX
 K BHE
 S A="BHE("
 S X=P_"^ALL EDUC;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,A)
 I '$D(BHE) Q
 S %=0 F  S %=$O(BHE(%)) Q:%'=+%  D
 .S D=$P(BHE(%),U,1)
 .S I=+$P(BHE(%),U,4)
 .S N=$P(^AUPNVPED(I,0),U)
 .Q:'N
 .S N=$P($G(^AUTTEDT(N,0)),U,2)
 .I $P(N,"-")="ACC" D
 ..S BHX(9999999-D,+$P(BHE(%),U,4))=""
 S N="",C=0 F  S N=$O(BHX(N)) Q:N=""  D
 .S X=0 F  S X=$O(BHX(N,X)) Q:X'=+X  S C=C+1 S DATA(C)=(9999999-N)_U_X
 K BHE
 Q
LASTACUR(P,BD,ED) ;EP
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 NEW R,C
 S R=$$LASTLAB^APCLAPIU(BHSPAT,BD,ED,,$O(^ATXLAB("B","DM AUDIT URINALYSIS TAX",0)),,$O(^ATXAX("B","DM AUDIT URINALYSIS LOINC",0)),"A")
 S C=$$LASTCPTT^APCLAPIU(DFN,,DT,"BJPC URINALYSIS CPT","A")
 I C]"",$P(C,U,1)>$P(R,U,1) Q C
 Q R
LASTACCB(P,BD,ED) ;EP
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 NEW R,C
 S R=$$LASTLAB^APCLAPIU(BHSPAT,BD,ED,,$O(^ATXLAB("B","BGP CBC TESTS",0)),,$O(^ATXAX("B","BGP CBC LOINC",0)),"A")
 S C=$$LASTCPTT^APCLAPIU(DFN,,DT,"BGP CBC CPT","A")
 I C]"",$P(C,U,1)>$P(R,U,1) Q C
 Q R
LASTACFO(P,BD,ED) ;EP
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 NEW R,C
 S R=$$LASTLAB^APCLAPIU(BHSPAT,BD,ED,,$O(^ATXLAB("B","BGP GPRA FOB TESTS",0)),,$O(^ATXAX("B","BGP FOBT LOINC CODES",0)),"A")
 S C=$$LASTCPTT^APCLAPIU(DFN,,DT,"BGP FOBT CPTS","A")
 I C]"",$P(C,U,1)>$P(R,U,1) Q C
 Q R
