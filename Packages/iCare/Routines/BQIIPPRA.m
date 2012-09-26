BQIIPPRA ;GDIT/HS/ALA-IPC Provider Monthly Aggregate ; 30 Nov 2011  11:17 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
EN(DATA,PLIST) ;EP -- BQI GET IPC MON PROV AGG
 ;Input Parameters
 ;  PLIST - List of DFNs (optional) assumes Microsystem list of providers if PLIST is blank
 NEW UID,II,TDATA,DTI,HDR,ORD,IDD,ID,BQMON,TIT,POS,Z,MEAS,MSDN,NUM,DEN
 NEW PROV,BQI,CAT,GOAL,IDN,POS1,POS2,TAB,STAB
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPPRA",UID)) K @DATA
 S TDATA=$NA(^TMP("BQIPRVMAG",UID)) K @TDATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPPRV D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;  get the current IPC definition
 NEW CRIPC,CRN
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 ;
 S HDR="T00050IPC_MEAS^T00030CATEGORY^T00005PERCENT_GOAL^"
 K Z
 S DTI="",POS=3
 F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  D
 . S BQMON=$E(DTI,4,5)
 . S TIT=$P($T(MON+BQMON^BQIIPUTL),";;",2)_"_"_(1700+$E(DTI,1,3))
 . S HDR=HDR_"T00010"_TIT_U_"T00045HIDE_"_TIT_U
 . S POS=POS+1
 . S Z(DTI)=POS_"^"_(POS+1)
 . S POS=POS+1
 ;
 S ORD=""
 F  S ORD=$O(^BQI(90508,1,22,CRN,1,"C",ORD)) Q:ORD=""  D
 . S IDD=""
 . F  S IDD=$O(^BQI(90508,1,22,CRN,1,"C",ORD,IDD)) Q:IDD=""  D
 .. S ID=$P(^BQI(90508,1,22,CRN,1,IDD,0),U,1)
 .. I $P(^BQI(90508,1,22,CRN,1,IDD,0),U,7)=1 Q
 .. S DTI=""
 .. F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  S @TDATA@(ID,DTI)="0^0"
 ;
 S @DATA@(II)=$$TKO^BQIUL1(HDR,"^")_$C(30)
 ;
 ; If a list of DFNs, process them instead of entire panel
 I $D(PLIST)>0 D
 . I $D(PLIST)>1 D
 .. S LIST="",BN=""
 .. F  S BN=$O(PLIST(BN)) Q:BN=""  S LIST=LIST_PLIST(BN)
 .. K PLIST S PLIST=LIST
 . F BQI=1:1 S PROV=$P(PLIST,$C(28),BQI) Q:PROV=""  D RTE(PROV)
 ;
 I $G(PLIST)="" S PROV="" F  S PROV=$O(^BQI(90508,1,22,CRN,2,"B",PROV)) Q:PROV=""  D RTE(PROV)
 ;
 S ORD=""
 F  S ORD=$O(^BQI(90508,1,22,CRN,1,"C",ORD)) Q:ORD=""  D
 . S IDD=""
 . F  S IDD=$O(^BQI(90508,1,22,CRN,1,"C",ORD,IDD)) Q:IDD=""  D
 .. S ID=$P(^BQI(90508,1,22,CRN,1,IDD,0),U,1)
 .. I $P(^BQI(90508,1,22,CRN,1,IDD,0),U,7)=1 Q
 .. I $G(@TDATA@(ID))="" Q
 .. S FDATA=@TDATA@(ID)
 .. S DATE=""
 .. F  S DATE=$O(@TDATA@(ID,DATE)) Q:DATE=""  D
 ... S DEN=$P(@TDATA@(ID,DATE),U,1),NUM=$P(@TDATA@(ID,DATE),U,2)
 ... S POS1=$P(Z(DATE),U,1),POS2=$P(Z(DATE),U,2)
 ... I ID="IPC_TOTP" D  Q
 .... S $P(FDATA,U,POS1)=DEN,$P(FDATA,U,POS2)="Total Patients: "_DEN
 ... I ID="IPC_REVG" D  Q
 .... I DEN=0 S $P(FDATA,U,POS1)="$0.00",$P(FDATA,U,POS2)="Visits: "_DEN_" Billed: $0.00" Q
 .... S $P(FDATA,U,POS1)=$$DOL(NUM/DEN),$P(FDATA,U,POS2)="Visits: "_DEN_" Billed: "_$$DOL(NUM)
 ... I DEN=0 S $P(FDATA,U,POS1)="0%",$P(FDATA,U,POS2)="Numerator: 0 Denominator: 0" Q
 ... I DEN'=0,NUM=0 S $P(FDATA,U,POS1)="0%",$P(FDATA,U,POS2)="Numerator: 0 Denominator: "_DEN Q
 ... I NUM'=0 D
 .... S VAL=$J((NUM/DEN)*100,3,0)
 .... S VAL=$$TRIM^BQIUL1(VAL," ")_"%"
 .... S $P(FDATA,U,POS1)=VAL,$P(FDATA,U,POS2)="Numerator: "_NUM_" Denominator: "_DEN
 .. S DATE=""
 .. F  S DATE=$O(Z(DATE)) Q:DATE=""  D
 ... S POS1=$P(Z(DATE),U,1),POS2=$P(Z(DATE),U,2)
 ... I $P(FDATA,U,POS1)="" S $P(FDATA,U,POS1)="N/A"
 ... I $P(FDATA,U,POS2)="" S $P(FDATA,U,POS2)="Not Applicable"
 .. S II=II+1,@DATA@(II)=FDATA_$C(30)
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
 .. S @TDATA@(ID)=ID_$C(28)_MEAS_U_CAT_U_GOAL_U
 .. S IDN=$O(^BQIPROV(PRV,30,"B",ID,"")) I IDN="" Q
 .. S DTI=""
 .. F  S DTI=$O(^BQI(90508,1,22,CRN,3,"B",DTI)) Q:DTI=""  D
 ... S MSDN=$O(^BQIPROV(PRV,30,IDN,1,"B",DTI,""))
 ... I MSDN="" S DEN=0,NUM=0
 ... I MSDN'="" S DEN=+$P(^BQIPROV(PRV,30,IDN,1,MSDN,0),U,2),NUM=+$P(^BQIPROV(PRV,30,IDN,1,MSDN,0),U,3)
 ... S $P(@TDATA@(ID,DTI),U,1)=$P($G(@TDATA@(ID,DTI)),U,1)+DEN,$P(@TDATA@(ID,DTI),U,2)=$P($G(@TDATA@(ID,DTI)),U,2)+NUM
 Q
 ;
DOL(X) ;EP - Dollar formatter
 S X2="2$" D COMMA^%DTC S X=X_$E("00",1,2-$L($P(X,".",2))) K X2
 Q $$TKO^BQIUL1($$TRIM^BQIUL1(X," ")," ")
