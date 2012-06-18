BTIUUPL ; IHS/ITSC/LJF - ASCII Upload ;
 ;;1.0;TEXT INTEGRATION UTILITIES;**1002**;NOV 04, 2004
 ; IHS copy of TIUUPLD for silent ASCII upload
 ;   -- see tagged lines for changes
 ;IHS/OIT/LJF 3/18/2005 PATCH 1002 if line too long, break it up using FM call
 ;
MAIN ;EP; Control branching
 Q:$$GET1^DIQ(9003130.2,1,.02)]""   ;do NOT start upload if one already running
 D SET(.02,$$NOW^XLFDT)             ;set start time for upload
 D ^XBKVAR                          ;added so call from unix works
 NEW TIUZMSG                        ;used for silent messaging
 N EOM,TIUDA,TIUERR,TIUHDR,TIULN,TIUSRC,X
 I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
 S TIUSRC=$P($G(TIUPRM0),U,9),EOM=$P($G(TIUPRM0),U,11)
 ;I EOM']"",($P(TIUPRM0,U,17)'="k") W !,$C(7),$C(7),$C(7),"No End of Message Signal Defined - Contact IRM.",! Q  ;original VA
 I EOM']"",($P(TIUPRM0,U,17)'="k") D SET(.05,"No End of Message Signal Defined - Contact IRM.") Q                ;store error message
 S:TIUSRC']"" TIUSRC="R"
 S TIUHDR=$P(TIUPRM0,U,10)
 ;I TIUHDR']"" W $C(7),$C(7),$C(7),"No Record Header Signal Defined - Contact IRM.",! Q                 ;original VA
 I TIUHDR']"" D SET(.05,"No Record Header Signal Defined - Contact IRM.") Q                             ;store error message
 S TIUDA=$$MAKEBUF
 ;I +TIUDA'>0 W $C(7),$C(7),$C(7),"Unable to create a Buffer File Record - Contact IRM.",! Q           ;original VA
 I +TIUDA'>0 D SET(.05,"Unable to create a Buffer File Record - Contact IRM.") Q                       ;store error message
 I TIUSRC="R" D REMOTE(TIUDA)
 I TIUSRC="H" D HFS(TIUDA)
 ;I +$G(TIUERR) W $C(7),$C(7),$C(7),!,"Kermit Error: ",$G(TIUERR)," Please re-transmit the file...",!  ;original VA
 I +$G(TIUERR) D SET(.05,"Kermit Error: "_$G(TIUERR)_" Please re-transmit the file...") Q              ;store error message
 ; Set $ZB to MAIN+14^TIUUPLD:2
 I +$O(^TIU(8925.2,TIUDA,"TEXT",0))>0,'+$G(TIUERR) D FILE(TIUDA)
 I +$O(^TIU(8925.2,TIUDA,"TEXT",0))'>0!+$G(TIUERR) D BUFPURGE^TIUPUTC(TIUDA)
 D SET(.02,"@")               ;upload done - okay to spawn new job
 Q
