ACRFVLK ;IHS/OIRM/DSD/AEF - VENDOR FILE LOOKUP ; [ 03/28/2007  10:56 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**21,22**;NOV 5, 2001
 ;
 ;    New routine ACR*2.1*20.14
 ;    Copied from AUTTVLK.  Vendor Add/Edit with additional mods
 ;                          mods to accomidate vendor screen changes
 ; Routine heavily modified for UFMS requirements ACR*2.1*22 UFMS
 Q
 ; ********************************************************************
 ;
ADD ; EP - Add or Edit Vendor data.
 D ^XBKVAR
 N ACRVND,ACRVAUTH,ACRDIC
 S ACRQUIT=0                                 ; Initialize quit flags
 S ACRVAUTH=$$EDITAUTH(DUZ)                  ; Get ARMS User Vendor Edit Authority
 F  D  Q:+ACRQUIT
 . D ASKVND                                  ; Add/Lookup Vendor
 . Q:+ACRQUIT                                ; Add/Lookup failed or user opted out
 . I +$P(ACRVND,U,3) D                       ; New vendor, edit all data
 . . S DR="[ACR VENDOR EDIT]"
 . . D SCREEN(ACRVND,DR)
 . I '+$P(ACRVND,U,3) D  Q:+ACRQUIT          ; Existing vendor, checks then edit
 . . D DISP                                  ; display current vendor data
 . . D CHKACTV                               ; Check if vendor active
 . . D DUNSCHK
 . . Q:+ACRQUIT
 . . I ",A,C,F,"'[(","_ACRVAUTH_",") D MSG   ; Check Vendor authority
 . . Q:+ACRQUIT
 . F  D EDIT Q:+ACRQUIT                      ; Edit Vendor Data
 Q
 ; ********************************************************************
 ;
EDITAUTH(X) ; EP; Check user's Vendor Edit Authority in ARMS USER File
 I '+X Q ""
 S Y=$$GET1^DIQ(9002185.3,X,17,"I")
 Q Y
 ; ********************************************************************
 ;
ASKVND ; Ask / Lookup Vendor
 ; Only allow Vendor addition if Vendor Edit Authority is F, C, or A.
 W:$D(IOF) @IOF
 K DD,DO,X,Y,DIC,DA,DR,DINUM,D,DLAYGO
 S DIC="^AUTTVNDR("
 S DIC(0)="AEMQZ"
 S DIC("A")="Edit which Vendor? "
 I ",A,C,F,"[(","_ACRVAUTH_",") D
 . S DIC(0)=DIC(0)_"L"
 . S DIC("A")="Add/Edit which Vendor? "
 . S DLAYGO=9999999.11
 D ^DIC
 I +Y<1 S ACRQUIT=1 Q
 S ACRVND=Y
 S ACRVND(0)=Y(0)
 Q
 ; ********************************************************************
 ;
DISP ;EP - If not new entry, display Current Vendor data.
 S DR="[ACR VENDOR DISPLAY]"
 D SCREEN(ACRVND,DR)
 Q
 ; ********************************************************************
 ;
CHKACTV ; Check to see if Vendor has been inactivated
 S ACRQUIT=0
 S ACRACTV=$$GET1^DIQ(9999999.11,+ACRVND,.05,"E")
 I ACRACTV'="" D               ; Inactive Vendor
 . S ACRQUIT=1
 . S DR="[ACR VENDOR DISPLAY-INACTIVE]"
 . D SCREEN(ACRVND,DR)
 Q
 ; ********************************************************************
 ;
MSG ;EP - Message edit authority denied
 S ACRQUIT=1
 S DR="[ACR VENDOR DISPLAY-AUTHORITY]"
 D SCREEN(ACRVND,DR)
 Q
 ; ********************************************************************
 ;
EDIT ; Edit which vendor data
 K DA,X,Y,DR,DIR
 D ^XBFMK
 S DIR(0)="SO^1:ALL Vendor Data;"
 S DIR(0)=DIR(0)_"2:Mailing Address;"
 S DIR(0)=DIR(0)_"3:Billing Address;"
 S DIR(0)=DIR(0)_"4:Remit To Address;"
 S DIR(0)=DIR(0)_"5:1099 Payment Data;"
 S DIR(0)=DIR(0)_"6:ARMS/CIS;"
 S DIR(0)=DIR(0)_"7:SMALL PURCHASE INFORMATION Data"
 S DIR("A")="Edit which data"
 S DIR("?")="Enter the code from the list to indicate the type of data you want to edit."
 W !
 D ^DIR
 I (Y<1!(Y>7)) S ACRQUIT=1 Q
 I ",F,A,"'[(","_ACRVAUTH_",")&(Y=5) D  Q    ; A or F auth req for Pay data
 . S DR="[ACR VENDOR DISPLAY-AUTHORITY]"
 . D SCREEN(ACRVND,DR)
 I ",C,A,"'[(","_ACRVAUTH_",")&((Y=6)!(Y=7)) D  Q    ; A or C auth req for CIS/SP data
 . S DR="[ACR VENDOR DISPLAY-AUTHORITY]"
 . D SCREEN(ACRVND,DR)
 S:Y DR="]"
 S:Y=2 DR="-MAIL]"
 S:Y=3 DR="-BILL]"
 S:Y=4 DR="-REMIT]"
 S:Y=5 DR="-PAY]"
 S:Y=6 DR="-CIS]"
 S:Y=7 DR="-SPIS]"
 S DR="[ACR VENDOR EDIT"_DR
 D SCREEN(ACRVND,DR)
 Q
 ; ********************************************************************
 ;
SCREEN(ACRVND,DR) ; EP; call screen man
 ; pass in DR
 ; pass in ACRVND
 W:$D(IOF) @IOF
 K DDSFILE,DA,X,Y
 S DA=+ACRVND
 S DDSFILE="^AUTTVNDR("
 D ^DDS
 K DDSFILE,DA,DR,X,Y
 W:$D(IOF) @IOF
 Q
 ; ********************************************************************
 ;
DUNS(X) ; EP;----- RETURNS DUNN AND BRADSTREET NUMBER
 ;
 ;      X  = VENDOR IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,0)),U,7)                ;FREE TEXT
 Q Y
 ; ********************************************************************
 ;
