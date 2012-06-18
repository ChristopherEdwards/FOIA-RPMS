BTIUHELP ; IHS/ITSC/LJF - On-line help library ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;IHS/ITSC/LJF 05/07/2003 copy of TIUHELP with code fixed so actually quits when user asks to quit
 ;
PROTOCOL ;EP; Help for protocols
 N DIRUT,DTOUT,DUOUT,TIUX,ORU,ORUPRMT,VALMDDF,VALMPGE S TIUX=X
 NEW BTIUSTOP S BTIUGO=1
 D FULL^VALM1
 I TIUX="?"!(TIUX="??") D  G PROTX
 . I TIUX="??",($G(VALMAR)="^TMP(""TIUR"",$J)") D STATUS I BTIUGO=0 W ! Q
 . D DISP^XQORM1 W !!,"Enter selection by typing the name, or abbreviation.",!,"Enter '??' or '???' for additional details.",!
 . I TIUX="?" W:$$STOP^TIUU ""
 I TIUX="???" D MENU(XQORNOD) I $D(DIROUT) S (XQORQUIT,XQORPOP)=1 Q
PROTX S VALMBCK="R"
 Q
MENU(XQORNOD) ; Unwind protocol menus for help
 N TIUSEQ,TIUI,TIUJ D CLEAR^VALM1
 Q:'$$CONTINUE  W "Valid selections are:",!    ;IHS/ITSC/LJF 02/26/2003
 S TIUI=0 F  S TIUI=$O(^ORD(101,+XQORNOD,10,TIUI)) Q:+TIUI'>0  D
 . S TIUJ=+$P($G(^ORD(101,+XQORNOD,10,TIUI,0)),U,3) S:$D(TIUSEQ(TIUJ)) TIUJ=TIUJ+.1
 . S TIUSEQ(TIUJ)=+$P(^ORD(101,+XQORNOD,10,TIUI,0),U)
 S TIUI=0 F  S TIUI=$O(TIUSEQ(TIUI)) Q:+TIUI'>0!$D(DIRUT)  D
 . I $D(^ORD(101,+TIUSEQ(TIUI),0)) D ITEM(+TIUSEQ(TIUI),1)
 Q
ITEM(XQORNOD,TAB) ; Show descriptions of items
 N TIUI
 Q:$P($G(^ORD(101,+XQORNOD,0)),U,2)']""
 W ?+$G(TAB),$G(IOINHI),$$UPPER^TIULS($P($G(^ORD(101,+XQORNOD,0)),U,2)),$G(IOINORM),!
 S TIUI=0 F  S TIUI=$O(^ORD(101,+XQORNOD,1,TIUI)) Q:+TIUI'>0  Q:'BTIUGO  D
 . S BTIUGO=$$CONTINUE Q:'BTIUGO  W ?(TAB+2),$G(^ORD(101,+XQORNOD,1,TIUI,0)),!
 S TIUI=0 F  S TIUI=$O(^ORD(101,+XQORNOD,10,TIUI)) Q:+TIUI'>0  D
 . D ITEM(+$G(^ORD(101,+XQORNOD,10,+TIUI,0))_";ORD(101,",3)
 Q
STATUS ; Show status descriptions
 W !!,"The Following Statuses are defined:"
 D STATEXP Q:'BTIUGO
 W !!,"The Following Indicators are defined:",!!
 W " '+' to the left of the Title or Patient's name indicates that",!,"     a report has addenda.",!
 W " '*' to the left of the Title or Patient's name indicates",!,"     a priority (STAT) document.",!
 W " '<' to the left of the Title or Patient's name indicates an",!,"     interdisciplinary note, which can be expanded to show entries.",!
 W " '>' to the left of the Title or Patient's name indicates",!,"     that the note is an entry of an interdisciplinary note.",!
 S BTIUGO=$$CONTINUE
 Q
CONTINUE() ; Pagination control
 N Y
 I $Y<(IOSL-2) S Y=1 G CONTX
 S Y=$$STOP^TIUU("",1) W:+Y @IOF,!
CONTX Q Y
 ;
STATEXP ; Explain Statuses
 N TIUI,TIUJ,TIUY S TIUI=0
 D STATUS^TIUSRVL(.TIUY,"ALL",1)
 S BTIUGO=$$CONTINUE Q:BTIUGO=0
 F  S TIUI=$O(TIUY(TIUI)) Q:+TIUI'>0  Q:'BTIUGO  D
 . I TIUI>1 W !
 . W !,$G(IOINHI),$P(TIUY(TIUI),U,2),$G(IOINORM)
 . S BTIUGO=$$CONTINUE Q:BTIUGO=0
 . S TIUJ=0 F  S TIUJ=$O(TIUY(TIUI,1,TIUJ)) Q:+TIUJ'>0  Q:'BTIUGO  D
 . . W !?2,$G(TIUY(TIUI,1,TIUJ))
 . . S BTIUGO=$$CONTINUE
 Q
