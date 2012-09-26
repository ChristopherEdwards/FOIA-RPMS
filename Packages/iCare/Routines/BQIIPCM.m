BQIIPCM ;VNGT/HS/ALA-Get IPC Monthly Data by Provider ; 17 Jun 2011  12:38 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
RET(DATA,PROV,CNT) ;EP -- BQI GET IPC PROV MONTHLY
 NEW UID,II,HDR,C1,C2,C3,C4,NAME,HEAD,HX,PEC,SORT,QFL,PCT,CT,DDATA
 NEW CPER,PPER,TIT,BQMON,DATE,TAB,STAB,TNM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIMUPROV",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPCM D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ; Get current IPC
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 ;
 K Z
 S HDR="T00050PROVIDER^T00050IPC_MEAS^T00030CATEGORY^T00005PERCENT_GOAL^"
 S DATE=""
 F  S DATE=$O(^BQI(90508,1,22,CRN,3,"B",DATE)) Q:DATE=""  D
 . S BQMON=$E(DATE,4,5)
 . S TIT=$P($T(MON+BQMON^BQIIPUTL),";;",2)_"_"_(1700+$E(DATE,1,3))
 . ;S TIT=$P($T(MON+BQMON^BQIIPUTL),";;",2)
 . S HDR=HDR_"T00010"_TIT_U_"T00045HIDE_"_TIT_U
 . S Z(DATE)="N/A^Not Applicable"
 S @DATA@(II)=$$TKO^BQIUL1(HDR,"^")_$C(30)
 ;
 S (C1,C2,C3,C4,CT,PCT)=0
 S PROV=$G(PROV,"")
 I PROV'="" D RTE(PROV) G DONE
 I PROV="" S PROV=+PROV
 F  S PROV=$O(^BQIPROV(PROV)) Q:'PROV  D RTE(PROV)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
RTE(PRV) ;EP
 S DDATA=""
 S PRVR=PRV_$C(28)_$P($G(^VA(200,PRV,0)),U,1)
 ;S PRVR=$P($G(^VA(200,PRV,0)),U,1)
 S DDATA=PRVR_U
 S CYR=$E(DT,1,3)
 S ORD=""
 F  S ORD=$O(^BQI(90508,1,22,CRN,1,"C",ORD)) Q:ORD=""  D
 . S IDD=""
 . F  S IDD=$O(^BQI(90508,1,22,CRN,1,"C",ORD,IDD)) Q:IDD=""  D
 .. S ID=$P(^BQI(90508,1,22,CRN,1,IDD,0),U,1),MEAS=$P(^(0),U,4),GOAL=$P(^(0),U,12)
 .. I $P(^BQI(90508,1,22,CRN,1,IDD,0),U,7)=1 Q
 .. NEW DA,IENS
 .. S DA(2)=1,DA(1)=CRN,DA=IDD,IENS=$$IENS^DILF(.DA)
 .. S CAT=$$GET1^DIQ(90508.221,IENS,.03,"E")
 .. S TAB=$$GET1^DIQ(90508.221,IENS,.13,"I")
 .. S STAB=$$GET1^DIQ(90508.221,IENS,.14,"I")
 .. I TAB="A",STAB="F" Q
 .. I CAT="" D
 ... S CODE=ID
 ... S RIEN=$O(^BQI(90506.1,"B",CODE,"")) I RIEN="" Q
 ... S CAT=$$GET1^DIQ(90506.1,RIEN_",",3.02,"E")
 .. S DDATA=DDATA_ID_$C(28)_MEAS_U_CAT_U_GOAL_U
 .. S IDN=$O(^BQIPROV(PRV,30,"B",ID,"")) I IDN="" D  Q
 ... S DTI=""
 ... F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  S Z(DTI)="N/A^Not Applicable"
 .. S DTI=""
 .. F  S DTI=$O(Z(DTI)) Q:DTI=""  D
 ... S MSDN=$O(^BQIPROV(PRV,30,IDN,1,"B",DTI,""))
 ... I MSDN="" S Z(DTI)="N/A^Not Applicable" Q
 ... S DEN=+$P(^BQIPROV(PRV,30,IDN,1,MSDN,0),U,2),NUM=+$P(^BQIPROV(PRV,30,IDN,1,MSDN,0),U,3)
 ... I ID="IPC_TOTP" D  Q
 .... S Z(DTI)=DEN_"^Total Patients: "_DEN
 ... I ID="IPC_REVG" D  Q
 .... I DEN=0 S Z(DTI)="$0^Visits: 0 Billed: 0" Q
 .... I DEN'=0,NUM=0 S Z(DTI)="$0^Visits: 0 Billed: 0" Q
 .... I DEN'=0,NUM'=0 S Z(DTI)=$$DOL(NUM/DEN)_U_"Visits: "_DEN_" Billed: "_$$DOL(NUM) Q
 ... I DEN=0 S Z(DTI)="0%^Numerator: 0 Denominator: 0" Q
 ... I DEN'=0,NUM=0 S Z(DTI)="0%^Numerator: 0 Denominator: "_DEN Q
 ... I NUM'=0 D
 .... S VAL=$J((NUM/DEN)*100,3,0)
 .... S VAL=$$TRIM^BQIUL1(VAL," ")_"%"
 .... S Z(DTI)=VAL_U_"Numerator: "_NUM_" Denominator: "_DEN
 . ;
 . S DTI="",TOT=0,TNM=0 F  S DTI=$O(Z(DTI)) Q:DTI=""  S TOT=TOT+1 S:Z(DTI)="" TNM=TNM+1
 . I TNM=TOT Q
 . F  S DTI=$O(Z(DTI)) Q:DTI=""  S DDATA=DDATA_Z(DTI)_U
 . S DDATA=$$TKO^BQIUL1(DDATA,"^")
 . S II=II+1,@DATA@(II)=DDATA_$C(30)
 . K Z
 . S DDATA=PRVR_U
 . S DTI=""
 . F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  S Z(DTI)=""
 Q
 ;