CHKVNDR ; EP - Check if vendor is inactive, DUNS exists, and DUNS is 9-13 long
 K ACRACTV,ACRVNDR,ACRDUNS,ACRINACT,ACRNODUN,ACRSIZE,ACRVERR
 K ACRDERR
 S ACRVNAME=$$GET1^DIQ(9999999.11,+ACRVND,.01,"E")
 D ACT
 D DUNSCHK
 D:ACRWARN'="WARN" @ACRWARN            ;ACR*2.1*22.04 IM22759
 K ACRACTV,ACRVNDR,ACRDUNS
 Q
 ; ********************************************************************
 ;
ACT ; EP - Check to see if Vendor has been inactivated
 S ACRVNAME=$$GET1^DIQ(9999999.11,+ACRVND,.01,"E")
 S ACRACTV=$$GET1^DIQ(9999999.11,+ACRVND,.05,"E")
 I ACRACTV'="" D  ;INACTIVE VENDOR
 .W *7
 .S ACRVERR=ACRVNAME_" is INACTIVE"
 .D:$D(DDSREFT) HLP^DDSUTL(ACRVERR)
 Q
 ; ********************************************************************
 ;
DUNSCHK ; EP - Check to see if there is a DUNS #
 S ACRWARN="WARN2"
 S:$D(DDSREFT) ACRWARN="WARN"   ;IF CALLED FROM SCREENMAN DO OTHER WARNING
 K ACRDERR
 S ACRDUNS=$$DUNS^ACRFVLK(+ACRVND)
 S ACRVNAME=$$GET1^DIQ(9999999.11,+ACRVND,.01,"E")
 I ACRDUNS="" D                        ;NO DUNS
 .W *7
 .S ACRDERR=ACRVNAME_" MUST have a DUNS number entered"
 .D:$D(DDSREFT) HLP^DDSUTL(ACRDERR)
 ;Check to see if the DUNS # is 9 - 13 chars long
 I ACRDUNS'="" D
 .I $L(ACRDUNS)<9!($L(ACRDUNS)>13)!(ACRDUNS[11111)!(ACRDUNS[99999) D  ;DUNS WRONG LENGTH
 ..W *7
 ..S ACRDERR=ACRVNAME_" MUST have a 9-13 digit DUNS number entered and cannot be all one number"
 ..D:$D(DDSREFT) HLP^DDSUTL(ACRDERR)
 Q
 ;
WARN ;EP; IN SM WARNING THAT VENDOR IS INACTIVE, DUNS IS MISSING OR BAD
 I $D(ACRDERR)!($D(ACRVERR)) D
 .W !!,$G(ACRDERR)
 .W:$G(ACRDERR)]"" ! W $G(ACRVERR)
 .S (ACRQUIT,ACROUT)=1
 Q
 ;
WARN2 ;EP; WARNING THAT VENDOR IS INACTIVE, DUNS IS MISSING OR BAD
 I $D(ACRDERR)!($D(ACRVERR)) D
 .D WARNING^ACRFWARN
 .W !!,$G(ACRDERR)
 .W:$G(ACRDERR)]"" ! W $G(ACRVERR)
 .W !!,"A Purchase Order or Request for Credit Card cannot be sent"
 .W !,"for approval until the reported problem has been resolved"
 .D PAUSE^ACRFWARN
 .S (ACRQUIT,ACROUT)=1
 Q
