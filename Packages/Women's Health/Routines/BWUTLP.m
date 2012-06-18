BWUTLP ;IHS/CIA/DKM - User prompt APIs;21-Oct-2003 10:04;PLS
 ;;2.0;WOMEN'S HEALTH;**3,5,7,8,9**;MAY 16, 1996
 ;
 ; Prompt for a date range.
 ; .BWB    Start date in FM format (returned)
 ; .BWE    End date in FM format (returned)
 ; .BWPOP  Abort flag (returned)
 ;  BWBDF  Default begin date (optional)
 ;  BWEDF  Default end date (optional)
 ;  BWSAME If nonzero, default end date is begin date (optional)
 ;  BWTIME If nonzero, ask for time (optional)
 ;
ASKDATES(BWB,BWE,BWPOP,BWBDF,BWEDF,BWSAME,BWTIME) ; EP
 N BWOPT
 W !!,"   *** Date Range Selection ***"
 S BWPOP=0,BWOPT=$S($G(BWTIME):"T",1:"")
 S BWB=$$ASKDATE("   Begin with DATE: ",.BWBDF,,BWOPT)
 S:'BWPOP BWE=$$ASKDATE("     End with DATE: ",$S($G(BWSAME):BWB,$G(BWEDF):BWEDF,1:""),BWB,BWOPT)
 Q
 ; Prompt for single date date
 ; BWPMT = Prompt
 ; BWDFL = Default value (optional)
 ; BWMIN = Minimum value (optional)
 ; BWOPT = Additional options (optional)
ASKDATE(BWPMT,BWDFL,BWMIN,BWOPT) ;
 N %DT,Y
 S %DT="APEX"_$G(BWOPT)
 S %DT("A")=BWPMT
 S:$G(BWMIN) %DT(0)=BWMIN
 I $G(BWDFL) D
 .S Y=BWDFL
 .D DD^%DT
 .S %DT("B")=Y
 D ^%DT
 S:Y<0 BWPOP=1
 Q Y
 ; Record locked
LOCKED D SHOWDLG(-4)
 Q
 ; Locked pregnancy log entry
LOCKEDE D SHOWDLG(-3)
 Q
 ; Locked pap log entry
LOCKEDP D SHOWDLG(-2)
 Q
 ;
 ; DIR call for Y/N response
DIRYN(BWPMT,BWDFL,BWHLP,BWPOP) ; EP
 N Y
 S Y=$$DIR("YO",.BWPMT,.BWDFL,.BWHLP,.BWPOP)
 ;IHS exemption approved on 10/20/2003
 Q:$Q Y
 Q
 ;
 ; Paramerized DIR call
DIR(BWDTP,BWPMT,BWDFL,BWHLP,BWPOP,BWSCN) ; EP
 N DIR,DTOUT,DUOUT,Y
 S DIR(0)=BWDTP,DIR("B")=$G(BWDFL)
 I '$G(BWPMT) M DIR("A")=BWPMT
 E  D GETTEXT(BWPMT,$NA(DIR("A")))
 I '$G(BWHLP) M DIR("?")=BWHLP
 E  D GETTEXT(BWHLP,$NA(DIR("?")))
 S:$L($G(BWSCN)) DIR("S")=BWSCN
 D ^DIR
 S:$D(DUOUT)!$D(DTOUT) BWPOP=1
 ;IHS exemption approved on 10/20/2003
 Q:$Q Y
 Q
 ; Pause for user input
DIRZ ; EP
 D DIR("E",,,,.BWPOP)
 Q
 ; Display dialog text
 ; BWDG = Dialog index (negative value causes pause)
SHOWDLG(BWDG) ; EP
 Q:$D(BWSILENT)!$D(ZTQUEUED)
 N BWX
 D GETTEXT(BWDG,"BWX")
 S BWX=0
 W:$X !
 F  S BWX=$O(BWX(BWX)) Q:'BWX  W BWX(BWX),!
 D:BWDG<0 DIRZ
 Q
 ; Load dialog text into array
 ; BWDG = Dialog index^optional parameters
 ; BWAR = Array to receive text
