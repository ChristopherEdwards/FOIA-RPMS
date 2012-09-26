VENPCC1A ; IHS/OIT/GIS - ENCOUNTER FORM DATA MINING ;
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 ; Patched for BCMA barcode string by GIS/OIT.  Sting len
 ;
 ;
 ; 
DEMO(PRV,DFN,VCN,VIEN,DEPTIEN,APPT) ; EP-GENERATE DEMOGRAPHIC INFO
 NEW %,AGE,COMM,DOB,DOC,FMDOB,H,M,NAME,SEX,SSN,TRIBE,X,Z,ASUFAC,HRN,PAD
 S X=$G(^DPT(+$G(DFN),0)) I X="" S STOP=1 Q
 S SEX=$P(X,U,2),FMDOB=$P(X,U,3),SSN=$P(X,U,9),NAME=$P(X,U)
 I $L(NAME),FMDOB,$L(SEX),$D(^VEN(7.95,DEPTIEN,0))
 E  S STOP=1 Q
 S @TMP@(1,"b26")=$E(NAME,1,29)
 I $G(APPT)?7N.E S Y=APPT X ^DD("DD") S @TMP@(1,"b25")=Y
 S NAME=$P(NAME,",",2,99)_" "_$P(NAME,","),@TMP@(1,"patient")=$E(NAME,1,29) ; PATIENT
 S ELIG=$$GET1^DIQ(9000001,DFN_",",1112) I ELIG="" S ELIG="ELIGIBILITY UNKNOWN"
 S %=$P($G(^VEN(7.41,+$G(DEFEF),0)),U,3)
 S @TMP@(1,"template")=%
 ; S %=$$PGRP^VENPCCU(DEPTIEN,0,$G(SPGRP)) I %="" S STOP=1 D ERR2^VENPCC1 Q
 ; S @TMP@(1,"group")=%
 S @TMP@(1,"header")=$$HEADER^VENPCCU(DEFEF),@TMP@(1,"printer")=""
 S @TMP@(1,"elig")=$E(ELIG,1,20)
 S %=$$INS^VENPCC1C(DFN) I %="" S %="No record of 3rd party eligibility..."
 S @TMP@(1,"b27")=$E(%,1,110) ; 3RD PARTY PAYORS
 S @TMP@(1,"agesex")=$$AGE(FMDOB)_$S(SEX="F":"female",SEX="M":"male",1:"") ; AGESEX
 S Y=FMDOB\1 X ^DD("DD") S @TMP@(1,"dob")=Y ; DOB
 I SSN S @TMP@(1,"ssn")=$E(SSN,1,3)_" "_$E(SSN,4,5)_" "_$E(SSN,6,9) ; SSN
 I VIEN'=+VIEN S @TMP@(1,"timestamp")="" G D1
 ; I '$D(^AUPNVSIT(+$G(VIEN),0)) S STOP=1 Q
 S %DT="TX",X="NOW" D ^%DT S Z=$P(Y,".",2)
 S Z=Z_$E("0000",1,(4-$L(Z))),H=$E(Z,1,2),M=$E(Z,3,4) ; TIMESTAMP
 X ^DD("DD") S @TMP@(1,"timestamp")=$P(Y,"@")_"@"_H_":"_M
