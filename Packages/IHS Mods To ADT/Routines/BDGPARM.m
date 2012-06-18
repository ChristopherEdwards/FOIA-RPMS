BDGPARM ; IHS/ANMC/LJF - IHS ADT PARAMETERS ;
 ;;5.3;PIMS;**1004**;MAY 28, 2004
 ;IHS/OIT/LJF 08/31/2005 PATCH 1004 add "Print Wristband" question to DR string
 ;
 NEW BDGERR,BDGIV,DIE,DA,DR,BDGF,BDGN
 ;
 ; -- get MAS Parameter file entry (only one allowed) and edit
 I '$D(^DG(43,1)) D  I $G(BDGERR)]"" D MSG^BDGF(BDGERR,1,0) Q
 . S BDGIV=$$CHOOSE(43,1,.BDGERR)
 Q:'$D(^DG(43,1,0))
 ;
 D TERM^VALM0
 D MSG^BDGF($G(IORVON)_"Editing system-wide parameters:"_$G(IORVOFF),1,1)
 S DIE=43,DA=1,DR="12T;11;205///5.3" D ^DIE Q:$D(Y)
 D MSG^BDGF($G(IORVON)_"Editing facility-wide parameters:"_$G(IORVOFF),3,1)
 ;
 ; -- if no entry in IHS ADT Parameter file, add one
 ;
 I '$O(^BDGPAR(0)) D  I $G(BDGERR) D MSG^BDGF(BDGERR,1,0) Q
 . ;
 . ; if no medical center division or > 1, add or choose one
 . S BDGF=$O(^DG(40.8,0))
 . I 'BDGF!$O(^DG(40.8,+BDGF)) S BDGF=+$$CHOOSE(40.8,"",.BDGERR)
 . Q:BDGF<1
 . ;
 . ; add ihs adt parameter entry to match
 . S BDGF=+$$CHOOSE(9009020.1,BDGF,.BDGERR)
 ;
AGAIN ;
 ; -- else choose facility to edit
 I '$G(BDGF) S BDGF=+$$CHOOSE(9009020.1,"",.BDGERR) Q:BDGF<1
 I $G(BDGERR)]"" D MSG^BDGF(BDGERR,1,0) Q
 ;
 ; -- check stuffed fields for IHS answers
 S DIE=40.8,DA=BDGF
 ;S DR=".07;1;35.01///^S X=""NO"";35.03///^S X=""NO"";100.01///0"
 S DR=".07;1;35.01///^S X=""NO"";35.03///^S X=""NO"";100.01///0;.08"   ;IHS/OIT/LJF 8/31/2005 PATCH 1004
 D ^DIE Q:$D(Y)
 ;
 ; -- check PCC Master Control file for PCC link turned on
 S BDGN=$P($G(^DG(40.8,BDGF,0)),U,7) I BDGN D
 . Q   ;TEMP FOR TESTING IN VA UCI
 . NEW DIE,DR,DA
 . S DIE=9001000.011,DA(1)=BDGN,DR=".02"
 . S DA=$O(^DIC(9.4,"C","DG",0)) I DA D ^DIE
 ;
 ; -- call ScreenMan to add/edit parameters
 NEW DDSFILE,DA,DR
 S DDSFILE=9009020.1,DA=BDGF,DR="[BDG PARAM]" D ^DDS
 K BDGF D AGAIN
 Q
 ;
 ;
CHOOSE(FILE,ENTRY,ERROR) ; calls DIC for file, add allowed
 NEW DD,DO,DIC,DLAYGO,X,DINUM
 K DD,DO S (DIC,DLAYGO)=FILE,DIC(0)="AMEQZL"
 I ENTRY]"" S (X,DINUM)=ENTRY D FILE^DICN I Y=-1 S ERROR="Adding entry to file "_FILE_" failed; contact supervisor." Q Y
 D ^DIC
 Q Y
