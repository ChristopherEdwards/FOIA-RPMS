ACHSY200 ; IHS/ITSC/PMF - FILE 200 CONVERSION ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; This utility converts the existing field in the CHS package that
 ; is non-compliant with the File 200 conversion.   That field is in
 ; the CHS FACILITY file, the DOCUMENT multiple, as field 80,
 ; REFERRAL PHYSICIAN.  Field 80 (F80) prior to conversion is a
 ; pointer to file 6, PROVIDER, which in turn points to file 16,
 ; PERSON.
 ;
 ; This utility calls EN^AVAPCHK,RESULTS^AVAPCHK, and if 3, 6, 16,
 ; and 200 have the proper links, proceeds $ORDERing thru your CHS
 ; Purchase Orders, changing the pointer value for each F80 from
 ; a pointer to 6, to the equivalent pointer to 200.
 ;
 ; When the pointers have been converted, the data dictionary is
 ; mod'd to reflect the change in F80 from file 6 to file 200.
 ;
 ; NOTE:  REFERRAL PHYSICIAN has not been included in any known
 ;        report, and is of minimal value with the distribution of
 ;        the Referred Care Information System.  Therefore,
 ;        minimal protections have been placed in this conversion.
 ;
START ;
 D HELP^XBHELP("HELP","ACHSY200")
 I $P($G(^DD(9002080.01,80,0)),U,2)[200 W *7,!,"According to the data dictionary, the conversion has already completed:",!,^(0),! Q
 ;
 Q:'$$DIR^XBDIR("Y","Do you want to proceed with the File 200 Synch check","Y")
 D EN^AVAPCHK,RESULTS^AVAPCHK
 I '$D(^AVA("OK")) Q
 ;
 I $$DIR^XBDIR("Y","Would you like to Q the File 200 converison to TaskMan","Y") D  Q
 . S ZTRTN="EN^ACHSY200",ZTDESC="CHS File 200 Conversion",ZTIO=""
 . D ^%ZTLOAD
 . I '$D(ZTSK) W *7,!,"Taskman interface failed..."
 . K ZTSK
 .Q
 ;
 I $D(DUOUT)!$D(DTOUT) W !,"You can use the programmer utilities menu to run this converison." Q
 ;
EN ;EP - From TaskMan.
 ;
 N ACHSDIEN,ACHSP6,ACHS0,FAC
 ;
 S FAC=0
 F  S FAC=$O(^ACHSF(FAC)) Q:'FAC  D
 . Q:'$D(^ACHSF(FAC,"D",0))  S ACHSP0=$P(^(0),U,3)
 . W:'$D(ZTQUEUED) !,"Converting ",$P(^DIC(4,FAC,0),U),"..."
 . S ACHSDIEN=$G(^ACHSF(FAC,"F80"),0),DX=$X,DY=$Y
 . F  S ACHSDIEN=$O(^ACHSF(FAC,"D",ACHSDIEN)) Q:'ACHSDIEN  D
 .. I '$D(ZTQUEUED),'(ACHSDIEN#100) X IOXY W ACHSDIEN," of ",ACHSP0
 .. S ACHSP6=$$DOC^ACHS(3,5)
 .. I ACHSP6 S $P(^ACHSF(FAC,"D",ACHSDIEN,3),U,5)=$G(^DIC(16,ACHSP6,"A3"))
 .. S ^ACHSF(FAC,"F80")=ACHSDIEN
 ..Q
 .Q
 ;
 F %=0:0 S %=$O(^ACHSF(%)) Q:'%  K ^ACHSF(%,"F80")
 S $P(^DD(9002080.01,80,0),U,2,3)="P200'^VA(200,"
 I '$D(ZTQUEUED) W !,"CHS Conversion to 200 successfully completed."
 Q
 ;
HELP ;
 ;;CHS File 200 Conversion....
 ;;
 ;;You'll have the chance to Q to TaskMan after the synch check.
 ;;  
 ;;You can use the programmer utilities menu on the CHS main menu
 ;;    to run the File 200 converison, anytime you want.
 ;; 
 ;;
