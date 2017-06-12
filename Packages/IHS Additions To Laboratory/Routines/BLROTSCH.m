BLROTSCH ; IHS/OIT/MKK - IHS LAB Order Test/Status CHanger; 10-Mar-2015 10:22 ; MKK
 ;;5.2;IHS Laboratory;**1034**;NOV 01, 1997;Build 88
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
EP ; EP
PEP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D BLR2VARS
 ;
 D ADDTMENU^BLRGMENU("LROSREPL^BLROTSCH","Order/Test Status Replacement")
 D ADDTMENU^BLRGMENU("LROSREST^BLROTSCH","Order/Test Status Restore")
 ;
 D MENUDRVR^BLRGMENU("RPMS Lab","Order/Test Status Utilities")
 Q
 ;
LROSREPL ; EP - LROS routine REPLacement
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$CHKOVERR("BLRLROS")="Q"
 ;
 D BLR2VARS("LROSREPL")
 ;
 S HEADER(1)="Order/Test Status Replacement"
 S HEADER(2)="With the RPMS version"
 D HEADERDT^BLRGMENU
 ;
 ;     123456789012345678901234567890123456789012345678901234567890
 W ?9,"This routine will replace the current Order/Test Status routine",!
 W ?4,"(LROS) with the RPMS routine (BLRLROS).",!!
 W ?9,"The RPMS version displays the SNOMED, UID, Clinical Indication",!
 W ?4,"as well as the order's ICD code(s).",!
 ;
 Q:$$WARNINGS("Are you sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS("Second Chance: Are you still sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS("LAST CHANCE: Do you want to do this",9)="Q"
 ;
 W !!,?4,"Very well."
 D PRESSKEY^BLRGMENU(9)
 ;
 I $D(^ROUTINE("LROSORIG"))<1 D
 . D HEADERDT^BLRGMENU
 . S X=$$ROUTINE^%R("LROS.INT",.CODE,.ERRORS,"L")
 . S RETURN=$$ROUTINE^%R("LROSORIG.INT",.CODE,.ERRORS,"BCS")
 . I +$G(RETURN)<1 D  Q
 .. W ?4,"LROS could *NOT* be saved as LROSORIG.  Error Message follows:",!
 .. W $$FMTERR^%R(.ERRORS,.CODE),!
 .. W ?4,"Routine Ends."
 .. D PRESSKEY^BLRGMENU(9)
 .. S BADSTUFF="YES"
 . ;
 . W ?4,"LROS has successfully been saved as LROSORIG"
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q:$G(BADSTUFF)="YES"
 ;
 D HEADERDT^BLRGMENU
 ;
 S X=$$ROUTINE^%R("BLRLROS.INT",.CODE,.ERRORS,"L")
 S RETURN=$$ROUTINE^%R("LROS.INT",.CODE,.ERRORS,"BCS")
 ;
 I +$G(RETURN)<1 D  Q
 . W ?4,"BLRLROS could *NOT* overwrite LROS.  Error Message follows:",!
 . W $$FMTERR^%R(.ERRORS,.CODE),!
 . W ?4,"Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 W ?4,"BLRLROS has successfully overwritten LROS."
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
LROSREST ; EP - LROS routine RESTore
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$CHKOVERR("LROSORIG")="Q"
 ;
 D BLR2VARS("LROSREPL")
 ;
 S HEADER(1)="Order/Test Status Replacement"
 S HEADER(2)="With the Original VistA version"
 D HEADERDT^BLRGMENU
 ;
 ;     123456789012345678901234567890123456789012345678901234567890
 W ?9,"This routine will replace the current Order/Test Status",!
 W ?4,"routine with the original VistA version from the VA.",!!
 W ?9,"The VistA version does *NOT* display the order's: SNOMED",!
 W ?4," code; UID; nor ICD code(s).",!
 ;
 Q:$$WARNINGS("Are you sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS("Second Chance: Are you still sure you want to do this",9)="Q"
 ;
 D HEADERDT^BLRGMENU
 Q:$$WARNINGS("LAST CHANCE: Do you want to do this",9)="Q"
 ;
 W !!,?4,"Very well."
 D PRESSKEY^BLRGMENU(9)
 ;
 D HEADERDT^BLRGMENU
 ;
 S X=$$ROUTINE^%R("LROSORIG.INT",.CODE,.ERRORS,"L")
 S RETURN=$$ROUTINE^%R("LROS.INT",.CODE,.ERRORS,"BCS")
 ;
 I +$G(RETURN)<1 D  Q
 . W ?4,"Original Vista version could *NOT* overwrite.  Error Message follows:",!
 . W $$FMTERR^%R(.ERRORS,.CODE),!
 . W ?4,"Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 ;     567890123456789012345678901234567890123456789012345678901234567890
 W ?4,"The original VistA version has successfully overwritten the current",!
 W ?4,"Order/Test status report."
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
CHKOVERR(RTN) ; EP - CHecK to make sure OVERwrite Routine exists
 I $D(^ROUTINE(RTN))<1 D  Q "Q"
 . W !!,?4,"The routine ",RTN," does NOT exist on this server."
 . W !!,?9,"Please contact IHS/OIT Lab Support."
 . D PRESSKEY^BLRGMENU(14)
 Q "OK"
 ;
 ; ============================= UTILITIES =============================
 ;
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q
 ;
BLR2VARS(TWO) ; EP
 S BLRVERN=$TR($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
 ;
WARNINGS(MSG,TAB) ; EP
 S TAB=$S(+$G(TAB):TAB,1:4)
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")=$J("",TAB)_MSG
 S DIR("B")="NO"
 D ^DIR
 Q:+$G(Y)<1!(+$D(DIRUT)) "Q"
 ;
 Q "OK"
 ;
BADSTUFF(STR,TAB) ; EP - BADSTUFF error message
 S TAB=$S($L($G(TAB))<1:4,1:TAB)
 W !!,?TAB,STR,"  Routine Ends."
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
BADSTUFN(STR,TAB) ; EP - BADSTUFF error message.  Ends with Q "" (i.e., null)
 D BADSTUFF(STR,$G(TAB))
 Q ""
 ;
BADSTUFQ(STR,TAB) ; EP - BADSTUFF error message.  Ends with Q "Q"uit
 D BADSTUFF(STR,$G(TAB))
 Q "Q"
 ;
