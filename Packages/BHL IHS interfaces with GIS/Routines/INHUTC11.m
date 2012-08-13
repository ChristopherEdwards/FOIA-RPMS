INHUTC11 ;bar; 19 Jun 97 17:29; Internal Functions for Criteria Mgmt 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 Q
 ;
SAVE(INOPT,INDA,INCTRL) ; save working record to user defined record
 ;
 ; input:   INOPT array. See INHUTCD for description.
 ;          INDA   = entry in criteria file (req)
 ;          INCTRL = S, U, B, or W. control value of saved record (opt)
 ; returns: ien of record in INTERFACE CRITERIA file
 ;          if function does not complete, reason text is returned.
 ;
 Q:'$G(INDA) "SAVE: Entry number not supplied"
 S INCTRL=$S('$L($G(INCTRL)):"U","SUBW"[INCTRL:INCTRL,1:"U")
 N INX,INAME,INOK,INOPT2
 ; get save field value
 S INX=$G(^DIZ(4001.1,INDA,0)),INAME=$P(INX,U,4)
 ; quit if not to be saved
 Q:'$L(INAME) INDA
 ; see if name exists already
 S INOPT2("DUZ")=$P(INX,U,2),INOPT2("TYPE")=$P(INX,U,5),INOPT2("APP")=$P(INX,U,8),INOPT2("FUNC")=$P(INX,U,6),INOPT2("CONTROL")=INCTRL
 S INFROM=$$LOOKUP^INHUTC1(.INOPT2,INAME)
 ; interactive mode, name exists, does not match selected name,
 ; ask to overwrite
 S INOK=1 I '$G(INOPT("NONINTER")),INFROM,INAME'=$P($G(INOPT("SELECTED")),U,2) S INOK=$$YN^UTWRD("Overwrite "_INAME_" with new version? ;0")
 ; return answer
 S INOPT("OVERWRITE")=INOK
 ; and if they say no? remove name and quit
 I 'INOK D  Q INDA
 . N DIC,DIE,DA S DIE=4001.1,DR=".04///@",DA=INDA D ^DIE
 ; if entry does not already exist, create new entry
 S:'INFROM INFROM=$$NEW^INHUTC1(.INOPT,INCTRL)
 ; copy data to record
 D COPY(INDA,INFROM,INCTRL)
 Q INDA
 ;
COPY(INFROM,INTO,INCTRL) ; copy search fields from one entry to another
 ; input:  INFROM = ien to INTERFACE CRITERIA file to copy from. (opt)
 ;                  if 0, will clear contents of INTO 
 ;         INTO   = ien to INTERFACE CRITERIA file to copy to    (req)
 ;         INCTRL = CONTROL field value of "TO" entry (opt)
 ;
 Q:'$G(INTO)  S INFROM=$G(INFROM,0),INCTRL=$G(INCTRL)
 N DIK,DA
 ; delete current x-refs
 S DIK="^DIZ(4001.1,",DA=INTO
 ; VA/IHS FileMan does not have IX2 tag
 I $$SC^INHUTIL1 D IX2^DIK
 ; clear current fields, clear name if no from entry
 S DA=0 F  S DA=$O(^DIZ(4001.1,INTO,DA)) Q:'DA  K ^(DA)
 S $P(^DIZ(4001.1,INTO,0),U,4)=""
 ; move entry
 M:INFROM ^DIZ(4001.1,INTO)=^DIZ(4001.1,INFROM)
 ; update .01 field
 S $P(^DIZ(4001.1,INTO,0),U,1)=INTO
 ; update CONTROL field
 I $L($G(INCTRL)) S $P(^DIZ(4001.1,INTO,0),U,3)=INCTRL
 ; update INTO entry with last access date
 S $P(^DIZ(4001.1,INTO,0),U,9)=$$DT^%ZTFDT
 ; if copied from system record, blank name
 I INFROM,$P(^DIZ(4001.1,INFROM,0),U,3)="S" S $P(^DIZ(4001.1,INTO,0),U,4)=""
 ; reindex this entry
 S DIK="^DIZ(4001.1,",DA=INTO D IX1^DIK
 Q
 ;
EDIT(INDA,INGALL) ; edit criteria entry
 ;
 ; input:   INDA = ien of criteria file entry (req)
 ;          INGALL = gallery name  (req)
 ; returns: ien of criteria entry if no errors
 ;          on error, returns text of error
 ;
 Q:'$G(INDA) "EDIT: Interface Criteria entry not supplied."
 ;  Force ^DWC to ask to file then Preset the fields for another search
 ; removed DWASK="" to not force it bar 02/05/97
 ; For IHS, don't deal with DWC.
 I $$SC^INHUTIL1 S DA=INDA,DWN=INGALL,DIE=4001.1,DWASK="" D ^DWC
 Q:$D(DTOUT)!$D(DUOUT) "EDIT: User aborted gallery edit."
 ; update edited date
 S $P(^DIZ(4001.1,INDA,0),U,9)=$$DT^%ZTFDT
 Q INDA
 ;
