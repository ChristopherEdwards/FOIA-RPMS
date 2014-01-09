ABSPOSJ1 ;IHS/SD/lwj - NCPDP 5.1 pre and post init for V1.0 patch 3 [ 10/31/2002  10:58 AM ]
 ;;1.0;Pharmacy Point of Sale;**3,6,12,14,16,17,24,28,29,31,32,36,37,38,39,42,43,44,45**;Jun 21,2001
 ;
 ; Pre and Post init routine use in absp0100.03k
 ;------------------------------------------------------------------
 ;
 ; Pre and Post init routine to use in absp0100.06k
 ;
 ; Purpose of new subroutines:
 ; These subroutines will be used to kill the ^ABSPF(9002313.91)
 ; and ^ABSP(9002313.91) files. This will be done in preparation of KIDS
 ; restoring the data portion of these files.  (As of January 2003 the
 ; SAC mandates that all global kills and restores be done within Kids.)
 ;
 ;------------------------------------------------------------------
 ;IHS/SD/lwj 6/9/05 patch 12
 ; Added new entry point for patch 12 post init.  Subroutine
 ; will update the ABSP INSURER file so anyone with Pp access can
 ; add to the file.
 ;------------------------------------------------------------------
 ;IHS/SD/lwj 11/7/05 patch 14
 ; Added a subroutine to add ABSP MEDICARE PART D ELIG CHK to the
 ; ABSP MANAGER MENU.
 ;------------------------------------------------------------------
 ;IHS/SD/RLT - 2/22/06 - Patch 16
 ; Added ABSP RPT MEDICARE PART D INS option to
 ; ABSP MENU RPT CLAIM STATUS menu
 ;------------------------------------------------------------------
 ;IHS/SD/RLT - 6/13/06 - Patch 17
 ; Added ABSP RPT MEDICARE PART D INS option to
 ; ABSP MENU RPT CLAIM STATUS menu
 ;------------------------------------------------------------------
 ;IHS/SD/RLT = 02/26/08 - Patch 23
 ; Update old Emdeon IP address 199.244.222.6 to DNS name
 ; emdeonserver.ihs.gov which is pointing to 170.138.220.70
 ;------------------------------------------------------------------
 ;IHS/OIT/SCR = 09/22/08 - Patch 28
 ; look for HELD claims in pre-init routines and print report if they are there
 ; Remove file  ^ABSPHOLD in post-init routine
 ; Remove outdated comments to get routine block size under 1500
 ;  ;------------------------------------------------------------------
 ;IHS/OIT/SCR = 02/06/09 - Patch 29
 ; Created routine ABSPOSJ2.int to isolate patch 28 changes and shorten routine
 Q