D1 S @TMP@(1,"uid")=$S(VCN'[".0X":VCN,1:"") ; VISIT CONTROL ID
 I '$G(DEFEF) S DEFEF=$P($G(^VEN(7.95,+$G(DEPTIEN),2)),U,1)
 S %=$P($G(^VEN(7.41,+$G(DEFEF),0)),U,4)
 S @TMP@(1,"vbar1")="*"_VIEN_"."_%_"1*",@TMP@(1,"vbar2")="*"_VIEN_"."_%_"2*" ; BAR CODE
 I $G(DEFEF) S @TMP@(1,"header")=$$HEADER^VENPCCU(DEFEF) ; GET SPECIAL HEADER FILE
 S X=$P($G(^VA(200,PRV,0)),U),X=$P(X,",",2,99)_" "_$P(X,","),@TMP@(1,"provider")="Provider: "_$E(X,1,35) I X["GENERIC PROVIDER" S X="" ; PROVIDER
 S @TMP@(1,"stop")="" ; CLINIC STOP
 S @TMP@(1,"clinic")="" ; FACILITY
 S TRIBE=+$P($G(^AUPNPAT(DFN,11)),U,8),@TMP@(1,"tribe")=$E($P($G(^AUTTTRI(TRIBE,0)),U),1,35) ; TRIBE
 S %=$P($G(^AUPNPAT(DFN,11)),U,18) I $L(%) S @TMP@(1,"community")=$E(%,1,22)
 E  S %=$O(^AUPNPAT(DFN,51,99999999),-1) I % S COMM=$P($G(^AUPNPAT(DFN,51,%,0)),U,3) I COMM S @TMP@(1,"community")=$E($P($G(^AUTTCOM(COMM,0)),U),1,22) ; COMMUNITY
 S @TMP@(1,"reqd")=$P($G(^VA(200,+$G(DUZ),0)),U) ; REQUESTED BY
 S ASUFAC=$P($G(^AUTTLOC(DUZ(2),0)),U,10) I ASUFAC S @TMP@(1,"u61")=ASUFAC ; "u61" = ASUFAC CODE ; PATCHED BY GIS 10.13/08 FOR CIHA
 S (HRN,@TMP@(1,"chart"))=$$CHART(DEPTIEN,DFN) I 'HRN Q  ; CHART NUMBER
 S PAD=$P($G(^VEN(7.5,$$CFG^VENPCCU,0)),U,25) I 'PAD S PAD=12
 I ASUFAC,HRN,PAD S %=$L(HRN)+$L(ASUFAC),Z="",$P(Z,0,PAD+1-%)="",X=ASUFAC_Z_HRN S @TMP@(1,"u60")=X ; "u60" = ASUFAC_CHART # JUSTIFIED WITH ZEROS - TOTAL 18 CHARACTERS FOR VA BAR CODE READER ; PATCHED BY GIS 10.13/08 FOR CIHA
 Q
 ;
AGE(DOB) ; EP-GIVEN DOB RETURNS FORMATTED AGE
 NEW %,D,M,X,X1,X2,Y,%DT
 S X=(DT-DOB)\10000 I X>3 Q (X_" y/o ")
 S X1=DT,X2=DOB D ^%DTC
 I X<22 Q (X_" d/o ")
 I X<57 Q ((X\7)_" w/o ")
 S Y=$E(DT,1,3)-$E(DOB,1,3),M=$E(DT,4,5)-$E(DOB,4,5),D=$E(DT,6,7)-$E(DOB,6,7)
 S M=M+(12*Y) I D<0 S M=M-1
 Q (M_" m/o ")
 ;
SPEC(DFN) ; EP-SPECIAL PATIENT INFO
 NEW %,AGE,FMDOB,SEX,X
 S X=^DPT(DFN,0),SEX=$P(X,U,2),FMDOB=$P(X,U,3)
 S AGE=((DT-FMDOB)\10000) I AGE<6 D BH(DFN) Q
 I SEX="F",AGE>10,AGE<60
 E  Q
FH ; EP-FEMALE HX
 NEW RIEN,X,Y,Z
 S @TMP@(1,"lab1")="LMP: "
 S @TMP@(1,"lab2")="FP Method: "
 S RIEN=$O(^AUPNREP("B",DFN,0)) I 'RIEN Q
 S X=$G(^AUPNREP(RIEN,0)) I X="" Q
 S Y=$P(X,U,2) I $L(Y) S @TMP@(1,"grav")="Repro Hx: "_Y ; CURES REPRO HX PARSING PROBLEMS
 S Y=$P(X,U,7) I Y X ^DD("DD") S Y="("_Y_")" ; FPM START DATE
 S Z=$P(X,U,6) I Z?1N S Z=Z+1,@TMP@(1,"fpm")=$P("Patient ed only^BC Pills^IUD^Surgical sterilization^Barrier method^Partner sterilized^Natural methods^Menopause^None",U,Z)_Y
 Q
 ;
PARSE(Z) ; EP-PARSES OUT REPRODUCTIVE HISTORY FROM FREE TEXT NARRATIVE
 NEW I
 F I=1:1:$L(Z) Q:$E(Z,I)?1N
 I $E(Z,I)?1N Q +$E(Z,I,99)
 Q ""
 ;
GP(Y) ; EP-PARSES OUT REPRO HX
 NEW %,G,L,P,S,T,X,Z
 I Y["G" S X=$F(Y,"G"),Z=$E(Y,X,99),%=$$PARSE(Z) S @TMP@(1,"grav")="G "_% ; GRAVIDA
 I Y["P" S X=$F(Y,"P"),Z=$E(Y,X,99),%=$$PARSE(Z) S @TMP@(1,"para")="P "_% ; PARA
 I Y["L" S X=$F(Y,"L"),Z=$E(Y,X,99),%=$$PARSE(Z) S @TMP@(1,"lc")="LC "_% ; LC
 I Y["S" S X=$F(Y,"S"),Z=$E(Y,X,99),%=$$PARSE(Z) S @TMP@(1,"ab")="SA "_% ; SAB
 I Y["T" S X=$F(Y,"T"),Z=$E(Y,X,99),%=$$PARSE(Z) S @TMP@(1,"ab")=@TMP@(1,"ab")_"      TA "_% ; TAB
 Q
 ;
BH(DFN) ; EP-GIVEN DFN GETS BIRTH HX
 NEW %,AS,BIEN,BW,DEL,GA,X
 S BIEN=+$O(^AUPNBMSR("B",DFN,0))
 S X=$G(^AUPNBMSR(BIEN,0))
 S @TMP@(1,"lab1")="Location"
 S @TMP@(1,"lab2")="Complications"
 S %=$P(X,U,2) I %=+% D  ; BIRTH WEIGHT
 . I %>25 S @TMP@(1,"grav")=%_"gms" Q
 . S @TMP@(1,"grav")=%_"lbs "_+$P(X,U,3)_"ozs"
 . Q
 E  S @TMP@(1,"grav")="BW"
 S %="",AS(1)=$P(X,U,4),AS(5)=$P(X,U,5)
 I AS(1)=+AS(1) S %=AS(1) I AS(5)=+AS(5) S %=%_"/"_AS(5) ; APGAR 1/5
 S @TMP@(1,"para")="AS "_%
 S %=$P(X,U,6) S @TMP@(1,"lc")="GA "_% ; GESTATIONAL AGE
 S %=$P(X,U,7) I $L(%) S @TMP@(1,"ab")=$E(%,1,10) ; DELIVERY TYPE
 E  S @TMP@(1,"ab")="Delivery"
 S %=$P(X,U,8) I $L(%) S @TMP@(1,"fpm")=$E(%,1,20) ; COMPLICATIONS
 Q
 ;
CHART(DEPTIEN,DFN) ; EP-GIVEN THE PATIENT DFN AND DEPT IEN RETURN THE CHART NMBR
 NEW %,SIEN,X,Y
 I $P($G(^VEN(7.5,+$G(CFIGIEN),0)),U,2) Q DFN ; FOR SITES THAT USE THE DFN AS THE RECORD NUMBER
 S X=$G(^VEN(7.95,+$G(DEPTIEN),0))
 I '$L(X) Q ""
 S SIEN=$P($G(^VEN(7.95,+$G(DEPTIEN),2)),U,4) I 'SIEN S SIEN=$G(DUZ(2)) I 'SIEN Q ""
 S Y=$P($G(^AUPNPAT(+$G(DFN),41,SIEN,0)),U,2)
 Q Y
 ; 
