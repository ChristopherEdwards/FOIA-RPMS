ASDREG ; IHS/ADC/PDW/ENM - REG EDITS ALLOWED FROM SCHEDULING ;  [ 12/21/1999  2:31 PM ]
 ;;5.0;IHS SCHEDULING;**3,4**;MAR 25, 1999
 ;PEP; called by AMER1 to edit full registration
 ;
 S SDSTOP=$O(^DIC(19,"B","AGEDIT",0))
 I SDSTOP'="",$P(^DIC(19,SDSTOP,0),"^",3)'="" K SDSTOP Q
 K SDSTOP
 ;
 K DIE("NO^"),SDQUIT
 ;
EDITYP ; -- check user for edit type to use
 NEW ASDREG
 S ASDREG=$$VALI^XBDIQ1(40.8,$$DIV^ASDUT,9999999.09)
 I 'ASDREG D DISPLAY Q
 I $D(^XUSEC("SDZREGEDIT",DUZ)),ASDREG>1 D  D END Q
 . D DISREG K DIR S DIR(0)="Y",DIR("B")="NO"
 . S DIR("A")="WANT TO EDIT REGISTRATION RECORD" D ^DIR K DIR
 . Q:Y=0  I Y'=1 S ASDQUIT="" Q
 . L +^AUPNPAT(DFN):3 I '$T D  Q
 .. W !,*7,"PATIENT ENTRY LOCKED; TRY AGAIN SOON"
 . S DIE=9000001,DA=DFN,DR=".14" D ^DIE L -^AUPNPAT(DFN)
 . D ^AGVAR S X="AGEDIT" D HDR^AG,DISPAT
 . I $D(AGOPT(14)) D PATNLK^AGEDIT ;IHS/DSD/ENM 12/21/99 RESET TO ORIG CODE. PATCH 2 CHANGE WAS INCORRECT. REQUIRES AGEDIT PATCH 4
 . D ^XBCLS W !! D DISPAT W !
 ;
DISPLAY ;PEP; -- display address then ask to edit
 ; to call at PEP have DFN set and ASDREG=1
 ; if you're sure user wants to edit, set ASDOK=1
 NEW ASDR D ENP^XBDIQ1(2,DFN,".111;.114:.116;.131;.132","ASDR(")
 S X=$$VAL^XBDIQ1(9000001,DFN,.03) W !?5,$$FIELD(9000001,.03),":  ",X
 W !!,ASDR(.111),!,ASDR(.114),", ",ASDR(.115),"  ",ASDR(.116)
 W !,ASDR(.131)," (home)  ",ASDR(.132)," (work)",!!
 I 'ASDREG!(ASDREG=3) D END Q
 I '$G(ASDOK) D  I Y'=1 D END Q
 . NEW DIR S DIR(0)="Y0",DIR("B")="NO"
 . S DIR("A")="Does patient's address or phone # need to be updated"
 . D ^DIR
 ;
 L +^AUPNPAT(DFN):3 I '$T D  D END Q
 . W !,*7,"PATIENT ENTRY LOCKED; TRY AGAIN SOON"
 ;
ST ; -- mailing address-street
 S DR=.111 D PRESAVE,EDIT(2),POSTCK G END:$D(SDQUIT)
 ;
CITY ; -- mailing address-city
 S DR=.114 D PRESAVE,EDIT(2),POSTCK
 I SDPOST'=SDPRE D NOTE
 G END:$D(DUOUT)
 ;
STATE ; -- mailing address-state
 S DR=.115 D PRESAVE,EDIT(2),POSTCK G END:$D(SDQUIT)
 ;
ZIP ; -- mailing address-zip
 S DR=.116 D PRESAVE,EDIT(2),POSTCK G END:$D(SDQUIT)
 ;
HPH ; -- home phone number
 S DR=.131 D PRESAVE,EDIT(2),POSTCK G END:$D(SDQUIT)
 ;
WPH ; -- work phone number
 S DR=.132 D PRESAVE,EDIT(2),POSTCK G END:$D(SDQUIT) W !!
 ;
END ; -- eoj
 L -^AUPNPAT(DFN)
 K DA,DR,DIE,X,SDPOST,SDPRE,SDQUIT,ASDOK,ASDREG
 K AG,AGCHRT,AGLINE,AGOPT,AGPAT,AGQI,AGQT,AGSCRN,AGTP,AGUPDT
 Q
 ;
 ;
PRESAVE ; -- SUBRTN to return before value of data
 S SDPRE=$$VAL^XBDIQ1(2,DFN,DR) Q
 ;
POSTCK ; -- SUBRTN to return new value of data & set ^agpatch if needed
 NEW X
 S SDPOST=$$VAL^XBDIQ1(2,DFN,DR) I SDPOST=SDPRE Q
 S X="NOW" D ^%DT S ^AGPATCH(Y,DUZ(2),DFN)=""
 ;HL7 CALL
 S ^XTMP("AGHL7",DFN)=DFN
 Q
 ;
EDIT(FILE) ; -- SUBRTN to set variables
 S DIE=FILE,DA=DFN W ! D ^DIE S:$D(Y) SDQUIT="" Q
 ;
NOTE ;
 W !!?24,"Mailing address-city has changed."
 W !?9,"Please check to see if Community of Residence has changed also."
 W !!?20,"If Community of Residence has changed,"
 W !?9,"have patient notify admitting - it affects eligibility.",! Q
 ;
DISPAT ; displays patient name & identifiers
 NEW ASDX
 S ASDX=^DPT(DFN,0)
 W !!?3,$P(ASDX,U),?40,$P(ASDX,U,2) ;name,sex
 W ?45,$$FMTE^XLFDT($P(ASDX,U,3),2) ;dob
 W ?55,$P(ASDX,U,9) ;ssn
 W ?67,$$VAL^XBDIQ1(9999999.06,DUZ(2),.08) ;facility
 W ?69,$J($P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),7) ;hrcn
 Q
 ;
DISREG ; displays last reg update and add. info
 NEW X
 W !!?3,$$REPEAT^XLFSTR("*",70)
 S X=$$VAL^XBDIQ1(9000001,DFN,.03) W !?5,$$FIELD(9000001,.03),":  ",X
 W !!?5,"Additional Registration Information:"
 S X=0 F  S X=$O(^AUPNPAT(DFN,13,X)) Q:'X  D
 . W !?7,^AUPNPAT(DFN,13,X,0)
 W !?3,$$REPEAT^XLFSTR("*",70),!
 Q
 ;
FIELD(X,Y) ; -- returns name of field
 Q $P($G(^DD(X,Y,0)),U)
