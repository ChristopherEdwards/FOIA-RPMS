BSDREG ; IHS/ANMC/LJF - REG EDITS FROM SCHEDULING ; 
 ;;5.3;PIMS;**1004,1006,1009**;MAY 28, 2004
 ; code to return to screen (RESET) on protocol
 ;IHS/OIT/LJF 07/22/2005 PATCH 1004 added ;EP to ADDRESS label; called by ^BSDWLE
 ;            09/08/2006 PATCH 1006 added PEP and cleaned up call to AG PEP
 ;cmi/anch/maw 02/23/2008 PATCH 1009 added code in MPH to file in OTHER PHONE (1801) field of PATIENT file
 ;
EN ;PEP; Edit Patient Registration using PIMS parameter rules;IHS/OIT/LJF 09/08/2006 line added
 NEW BSDREG,DFN
 S BSDREG=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.19,"I")  ;access level
 I SDAMTYP="P" S DFN=SDFN
 I SDAMTYP="C" S DFN=+$$READ^BDGF("P^2:EMQZ","Select PATIENT") Q:'DFN
 D FULL^VALM1
 ;
 NEW AG,AGCHRT,AGLINE,AGOPT,AGPAT,AGQI,AGQT,AGSCRN,AGTP,AGUPDT
 ;
 ;  if turned off, display address then quit
 I ('BSDREG)!(BSDREG=3&'$D(^XUSEC("SDZREGEDIT",DUZ))) D DISPLAY,PAUSE^BDGF Q
 ;
 ;  if address only or no key
 I (BSDREG=1)!('$D(^XUSEC("SDZREGEDIT",DUZ))) D  Q
 . D ADDRESS L -^AUPNPAT(DFN)
 ;
 ; full Registration access - first display page 11
 D DISPLY11
 Q:'$$READ^BDGF("Y","Want to Edit this Registration Record","NO")
 ;
 ;IHS/OIT/LJF 09/08/2006 PATCH 1006 cleaned up code to only call PEP
 ;D ^AGVAR S X="AGEDIT" D HDR^AG
 ;I $D(AGOPT(14)) D PATNLK^AGEDIT
 D PATNLK^AGEDIT
 Q
 ;
DISPLAY ; display address info only
 NEW BSDR
 D ENP^XBDIQ1(2,DFN,".111;.114:.116;.1219;.131;.132","BSDR(")
 W !!?5,"Date of Last Registration Update: ",$$GET1^DIQ(9000001,DFN,.03)
 W !!,BSDR(.111),!,BSDR(.114),", ",BSDR(.115),"  ",BSDR(.116)
 W !,BSDR(.131)," (home)  ",BSDR(.132)," (work)"
 I BSDR(.1219)]"" W !,BSDR(.1219)," (msg)",!!
 Q
 ;
DISPLY11 ; display page 11 - other info
 NEW X
 W !!?3,$$REPEAT^XLFSTR("*",70)
 W !?5,"Date of Last Registration Update: ",$$GET1^DIQ(9000001,DFN,.03)
 W !!?5,"Additional Registration Information:"
 S X=0 F  S X=$O(^AUPNPAT(DFN,13,X)) Q:'X  D
 . W !?7,^AUPNPAT(DFN,13,X,0)
 W !?3,$$REPEAT^XLFSTR("*",70),!
 Q
 ;
ADDRESS ;EP; edit address only  ;IHS/OIT/LJF 7/22/2005 PATCH 1004
 D DISPLAY
 Q:'$$READ^BDGF("Y","Does patient's address or phone # need to be updated","NO")
 ;
NEWADD ;EP; called by mini-registration to add address
 L +^AUPNPAT(DFN):3 I '$T D  Q
 . W !,*7,"Patient Entry being updated by another; try again soon."
 . D PAUSE^BDGF
 ;
 NEW DR,SDQUIT,SDPOST,SDPRE,DIE,DA
ST ; -- mailing address-street
 S DR=.111 D PRESAVE,EDIT(2),POSTCK Q:$D(SDQUIT)
 ;
CITY ; -- mailing address-city
 S DR=.114 D PRESAVE,EDIT(2),POSTCK
 I SDPOST'=SDPRE D NOTE
 Q:$D(DUOUT)
 ;
STATE ; -- mailing address-state
 S DR=.115 D PRESAVE,EDIT(2),POSTCK Q:$D(SDQUIT)
 ;
ZIP ; -- mailing address-zip
 S DR=.116 D PRESAVE,EDIT(2),POSTCK Q:$D(SDQUIT)
 ;
HPH ; -- home phone number
 S DR=.131 D PRESAVE,EDIT(2),POSTCK Q:$D(SDQUIT)
 ;
WPH ; -- work phone number
 S DR=.132 D PRESAVE,EDIT(2),POSTCK Q:$D(SDQUIT)
 ;
MPH ; -- message phone number
 ;S DR=".1219T" D PRESAVE,EDIT(2),POSTCK  ;cmi/maw 2/23/2008 PATCH 1009 orig line
 S DR="1801" D PRESAVEA,EDIT(9000001),POSTCKA  ;cmi/maw 2/23/2008 PATCH 1009 to update OTHER PHONE field in 9000001
 W !!
 Q
 ;
PRESAVE ; -- returns before value of data
 S SDPRE=$$GET1^DIQ(2,DFN,DR)
 Q
 ;
PRESAVEA ; -- returns before value of data
 S SDPRE=$$GET1^DIQ(9000001,DFN,DR)
 Q
 ;
POSTCK ; -- returns new value of data & sets ^agpatch if needed
 NEW X
 S SDPOST=$$GET1^DIQ(2,DFN,DR) I SDPOST=SDPRE Q
 S X="NOW" D ^%DT S ^AGPATCH(Y,DUZ(2),DFN)=""
 Q
 ;
POSTCKA ; -- returns new value of data & sets ^agpatch if needed
 NEW X
 S SDPOST=$$GET1^DIQ(9000001,DFN,DR) I SDPOST=SDPRE Q
 S X="NOW" D ^%DT S ^AGPATCH(Y,DUZ(2),DFN)=""
 Q
 ;
EDIT(FILE) ; -- edits field
 S DIE=FILE,DA=DFN W ! D ^DIE S:$D(Y) SDQUIT=""
 Q
 ;
NOTE ;
 W !!?24,"Mailing address-city has changed."
 W !?9,"Please check to see if Community of Residence has changed also."
 W !!?20,"If Community of Residence has changed,"
 Q
 ;
