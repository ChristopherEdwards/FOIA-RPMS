BQIIPTBL ;VNGT/HS/ALA-IPC Tables ; 24 Jun 2011  8:06 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
TMM(DATA,TEAM) ; EP - BQI GET TEAM MEMBERS
 ; Input Parameters
 ;   TEAM - IEN of the team
 NEW UID,II
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPCTMM",UID))
 K @DATA
 S II=0,TYPE=$G(TYPE,"")
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPTBL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="I00010IEN^T00035"
 S @DATA@(II)=HDR_$C(30)
 S TN=0
 F  S TN=$O(^BSDPCT(TEAM,1,TN)) Q:'TN  D
 . S IEN=$P(^BSDPCT(TEAM,1,TN,0),U,1),NAME=$P($G(^VA(200,IEN,0)),U,1)
 . S II=II+1,@DATA@(II)=IEN_U_NAME_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ITM(DATA,FAKE) ; EP -- BQI GET IPC MEASURES
 ;
 NEW UID,II,CRIPC,CRN,MSN,IDATA,CODE,TYP,CAT,TIP,TP,SHEET,NUM,DEN
 NEW BQIH,YEAR,BQIYR,BQIINDG,BQIMEASG,MEAS,ORD,SUB
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPCITM",UID))
 K @DATA
 S II=0,TYPE=$G(TYPE,"")
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPTBL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="T00030ID^T00050NAME^T00030CATEGORY^T00030CAT2^T00001SUBCATEGORY^T00030EXCEL_SHEET^T00010EXCEL_NUM_COL^"
 S HDR=HDR_"T00010EXCEL_DEN_COL^T00001PER_DIRECT^T01024TOOLTIP"
 S @DATA@(II)=HDR_$C(30)
 ; Get current IPC
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 S MSN=0
 F  S MSN=$O(^BQI(90508,1,22,CRN,1,MSN)) Q:'MSN  D
 . S IDATA=^BQI(90508,1,22,CRN,1,MSN,0)
 . S CODE=$P(IDATA,U,1),TYP=$P(IDATA,U,2)
 . ; If inactive, quit
 . I $P(IDATA,U,7)=1 Q
 . ; If type is Non calculable, quit
 . I TYP="N" Q
 . ; If order of display is blank, quit
 . I $P(IDATA,U,6)="" Q
 . NEW DA,IENS
 . S DA(2)=1,DA(1)=CRN,DA=MSN,IENS=$$IENS^DILF(.DA)
 . S SUB=$$GET1^DIQ(90508.221,IENS,.05,"I")
 . S ORD=$P(IDATA,U,6),SHEET=$P(IDATA,U,8),NUM=$P(IDATA,U,10),DEN=$P(IDATA,U,9)
 . S CAT=$$GET1^DIQ(90508.221,IENS,.03,"E")
 . I CAT="" D
 .. S RIEN=$O(^BQI(90506.1,"B",CODE,""))
 .. S CAT=$$GET1^DIQ(90506.1,RIEN_",",3.02,"E")
 . S CAT2=$$GET1^DIQ(90508.221,IENS,.11,"E")
 . S PDIR=$$MEAS^BQIGPUTL(CODE)
 . S TIP="",TP=0
 . F  S TP=$O(^BQI(90508,1,22,CRN,1,MSN,3,TP)) Q:'TP  D
 .. S TIP=TIP_^BQI(90508,1,22,CRN,1,MSN,3,TP,0)_$C(10)
 . I TIP="",TYP="G" D
 .. S BQIH=$$SPM^BQIGPUTL()
 .. S YEAR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 .. S BQIYR=$$LKP^BQIGPUTL(YEAR)
 .. D GFN^BQIGPUTL(BQIH,BQIYR)
 .. S BQIINDG=$$ROOT^DILFD(BQIINDF,"",1)
 .. S BQIMEASG=$$ROOT^DILFD(BQIMEASF,"",1)
 .. S MEAS=$P(CODE,"_",2),TP=0
 .. F  S TP=$O(@BQIMEASG@(MEAS,18,TP)) Q:'TP  D
 ... S TIP=TIP_@BQIMEASG@(MEAS,18,TP,0)_$C(10)
 . S II=II+1,@DATA@(II)=CODE_U_$P(IDATA,U,4)_U_CAT_U_CAT2_U_SUB_U_SHEET_U_NUM_U_DEN_U_PDIR_U_TIP_$C(30)
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
DTE(DATA,FAKE) ;EP -- BQI GET IPC DATES
 NEW UID,II,CRIPC,CRN,MSN,DATE,MONTH,MSN,BQMON,TIT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPCDTE",UID))
 K @DATA
 S II=0,TYPE=$G(TYPE,"")
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPTBL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="T00030DATE^T00010ROW^T00010MONTH^T00007HIDE_MON_DATE"
 S @DATA@(II)=HDR_$C(30)
 ; Get current IPC
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 S DATE=""
 F  S DATE=$O(^BQI(90508,1,22,CRN,3,"B",DATE)) Q:DATE=""  D
 . S MSN=""
 . F  S MSN=$O(^BQI(90508,1,22,CRN,3,"B",DATE,MSN)) Q:MSN=""  D
 .. S BQMON=$E(DATE,4,5)
 .. S TIT=$P($T(MON+BQMON^BQIIPUTL),";;",2)_"_"_(1700+$E(DATE,1,3))
 .. S MONTH=$P($T(MON+BQMON^BQIIPUTL),";;",2)_"-"_$E((1700+$E(DATE,1,3)),3,4)
 .. S II=II+1,@DATA@(II)=TIT_U_$P(^BQI(90508,1,22,CRN,3,MSN,0),U,2)_U_MONTH_U_DATE_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