REMOTE(DA) ; Read ASCII stream from remote computer
 N TIUI,TIUPAC,X
 I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
 S TIUPAC=$P(TIUPRM0,U,15)
 ;I TIUPAC']"",($P(TIUPRM0,U,17)'="k") W $C(7),$C(7),$C(7),"No Pace Character Defined - Contact IRM.",! Q  ;original VA
 I TIUPAC']"",($P(TIUPRM0,U,17)'="k") D SET(.05,"No Pace Character Defined - Contact IRM.") Q              ;store error message
 I $P(TIUPRM0,U,17)="k" D KERMIT(DA) Q
 D REMHDR("ASCII")
 F  R X:DTIME Q:'$T!(X=EOM)!(X="^")!(X="^^")  D
 . I X?1."?" D HELP(X),REMHDR("ASCII") Q
 . ; Ignore leading white space
 . I (+$O(^TIU(8925.2,DA,"TEXT",0))'>0),(X="") Q
 . S TIUI=+$G(TIUI)+1,^TIU(8925.2,DA,"TEXT",TIUI,0)=$$STRIP(X)
 . W !,$C(TIUPAC) ; Send ACK to remote
 S ^TIU(8925.2,DA,"TEXT",0)="^^"_$G(TIUI)_"^"_$G(TIUI)_"^"_DT_"^^^^"
 Q
REMHDR(PRTCL) ; Write Header for Remote upload
 W @IOF D JUSTIFY^TIUU($$TITLE^TIUU(PRTCL_" UPLOAD"),"C")
 W:PRTCL="ASCII" !!,"Initiate upload procedure:",!
 Q
KERMIT(DA) ; Use Kermit Protocol Driver
 N XTKDIC,XTKERR,XTKMODE,DWLC
 D REMHDR("KERMIT")
 S XTKDIC="^TIU(8925.2,"_+DA_",""TEXT"",",XTKMODE=2
 D RECEIVE^XTKERMIT I +$G(XTKERR) S TIUERR=$G(XTKERR) W !
 Q
HFS(DA) ; Read HFS file
 N TIUI,X
 I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
 ;W @IOF D JUSTIFY^TIUU($$TITLE^TIUU("ASCII UPLOAD"),"C")                      ;original VA
 ;W !!,"Select Host File:",! D ^%ZIS I POP W !,$C(7),"Device unavailable." Q   ;original VA
 ;
 NEW TIUSITE S TIUSITE=$O(^TIU(8925.99,"B",DUZ(2),0))                          ;added - find site
 I 'TIUSITE D SET(.05,"Site not setup in Parameter File") Q                    ;added - store error and quit
 S IOP="HFS",%ZIS("HFSNAME")=$$GET1^DIQ(8925.99,TIUSITE,9999999.01)            ;added - find directory
 S %ZIS("HFSNAME")=%ZIS("HFSNAME")_$$GET1^DIQ(8925.99,TIUSITE,9999999.03)      ;added - find filename
 S %ZIS("HFSMODE")="R" D ^%ZIS                                                 ;added - is it there?
 I POP D SET(.03,$$NOW^XLFDT) Q                                                ;added - if no file, update status global & quit
 H 5                                                                           ;added wait in case ftp in process at call time
 S IOP="HFS",%ZIS("HFSNAME")=$$GET1^DIQ(8925.99,TIUSITE,9999999.01)            ;added - find directory
 S %ZIS("HFSNAME")=%ZIS("HFSNAME")_$$GET1^DIQ(8925.99,TIUSITE,9999999.03)      ;added - find filename
 S %ZIS("HFSMODE")="RW" D ^%ZIS                                                ;added - open of uploading now
 I POP D SET(.05,"Device Unavailable") Q                                       ;added - store error and quit
 ;
 ;F  U IO R X:DTIME Q:'$T!(X=EOM)!(X="^")!(X="^^")  D                ;original VA
 NEW QUIT S QUIT=0 F  U IO R X:1 Q:QUIT=1  D                         ;changed DTIME per Dimitri
 . I X=EOM S QUIT=1 Q
 . ;
 . ;IHS/OIT/LJF 3/18/2005 PATCH 1002 if line too long, break it up
 . ;I $L(X)>255 S X=$$REPEAT^XLFSTR("?",75)      ;if line too long, reset to 75? - may be garbage
 . I $L(X)>255 D  Q
 . . NEW I K ^UTILITY($J,"W")
 . . S DIWL=1,DIWR=75,DIWF="I" D ^DIWP
 . . F I=1:1 Q:'$D(^UTILITY($J,"W",1,I))  S TIUI=+$G(TIUI)+1,^TIU(8925.2,DA,"TEXT",TIUI,0)=$$STRIP(^UTILITY($J,"W",1,I,0))
 . . K ^UTILITY($J,"W")
 . . ;IHS/OIT/LJF 3/18/2005 PATCH 1002 end of new code
 . ;
 . S TIUI=+$G(TIUI)+1,^TIU(8925.2,DA,"TEXT",TIUI,0)=$$STRIP(X)
 ;
 S ^TIU(8925.2,DA,"TEXT",0)="^^"_$G(TIUI)_"^"_$G(TIUI)_"^"_DT_"^^^^"
 D ^%ZISC
 ;
 D SET(.04,$$NOW^XLFDT)           ;added - update status global for date last file processed
 D ^BTIUARC                       ;added - move to archive directory
 ;
 Q
STRIP(X) ; Strip control characters
 N I,Y
 ; First replace TABS w/5 spaces
 F I=1:1:$L(X) S:$A(X,I)=9 X=$E(X,1,(I-1))_"     "_$E(X,(I+1),$L(X))
 ; Next, remove control characters
 S Y="" F I=1:1:$L(X) S:$A(X,I)>31 Y=Y_$E(X,I)
 Q Y
MAKEBUF() ; Subroutine to create buffer records
 N DIC,DA,DR,DIE,START,X,Y
 S START=$$NOW^TIULC
 S (DIC,DLAYGO)=8925.2,DIC(0)="LX",X=""""_$J_"""" D ^DIC
 I +Y'>0 S DA=Y G MAKEBUX
 S DA=+Y,DIE=DIC,DR=".02////"_+$G(DUZ)_";.03////"_START D ^DIE
MAKEBUX Q DA
FILE(DA) ; Completes upload transaction, invokes filer/router
 N DIE,DR
 I '$D(^TIU(8925.2,+DA,0)) G FILEX
 S DIE="^TIU(8925.2,",DR=".04////"_$$NOW^TIULC D ^DIE
 ; Task background filer/router to process buffer record
 S ZTIO="",ZTDTH=$H,ZTSAVE("DA")=""
 S ZTRTN=$S($P(TIUPRM0,U,16)="D":"MAIN^TIUPUTD",1:"MAIN^TIUPUTC")
 S ZTDESC="TIU Document Filer"
 ; If filer is NOT designated to run in the foreground, queue it
 I '+$P(TIUPRM0,U,18) D  G FILEX
 . D ^%ZTLOAD
 . ;W !,$S($D(ZTSK):"Filer/Router Queued!",1:"Filer/Router Cancelled!")      ;original VA - need silence
 ; Otherwise, run the filer in the foreground
 D @ZTRTN
FILEX Q
HELP(X) ; Process HELP for Remote upload
 I X="?" W !?3,"Begin file transfer using ASCII protocol upload procedure.",!
 I X?2."?" D
 . W !?3,"Consult your terminal emulator's User Manual to determine",!
 . W !?3,"how to set-up and initiate an ASCII protocol file transfer.",!
 W !?3,"Enter '^' or '^^' to exit.",!
 S TIUX=$$READ^TIUU("FOA","Press RETURN to continue...")
 Q
 ;
SET(FIELD,ANS) ; upload BTIU UPLOAD STATUS file
 NEW DIE,DA,DR
 S DIE=9003130.2,DA=1,DR=FIELD_"///"_ANS
 D ^DIE
 Q
 ;
DISPLAY ;EP; -- display status of upload
 NEW X,Y
 D ^XBCLS D MSG^BTIUU("**STATUS OF TIU UPLOAD**",2,1,0)
 ;
 S Y=$$GET1^DIQ(9003130.2,1,.04,"I")
 S X=$S(Y="":"NO FILES UPLOADED",1:$$DOW^XLFDT(Y)_" "_$$FMTE^XLFDT(Y))
 D MSG^BTIUU("LAST FILE UPLOADED INTO RPMS:   "_X,1,1,0)
 ;
 S Y=$$GET1^DIQ(9003130.2,1,.03,"I")
 S X=$S(Y="":"NO LAST SCAN FOUND",1:$$DOW^XLFDT(Y)_" "_$$FMTE^XLFDT(Y))
 D MSG^BTIUU("LAST SCAN FOR NEW TIU FILE:     "_X,1,1,0)
 ;
 S Y=$$GET1^DIQ(9003130.2,1,.02) I Y]"" D
 . D MSG^BTIUU("UPLOAD STILL RUNNING; CHECK END OF FILE MARKERS",1,0,0)
 . D MSG^BTIUU("UPLOAD STARTED ON "_Y,1,0,0)
 . S X=$$GET1^DIQ(900903130.2,1,.05)
 . I X]"" D MSG^BTIUU("ERROR RECORDED: "_X,1,1,0)
 D RETURN^BTIUU
 Q
 ;
RESET ;EP; resets Upload Running and Error Messages back to null so uplaod can run
 ; after porblem has been fixed; run this to restart upload
 Q:'$$READ^TIUU("Y","OKAY to Reset UPLOAD STATUS","NO")
 NEW DIE,DA,DR
 S DIE=9003130.2,DA=1,DR=".02///@;.05///@"
 D ^DIE
 Q