PATCH6 ;EP - pre-init for absp0100.p6k
 ; This subroutine is used to perform the preinits needed
 ; for POS V1.0 patch 6.
 D SAVE         ;patch 3 conversion
 D FLDDEF       ;kill ABSPF(9002313.91 for new field definitions
 D FORMAT        ;kill ABPSF(9002313.92 for new/updated formats
 ;D HOLDCHK^ABSPOSJ2  ;IHS/OIT/SCR - 02/09/08 Patch 29 look for and release HELD claims
 Q
FLDDEF ;EP - pre-init for abps0100.p6k    
 ;   Kill of ^ABSPF(9002313.91)  - ABSP NCPDP FIELD DEFS
 ;   This file is killed so that updated field definitions can be loaded
 ;   into the file.
 K ^ABSPF(9002313.91)
 Q
FORMAT ;EP - pre-init for absp0100.p6k
 ;   This file is killed so that updated formats can be loaded into
 ;   the file
 ;K ^ABSPF(9002313.92) ;OIT/PIERAN/RCS Patch 42
 ;
 Q
SAVE ;EP - pre-init for abps0100.p3k
 ; This subroutine will save any existing values found in the
 ; 431, and 433-443 fields into a save global (^ABSPOSXX($J,"ABSPOSJ1")
 ; This global will be used to hold the values while the data
 ; dictionary redefines their storage location, and it will
 ; then be used in the RESTORE subroutine of this program during the
 ; post-init to restore the values to their new home.
 ; ^ABSPOSXX($J,"ABSPOSJ1",ClmIEN,400,MedIEN,400)
 ;   ClmIEN - IEN for the individual claims
 ;   MedIEN - IEN for the medication subfile
 ; first thing - see if the conversion has run before - if so, quit
 Q:$$CKSETUP()
 ;
 N CLMIEN,MEDIEN,REC
 S (CLMIEN,MEDIEN)=0
 F  S CLMIEN=$O(^ABSPC(CLMIEN)) Q:'+CLMIEN  D
 . D SAV320
 . S MEDIEN=0
 . F  S MEDIEN=$O(^ABSPC(CLMIEN,400,MEDIEN)) Q:'+MEDIEN  D
 .. S REC=$G(^ABSPC(CLMIEN,400,MEDIEN,400))
 .. Q:REC=""
 .. D SAVREC
 ;
 Q
 ;
SAV320 ; Save the 320 field, since node 300 also hit its limits 
 N OUTREC,FDA,MSG,VALUE
 S VALUE=$P($G(^ABSPC(CLMIEN,300)),U,20)    ;grab 320
 Q:VALUE=""
 S OUTREC=VALUE_"^"
 S FDA(9002313.02,CLMIEN_",",320)=""
 D FILE^DIE("","FDA","MSG")
 S ^ABSPOSXX("ABSPOSJ1",CLMIEN,320)=OUTREC
 Q
 ;
SAVREC ; Save the record
 N OUTREC,I,FND
 S FND=0     ;set to 1 if a value is found
 S OUTREC="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"   ;start at 31
 S OUTREC=OUTREC_$P(REC,U,31)_"^"    ;1st just field 431
 I $P(REC,U,31)'="" D DELFLD(431)  ;if value - delete it
 F I=33:1:43  D    ;now get 433- 443
 . S OUTREC=OUTREC_"^"_$P(REC,U,I)    ;save it 
 . I $P(REC,U,I)'="" D DELFLD(400+I)  ;delete it
 S:FND ^ABSPOSXX("ABSPOSJ1",CLMIEN,400,MEDIEN,400)=OUTREC
 Q
DELFLD(FLDNUM) ;
 N FDA,MSG
 S FDA(9002313.0201,MEDIEN_","_CLMIEN_",",FLDNUM)=""
 D FILE^DIE("","FDA","MSG")
 S FND=1              ;we found at least 1
 Q
POST45 ; IHS/OIT/RCS 11/28/2012 Patch 45 Add the ICD10 General default date
 D DEF^ABSPOSJ2
 D POST44
 Q
POST44 ; IHS/OIT/RCS 8/31/2012 Patch 44 fix for DIALOUT field
 D DIAL^ABSPOSJ2
 D POST43
 Q
POST43 ; - IHS/OIT/RCS 3/2/2012 patch 43 run fix for errored reversals
 D CLNREV^ABSPOSJ2
 D POST42
 Q
POST42 ; - IHS/OIT/RAN 3/16/2011 patch 42 run conversion that switches over from formats to new Claims methodology
 D EN^ABSPICNV
 D POST39
 Q
POST39 ; - IHS/OIT/SCR 6/28/2010 patch 39 cleanup reject codes in response file
 D CLNREJ^ABSPOSJ2
 D POST38
 Q
POST38 ;EP - IHS/OIT/SCR 03/24/10 patch 38 mark options out of order if site not using IHS 3PB
 ;IHS/OIT/CNI/SCR patch 39 060210 mark options as active if site IS using IHS 3PB..
 N ABSPAR
 S ABSPAR=$G(^ABSP(9002313.99,1,"A/R INTERFACE"))
 I $P(ABSPAR,"^",1)'=3 D
 .D OUT^XPDMENU("ABSP RPT TXN POSTING SUMMARY","OUT OF ORDER: IHS A/R NOT IN USE")
 I $P(ABSPAR,"^",1)=3 D
 .D OUT^XPDMENU("ABSP RPT TXN POSTING SUMMARY","")
 ;
 D POST37
 Q
POST37 ;EP - IHS/OIT/SCR 02/19/10 patch 37 mark options out of order if site not using IHS 3PB
 ;IHS/OIT/CNI/SCR 060210 patch 39 mark options as active if site IS using IHS 3PB..
 N ABSPAR
 S ABSPAR=$G(^ABSP(9002313.99,1,"A/R INTERFACE"))
 I $P(ABSPAR,"^",1)'=3 D
 .D OUT^XPDMENU("ABSP RPT BAR PERIOD SUMMARY","OUT OF ORDER: IHS A/R NOT IN USE")
 .D OUT^XPDMENU("ABSP RPT BARSTATRPT","OUT OF ORDER: IHS A/R NOT IN USE")
 ;
 I $P(ABSPAR,"^",1)=3 D
 .D OUT^XPDMENU("ABSP RPT BAR PERIOD SUMMARY","")
 .D OUT^XPDMENU("ABSP RPT BARSTATRPT","")
 .;D POST36  ;IHS/OIT/CNI/SCR 060210 patch 3WRR WAS REMOVED FROM THE PACKAGE...SKIP THE POSTINIT ROUTINE TO ACTIVATE IT
 .D POST31
 Q
POST36 ;EP - IHS/OIT/SCR 01/12/10 patch 36 mark option in order
 D OUT^XPDMENU("ABSP RPT RECOVERED FROM RJCTN","")
 D MES^XPDUTL("WRR Worked Rejection Report re-activated")
 I $$DELETE^XPDMENU("ABSP MENU RPT CLAIM STATUS","ABSP RPT MEDICARE PART D INS") D MES^XPDUTL("MPD report removed from CLA menu")
 ;E  D MES^XPDUTL("***could not remove MPD report from CLA menu****")
 D POST31
 Q
POST31 ;EP - IHS/OIT/SCR 05/15/09 patch 31 added subroutine
 ; Remove 'garbage strings' from returning message field of ABSP REPORT MASTER
 N ABSP31
 S ABSP31=$$CLNRPT()  ;RETURNS 1 IF NO CHANGS, 2 IF CHANGE
 I ABSP31=2 D MES^XPDUTL("Coded Rejection Messages Found and purged from ABSP REPORT MASTER file")
 D POST28
 Q
 ;IHS/OIT/SCR 09/22/08 Patch 28 - remove release any HELD claims START new code
POST28 ;EP - IHS/OIT/SCR 09/22/08 ; added subroutine
 ; If there are claims that are being held, release them for processing
 N DIU,ABSPHIEN
 S DIU="^DIC(9002313.2,",DIU(0)="" D EN^DIU2
 K DIU
 S ABSPHIEN=0
 ;Shoudln't be any data left, and nodes should already be deleted, but clean up anyway
 F  S ABSPHIEN=$O(^ABSPHOLD(ABSPHIEN)) Q:'+ABSPHIEN  K ^ABSPHOLD(ABSPHIEN)
 K ^ABSPHOLD(0)
 D POST24
 Q
 ;IHS/OIT/SCR 09/22/08 Patch 28-remove release any HELD claims END new code
POST24 ;EP - 02/28/08 - Patch 24 - RLT
 ; Update old Emdeon IP address 199.244.222.6 to DNS name
 ; emdeonserver.ihs.gov which is pointing to 170.138.220.70
 N DIALIEN,NEWIP,IP
 S DIALIEN=$O(^ABSP(9002313.55,"B","ENVOY DIRECT VIA T1 LINE",0))
 I 'DIALIEN D
 . D MES^XPDUTL("ENVOY DIRECT VIA TO LINE NOT FOUND, NOT updated")
 . D MES^XPDUTL("from 199.244.222.6 to emdeonserver.ihs.gov")
 I DIALIEN D
 . S NEWIP="emdeonserver.ihs.gov"
 . S IP=$P($G(^ABSP(9002313.55,DIALIEN,"SERVER")),U)
 . I IP'="199.244.222.6"&(IP'="emdeonserver.ihs.gov") D
 .. D MES^XPDUTL("ENVOY DIRECT VIA TO LINE has NOT been updated")
 .. D MES^XPDUTL("origninal IP is not 199.244.222.6")
 .. D MES^XPDUTL("origninal IP is "_IP)
 . I IP="emdeonserver.ihs.gov" D
 .. D MES^XPDUTL("ENVOY DIRECT VIA TO LINE has all ready")
 .. D MES^XPDUTL("been updated to emdeonserver.ihs.gov")
 . I IP="199.244.222.6" D
 .. D ^XBFMK      ;kill FileMan variables
 .. S DIE="^ABSP(9002313.55,"
 .. S DA=DIALIEN
 .. S DR="2021.01///"_NEWIP
 .. D ^DIE
 .. S IP=$P($G(^ABSP(9002313.55,DIALIEN,"SERVER")),U)
 .. I IP="emdeonserver.ihs.gov" D
 ... D MES^XPDUTL("ENVOY DIRECT VIA TO LINE has been updated")
 ... D MES^XPDUTL("from 199.244.222.6 to emdeonserver.ihs.gov")
 .. I IP'="emdeonserver.ihs.gov" D
 ... D MES^XPDUTL("ENVOY DIRECT VIA TO LINE has NOT been updated")
 ... D MES^XPDUTL("from 199.244.222.6 to emdeonserver.ihs.gov")
 D POST17  ;cumulative patches - let's call the rest
 Q
POST17 ;EP - 6/13/06 Patch 17 RLT
 ;Adding ABSP RPT RX BILLING STATUS option to
 ;ABSP MENU RPT SETUP menu
 N ABSPMENU,ABSPOPT,ABSPSYN,ABSPORD,ABSPX
 S ABSPMENU="ABSP MENU RPT SETUP"
 S ABSPOPT="ABSP RPT RX BILLING STATUS"
 S ABSPSYN="RXB"
 S ABSPORD=25
 S ABSPX=$$ADD^XPDMENU(ABSPMENU,ABSPOPT,ABSPSYN,ABSPORD)
 D:ABSPX'=1 MES^XPDUTL("ABSP RPT MEDICARE PART D INS **NOT** added")
 D POST16  ;cumulative patches - let's call the rest
 Q
POST16 ;EP - 2/22/06 Patch 16 RLT
 ;Adding ABSP RPT MEDICARE PART D INS option to
 ;ABSP MENU RPT CLAIM STATUS menu
 N ABSPMENU,ABSPOPT,ABSPSYN,ABSPORD,ABSPX
 S ABSPMENU="ABSP MENU RPT CLAIM STATUS"
 S ABSPOPT="ABSP RPT MEDICARE PART D INS"
 S ABSPSYN="MPD"
 S ABSPORD=93
 S ABSPX=$$ADD^XPDMENU(ABSPMENU,ABSPOPT,ABSPSYN,ABSPORD)
 D:ABSPX'=1 MES^XPDUTL("ABSP RPT MEDICARE PART D INS **NOT** added")
 D POST14  ;cumulative patches - let's call the rest
 Q
POST14 ;EP - 11/7/05 patch 14 lwj
 ; need to add the menu option for the Medicare Part D
 ; eligibility check to the menu
 D
 . N X,DIC,DLAYGO,Y,DA
 . S DIC(0)="XZ"
 . S DA(1)=$O(^DIC(19,"B","ABSP MENU RPT MAIN",0)) ;main option nbr
 . S X="ABSP MEDICARE PART D ELIG CHK"
 . S DIC="^DIC(19,"_DA(1)_",10,"
 . D ^DIC
 . ;
 . I Y<1 D          ;no menu entry yet - let's add it
 .. S DA=$O(^DIC(19,"B","ABSP MEDICARE PART D ELIG CHK",0)) ;item rec nbr
 .. S DIC("P")=$P(^DD(19,10,0),"^",2) ;get menu sub file nbr
 .. S DIC("DR")="2///ELIG" ;synonym
 .. S X=DA
 .. S DIC(0)="LMZ"
 .. D FILE^DICN
 D POST12  ;cumulative patches - let's call the rest
 Q
POST12 ;EP - 6/9/05 patch 12 lwj
 ; From patch 12 forward we need to make sure the insurer file
 ; can be access for update and addition by anyone with Pp access.
 S ^DIC(9002313.4,0,"WR")="Pp"      ;WRITE access
 S ^DIC(9002313.4,0,"LAYGO")="Pp"   ;LAYGO access
 D POST
 Q
POST ;EP - This will be the entry point for the post init in patch    
 ; 3 of Pharmacy Point of Sale Version 1.0.  It will do two 
 ; things.  First, it will check to see if patch 2 was run 
 ; First, it will call the routine created in Patch 2 that
 ; creates the Cache entry in the ABSP Dial out file.  Secondly,
 ; it will call the "RESTORE" subroutine in this program to
 ; restore the values from the moves done in fields on the 
 ; ABSP claims file in preparation of 5.1.
 ; first thing - see if the conversion has run before - if so, quit
 Q:$$CKSETUP()
 D ^ABSPOSSC       ;create Cache entry in dial out (from Patch 2)
 D RESTORE^ABSPOSJ2
 D UPSETUP         ;log that the conversion is complete
 Q
RST320 ; this will restore the 320 value onto the 320 node, piece 20
 N FDA,MSG,VALUE
 S VALUE=$P($G(^ABSPOSXX(RTN,CLMIEN,320)),U)
 Q:VALUE=""
 S FDA(9002313.02,CLMIEN_",",320)=VALUE
 D FILE^DIE(,"FDA","MSG")
 Q
MOVFLD(FLDNUM,VALUE) ;Adds the field back to it's new location
 N FDA,MSG
 Q:FLDNUM=432    ;don't need to move 432
 S FDA(9002313.0201,MEDIEN_","_CLMIEN_",",FLDNUM)=VALUE
 D FILE^DIE(,"FDA","MSG")
 Q
UPSETUP ; This routine is called after the conversion to the claim file is 
 ; completed.  It will update the "NCPDP51" node of the setup file
 ; with today's date so that future patches will not need to
 ; run the conversion again.
 N DATE,FDA,MSG
 D NOW^%DTC
 S DATE=%
 S FDA(9002313.99,"1,",5151)=DATE
 D FILE^DIE(,"FDA","MSG")
 Q
CKSETUP() ; This routine will check the setup file for the existance of the
 ; NCPDP51 node in the setup file.  If it exists, then the conversion
 ; has already been run, and we will exit the routine.
 N CONV
 S CONV=1           ;1 means the conversion has run
 S:$P($G(^ABSP(9002313.99,1,"NCPDP51")),U)="" CONV=0
 Q CONV
CLNRPT()  ;This routine will remove 'garbage' strings from 
 ; ABSP REPORT MASTER file for RELEASED DATES in past 90 days
 ;
 ;LOOP THROUGH ABSP REPORT MASTER for strings in RETURN MESSAGE that start and end with "&" 
 ;as in &ECL;RC:300;&  OR CONTAIN THE STRING "SPH:mmc3" and replace these strings.
 N ABSPSTRT,ABSPIEN,ABSPDATE,ABSPMSG,MSGTEXT,ABSPRTN
 D NOW^%DTC
 S DATE=%
 S ABSPSTRT=DATE-91
 S ABSPRTN=1 ;ASSSUME RETURN WITH NO REPLACEMENT
 S ABSPDATE=ABSPSTRT
 F  S ABSPDATE=$O(^ABSPECX("RPT","B",ABSPDATE)) Q:'ABSPDATE  D
 .N ABSPIEN S ABSPIEN=0 F  S ABSPIEN=$O(^ABSPECX("RPT","B",ABSPDATE,ABSPIEN)) Q:'ABSPIEN  D
 ..S ABSPMSG=$P($G(^ABSPECX("RPT",ABSPIEN,"M",0)),"^",4)
 ..;IHS/OIT/SCR 061509 patch 32 -added next two lines to strip leading and ending ";"
 ..I ($E(ABSPMSG,1,1)=";") S ABSPMSG=$E(ABSPMSG,2,$L(ABSPMSG))
 ..I ($E(ABSPMSG,$L(ABSPMSG),$L(ABSPMSG))=";") S ABSPMSG=$E(ABSPMSG,1,$L(ABSPMSG)-1)
 ..I ($E(ABSPMSG,1,1)="&")&($E(ABSPMSG,$L(ABSPMSG),$L(ABSPMSG))="&") S MSGTEXT(1)="**Converted Msg" ;IHS/OIT/SCR 05/15/09
 ..I ABSPMSG["SPH:mmc3" S MSGTEXT(1)="**Converted Msg"   ;IHS/OIT/SCR 05/12/09
 ..I $D(MSGTEXT) D
 ...N FDA,MSG
 ...S FDA(9002313.61,ABSPIEN,1300)="MSGTEXT"
 ...D UPDATE^DIE(,"FDA",,"MSG")
 ...S ABSPRTN=2
 ...Q
 ..Q
 .Q
 Q ABSPRTN