FAC(DATA,FAKE) ;EP -- BQI GET IPC FAC MONTHLY
 NEW UID,II,HDR,FAC,CYR,DATE,Z,I,IDN,ID,DTI,MSDN,DEN,NUM,VAL,DDATA,TIT,BQMON,DATE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPCF",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPCM D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ; Get current IPC
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 ;
 K Z
 S HDR="T00030FACILITY^T00050IPC_MEAS^T00030CATEGORY^T00005PERCENT_GOAL^"
 S DATE=""
 F  S DATE=$O(^BQI(90508,1,22,CRN,3,"B",DATE)) Q:DATE=""  D
 . S BQMON=$E(DATE,4,5)
 . S TIT=$P($T(MON+BQMON^BQIIPUTL),";;",2)_"_"_(1700+$E(DATE,1,3))
 . ;S TIT=$P($T(MON+BQMON^BQIIPUTL),";;",2)
 . S HDR=HDR_"T00010"_TIT_U_"T00045HIDE_"_TIT_U
 . S Z(DATE)="N/A^Not Applicable"
 ; 
 S @DATA@(II)=$$TKO^BQIUL1(HDR,"^")_$C(30)
 ;
 S FAC=$$HME^BQIGPUTL()
 S II=II+1,SAME=FAC_$C(28)_$P(^DIC(4,FAC,0),U,1)_U,DDATA=SAME
 ;
 S ORD=""
 F  S ORD=$O(^BQI(90508,1,22,CRN,1,"C",ORD)) Q:ORD=""  D
 . S IDD=""
 . F  S IDD=$O(^BQI(90508,1,22,CRN,1,"C",ORD,IDD)) Q:IDD=""  D
 .. S ID=$P(^BQI(90508,1,22,CRN,1,IDD,0),U,1),MEAS=$P(^(0),U,4),GOAL=$P(^(0),U,12)
 .. I $P(^BQI(90508,1,22,CRN,1,IDD,0),U,7)=1 Q
 .. NEW DA,IENS
 .. S DA(2)=1,DA(1)=CRN,DA=IDD,IENS=$$IENS^DILF(.DA)
 .. S CAT=$$GET1^DIQ(90508.221,IENS,.03,"E")
 .. I CAT="" D
 ... S CODE=ID
 ... S RIEN=$O(^BQI(90506.1,"B",CODE,"")) I RIEN="" Q
 ... S CAT=$$GET1^DIQ(90506.1,RIEN_",",3.02,"E")
 .. S DDATA=DDATA_ID_$C(28)_MEAS_U_CAT_U_GOAL_U
 .. S IDN=$O(^BQIFAC(FAC,30,"B",ID,"")) I IDN="" D  Q
 ... S DTI=""
 ... F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  S Z(DTI)="N/A^Not Applicable"
 .. S DTI=""
 .. F  S DTI=$O(Z(DTI)) Q:DTI=""  D
 ... S MSDN=$O(^BQIFAC(FAC,30,IDN,1,"B",DTI,""))
 ... I MSDN="" S Z(DTI)="N/A^Not Applicable" Q
 ... S DEN=+$P(^BQIFAC(FAC,30,IDN,1,MSDN,0),U,2),NUM=+$P(^BQIFAC(FAC,30,IDN,1,MSDN,0),U,3)
 ... I ID="IPC_TOTP" D  Q
 .... S Z(DTI)=DEN_"^Total Patients: "_DEN
 ... I ID="IPC_REVG" D  Q
 .... I DEN=0 S Z(DTI)="$0^Visits: 0 Billed: 0" Q
 .... I DEN'=0,NUM=0 S Z(DTI)="$0^Visits: 0 Billed: 0" Q
 .... I DEN'=0,NUM'=0 S Z(DTI)=$$DOL(NUM/DEN)_U_"Visits: "_DEN_" Billed: "_$$DOL(NUM) Q
 ... I DEN=0 S Z(DTI)="0%^Numerator: 0 Denominator: 0" Q
 ... I DEN'=0,NUM=0 S Z(DTI)="0%^Numerator: 0 Denominator: 0" Q
 ... I NUM'=0 D
 .... S VAL=$J((NUM/DEN)*100,3,0)
 .... S VAL=$$TRIM^BQIUL1(VAL," ")_"%"
 .... S Z(DTI)=VAL_U_"Numerator: "_NUM_" Denominator: "_DEN
 . ;
 . S DTI="",TOT=0,TNM=0 F  S DTI=$O(Z(DTI)) Q:DTI=""  S TOT=TOT+1 S:Z(DTI)="" TNM=TNM+1
 . I TNM=TOT Q
 . F  S DTI=$O(Z(DTI)) Q:DTI=""  S DDATA=DDATA_Z(DTI)_U
 . S @DATA@(II)=$$TKO^BQIUL1(DDATA,U)_$C(30)
 . S DDATA=SAME
 . S II=II+1
 . K Z
 . S DTI=""
 . F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  S Z(DTI)=""
 Q
 ;
DOL(X) ;EP - Dollar formatter
 S X2="2$" D COMMA^%DTC S X=X_$E("00",1,2-$L($P(X,".",2))) K X2
 Q $$TKO^BQIUL1($$TRIM^BQIUL1(X," ")," ")
