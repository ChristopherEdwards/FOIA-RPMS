AUMAUTFX ;IHS/OIT/ABK - AUM 10 patch 2 AD-HOC LOAD [ 10/10/2010  9:19 AM ]
 ;;11.0;TABLE MAINTENANCE;**5**;Oct 15,2010
 ;Utilites to facilitate AUM/AUTT Fix
 ;
 ;
DOFTG(PATH,FILENAME) ;
 N GBL,GBLZISH,SUCCESS
 K ^TMP("AUMPFIX",$J)
 S GBL="^TMP(""AUMPFIX"",$J)"
 S GBLZISH="^TMP(""AUMPFIX"",$J,1)"
 S GBLZISH=$NA(@GBLZISH)
 S SUCCESS=$$FTG^%ZISH(PATH,FILENAME,GBLZISH,3)
 Q
 ;
DOGTF(PATH,FILENAME) ;
 N GBL,GBLZISH,SUCCESS
 S GBL="^TMP(""AUMPFIX"",$J)"
 S GBLZISH="^TMP(""AUMPFIX"",$J,1)"
 S GBLZISH=$NA(@GBLZISH)
 S SUCCESS=$$GTF^%ZISH(GBLZISH,3,PATH,FILENAME)
 Q
 ;
FIX ;
 N AUMDA,AUMDA1,TOTCNT,AUMERR,TOTUPD,FIXSTR,AUMCNAM,AUMMNE,AUMMJT
 S AUMDA="",TOTCNT=0,AUMERR=0,TOTUPD=0
 F  S AUMDA=$O(^TMP("AUMPFIX",$J,AUMDA)) Q:AUMDA=""  S FIXSTR=^(AUMDA) D
  .S TOTCNT=TOTCNT+1
  .S AUMCNAM=$P(FIXSTR,U,4)_"-"_$P(FIXSTR,U,5),AUMMNE=$P(FIXSTR,U,3),AUMMJT=$P(FIXSTR,U,4)
  .; Do error checking
  .I AUMCNAM="" D BMES^XPDUTL("Name field is null "_AUMCNAM_" not updated - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1 Q
  .I AUMMNE="" D BMES^XPDUTL("Mnemonic field is null "_AUMMNE_" not updated - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1 Q
  .; Ok - past that
  .S AUMDA1=0,AUMDA1=$O(^AUTTEDT("C",AUMMNE,AUMDA1))
  .I AUMDA1'="" D  ; DA NOT NULL,updating
  ..S TOTUPD=TOTUPD+1
  ..S DIE="^AUTTEDT(",DA=AUMDA1 ;,DIC(0)="L"
  ..S DR=".01////"_AUMCNAM_";1////"_AUMMNE_";.06////"_AUMMJT_";.03////@"
  ..D ^DIE D BMES^XPDUTL("Updated - Name = "_AUMCNAM_"    Mnemonic = "_AUMMNE)
  ..D ^XBFMK
  ..Q
  .Q
  D BMES^XPDUTL("Total records processed:   "_TOTCNT)
  D BMES^XPDUTL("Total records in  error:   "_AUMERR)
  D BMES^XPDUTL("Total records   updated:   "_TOTUPD)
 Q
 ;
FIXAUM ;
 N AUMDA,AUMDA1,TOTCNT,AUMERR,TOTUPD,FIXSTR,AUMCNAM,AUMMNE,AUMMJT
 S AUMDA="",TOTCNT=0,AUMERR=0,TOTUPD=0
 F  S AUMDA=$O(^TMP("AUMPFIX",$J,AUMDA)) Q:AUMDA=""  S FIXSTR=^(AUMDA) D
  .S TOTCNT=TOTCNT+1
  .S AUMCNAM=$P(FIXSTR,U,4)_"-"_$P(FIXSTR,U,5),AUMMNE=$P(FIXSTR,U,3),AUMMJT=$P(FIXSTR,U,4)
  .; Do error checking
  .I AUMCNAM="" D BMES^XPDUTL("Name field is null "_AUMCNAM_" not updated - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1 Q
  .I AUMMNE="" D BMES^XPDUTL("Mnemonic field is null "_AUMMNE_" not updated - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1 Q
  .; Ok - past that
  .S AUMDA1=0,AUMDA1=$O(^AUTTEDT("C",AUMMNE,AUMDA1))
  .I $D(^AUMPCLN(AUMMNE)) S XSTR=^(AUMMNE),$P(XSTR,U,2)=AUMCNAM,$P(XSTR,U,4)=AUMMJT,^AUMPCLN(AUMMNE)=XSTR,TOTUPD=TOTUPD+1
  .E  D BMES^XPDUTL("Mnemonic - "_AUMMNE_" does not exist - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1
  .Q
  D BMES^XPDUTL("Total records processed:   "_TOTCNT)
  D BMES^XPDUTL("Total records in  error:   "_AUMERR)
  D BMES^XPDUTL("Total records   updated:   "_TOTUPD)
 Q
UPPER(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ; End of routine
FIXSMT ; Fix Target AUTTEDMT data, translate to upper and remove apostrophes
 N X1,X2,X3,AUMDA
 S AUMDA=0
 F  S AUMDA=$O(^AUTTEDMT(AUMDA)) Q:AUMDA="B"  S X1=^(AUMDA,0),X2=$TR(X1,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),X3=$TR(X2,"'") S ^AUTTEDMT(AUMDA,0)=X3
 Q
FIXEDMT ; Fix AUTTEDMT global, by updating it with new major topics
 N AUMDA,AUMDA1,TOTCNT,AUMERR,TOTNEW,TOTUPD,FIXSTR,AUMMNE,AUMMJT
 S AUMDA="",TOTCNT=0,AUMERR=0,TOTNEW=0,TOTUPD=0
 F  S AUMDA=$O(^AUMPMT(AUMDA)) Q:AUMDA=""  S FIXSTR=^(AUMDA) D
  .S TOTCNT=TOTCNT+1
  .S AUMMNE=$P(FIXSTR,U,1),AUMMJT=$P(FIXSTR,U,2)
  .; Do error checking
  .I AUMMJT="" D BMES^XPDUTL("Topic Name field is null "_AUMMJT_" not updated - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1 Q
  .I AUMMNE="" D BMES^XPDUTL("Mnemonic field is null "_AUMMNE_" not updated - error"),BMES^XPDUTL("Record: "_FIXSTR) S AUMERR=AUMERR+1 Q
  .; Ok - past that
  .S AUMDA1=0,AUMDA1=$O(^AUTTEDMT("B",AUMMNE,AUMDA1))
  .I AUMDA1'="" D  ; DA NOT NULL,updating
  ..S TOTUPD=TOTUPD+1
  ..S DIE="^AUTTEDMT(",DA=AUMDA1 ;,DIC(0)="L"
  ..S DR=".01////"_AUMMJT_";.02////"_AUMMNE
  ..D ^DIE D BMES^XPDUTL("Updated - Name = "_AUMMJT_"    Mnemonic = "_AUMMNE)
  ..D ^XBFMK
  ..Q
  .I AUMDA1="" D  ; DA NULL,RECORD MISSING,SO WE ADD IT
  ..S X=AUMMJT,DIC="^AUTTEDMT(",DIC(0)="L"
  ..S DIC("DR")=".02////"_AUMMNE
  ..D ^DIC
  ..I $P(Y,U,3)=1 D
  ...S TOTNEW=TOTNEW+1
  ...D BMES^XPDUTL("Inserted Topic - Name = "_AUMMJT_"    Mnemonic = "_AUMMNE)
  ...Q
  ..E  D
  ...S AUMERR=AUMERR+1
  ...D BMES^XPDUTL("No Insert Performed - Name = "_AUMMJT_"    Mnemonic = "_AUMMNE)
  ...Q
  ..D ^XBFMK
  ..Q
  .Q
  ;
  D BMES^XPDUTL("Total records       processed:   "_TOTCNT)
  D BMES^XPDUTL("Total records already present:   "_AUMERR)
  D BMES^XPDUTL("Total records         updated:   "_TOTUPD)
  D BMES^XPDUTL("Total records        inserted:   "_TOTNEW)
 Q
KILL ;kill "B" cross-references
 K ^AUTTEDMT("B")
 Q
 ;
POST ;call to ENALL^DIK for .01 and 1
 W !,"Rebuilding Indexes",!
 S DIK="^AUTTEDMT("
 S DIK(1)=".01^B"
 D ENALL^DIK
 S DIK(1)=".02^C"
 D ENALL^DIK
 Q
 ;
