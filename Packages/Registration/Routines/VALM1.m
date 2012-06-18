VALM1 ;ALB/MJK - Screen Malipulation Utilities ;08:17 PM  6 Dec 1992 [ 09/26/2002  11:33 AM ]
 ;;1;List Manager;**1002**;Aug 13, 1993
 ;IHS/ANMC/LJF 7/8/98 IHS PATCH #1002
 ;  -- added check for VALMWD under FULL
 ;
INSTR(STR,X,Y,LENGTH,ERASE) ; -- insert text
 ;    STR := string to insert
 ;      X := X coordinate
 ;      Y := Y coordinate
 ; LENGTH := clear # of characters
 ;  ERASE := erase chars first
 ;
 W IOSC
 I $G(ERASE) S DY=Y-1,DX=X-1 X IOXY W $J("",LENGTH)
 S DY=Y-1,DX=X-1 X IOXY W STR
 W IORC
 Q
 ;
FLDUPD(STR,FLD,LINE,CON,COFF) ; -- update entry and field on screen
 ;    STR := string to insert
 ;    FLD := col name
 ;  LINE := entry # in list
 ;
 D INSTR(.STR,+$P(VALMDDF(FLD),U,2),LINE-VALMBG+VALM("TM"),$P(VALMDDF(FLD),U,3),1)
 Q
 ;
SETFLD(STR,VAR,FLD) ; -- set field in var
 ; input: STR := string to insert
 ;        VAR := destination string
 ;        FLD := col name
 Q $$SETSTR(STR,VAR,+$P(VALMDDF(FLD),U,2),+$P(VALMDDF(FLD),U,3))
 ;
SETSTR(S,V,X,L) ; -- insert text(S) into variable(V)
 ;    S := string to insert
 ;    V := destination string
 ;    X := insert @ col X
 ;    L := clear # of chars (length)
 ;
 Q $E(V_$J("",X-1),1,X-1)_$E(S_$J("",L),1,L)_$E(V,X+L,999)
 ;
FULL ; set full scrolling region
 ;I '$D(IOSTBM) D TERM^VALM0  ;IHS PATCH #1002
 I '$D(IOSTBM)!('$D(VALMWD)) D TERM^VALM0  ;IHS PATCH #1002
 I IOSTBM]"" S IOTM=1,IOBM=IOSL W IOSC W @IOSTBM W IORC
 S X=VALMWD X ^%ZOSF("RM")
 Q
 ;
CLEAR ; -- clear screen
 D FULL,ERASE W @IOF
 Q
 ;
ERASE ;
 W $G(VALMSGR),$G(IOSGR0)
 Q
 ;
FDATE(Y) ; -- return formatted date
 ;   input:          Y := field name
 ;  output: [returned] := formatted date only
 Q $E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)
 ;
FTIME(Y) ; -- return formatted date/time
 ;   input:          Y := internal date/time
 ;  output: [returned] := formatted date and time
 D DD^%DT
 Q Y
 ;
FDTTM(Y) ; -- return formatted date/time
 ;   input:          Y := internal date/time
 ;  output: [returned] := formatted date and time
 N VALMY
 S VALMY=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)
 D DD^%DT
 Q VALMY_$S($P(Y,"@",2)]"":"@"_$P(Y,"@",2),1:"")
 ;
NOW() ; -- return now
 D NOW^%DTC
 Q $$FTIME(%)
 ;
RANGE ; -- change date range
 G RANGE^VALM11
 ;
PAUSE ;
 W ! S DIR(0)="E" D ^DIR K DIR W !
 Q
 ;
PRT ; -- prt screen (PS)
 N VALMESC
 S VALMBCK="R"
 D:VALMCC FULL
 S %ZIS="Q" D ^%ZIS G PRTQ:POP
 I '$D(IO("Q")),IO=IO(0) D CLEAR S X=0 X ^%ZOSF("RM")
 I '$D(IO("Q")) G PRTS
 S ZTRTN="PRTS^VALM1",ZTIO=ION,ZTDESC="Print Screen -- List Manager Action"
 D SAVE,^%ZTLOAD G PRTQ
 ;
PRTS ;
 N VALMCC,VALMCAP
 S VALMCC=0,VALMCAP=$$CAPTION^VALM
 U IO D HDR^VALM,TBAR^VALM,LIST^VALM,LBAR^VALM,FTR
PRTQ D:'$D(ZTQUEUED) ^%ZISC D TERM^VALM0 S X=0 X ^%ZOSF("RM")
 Q
 ;
SAVE ; -- save to queue
 F X="VALMIOXY","VALMEVL","VALMLFT","VALMPGE","VALMWD","VALMCNT","VALMBG","VALMDDF(","VALMHDR(","VALM(" S ZTSAVE(X)=""
 F X="VALMAR",$S($E(VALMAR,$L(VALMAR))=")":$E(VALMAR,1,$L(VALMAR)-1)_",",1:VALMAR_"(") S ZTSAVE(X)=""
 Q
 ;
FTR ; -- footer to print
 S VALMESC=""
 I $E(IOST,1,2)="C-" D PAUSE S VALMESC='Y
 Q
 ;
PRTL ; -- prt list (PL)
 I $G(VALM("PRT"))]"",$O(^ORD(101,"B",VALM("PRT"),0)) S X=$O(^(0))_";ORD(101," D EN^XQOR G PRTQ
 N VALMESC
 S VALMBCK="R"
 D:VALMCC FULL
 S %ZIS="Q" D ^%ZIS G PRTQ:POP
 I '$D(IO("Q")),IO=IO(0) D CLEAR S X=0 X ^%ZOSF("RM")
 I '$D(IO("Q")) G PRTLS
 S ZTRTN="PRTLS^VALM1",ZTIO=ION,ZTDESC="Print List -- List Manager Action"
 D SAVE,^%ZTLOAD G PRTLQ
 ;
PRTLS ;
 N VALMPGE,VALMESC,VALMCC,VALMI,VALMLNS,VALMCAP,VALMWD
 S VALMWD=IOM,VALMLNS=VALM("LINES")
 S VALM("LINES")=IOSL-5,VALMCC=0,VALMPGE=1,VALMCAP=$$CAPTION^VALM
 ;9/26/2002 WAR per LJF24
 ;U IO D HDR^VALM,TBAR^VALM
 U IO NEW VALMSAV S VALMSAV=VALM("HDR") S VALM("HDR")="" D HDR^VALM,TBAR^VALM S VALM("HDR")=VALMSAV     ;IHS/ANMC/LJF 7/29/2002 VALMHDR array already sen't recreate if queued
 F VALMI=1:1:VALMCNT S X=$G(@VALMAR@($$GET^VALM4(VALMI),0)) W !,X I IOSL<($Y+6) D FTR G PRTLQ:VALMESC S VALMPGE=VALMPGE+1 D HDR^VALM,TBAR^VALM
 D FTR
PRTLQ D:'$D(ZTQUEUED) ^%ZISC D TERM^VALM0 S X=0 X ^%ZOSF("RM")
 S:$D(VALMLNS) VALM("LINES")=VALMLNS
 Q
 ;
UPPER(X) ; -- convert to uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
LOWER(X) ;
 N Y,C,Z,I
 S Y=$E(X)_$TR($E(X,2,999),"ABCDEFGHIJKLMNOPQRSTUVWXYZ@","abcdefghijklmnopqrstuvwxyz ")
 F C=" ",",","/" S I=0 F  S I=$F(Y,C,I) Q:'I  S Y=$E(Y,1,I-1)_$TR($E(Y,I),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")_$E(Y,I+1,999)
 Q Y
 ;
