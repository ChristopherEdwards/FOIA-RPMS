CIAZGUTP ;MSC/IND/DKM - User prompt APIs ;03-Mar-2008 10:15;DKM
 ;;1.4;GENERIC RETRIEVAL UTILITY;;Feb 14, 2008
 ;;Copyright 2000-2008, Medsphere Systems Corporation
 ;=================================================================
 ; Single value prompt
ASK1(DTP) ; EP
 S VAL(1)=$$DIR(DTP,.PROMPT,$G(VAL(1)),,.ABORT)
 Q
 ; Range prompt
ASK2(DTP) ; EP
 N X1,X2
 S X1=$G(VAL(1)),X2=$G(VAL(2))
 D DIR2(DTP,.PROMPT,.X1,.X2,,.ABORT)
 S:'$G(ABORT) VAL(1)=X1,VAL(2)=X2
 Q
 ;
 ; Prompt for a range of values
DIR2(DTP,PMT,VAL1,VAL2,HLP,ABORT,SCN) ; EP
 N Y
 D PMPTOUT(.PMT)
 S VAL1=$$DIR(DTP,"  First",.VAL1,.HLP,.ABORT)
 Q:$G(ABORT)
 S VAL2=$$DIR(DTP,"   Last",.VAL2,.HLP,.ABORT)
 S:VAL1>VAL2 Y=VAL1,VAL1=VAL2,VAL2=Y
 Q
 ; DIR call for Y/N response
DIRYN(PMT,DFL,HLP,POP) ; EP
 Q $$DIR("YO",.PMT,.DFL,.HLP,.POP)
 ;
 ; Paramerized DIR call
DIR(DTP,PMT,DFL,HLP,ABORT,SCN) ; EP
 N DIR,DTOUT,DUOUT,Y
 I $E(DTP)="D",$G(DFL),DFL=+DFL S DFL=$$FMTE^XLFDT(DFL)
 S DIR(0)=DTP,DIR("B")=$G(DFL)
 I '$G(PMT) M DIR("A")=PMT
 E  D GETTEXT(PMT,$NA(DIR("A")))
 I '$G(HLP) M DIR("?")=HLP
 E  D GETTEXT(HLP,$NA(DIR("?")))
 S:$L($G(SCN)) DIR("S")=SCN
 D ^DIR
 S:$D(DUOUT)!$D(DTOUT) ABORT=1
 I '$G(ABORT) D
 .S DFL=Y
 .W:$D(Y(0)) "  ",Y(0)
 Q:$Q Y
 Q
 ; Pause for user input
DIRZ ; EP
 D DIR("E",,,,.ABORT)
 Q
 ; Display dialog text
 ; DLG = Dialog index (negative value causes pause)
SHOWDLG(DLG,SILENT) ; EP
 Q:$D(SILENT)!$D(ZTQUEUED)
 N X
 D GETTEXT(DLG,"X")
 S X=0
 W:$X !
 F  S X=$O(X(X)) Q:'X  W X(X),!
 D:DLG<0 DIRZ
 Q
 ; Load dialog text into array
 ; DLG = Dialog index^optional parameters
 ; ARY = Array to receive text
GETTEXT(DLG,ARY) ;
 N PM
 K @ARY
 F X=2:1:$L(DLG,U) S PM(X-1)=$P(DLG,U,X)
 S DLG=$S(DLG<0:-DLG,1:+DLG)
 D BLD^DIALOG(DLG+199504000,.PM,,ARY)
 Q
 ;
 ; Prompt for entry from file
 ;  FILE  = File #
 ;  PMPT  = Prompt
 ;  SCRN  = Screen (optional)
 ; .ABORT = If set, operation was aborted (returned)
GETIEN(FILE,PMPT,SCRN,ABORT) ; EP
 N DIC,D,Y
 S D=$$GET1^DIQ(FILE,$$FIND1^DIC(FILE,,," "),.01)
 S DIC=FILE,DIC(0)="AE",DIC("A")=$G(PMPT),DIC("B")=D
 S:$L($G(SCRN)) DIC("S")=SCRN
 D ^DIC
 S:Y'>0 ABORT=1
 Q +Y
 ; Select one or more items from a file or set of codes
 ; ITEM = Item descriptor (start with "-" if exclusion)
 ; FILE = File #
 ; ARY  = Array name to receive selections
 ; SCRN = Optional screen
 ; DFLT = Optional default value
 ; FLD  = If target lookup is a set, pass the field # for the set
 ; ASK  = Optional flag to issue Y/N prompt (default = 1)
SELECT(ITEM,FILE,ARY,SCRN,DFLT,ABORT,FLD,ASK) ; EP
 N ITEMS,DONE,IE
 I '$D(ITEM)!'$G(FILE)!'$D(ARY) S ABORT=1 Q
 I $E(ITEM)="-" S $E(ITEM)="",IE="excluded from"
 E  S IE="included in"
 S ITEMS=$S("Yy"[$E(ITEM,$L(ITEM)):$E(ITEM,1,$L(ITEM)-1)_"ies",1:ITEM_"s"),DONE=0,ASK=$G(ASK,1)
 K @ARY
 F  D  Q:ABORT!DONE
 .N DIC,Y,X
 .S:ASK DONE=$$DIRYN(14_U_ITEMS,"YES",13_U_ITEMS,.ABORT)
 .Q:ABORT!DONE
 .D SHOWDLG(15_U_ITEM_U_IE)
 .I $G(FLD) D
 ..F  D  Q:Y<1
 ...S Y=+$$DIR(FILE_","_FLD_"O","Select "_ITEM,.DFLT,,.ABORT,.SCRN)
 ...S:Y>0 @ARY@(Y)=""
 .E  D
 ..S DIC(0)="QEMA",DIC=FILE,DIC("A")="Select "_ITEM_": "
 ..S:$D(DFLT) DIC("B")=DFLT
 ..S:$D(SCRN) DIC("S")=SCRN
 ..F  D ^DIC K DIC("B") Q:Y<0  S @ARY@(+Y)=""
 .D SHOWDLG($S($D(@ARY):17,1:16)_U_ITEMS_U_IE)
 .S X=""
 .F  S X=$O(@ARY@(X)) Q:'$L(X)  D
 ..I $G(FLD) W ?5,$$EXTERNAL^DILFD(FILE,FLD,,X),!
 ..E  W ?5,$$GET1^DIQ(FILE,X,.01),!
 .W !
 .S DONE=$$DIRYN("Is this correct","YES",,.ABORT)
 .I 'DONE D
 ..K @ARY
 ..D:'ABORT SHOWDLG(18_U_ITEMS)
 Q
 ; Display a prompt
PMPTOUT(PMPT) ;
 N NXT
 W !!
 S NXT="PMPT"
 W:$D(PMPT)#2 PMPT,!
 F  S NXT=$Q(@NXT) Q:'$L(NXT)  W @NXT,!
 Q
