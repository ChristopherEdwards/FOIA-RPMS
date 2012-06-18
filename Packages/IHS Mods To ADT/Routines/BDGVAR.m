BDGVAR ; IHS/ANMC/LJF - VARIABLE SET AND KILL ;  [ 01/02/2004  10:27 AM ]
 ;;5.3;PIMS;**1011,1012**;APR 26, 2002
 ;
ENTER ;EP; entry point called by main menu
 I $G(BDGQUIT) K BDGQUIT Q   ;don't call this twice
 NEW I,X
 S BDGMENU=1
 D ^XBCLS W @IOF W !?27 F I=1:1:25 W "*"
 W !?24,"**   INDIAN HEALTH SERVICE   **"
 W !?19,"** ADMISSION/DISCHARGE/TRANSFER SYSTEM **"
 W !?24,"**       VERSION ",$$VERSION^XPDUTL("DG"),?53,"**"
 W !?27 F I=1:1:25 W "*"
 ;
 I '$D(DUZ(2)) D  S XQUIT=1 D PAUSE^BDGF Q
 . W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE ADT!"
 ;
 S X=$$GET1^DIQ(4,DUZ(2),.01) W !!?80-$L(X)\2,X
 I X="" D  S XQUIT=1 D PAUSE^BDGF Q
 . W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!"
 ;
 I $D(XQUIT) D EXIT Q
 Q
 ;
VAR ;PEP;***> set package variables from site parameter file
 Q:$G(XQUIT)
 ;
 ; set system-wide variables
 ;   -- set division based on DUZ(2)
 S BDGDIV=$$DIV^BDGPAR(DUZ(2))
 Q
 ;
CHECK(TALK) ;PEP; check that ADT is set up and PCC link is turned on
 ; TALK = 1 means display mini message to screen
 ; TALK = 2 means display full message to screen
 ; TALK = 0 means no display; just return status
 ;
 ; Returns 1 if ADT set up but PCC link is off
 ; Returns 2 if ADT set up and PCC link is on
 ; Returns 0 if ADT not set up - do not continue
 ;
 ; If TALK not = 2 and ADT not set up, XQUIT set to 1
 ;
 NEW I,STATUS,X,Y
 ; -- display heading
 I TALK=2 D
 . D ^XBCLS W !?25,"ADT-PCC LINK ENVIRONMENT"
 . W !?25 F I=1:1:24 W "-"
 ;
 I '$D(^AUTTSITE(1,0)) D  Q 0
 . I TALK=2 W !!?10,"1) RPMS SITE file is NOT present."
 . I TALK=1 W !?9,"** ADT is NOT set up properly; contact application coordinator. **" D PAUSE^BDGF
 . I TALK'=2 S XQUIT=1
 ;
 S STATUS=2   ;start with best case
 S X=$$GET1^DIQ(9999999.39,1,.08) I X'="YES" S STATUS=1
 I TALK=2 W !!?10,"1) PCC is running at this site (RPMS SITE file): ",X
 ;
 S X=$D(^APCCCTRL(DUZ(2))) I 'X S STATUS=1
 I TALK=2 W !!?10,"2) PCC MASTER CONTROL file is defined for this site: ",$S(X:"YES",1:"NO")
 ;
 S X=$$GET1^DIQ(9001000,DUZ(2),.04) I X="" S STATUS=1
 I TALK=2 W !!?10,"3) VISIT TYPE defined in the PCC MASTER CONTROL file: ",X
 ;
 S X=0,Y=0 F  S X=$O(^BDGPAR(X)) Q:'X  Q:Y  D
 . ;I $D(^DG(40.8,"C",DUZ(2),X)) S Y=X  ;cmi/maw 9/1/09 orig line PATCH 1011
 . I $D(^DG(40.8,"AD",DUZ(2),X)) S Y=X  ;cmi/maw 9/1/09 mod line PATCH 1011
 I 'Y S STATUS=0
 I TALK=2 W !?10,"4) ADT Division in IHS ADT PARAMETER file: ",$S('Y:"NO",1:$$GET1^DIQ(40.8,Y,.01))
 ;
 S X=$O(^DIC(9.4,"C","PIMS",0)) I TALK=2 W !!?10,"5) PIMS package defined in the PACKAGE file: ",$S(X:"YES",1:"NO")
 I 'X S STATUS=0
 ;
 S Y=$S($D(^APCCCTRL(DUZ(2),11,+X,0)):"YES",1:"NO")
 I Y="NO",STATUS S STATUS=1
 I TALK=2 W !!?10,"6) PIMS entry exists in the PCC MASTER CONTROL file: ",Y
 ;
 I $D(^APCCCTRL(DUZ(2),11,+X,0)),STATUS D
 . S Y=+$P(^APCCCTRL(DUZ(2),11,+X,0),U,2) I 'Y S STATUS=1
 . I TALK=2 D
 .. W !!?10,"7) PIMS entry has ""PASS DATA TO PCC"" set to: "
 .. W $S(Y:"YES",1:"NO")
 ;
 I TALK D
 . I STATUS=0 S X="** ADT is NOT set up properly; contact application coordinator. **"
 . I STATUS=1 S X="** PCC link is turned OFF. **"
 . I STATUS=2 S X="** PCC link is turned ON. **"
 . I TALK=2 W !!?(80-$L(X)/2),X Q
 . I STATUS=0 W !?(80-$L(X)/2),X I '$D(^XUSEC("DGZSYS",DUZ)) D PAUSE^BDGF S XQUIT=1 Q
 . I STATUS,$D(^XUSEC("DGZSYS",DUZ)) W !?(80-$L(X)/2),X
 ;
 Q STATUS
 ;
EXIT ;PEP; kill system wide variables
 K BDGMENU,BDGDIV,BDGQUIT
 D EN^XBVK("VALM")
 Q
 ;
MENU ;ENTRY POINT  >>> entry action for all submenus
 NEW BDG
 S BDG("TITLE")=$P($G(XQY0),U,2)
 I $L(BDG("TITLE"))>2 W @IOF,!!?80-$L(BDG("TITLE"))/2,BDG("TITLE")
 S X=$$GET1^DIQ(4,DUZ(2),.01)
 W !!?80-$L(X)\2,"(",X,")"
 Q
 ;
SECENTER ;EP; entry point for Security Officer Menu
 ;Part of PIMS but released with DPT so use DPT version #
 ;
 D ^XBCLS W !?18 F BDG("I")=1:1:41 W "*"
 W !?18,"*        INDIAN HEALTH SERVICE          *"
 W !?18,"*   SENSITIVE PATIENT TRACKING MODULE   *"
 W !?18,"*             VERSION ",$$VERSION^XPDUTL("PIMS"),?58,"*"
 W !?18 F BDG("I")=1:1:41 W "*"
 ;
 I '$D(DUZ(2))!('$D(DUZ(0))) D  D SECQUIT Q
 .W !!,"YOU MUST SIGN ON PROPERLY THROUGH THE KERNEL TO USE THIS MENU"
 .S XQUIT=1 D PAUSE^BDGF
 S X=$$GET1^DIQ(4,DUZ(2),.01) W !!?80-$L(X)\2,X
 I X="" W !!,"INVALID FACILITY; NOTIFY YOUR SITE MANAGER!" S XQUIT=1
 ;
SECQUIT W ! K BDG,X,Y Q
