BIDUPLT ;IHS/CMI/MWR - BI PRINT LETTERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRINT PATIENT LETTERS.
 ;
 ;
 ;----------
PRINTDUE ;EP
 ;---> Print Immunization Due letters.
 ;---> Called by Protocol BI DUE LETTERS PRINT.
 ;---> Variables:
 ;     1 - BIAG   (req) Age Range in months.
 ;     2 - BIPG   (req) 0=Due, >0=Number of months Past Due.
 ;     3 - BICC   (req) Current Community array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIDPRV (req) Designated Provider array.
 ;     6 - BIFDT  (req) Forecast date.
 ;     7 - BIMMD  (req) Immunization Due array.
 ;     8 - BIHCF  (req) Health Care Facility array.
 ;     9 - BILOT  (req) Lot Number array.
 ;    10 - BIORD  (req) Order of listing.
 ;    11 - BIRDT  (opt) Date Range for Received Imms (form BEGDATE:ENDDATE).
 ;    12 - BIBEN  (req) Beneficiary Type array: either BIBEN(1) or BIBEN("ALL").
 ;
 ;---> Check for required Variables.
 I '$D(BIAG) D ERROR(613) Q
 I '$D(BIPG) D ERROR(620) Q
 I '$D(BICC) D ERROR(614) Q
 I '$D(BICM)  D ERROR(615) Q
 I '$D(BIDPRV) D ERROR(680) Q
 I '$G(BIFDT) D ERROR(616) Q
 I '$D(BIMMD) D ERROR(638) Q
 I '$D(BIHCF) D ERROR(625) Q
 I '$D(BILOT) D ERROR(630) Q
 I '$G(BIORD) D ERROR(618) Q
 I '$D(BIBEN) S BIBEN(1)=""
 ;
 S BIPOP=0
 ;
 ;---> Select Form Letter.
 D FULL^VALM1,TITLE^BIUTL5("SELECT FORM LETTER")
 D DEFLET(.BIDFLT,DUZ(2))
 D ASKLET^BILETPR(.BILET,.BIDLOC,.BIPOP,BIDFLT)
 I BIPOP D RESET^BIDU Q
 ;
 ;---> Specify Minimum Interval days since last letter.
 D MINDAYS^BIOUTPT3(.BIMD,.BIPOP)
 I BIPOP D RESET^BIDU Q
 ;
 D DEVICE
 I BIPOP D RESET^BIDU Q
 ;
 ;
 ;---> Retrieve patients for this batch of letters.
 D RETRIEVE(.BIT,.BIERR)
 I $G(BIERR) D ERROR(BIERR),EXIT,RESET^BIDU Q
 ;
 ;---> Print letters for patients retrieved.
 D PRINT^BIDUPLT1(BILET,$G(BIDLOC),ION,BIFDT)
 D ^%ZISC
 D EXIT,RESET^BIDU
 Q
 ;
 ;
 ;----------
RETRIEVE(BIT,BIERR) ;EP
 ;---> Retrieve patients according to parameters set.
 ;---> Parameters:
 ;     1 - BIT   (ret) Total Patients retrieved.
 ;     2 - BIERR (ret) If error, return Error#.
 ;
 ;  vvv83
 D R^BIDUR(BIAG,BIPG,BIFDT,.BICC,.BICM,.BIMMR,.BIMMD,.BILOT,BIMD,BIORD,$G(BIRDT),,.BIT,.BIHCF,.BIDPRV,.BIERR,.BIBEN)
 Q
 ;
 ;
 ;----------
DEVICE ;EP
 ;---> Get Device and possibly queue to Taskman.
 D FULL^VALM1
 K %ZIS,IOP
 S ZTRTN="DEQUEUE^BIDUPLT"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Retrieve patients for this batch of letters.
 D RETRIEVE(.BIT,.BIPOP)
 I BIPOP D EXIT Q
 ;
 ;---> Print letters for patients retrieved.
 D PRINT^BIDUPLT1(BILET,$G(BIDLOC),ION,BIFDT)
 D ^%ZISC
 D EXIT,KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
DEFLET(BILET,BISITE) ;EP
 ;---> Retrieve Immunizations Due Letter from Site Parameter file
 ;---> as the default letter for Immunizations Due.
 ;---> Parameters:
 ;     1 - BILET  (ret) IEN of Imms Due Letter in BI LETTER File.
 ;     2 - BISITE (req) Site under which user is logged in.
 ;
 S BILET=""
 I '$D(^BISITE(BISITE,0)) D ERRCD^BIUTL2(103,,1) Q
 S BILET=$$DEFLET^BIUTL2(BISITE)
 I 'BILET D  Q
 .D TEXT1 W !?22,$$INSTTX^BIUTL6(BISITE)
 .D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 .W !?5,"Returning to Print Due Letters...",!
 I '$D(^BILET(BILET,0)) D ERRCD^BIUTL2(108,,1) S BILET="" Q
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;An Immunizations Due default letter has not been chosen for this
 ;;site.  If you wish to have a default letter appear at this prompt,
 ;;you must use the "Edit Site Parameters" option under the "Manager
 ;;Menu" and select an "IMMUNIZATION DUE LETTER" in the Site Parameters
 ;;for this site:
 D PRINTX("TEXT1",5)
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
ERROR(BIERR) ;EP
 ;---> Report error, reset Listman screen and quit.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 S:'$G(BIERR) BIERR=999
 D ERRCD^BIUTL2(BIERR,,1) D RESET^BIDU Q
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup and Quit.
 K ^TMP("BIDUL",$J)
 Q
