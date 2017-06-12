BQIRGPG ;GDIT/HS/ALA-Pregnancy Care Mgmt ; 17 Jul 2013  7:49 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
CURR(DFN) ;EP - Currently marked as pregnant
 NEW RESULT
 S RESULT="NO"
 I $$GET1^DIQ(9000017,DFN_",",1101,"E")'="" S RESULT=$$GET1^DIQ(9000017,DFN_",",1101,"E")
 Q RESULT
 ;
EDD(DFN) ;EP - Estimated Date of Delivery
 NEW RES,ARRAY,PI,PDATA,EDD
 S RES="",PDATA=$G(^AUPNREP(DFN,13))
 F PI=2,5,8,11,14 D
 . I $P(PDATA,U,PI)'="" S ARRAY($P(PDATA,U,PI))=PI
 S EDD=$O(ARRAY(""),-1) I EDD'="" S RES=$$FMTE^BQIUL1(EDD)
 Q RES
 ;
HGH(DFN) ;EP - High Risk Prenatal Problems
 NEW BQJN,OK
 S OK="NO",BQJN=""
 F  S BQJN=$O(^BJPNPL("D",DFN,BQJN)) Q:BQJN=""  D
 . I $P(^BJPNPL(BQJN,0),U,6)="H" S OK="YES"
 Q OK
 ;
EGA(DFN) ;EP - Estimated gestational age
 NEW VALL,RES,DATE
 S RES=""
 S VALL=$$MEAS^BQITUTL(DFN,"EGA")
 I VALL=0 Q RES
 S RES=$P(VALL,U,3)_" ("_$$FMTE^BQIUL1($P(VALL,U,2))_")"
 Q RES
 ;
GRAV(DFN) ;EP - Gravida Total # of pregnancies
 NEW RES
 S RES=+$$GET1^DIQ(9000017,DFN_",",1103,"E")
 Q RES
 ;
LAB ;EP - Pull out prenatal lab tests
 NEW LRES,RES
 S LRES=$$ITM^BQICMUTL("",BQDFN,FREF,RREF,ITM,TAX,.TREF)
 I $P(LRES,U,1)=0 S RESULT=0 Q
 S RES=$P(LRES,U,7) I RES="" S RES=$P(LRES,U,6)
 S RESULT=1_U_$P(LRES,U,2)_U_RES
 Q
 ;
LBT ;EP - Set up lab tests
 NEW TAX,TREF
 S TAX="BQI PRENATAL TAX"
 S TREF=$NA(^TMP("BQIPRENTL",$J)) K @TREF
 D BLD^BQITUTL(TAX,.TREF,"L")
 ; Clean up labs
 NEW DA,IENS,CIEN
 S CIEN=$O(^BQI(90506.5,"B","Prenatal","")) I CIEN="" Q
 S DA=0,DA(1)=CIEN
 F  S DA=$O(^BQI(90506.5,CIEN,10,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90506.51,IENS,.09)=1
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Set up lab tests
 NEW BN,CT,CD,DA,IENS,DIC,DESC,PNL,DLAYGO,DIC,X,Y,NM,NAME
 S BN=0
 F  S BN=$O(@TREF@(BN)) Q:'BN  D
 . S NM=$P(^LAB(60,BN,.1),U,1),NAME=$P(^LAB(60,BN,0),"^",1)
 . S PNL=0 I $O(^LAB(60,BN,2,0))'="" S PNL=1
 . S IEN=$O(^BQI(90506.5,CIEN,10,"C",NM,""))
 . I IEN'="" D
 .. S DA(1)=CIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90506.51,IENS,.09)="@"
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. I PNL S DESC(1)="Most recent "_NAME_" panel from V Lab is displayed."
 .. I 'PNL S DESC(1)="Most recent "_NAME_" lab test from V Lab is displayed."
 .. D WP^DIE(90506.51,IENS,4,"","DESC")
 . I IEN="" D
 .. S CT=$P($G(^BQI(90506.5,CIEN,10,0)),U,3),CT=CT+1
 .. S CD="PG_"_$E("0000",$L(CT),2)_CT
 .. S DA(1)=CIEN,X=CD,DIC="^BQI(90506.5,"_DA(1)_",10,",DIC(0)="L",DLAYGO=90506.51
 .. K DO,DD D FILE^DICN S DA=+Y
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90506.51,IENS,.02)=3,BQIUPD(90506.51,IENS,.03)=NM
 .. S BQIUPD(90506.51,IENS,.04)=BN,BQIUPD(90506.51,IENS,.05)="B"
 .. S BQIUPD(90506.51,IENS,.06)="D",BQIUPD(90506.51,IENS,.08)="A"
 .. S BQIUPD(90506.51,IENS,1)="D LAB^BQIRGPG"
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. I PNL S DESC(1)="Most recent "_NAME_" panel from V Lab is displayed."
 .. I 'PNL S DESC(1)="Most recent "_NAME_" lab test from V Lab is displayed."
 .. D WP^DIE(90506.51,IENS,4,"","DESC")
 K @TREF
 Q
 ;
GLS(DATA,FAKE) ;EP - BQI GET PRENATAL GLOSSARY
 NEW UID,II,TRIEN,CAT,TIT,SORT,RMK,REMARK,CT,NXT,GLIEN,IEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGPGLS",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRGPG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T32767REPORT_TEXT"_$C(30)
 S GLIEN=$O(^BQI(90508.2,"B","Prenatal","")) I GLIEN="" S BMXSEC="Problem with Prenatal glossary in file 90508.2" G DONE
 S IEN=0 F  S IEN=$O(^BQI(90508.2,GLIEN,1,IEN)) Q:'IEN  D
 . S II=II+1,@DATA@(II)=$G(^BQI(90508.2,GLIEN,1,IEN,0))
 ;S GLIEN=$O(^BQI(90506.5,"B","Prenatal","")) I GLIEN="" S BMXSEC="Problem with Prenatal source list" G DONE
 ;S IEN=0 F  S IEN=$O(^BQI(90506.5,GLIEN,10,IEN)) Q:'IEN  D
 ;. S IIEN=$P(^BQI(90506.5,GLIEN,10,IEN,0),U,4)
 ;. S II=II+1,@DATA@(II)="    "_$P(^BQI(90506.5,GLIEN,10,IEN,0),U,3)_" ("_$P($G(^LAB(60,IIEN,0)),U,1)_")"
 I II>0 S @DATA@(II)=@DATA@(II)_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
