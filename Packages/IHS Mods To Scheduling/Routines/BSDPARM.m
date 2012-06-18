BSDPARM ; IHS/ANMC/LJF - IHS SCHEDULING PARAMETERS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW BSDF,BSDIV,DIE,DA,DR,DD,DO,DIC,DLAYGO,Y,X,DINUM,BSDERR
 ;
 ; -- get MAS Parameter file entry (only one allowed) and edit
 I '$D(^DG(43,1)) D  I $G(BSDERR)]"" D MSG^BDGF(BSDERR,1,0) Q
 . S BSDIV=$$CHOOSE(43,1,.BSDERR)
 Q:'$D(^DG(43,1,0))
 ;
 D TERM^VALM0
 D MSG^BDGF($G(IORVON)_"Editing system-wide parameters:"_$G(IORVOFF),1,1)
 S DIE=43,DA=1,DR="12T;11;212;205///5.3" D ^DIE Q:$D(Y)
 D MSG^BDGF($G(IORVON)_"Editing facility-wide parameters:"_$G(IORVOFF),3,1)
 ;
 ; -- if no entry in IHS Scheduling Parameter file, add one
 ;
 I '$O(^BSDPAR(0)) D  I $G(BSDERR) D MSG^BDGF(BSDERR,1,0) Q
 . ;
 . ; if no medical center division or > 1, add or choose one
 . S BSDF=$O(^DG(40.8,0))
 . I 'BSDF!$O(^DG(40.8,+BSDF)) S BSDF=+$$CHOOSE(40.8,"",.BSDERR)
 . Q:BSDF<1
 . ;
 . ; add ihs sched parameter entry to match
 . S BSDF=+$$CHOOSE(9009020.2,BSDF,.BSDERR)
 ;
AGAIN ;
 ; -- else choose facility to edit
 I '$G(BSDF) S BSDF=+$$CHOOSE(9009020.2,"",.BSDERR) Q:BSDF<1
 I $G(BSDERR)]"" D MSG^BDGF(BSDERR,1,0) Q
 ;
 ; -- check stuffed fields for IHS answers
 S DIE=40.8,DA=BSDF
 S DR=".07;1;35.01///^S X=""NO"";35.03///^S X=""NO"";100.01///0"
 D ^DIE Q:$D(Y)
 ;
 ;
 ; -- call ScreenMan to add/edit parameters
 NEW DDSFILE,DA,DR
 S DDSFILE=9009020.2,DA=BSDF,DR="[BSD PARAM]" D ^DDS
 K BSDF D AGAIN
 Q
 ;
 ;
CHOOSE(FILE,ENTRY,ERROR) ; calls DIC for file, add allowed
 NEW DD,DO,DIC,DLAYGO,X,DINUM
 K DD,DO S (DIC,DLAYGO)=FILE,DIC(0)="AMEQZL"
 I ENTRY]"" S (X,DINUM)=ENTRY D FILE^DICN I Y=-1 S ERROR="Adding entry to file "_FILE_" failed; contact supervisor." Q Y
 D ^DIC
 Q Y
