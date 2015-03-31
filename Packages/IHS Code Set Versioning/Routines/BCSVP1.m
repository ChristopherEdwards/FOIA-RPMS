BCSVP1 ;IHS/MSC/BWF - CSV Patch 1 ;16-Apr-2010 09:58;JSH
 ;;1.0;BCSV;;APR 23, 2010;Build 44
 ;=================================================================
PRE ;
 I '$D(^XPD(9.6,"B","IHS CSV VA UPDATES 1.0")) S XPDABORT=1
 I $G(XPDABORT) D BMES^XPDUTL("BCSV 1.0 has not been installed. This patch cannot be executed!") Q
FIX ;
 N BCSVNUM,BCSVIEN,CNT,FIL,EFLG,CIEN
 ; fix DIC(81.3,0)
 S $P(^DIC(81.3,0),U,2)="81.3I"
 S BCSVNUM=$$NUM()
 S $P(^DIC(81.3,0),U,4)=BCSVNUM
 ; re-index M and M2 indices associated with the RANGE multiple field (#10)
 W !,"Re-indexing M,M2,and MR indices in file #81.3",!!	
 S (BCSVIEN,CNT)=0 F  S BCSVIEN=$O(^DIC(81.3,BCSVIEN)) Q:'BCSVIEN  D
 .S DA(1)=BCSVIEN,DIK="^DIC(81.3,"_BCSVIEN_",10,"
 .S DIK(1)=".01^M^M2" D ENALL^DIK
 .S DIK(1)=".02^M^MR" D ENALL^DIK
 ; fix .9999 AB index
 S CIEN=$O(^ICD9("AB",".9999 ",0))
 I 'CIEN S CIEN=$O(^ICD9("BA",".9999 ",0))
 I CIEN S ^ICD9("AB",.9999,CIEN)=""
 ; fix age issues as identified - note.. this is no longer needed. It has been determined that the values
 ; being used are the correct values (translated) from the VA dataset.
 ;D FIXAGE80(377.43,15,99),FIXAGE80(799.02,15,99)
 ; fix issue where age low>age high. BCSV 1.0 caused an issue where in the event that age low was 0, the VA
 ; value was put in its place due to the check being boolean. These two functions will evaluate age low and
 ; age high, if age low is higher than the age high value, the age low value will be reset to 0.
 D LOOP80,LOOP81
 ;
 ;
 ;
 ;Create an index of all "NEW" entries from ^XCSV(FILE,"NEW",IEN)
 ;This is being done by comparing the key value (field) that is compared in mapping.
 ;If there is a match, and the entry in ^XCSV was not MAPPED TO by an IHS code, we will choose that value.
 ;
PRE2 ;
 N EFLG,OFF,FIL
 D INIT^BCSVMP
 F  D  Q:$G(EFLG)
 .S FIL=$$NXTFIL^BCSVMP(.OFF)
 .I $P(FIL,DDLM,2)="" S EFLG=1 Q
 .D INDEX(FIL)
 Q
INDEX(FIL) ;
 N SRCARY,TRGARY,LOOPGLB,TGNM,NGNM,SGLB,IEN
 D SETFILE^BCSVMP($P(FIL,DDLM,2),.SRCARY,.TRGARY)
 S LOOPGLB=$$GLBPATH^BCSVMP(TRGARY("NUM"),"NEW")
 S SGLB=$$GLB^BCSVMP(SRCARY("NUM"))
 S TGNM=$NA(^XCSV(TRGARY("GNAM"),"DATA"))
 S NGNM=$NA(^XCSV(TRGARY("GNAM"),"NEW"))
 S IEN=0 F  S IEN=$O(@NGNM@(IEN)) Q:'IEN  D
 .I '$D(@SGLB@(IEN)) Q
 .S SDATA=$G(@SGLB@(IEN,0))
 .Q:SDATA=""
 .S VAL=$P(SDATA,U)
 .S TIEN=$$IENLKP^BCSVMP(TGNM,VAL,IEN,TRGARY("XRI"))
 .D UPDGLOB(TRGARY("GNAM"),IEN,TIEN)
 Q
UPDGLOB(FIL,SIEN,TIEN) ;
 N MGLN
 S MGLN=$$GLBPATH^BCSVMP(FIL,"NEW")
 I TIEN D
 .S @MGLN@(SIEN)=TIEN
 .S @MGLN@("B",TIEN)=SIEN
 Q
 ;
NUM() ;
 N X,VAL
 S X=0 F  S X=$O(^DIC(81.3,X)) Q:'X  S VAL=$G(VAL)+1
 Q VAL
 ;
FIXAGE80(CODE,LOW,HIGH) ;
 ; INPUT  IEN - ien to file 80
 ;        LOW - low age (in years)
 ;        HIGH - high age (in years)
 ; fix code 760.71 (age high)
 N IENS
 I 'CODE Q
 S CODE=CODE_" "
 S IEN=$O(^ICD9("AB",CODE,0))
 S IENS=IEN_","
 I LOW D
 .S FDA(80,IENS,14)=LOW*365
 .S FDA(80,IENS,9999999.01)=LOW
 I HIGH D
 .S FDA(80,IENS,15)=HIGH*365
 .S FDA(80,IENS,9999999.02)=HIGH
 I $D(FDA) D FILE^DIE(,"FDA") K FDA
 Q
 ;
LOOP80 ;
 N X,ALOW,AHIGH
 S X=0 F  S X=$O(^ICD9(X)) Q:'X  D
 .S ALOW=$$GET1^DIQ(80,X,14),AHIGH=$$GET1^DIQ(80,X,15)
 .I ALOW<AHIGH!(ALOW="") Q
 .S FDA(80,X_",",14)=0 D FILE^DIE(,"FDA") K FDA Q
 Q
LOOP81 ;
 N X,ALOW,AHIGH
 S X=0 F  S X=$O(^ICPT(X)) Q:'X  D
 .S ALOW=$$GET1^DIQ(81,X,10.01),AHIGH=$$GET1^DIQ(81,X,10.02)
 .I ALOW<AHIGH!(ALOW="") Q
 .S FDA(81,X_",",10.01)=0 D FILE^DIE(,"FDA") K FDA Q
 Q