AI ;EP - INVOKE SCREEN TO ALLOW ACTIVATION/INACTIVATION OF VENDOR
 S ACRVAUTH=$$EDITAUTH(DUZ)
 D ASKVND
 Q:$D(ACRQUIT)
 I ",A,C,F,"'[(","_ACRVAUTH_",") D MSG Q
 S DR="[ACR VENDOR EDIT-ACT/INACT]"
 D SCREEN(ACRVND,DR)
 Q
EINCHK ;CHECK FOR VENDORS WITH THE SAME EIN NO  ACR*2.1*21.03  IM22241
 S (ACRVEIN,ACRVIEN,ACRVDUP)=""
 F  S ACRVEIN=$O(^AUTTVNDR("E",ACRVEIN)) Q:'ACRVEIN  D
 .Q:$E(ACRVEIN,1,10)'=X
 .F  S ACRVIEN=$O(^AUTTVNDR("E",ACRVEIN,ACRVIEN)) Q:'ACRVIEN  D
 .. S ACRVDUP=$$GET1^DIQ(9999999.11,ACRVIEN,.01)_"  "_$$GET1^DIQ(9999999.11,ACRVIEN,1101)
 ..W *7
 ..D HLP^DDSUTL(ACRVDUP_"    ALREADY EXISTS")
 ..D HLP^DDSUTL("Make sure this is the correct EIN number and change if necessary")
 ..D HLP^DDSUTL("$$EOP")
 ..S DDSBR=6
 K ACRVEIN,ACRVDUP
 Q
SUFCHK ;CHECK EIN SUFFIX  ACR*2.1*21.03  IM22241
 K ACRSUFF
 I '$D(ACREINNW) S ACREIN=$E($$GET1^DIQ(9999999.11,DA,1101))
 I $D(ACREINNW) S ACREIN=$E(ACREINNW)
 ;I ACREIN=1,X=""!($L(X)'=2)!(X'?2UN) D  ;BAD SUFFIX  ;ACR*2.1*22.11l
 I X=""!($L(X)'=2)!(X'?2UN) D  ;BAD SUFFIX  ;ACR*2.1*22.11l
 .S ACRSUFF=""
 .W *7
 .;D HLP^DDSUTL("Organizations MUST HAVE a SUFFIX, SUFFIX MUST BE 2 characters long, and SUFFIX MUST BE a combination of uppercase letters and numbers") ;ACR*2.1*22.11l
 .D HLP^DDSUTL("ALL VENDORS MUST HAVE a SUFFIX, MUST BE 2 characters long, and MUST BE a combination of uppercase letters and numbers")  ;ACR*2.1*22.11l
 .D HLP^DDSUTL("$$EOP")
 Q:X=""
 S (ACRVIEN,ACRVEIN,ACRVDUP)=""
 I '$D(ACREINNW) S ACRVEIN=$$GET1^DIQ(9999999.11,DA,1101)_X
 I $D(ACREINNW) S ACRVEIN=ACREINNW_X
 F  S ACRVIEN=$O(^AUTTVNDR("E",ACRVEIN,ACRVIEN)) Q:'ACRVIEN  D
 .Q:ACRVIEN=DA                         ;ACR*2.1*22.11h IM22761
 .S ACRVDUP=$$GET1^DIQ(9999999.11,ACRVIEN,.01)_"  "_$$GET1^DIQ(9999999.11,ACRVIEN,1102.01)
 .W *7
 .D HLP^DDSUTL(ACRVDUP_"    Already Exists")
 .D HLP^DDSUTL("You CANNOT have vendors with the same EIN NUMBER and SUFFIX")
 .D HLP^DDSUTL("Correct the EIN NUMBER or SUFFIX accordingly")
 .D HLP^DDSUTL("$$EOP")
 .S DDSBR=6
 K ACRVIEN,ACRVEIN,ACRVDUP
 Q
