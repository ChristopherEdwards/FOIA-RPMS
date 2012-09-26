AMEREDDX ; IHS/OIT/SCR - Sub-routine for ER VISIT EDIT of DX information
 ;;3.0;ER VISIT SYSTEM;**2,3**;DEC 07, 2011;Build 11
 ;
 ; VARIABLES: The following variables are passed to multiple editing routines
 ;  AMERDA  : the IEN of the ER VISIT that is selected for editing
 ;  AMERAIEN: The IEN of the ER AUDIT that is created when user begins editing a record
 ;  AMEREDNO: An integer representing the number of multiple fields that have been edited
 ;            for uniqueness in multiple field number in audit file
 ; Edit Auditing VARIABLES newed and used throughout edit routines:
 ;      AMEROLD : original value of edited field
 ;      AMERNEW : new value of edited field
 ;      AMERSTRG : A ";" deliminated string of edit information for a field
 ;      
EDDIAGS(AMERDA,AMEREDNO,AMERAIEN) ; EP from AMEREDIT 
 ;
 I '$D(^XUSEC("AMERZ9999",DUZ)) D EN^DDIOL("You are not authorized to use this option","","!!") Q 1  ;PROGRAMATICALLY LOCKING this option to holders of the coding key
 ; AMERDXNO - counter that identifies a multiple DX entry for subsequent matching
 ; AMERPDX - the ICD9 code that has been identified as the primary DX:
 ; AMERNAR - a string containing the narrative that has been identified by user
 ; AMERDX  - a pointer to the ICD9 file that has been selected by user
 N AMERDXNO,Y,AMERPDX,AMERPNAR,AMERNAR,AMERDX,DIC,AMERDONE,AMERQUIT,AMERPRIM,AMERSEL,AMERCODE
 S (AMERQUIT,AMERDXNO)=0
 S (Y,AMERPDX,AMERNAR,AMERDX,AMERDONE)=""
 D EN^DDIOL("","","!")
 I $P($G(^AMERVSIT(AMERDA,5.1)),U,2)="" S AMERPDX=""
 I $P($G(^AMERVSIT(AMERDA,5.1)),U,3)="" S AMERPNAR=""
 ;IHS/OIT/SCR 11/20/08 modify function that screens valid codes to allow 'LOCAL CODES'
 ;I $P($G(^AMERVSIT(AMERDA,5.1)),U,2)'="" S AMERPDX=$P($$ICDDX^ICDCODE($P($G(^AMERVSIT(AMERDA,5.1)),U,2),0),U,2)
 I $P($G(^AMERVSIT(AMERDA,5.1)),U,2)'="" S AMERPDX=$P($$ICDDX^ICDCODE($P($G(^AMERVSIT(AMERDA,5.1)),U,2),,,1),U,2)
 I $P($G(^AMERVSIT(AMERDA,5.1)),U,3)'="" S AMERPNAR=$P(^AMERVSIT(AMERDA,5.1),U,3)
 F  Q:AMERDONE="^"  D
 .D ^XBCLS
 .;IHS/OIT/SCR 11/03/08 allow selection of ICD9 code by number START CHANGES
 .;D DSPLYDX(AMERPDX,AMERPNAR)
 .S AMERSEL=$$SELECTDX(AMERPDX,AMERPNAR)
 .I AMERSEL=-1 S AMERDONE="^" Q
 .I (AMERSEL>0) S AMERCODE=$P($$ICDDX^ICDCODE($G(^AMERVSIT(AMERDA,5,AMERSEL,0)),,,1),U,2)
 .S DIC("A")=""
 .S DIC("B")=""
 .D EN^DDIOL("","","!")
 .I (AMERSEL'=0) D
 ..S DIC("B")=AMERCODE
 ..S DIC("A")="MODIFY INFORMATION FOR ICD9 CODE: "
 ..S DIC(0)="ME",X=AMERCODE ;
 .E  S DIC("A")="ENTER ICD9 CODE TO ADD: ",DIC(0)="AMEQ"
 .S DIC="^ICD9(",Y="" ; 
 .;Screen ICD9 codes so that only those that will create a V POV entry can be selected
 .; this screen comes from the .01 field of the V POV file
 .S DIC("S")="D ^AUPNSICD"
 .D ^DIC
 .I $D(DUOUT)!$D(DTOUT) S AMERDONE="^" Q
 .S AMERDX=Y
 .I AMERDX>0 D
 ..;S AMEREDNO=AMEREDNO+1  ; Tracking the edit number for "field" uniqueness in ^AMERAUDT
 ..S AMERPRIM=$$PROCESDX(AMERSEL,AMERDX,AMERPDX,AMERPNAR)
 ..I AMERPRIM'="" S AMERPDX=$P(AMERPRIM,U,1),AMERPNAR=$P(AMERPRIM,U,2)
 ..D EN^DDIOL("   ","","!!")
 ..Q
 .E  I AMERDX=-1 S AMERDONE="^"
 K AMERDXNO,Y,AMERNAR,AMERDX,DIC,AMERDONE
 ;I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0  ;IHS/OIT/SCR 01/06/09
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT
 I AMERQUIT=1 Q 0
 Q 1
 ;
PRIMDIAG(AMERDA,AMERDX,AMERNNAR,AMERAIEN,AMERPRIS,AMEROLDS) ;
 ; UPDATES PRIMARY DIAGNOSIS FIELDS IF THE ORIGINAL INFORMATION MATCHES PRIMARY DX INFORMATION
 ; AND ALLOWS USER TO REPLACE PRIMARY DX FIELDS WITH NEW ONE'S IF ORIGINAL INFORMATION IS DIFFERENT
 ;
 ; INPUT:
 ; AMERDA - THE IEN OF THE ER VISIT
 ; AMERDX - THE DX CODE THAT IS BEING ENTERED
 ; AMERNAR - THE DX NARRATIVE THAT IS BEING ENTERED
 ; AMERAIEN - THE IEN OF THE ER AUDIT FILE
 ; AMERPRIS - A "^" DELIMITED STRING CONTAINING: NEW PRIMARY ICD9^CURRENT PRIMARY NARRATIVE
 ; AMEROLDS - A "^" DELIMITED STRING CONTAINING:  ORIGINAL ICD9^ORIGINAL NARRATIVE
 ; RETURNS: A "^" DELEMITED STRING CONTAINING UPDATED PRIMARY ICD9^UPDATED PRIMARY NARRATIVE
 N AMERSTRG,AMEREDTS,DR,AMERODX,AMERONAR,DIR,AMEROLD,AMERNEW,Y,AMERPNAR,AMERPDX,AMERTEMP
 S Y=0
 S AMERPDX=$P(AMERPRIS,U,1),AMERPNAR=$P(AMERPRIS,U,2)
 S (AMERSTRG,AMEREDTS,DR,AMEROLD)=""
 S AMERONAR=$P($G(^AMERVSIT(AMERDA,5.1)),U,3)
 S AMERODX=$P($G(^AMERVSIT(AMERDA,5.1)),U,2)
 I AMERODX="" S Y=1  ; IF THERE IS NO PRIMARY DX ENTERED, make this primary
 I AMERODX'="" D
 .S AMERTEMP=$P($$ICDDX^ICDCODE(AMERODX,,,1),U,2)
 .I ($G(AMERPDX)=AMERTEMP)&(AMERPNAR=$P(AMEROLDS,U,2)) S Y=1
 .Q
 ; IF the original primary ICD9 code is what the old pointer points to AND the original narrative is the primary narrative
 ; JUST UPDATE PRIMARY FIELDS, DON'T ASK
 I Y=0 D
 .S DIR("B")="NO"
 .S DIR(0)="Y",DIR("A")="Is this the Primary DX"
 .D ^DIR
 .Q
 I $G(Y)>0 D
 .I AMERODX'=AMERDX D
 ..;IHS/OIT/SCR 11/20/09 MODIFYING FUNCTION THAT SCREENS VALID CODES TO ALLOW 'LOCAL'
 ..;S:AMERODX'="" AMEROLD=$P($$ICDDX^ICDCODE(AMERODX),U,2)
 ..S:AMERODX'="" AMEROLD=$P($$ICDDX^ICDCODE(AMERODX,,,1),U,2)
 ..S AMERNEW=$P($$ICDDX^ICDCODE(AMERDX,,,1),U,2)
 ..S AMERPDX=AMERNEW
 ..D NOW^%DTC  ; FM datetime returned in X
 ..S AMERSTRG="5.2."_AMEREDNO_";"_X_";"_$$EDDISPL^AMEREDAU(AMEROLD,"X")_";"_$$EDDISPL^AMEREDAU(AMERNEW,"X")_";"_"Administrative;PRIMARY DIAGNOSIS;Silent audit trail"
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..S DR=$S(DR'="":DR_";",1:""),DR=DR_"5.2////"_AMERDX  ; UPDATE POINTER
 ..Q
 .Q:AMERSTRG="^"
 .I AMERONAR'=AMERNNAR D
 ..S AMERPNAR=AMERNNAR
 ..D NOW^%DTC  ; FM date time returned in X
 ..S AMERSTRG="5.3."_AMEREDNO_";"_X_";"_AMERONAR_";"_AMERPNAR_";Administrative;PRIMARY DX NARRATIVE;Silent Audit Trail"
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..S DR=$S(DR'="":DR_";",1:""),DR=DR_"5.3////"_AMERNNAR  ; Update narrative
 ..Q
 .Q
 D:DR'="" DIE^AMEREDIT(AMERDA,DR)
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 K AMERSTRG,AMEREDTS,DR,AMERODX,AMERONAR,DIR
 Q AMERPDX_"^"_AMERPNAR
 ;
DELDIAG(AMERIEN,AMERSUB) ;
 ; Delete diagnosis record
 N DIR,DIK,AMERFLAG
 S (AMERSTRG,AMEREDTS)=""
 S DIR(0)="Y",DIR("A")="Do you want to delete this DX completely",DIR("B")="NO"
 D ^DIR K DIR
 S AMERFLAG=0
 I $G(Y)>0 D
 .S DA(1)=AMERIEN,DA=AMERSUB
 .; First, delete the V POV entry to insure that it is synch'd with the ER VISIT file ; IHS/OIT/GIS 11/30/11
 .D DELVPOV^AMEREDDY(AMERIEN,AMERSUB)
 .;IHS/OIT/SCR 02/03/09 LET'S GET THIS DELETE RIGHT
 .S DIK="^AMERVSIT("_DA(1)_",5,"
 .D ^DIK,EN^DIK  ; Delete identified entry and re-index diagnosis field
 .S AMERFLAG=1
 .Q
 K DIR,DIK
 Q AMERFLAG
 ;
PROCESDX(AMERDXNO,AMERDIAG,AMERPDX,AMERPNAR) ;
 ;
 ; INPUT: AMERDXNO - The number of the diagnosis record that was selected for editing - 0 IF NEW
 ;        AMERDIAG - Pointer to the ICD9 code that was selected
 ;        AMERPDX - current primary DX ICD9 code for this visit
 ;        AMERPNAR - current primary DX narrative
 ;
 ; RETURNS: AMERPRIM  - a "^" delimited string that contains the primary DX code and narrative
 ;
 ; First look to see if that DX has already been entered
 ; if it has, we give the user a chance to delete it (if it isn't primary) or edit the narrative
 N AMEREDTS,AMERSTRG,DR,AMERBAD,AMERPRIS,AMEROLDS
 N AMERODX,AMERNDX,AMERONAR,AMERNNAR,AMERSKIP,AMERICD9,AMERGONE,AMERQUIT
 N AMERGOOD  ;IHS/OIT/SCR 092909 patch 2
 ;S AMERDIAG=$G(^AMERVSIT(AMERDA,5,AMERSEL,0))
 S (AMERNDX,AMERODX,AMERONAR,AMERNNAR,AMEREDTS,AMERSTRG,DR,AMERODX)=""
 ;S (AMERDXNO,AMERSKIP)=0,AMERDX=$P(AMERDIAG,U,1),AMERICD9=$P(AMERDIAG,U,2)
 S AMERSKIP=0,AMERDX=$P(AMERDIAG,U,1),AMERICD9=$P(AMERDIAG,U,2)
 S AMERQUIT=0
 S AMERPRIS=AMERPDX_"^"_AMERPNAR ; Primary DX code and Narrative might change but must be returned
 ;F  S AMERDXNO=$O(^AMERVSIT(AMERDA,5,AMERDXNO)) Q:AMERDXNO="B"!(AMERDXNO="")  I ^AMERVSIT(AMERDA,5,AMERDXNO,0)=AMERDX D
 I AMERDXNO>0 D
 .S AMERSKIP=1,AMERBAD=0,AMERGONE=0  ; Flags
 .S AMERODX=AMERICD9  ; Keep diagnosis for audit trail
 .D EN^DDIOL("Narrative: "_$G(^AMERVSIT(AMERDA,5,AMERDXNO,1)),"","!!")
 .S AMERONAR=$G(^AMERVSIT(AMERDA,5,AMERDXNO,1))   ; Keep narrative for default
 .S AMEROLDS=AMERODX_"^"_AMERONAR   ; Pass the old values for comparison with old primary values
 .I AMERPDX=AMERICD9&(AMERPNAR=AMERONAR) D EN^DDIOL("**This is currently the Primary DX**","","!")
 .D EN^DDIOL("","","!!")
 .I '(AMERPDX=AMERICD9&(AMERPNAR=AMERONAR)) D
 ..I $$DELDIAG(AMERDA,AMERDXNO)=1 D   ; DIAG record has been deleted
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("5-01"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMERODX,"X"),"","DIAGNOSIS")
 ...I AMERSTRG="^" Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S AMERGONE=1
 ...Q
 ..I $D(DUOUT)!$D(DTOUT) S AMERQUIT=1
 ..Q
 .Q:AMERQUIT  ; Quit if user "^" when asked if wants to delete
 .I 'AMERGONE D    ; DX record NOT DELETED,can change code AND narrative
 ..S DIR(0)="Y",DIR("A")="Do you want to change DX code",DIR("B")="YES"
 ..D ^DIR K DIR
 ..I $D(DUOUT)!$D(DTOUT) S AMERQUIT=1 Q
 ..I $G(Y)=0 S AMERNDX=AMERODX
 ..I $G(Y)=1 D
 ...;IHS/OIT/SCR 10/20/08
 ...S DIC="^ICD9(",DIC(0)="AMEQ",Y="",DIC("S")="D ^AUPNSICD"
 ...S DIC("A")="Enter NEW ICD Code: "
 ...D ^DIC K DIC
 ...I $D(DUOUT)!$D(DTOUT) S AMERDONE="^",AMERQUIT=1 Q
 ...I Y<1 S AMERBAD=1 Q
 ...S AMERDX=$P(Y,U,1),AMERNDX=$P(Y,U,2)
 ...I ((AMERNDX=AMERODX)!(AMERNDX="")) Q
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("5-01"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMERODX,"X"),$$EDDISPL^AMEREDAU(AMERNDX,"X"),"DIAGNOSIS") ; Update the Audit file
 ...I AMERSTRG="^" Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S DIE="^AMERVSIT(DA(1),5,",DA(1)=AMERDA,DA=AMERDXNO,DR=""
 ...S DR=".01////"_AMERDX   ;IHS/OIT/SCR 11/07/08 try stuffing with no validation to get rid of weirdness
 ...D MULTDIE^AMEREDIT(DIE,DA,DA(1),DR) ; Update the POV multiple in AMER VISIT
 ...I DA=1 D  ; UPDATE PRIM ICD IN ER VISIT FILE ; IHS/OIT/GIS 12/09/2011
 ....S DIE="^AMERVSIT(",DA=AMERDA,DR="5.2////^S X=AMERDX"
 ....L +^AMERVSIT(DA):1 I  D ^DIE L -^AMERVSIT(DA)
 ....Q
 ...S DR=""
 ...Q
 ..Q:AMERBAD!AMERQUIT
 ..; User can change narrative
 ..S DIR(0)="Y",DIR("A")="Do you want to change narrative",DIR("B")="YES"
 ..D ^DIR K DIR
 ..I $D(DUOUT)!$D(DTOUT) S AMERQUIT=1
 ..I $G(Y)=0 S AMERNNAR=AMERONAR
 ..I $G(Y)=1 D
 ...S DIR(0)="FAOr^1:80",DIR("A")="Enter NEW Provider Narrative: ",DIR("B")=AMERONAR
 ...D ^DIR
 ...I $D(DUOUT)!$D(DTOUT) S AMERQUIT=1 Q
 ...Q:Y=""
 ...;IHS/OIT/SCR 092909 patch 2 START CHANGES TO AVOID ";" IN NARRATIVE
 ...D CKSC^AMER1
 ...I $D(AMERCKSC) D
 ....S AMERGOOD=0
 ....F  Q:AMERGOOD  D
 .....S Y=$G(DIR("B"))
 .....S DIR(0)="FAOr^1:80",DIR("A")="Enter NEW Provider Narrative: ",DIR("B")=AMERONAR
 .....D ^DIR
 .....D CKSC^AMER1
 .....I '$D(AMERCKSC) S AMERGOOD=1
 .....K AMERCKSC
 .....Q
 ....I Y="" S AMERQUIT=1
 ....Q
 ...K DIR
 ...Q:AMERQUIT
 ...;IHS/OIT/SCR 071509 patch 2 END CHANGES
 ...S AMERNNAR=Y
 ...I (AMERNNAR'=AMERONAR) D
 ....S DIE="^AMERVSIT(DA(1),5,",DA(1)=AMERDA,DA=AMERDXNO,DR=""
 ....S AMERNNAR=$$STRIPNAR^AMERPCC2(AMERNNAR) ;IHS/OIT/SCR 05/05/09
 ....S DR="1////"_AMERNNAR
 ....D MULTDIE^AMEREDIT(DIE,DA,DA(1),DR) K DIE ; Update the POV multiple in AMER VISIT
 ....I DA=1 D  ; UPDATE PRIM DX NARR IN ER VISIT FILE ; IHS/OIT/GIS 12/09/2011
 .....S DIE="^AMERVSIT(",DA=AMERDA,DR="5.3////^S X=AMERNNAR"
 .....L +^AMERVSIT(DA):1 I  D ^DIE L -^AMERVSIT(DA)
 .....Q
 ....S DR=""
 ....S AMERSTRG=$$EDAUDIT^AMEREDAU("5-1"_"."_AMEREDNO,AMERONAR,AMERNNAR,"PROVIDER NARRATIVE") ; Update the Audit file
 ....I AMERSTRG="^" Q
 ....S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ....Q
 ...Q
 ..I AMERNDX=AMERODX,AMERNNAR=AMERONAR ;IHS/OIT/GIS 11/30/11 patch 3
 ..E  D UPVPOV^AMEREDDY(AMERNDX,AMERODX,AMERNNAR,AMERONAR,AMERDA) ; Update the V POV entry here
 ..Q
 .I AMEREDTS'="" D MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 .S AMEREDTS=""
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q AMERPRIS
 S Y="",AMERDXNO=0
 I 'AMERSKIP&(AMERDX>0) D
 .S AMERODX="",AMERNDX=AMERICD9,AMEROLDS=""
 .S AMERNDX=AMERICD9
 .S DIR("A")="Enter narrative description of DX: "
 .S DIR(0)="FAOr^1:80"
 .S DIR("?")="Enter free text diagnosis (80 characters max.  ';' and ':' not allowed)"
 .D ^DIR
 .I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q
 .S AMERNNAR=Y
 .Q:AMERNNAR=""
 .S AMERNNAR=$$STRIPNAR^AMERPCC2(AMERNNAR) ;IHS/OIT/SCR 05/05/09
 .I AMERDX=$P($$ICDDX^ICDCODE(".9999",,,1),U,1) D
 ..S DA(1)=AMERDA,DIC="^AMERVSIT("_DA(1)_",5,",DIC(0)="L"  ; DIAGNOSES
 ..S X=AMERDX
 ..D FILE^DICN
 ..Q
 .I AMERDX'=$P($$ICDDX^ICDCODE(".9999",,,1),U,1) D
 ..S DA(1)=AMERDA,DIC="^AMERVSIT("_DA(1)_",5,",DIC(0)="L" ; DIAGNOSES
 ..S X="`"_AMERDX
 ..D ^DIC
 ..Q
 .Q:Y<0
 .; Just created a new DX in ER VISIT file - collect audit information and update V POV
 .D ADDVPOV^AMEREDDY(AMERNDX,AMERNNAR,AMERDA) ; Add V POV entry to sync with ER VISIT file
 .S AMERSTRG=$$EDAUDIT^AMEREDAU("5-01"_"."_AMEREDNO,"",$$EDDISPL^AMEREDAU(AMERNDX,"X"),"DIAGNOSIS") ; Collect code edit info
 .I AMERSTRG="^" Q
 .S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .S DIE=DIC,DA(1)=AMERDA,DA=+Y,DR="1////"_AMERNNAR
 .K DIC
 .D MULTDIE^AMEREDIT(DIE,DA,DA(1),DR)
 .Q
 Q AMERPRIS
SELECTDX(AMERPDX,AMERPNAR) ;IHS/OIT/GIS 9/9/11 patch 3
 N AMERICD9,AMERDXNO,AMERSEL,DIR
 S AMERSEL=0 ; DEFAULT TO QUIT
 ;IHS/OIT/SCR 11/18/08 TEMPORARILY ALLOWING LOCAL CODES
 ;S AMERICD9=$P($$ICDDX^ICDCODE($P($G(^AMERVSIT(AMERDA,5,0)),U,3),0),U,2)
 ;S AMERICD9=$P($$ICDDX^ICDCODE($P($G(^AMERVSIT(AMERDA,5,0)),U,3),,,1),U,2)
 D EN^DDIOL("EDIT/ADD Dx narrative(s) and/or code(s)","","!")
 D EN^DDIOL("Primary DX is marked with '**'","","!?5")
 ;IHS/OIT/SCR 11/03/08 - allow dx to be selected by number START CHANGES
 S AMERDXNO=0
 ; S DIR(0)="SO^0: ADD NEW DIAGNOSIS;"
 S DIR(0)="SO^"
 F  S AMERDXNO=$O(^AMERVSIT(AMERDA,5,AMERDXNO)) Q:(AMERDXNO="B"!(AMERDXNO=""))  D
 .N Y1,Y2,Y
 .S Y=$G(^AMERVSIT(AMERDA,5,AMERDXNO,0))  ;ICD9 CODE
 . ;IHS/OIT/SCR 11/20/08 TEMPORARILY ALLOWING LOCAL CODES
 .;S Y1=$P($$ICDDX^ICDCODE(Y),U,2)
 .;S Y2=$P($$ICDDX^ICDCODE(Y),U,4)
 .S Y1=$P($$ICDDX^ICDCODE(Y,,,1),U,2)
 .S Y2=$P($$ICDDX^ICDCODE(Y,,,1),U,4)
 .I Y1=AMERPDX&($G(^AMERVSIT(AMERDA,5,AMERDXNO,1))=AMERPNAR) D
 ..S DIR(0)=DIR(0)_AMERDXNO_":**"_Y1_"("_Y2_") "_$G(^AMERVSIT(AMERDA,5,AMERDXNO,1))_";"
 ..Q
 .E  S DIR(0)=DIR(0)_AMERDXNO_":  "_Y1_"  ("_Y2_") "_$G(^AMERVSIT(AMERDA,5,AMERDXNO,1))_";"
 .Q
 S DIR(0)=DIR(0)_"A: ADD NEW DIAGNOSIS;Q: QUIT"
 ; S DIR("B")=0 ;IHS/OIT/SCR 11/20/08
 S DIR("A")="Enter line # to EDIT, 'A' to ADD NEW DIAGNOSIS, or 'Q' to QUIT",DIR("?")="Enter line number you want to edit, ADD or QUIT"
 D ^DIR
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q -1
 Q $S(Y:Y,Y="A":0,1:-1)
 ; 