GETTEXT(BWDG,BWAR) ;
 N BWPM
 K @BWAR
 F X=2:1:$L(BWDG,U) S BWPM(X-1)=$P(BWDG,U,X)
 S BWDG=$S(BWDG<0:-BWDG,1:+BWDG)
 D BLD^DIALOG(BWDG/1000+9002086,.BWPM,,BWAR)
 Q
 ;
 ; Prompt for entry from file
 ; BWFILE = File #
 ; BWPMPT = Prompt
GETIEN(BWFILE,BWPMPT) ; EP
 N DIC,BWD,Y
 S BWD=$$GET1^DIQ(BWFILE,$$FIND1^DIC(BWFILE,,," "),.01)
 S DIC=BWFILE,DIC(0)="AE",DIC("A")=$G(BWPMPT),DIC("B")=BWD
 D ^DIC
 S:Y'>0 BWPOP=1
 Q +Y
 ; Select one or more items from a file or set of codes
 ; BWITEM = Item descriptor (start with "-" if exclusion)
 ; BWFILE = File #
 ; BWARRY = Array name to receive selections
 ; BWSCRN = Optional screen
 ; BWDFLT = Optional default value
 ; BWFLD  = If target lookup is a set, pass the field # for the set
 ; BWASK  = Optional flag to issue Y/N prompt (default = 1)
SELECT(BWITEM,BWFILE,BWARRY,BWSCRN,BWDFLT,BWPOP,BWFLD,BWASK) ; EP
 N BWITEMS,BWDONE,BWIE
 I '$D(BWITEM)!'$G(BWFILE)!'$D(BWARRY) S BWPOP=1 Q
 I $E(BWITEM)="-" S $E(BWITEM)="",BWIE="excluded from"
 E  S BWIE="included in"
 S BWITEMS=$S("Yy"[$E(BWITEM,$L(BWITEM)):$E(BWITEM,1,$L(BWITEM)-1)_"ies",1:BWITEM_"s"),BWDONE=0,BWASK=$G(BWASK,1)
 K @BWARRY
 F  D  Q:BWPOP!BWDONE
 .N DIC,Y,BWX
 .S:BWASK BWDONE=$$DIRYN(14_U_BWITEMS,"YES",13_U_BWITEMS,.BWPOP)
 .Q:BWPOP!BWDONE
 .D SHOWDLG(15_U_BWITEM_U_BWIE)
 .I $G(BWFLD) D
 ..F  D  Q:Y<1
 ...S Y=+$$DIR(BWFILE_","_BWFLD_"O","Select "_BWITEM,.BWDFLT,,.BWPOP,.BWSCRN)
 ...S:Y>0 @BWARRY@(Y)=""
 .E  D
 ..S DIC(0)="QEMA",DIC=BWFILE,DIC("A")="Select "_BWITEM_": "
 ..S:$D(BWDFLT) DIC("B")=BWDFLT
 ..S:$D(BWSCRN) DIC("S")=BWSCRN
 ..F  D ^DIC K DIC("B") Q:Y<0  S @BWARRY@(+Y)=""
 .D SHOWDLG($S($D(@BWARRY):17,1:16)_U_BWITEMS_U_BWIE)
 .S BWX=""
 .F  S BWX=$O(@BWARRY@(BWX)) Q:'$L(BWX)  D
 ..I $G(BWFLD) W ?5,$$EXTERNAL^DILFD(BWFILE,BWFLD,,BWX),!
 ..E  W ?5,$$GET1^DIQ(BWFILE,BWX,.01),!
 .W !
 .S BWDONE=$$DIRYN("Is this correct","YES",,.BWPOP)
 .I 'BWDONE D
 ..K @BWARRY
 ..D:'BWPOP SHOWDLG(18_U_BWITEMS)
 Q
