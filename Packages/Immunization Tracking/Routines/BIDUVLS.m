BIDUVLS ;IHS/CMI/MWR - VIEW DUE LIST.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW LIST OF PATIENTS (DUE LIST OR MASTER LIST).
 ;;  CALLED BY PROTOCOL: BI DUE LIST OF PATIENTS ("List of Patients")`
 ;
 ;
 ;----------
VIEWDUE ;EP
 ;---> View Immunization Due list.
 ;---> Called by Protocol BI DUE LIST OF PATIENTS.
 ;---> Variables:
 ;     1 - BIAG   (req) Age Range in months.
 ;     2 - BIPG   (req) Patient Group Data; see PGRPOUP1^BIOUTPT4 for details.
 ;     3 - BIFDT  (req) Forecast date.
 ;     4 - BICC   (req) Current Community array.
 ;     5 - BICM   (req) Case Manager array.
 ;     6 - BIDPRV (req) Designated Provider array.
 ;     7 - BIMMR  (req) Immunizations Received array.
 ;     8 - BIMMD  (req) Immunizations Due array.
 ;     9 - BIHCF  (req) Health Care Facility array.
 ;    10 - BILOT  (req) Lot Number array.
 ;    11 - BIORD  (req) Order of listing.
 ;    12 - BINFO  (opt) Array of Additional Information elements (may be null).
 ;    13 - BIRDT  (opt) Date Range for Received Imms (form BEGDATE:ENDDATE).
 ;    14 - BIDED  (opt) Include Deceased Patients (0=no, 1=yes).
 ;    15 - BIMMRF (opt) Imms Received Filter array (subscript=CVX's included).
 ;    16 - BIBEN  (req) Beneficiary Type array: either BIBEN(1) or BIBEN("ALL").
 ;
 ;---> Check for required Variables.
 I '$D(BIAG) D ERROR(613) Q
 I '$D(BIPG) D ERROR(620) Q
 I '$G(BIFDT) D ERROR(616) Q
 I '$D(BICC) D ERROR(614) Q
 I '$D(BICM) D ERROR(615) Q
 I '$D(BIDPRV) D ERROR(680) Q
 I '$D(BIMMR) D ERROR(652) Q
 I '$D(BIMMD) D ERROR(638) Q
 I '$D(BIHCF) D ERROR(625) Q
 I '$D(BILOT) D ERROR(630) Q
 I '$G(BIORD) D ERROR(618) Q
 ;I '$D(BINFO) D ERROR(629) Q  ;Additional Info not required (may be null).
 ;  ;BIMMRF not required (may be null).
 ;
 I '$D(BIRDT) S BIRDT=""
 I '$D(BIDED) S BIDED=0
 I '$D(BIBEN) S BIBEN(1)=""
 ;
 D FULL^VALM1 N BIERR
 D TITLE^BIUTL5("PRINT OR VIEW LIST"),TEXT1
 N DIR
 S DIR("A")="     Select Print or View: ",DIR("B")="View"
 S DIR(0)="SAM^p:Print;v:View;q:Quit"
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) D RESET^BIDU Q
 ;
 ;---> User chose to Quit.
 I Y="q" D RESET^BIDU Q
 ;
VIEW ;---> User chose to VIEW Due List.
 I Y="v" D  Q
 .W !!?10,"This may take some time.  Please hold on...",!
 .;
 .;---> Retrieve patients for this listing.
 .;---> (Patient's forecast gets updated at CHKSET+60^BIDUR.)
 .;---> Since this is List (not Letter), send 0 days since last letter
 .;---> as 10th parameter.  BIT=Total Patients retrieved.
 .;
 .;D NOW1^BIUTL3
 .D RETRIEVE(.BIT,.BIERR)
 .I $G(BIERR) D ERROR(BIERR),EXIT,RESET^BIDU Q
 .;D NOW2^BIUTL3
 .;
 .;---> Display list of patients retrieved.
 .K ^TMP("BIDULV",$J)
 .D START^BIDUVLS1(BIFDT,.BINFO,BIPG,BIAG,BIT,,,,,.BIBEN)
 .D EXIT,RESET^BIDU
 ;
 ;
PRINT ;EP
 ;---> User chose to PRINT Due List.
 N BIPOP
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET^BIDU Q
 ;
 D:$G(IO)'=$G(IO(0))
 .W !!?10,"This may take some time.  Please hold on...",!
 ;
 ;---> Retrieve patients for this listing.
 D RETRIEVE(.BIT,.BIERR)
 I $G(BIERR) D ERROR(BIERR),EXIT,RESET^BIDU Q
 ;
 ;---> Print list of patients retrieved.
 ;---> Cannot pass params to INIT, but should have BIFDTDT,
 ;---> BINFO, and BIT defined.
 K ^TMP("BIDULV",$J)
 N VALM,VALMHDR
 D HDR^BIDUVLS1,INIT^BIDUVLS1
 D PRTLST^BIUTL8("BIDULV")
 D EXIT,RESET^BIDU
 Q
 ;
 ;
 ;----------
RETRIEVE(BIT,BIERR) ;EP
 ;---> Retrieve patients according to parameters set.
 ;---> Parameters:
 ;     1 - BIT   (ret) Total Patients retrieved.
 ;     2 - BIERR (ret) Error Code.
 ;
 D R^BIDUR(BIAG,BIPG,BIFDT,.BICC,.BICM,.BIMMR,.BIMMD,.BILOT,0,BIORD,BIRDT,BIDED,.BIT,.BIHCF,.BIDPRV,.BIERR,.BIBEN)
 Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 S ZTRTN="DEQUEUE^BIDUVLS"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print list of patients retrieved.
 ;
 D RETRIEVE(.BIT,.BIERR)
 I $G(BIERR) D EXIT Q
 K VALMHDR,^TMP("BIDULV",$J)
 D HDR^BIDUVLS1,INIT^BIDUVLS1
 D PRTLST^BIUTL8("BIDULV")
 D EXIT
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
TEXT1 ;
 ;;You may either PRINT the List or VIEW it on this screen.
 ;;
 ;;PRINT: If it customarily takes a long time for your computer
 ;;to produce a List of Patients, it may be more efficient for you
 ;;to QUEUE it to a printer.  That way you can be free to do other
 ;;things until the printout is finished.
 ;;
 ;;VIEW:  You will have to wait while the computer retrieves the
 ;;information.  However, once the List of Patients comes up on
 ;;the screen, you will be able to browse the list on screen by
 ;;scrolling up and down using the arrow keys.
 ;;
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
EXIT ;EP
 ;---> Cleanup and Quit.
 K ^TMP("BIDULV",$J)
 Q
 ;
 ;
 ;----------
EDITPAT ;EP
 ;---> Edit Patient from List.
 S:'$G(BIORD) BIORD=1
 D FULL^VALM1
 D
 .N BIAG,BIBEN,BICC,BICM,BICPT,BIDPRV,BIFDT,BIHCF,BILOT,BIMD
 .N BIMMD,BIMMR,BINFO,BIORD,BIPG,BIQDT,BIRPDT,BIT
 .D ONEPAT^BIPATVW
 ;
 S VALMBCK="R"
 Q
