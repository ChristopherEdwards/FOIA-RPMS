ACRFRRP2 ;IHS/OIRM/DSD/AEF - DISPLAY RECEIVING REPORT REMARKS [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
 ;
 ;This routine displays the receiving report remarks when
 ;printing receiving reports.
 ;
REM(ACRDOCDA,ACRRRDA)        ;EP
 ;----- DISPLAY RECEIVING REPORT REMARKS
 ;
 ;If the Receiving Report Remarks field #170 in the FMS Document
 ;file contains data, then this data will be displayed.  This is
 ;the old remarks field.  If the Receiving Report Remarks field
 ;in the FMS Receiving Report file contains data, then this data
 ;will be displayed.  This is the new remarks field.  Both fields
 ;are evaluated in case old receiving reports that were created
 ;before the new field was placed in the FMS Receiving Reports
 ;file need to be printed.  Called by print template [ACR
 ;RECEIVING REPORT]
 ;
 ;      INPUT:
 ;      ACRDOCDA = DOCUMENT NUMBER IEN FROM FMS DOCUMENT FILE
 ;      ACRRRDA  = RECEIVING REPORT IEN FROM FMS RECEIVING REPORT
 ;                 FILE
 ;
 I '$D(^ACRRR(+ACRRRDA,13)) D  Q
 . I $D(^ACRDOC(+ACRDOCDA,17)) D DOC(+ACRDOCDA)
 I $D(^ACRRR(+ACRRRDA,13)) D RR(+ACRRRDA)
 Q
DOC(D0) ;----- PRINT REMARKS FROM FMS DOCUMENT FILE    
 ;
 N D1,DIWL,DIWR,X
 S D1=0
 F  S D1=$O(^ACRDOC(D0,17,D1)) Q:'D1  D
 . S X=^ACRDOC(D0,17,D1,0)
 . S DIWL=10
 . S DIWR=75
 . D ^DIWP
 D ^DIWW
 Q
RR(D0) ;----- PRINT REMARKS FROM FMS RECEIVING REPORT FILE
 ;
 N D1,DIWL,DIWR,X
 S D1=0
 F  S D1=$O(^ACRRR(D0,13,D1)) Q:'D1  D
 . S X=^ACRRR(D0,13,D1,0)
 . S DIWL=10
 . S DIWR=75
 . D ^DIWP
 D ^DIWW
 Q
