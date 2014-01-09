BCSVMR2 ;IHS/MSC/PLS - CSV Mapping Report;28-Jul-2008 12:55;AA
 ;;1.0;BCSV;;APR 23, 2010
 ;=================================================================
 Q
EN ; EP - Generate mapping status report.
 N POP,UNMAPF,MAPF
 W !,"Mapping Report for Code Set Versioning Project - Phase One",!!
 D ENVCHK
 D PARAM
 D DEVICE
 Q:POP
 D TASK
 Q
 ;
TASK ;EP
 N ZTRTN,ZTDTH,ZTDESC
 S ZTRTN="OUTPUT^BCSVMR2"
 I $G(IO("Q")) D
 .S ZTDTH=$H
 .S ZTDESC="CSV Field Mapping Report"
 .S ZTIO=ION
 .S ZTSAVE("UNMAPF")="",ZTSAVE("MAPF")=""
 .D ^%ZTLOAD
 E  D @ZTRTN
 D ^%ZISC
 Q
 ; Generate report
OUTPUT ;
 N SIZE,FLAGQ,FLAGP,FLAGE,FIL,LP,DLM,DDLM,EFLG,OFF,SRC,TRG
 N DASH,DOT,EQUAL,RPTDATE,Z1,ARW
 S SIZE=IOSL-5,FLAGP=1,ARW="=>"
 D INIT^BCSVMP
 S $P(DASH,"-",212)=""
 S $P(DOT,".",106)=""
 S $P(EQUAL,"=",212)=""
 F  D  Q:$G(EFLG)!$G(FLAGE)
 .S FIL=$$NXTFIL^BCSVMP(.OFF)
 .I $P(FIL,DDLM,2)="" S EFLG=1 Q
 .S FLAGQ=0
 .D SETFILE^BCSVMP($P(FIL,DDLM,2),.SRC,.TRG)
 .D PT(SRC("NUM"),SRC("FNAM"))
 .S HD="" D PAGE
 Q
 ; Returns status of environment
ENVCHK Q
 ; Collects parameters
PARAM ;
 S UNMAPF=1,MAPF=1
 W !,"WARNING:  Printing mapped items will consume a lot of paper",!
 S UNMAPF=$$YN^BCSVMP("N","Include list of unmapped items")
 S MAPF=$$YN^BCSVMP("N","Include list of mapped items")
 I MAPF=1 D
 .K RPTTYP
 .N DIR,Y
 .S DIR(0)="S^A:AUTOMAPPED;M:MANUALLY MAPPED;B:BOTH"
 .S DIR("B")="B"
 .S DIR("A")="What do you want to include"
 .D ^DIR
 .S RPTTYP=Y
 W !
 Q
 ; Prompts for output device
DEVICE ;
 N %ZIS
 S %ZIS="Q",%ZIS("A")="Select device for mapping report: "
 D ^%ZIS
 Q
 ; Pointers to the file
PT(FNUM,FNAM) ;EP
 N FILE,FLD,ZGL,ZCNT,FILEN,ZFILE,ZGLCNT	
 S ZGL=^DIC(FNUM,0,"GL")
 ;S ZGLCNT=$G(@(ZGL_"0)")),ZGLCNT=$S($P(ZGLCNT,U,4)]"":$P(ZGLCNT,U,4),1:"No Entries")
 S ZGLCNT=$$GLOBCNT(ZGL) I 'ZGLCNT S ZGLCNT="No Entries"
 D INIT7 G:FLAGQ EX D HDRP S FILE="",ZCNT=1,HD="HDRP"
 I '$D(^DD(FNUM,0,"PT")) W ?30,"No files point to the "_FNAM_" file." Q
 F  S FILE=$O(^DD(FNUM,0,"PT",FILE)) Q:FILE=""!FLAGQ  D
 .S FLAGPT=0 D @$S($D(^DIC(FILE,0)):"PTYES",1:"PTNO")
 .I 'FLAGPT S FLD="" F  S FLD=$O(^DD(FNUM,0,"PT",FILE,FLD)) Q:FLD=""  D  Q:FLAGQ!$G(FLAGE)
 ..D PTPRT Q:FLAGQ
 S HD="" D PAGE
 I '$G(FLAGE)&'FLAGQ D
 .D:UNMAPF UNMAP(SRC("GNAM"))
 .Q:$G(FLAGE)!FLAGQ
 .D PAUSE
 .Q:$G(FLAGE)!FLAGQ
 .D:MAPF MAP(SRC("GNAM"))
 K FLAGPT
 Q
 ; Get true global entry count
GLOBCNT(GBL) ;
 N LOOP,IEN,GCNT
 S GCNT=0
 S LOOP=GBL_"IEN)"
 S IEN=0 F  S IEN=$O(@LOOP) Q:'IEN  D
 .S GCNT=GCNT+1
 Q GCNT
PTNO ;
 I '$D(^DD(FILE,0,"UP")) S FLAGPT=1 Q
 S FILETP=FILE F  S FILETP=^DD(FILETP,0,"UP") Q:$D(^DIC(FILETP,0))  I '$D(^DD(FILETP,0,"UP")) Q
 I '$D(^DIC(FILETP,0)) S FLAGPT=1 Q
 S GL=^DIC(FILETP,0,"GL"),FILEN=$P(^DIC(FILETP,0),U)
 Q
PTYES S GL=^DIC(FILE,0,"GL"),FILEN=$P(^DIC(FILE,0),U)
 Q
PTPRT ;
 N KNWPTR
 S KNWPTR=$S($$KNWNPTR^BCSVMP(TRG("GNAM"),FILE,FLD):" ",1:"#")
 W !,$J(ZCNT,4),".",?6,GL,?21,$E(FILEN,1,25)
 W ?47 I $D(^DD(FILE,FLD,0)),$P(^(0),U)]"" W KNWPTR_$E($P(^(0),U),1,22)," (",FLD,")"
 E  W "--> Field ",FLD," does not exist."
 S ZCNT=ZCNT+1 I $Y>SIZE D PAGE
 Q
 ; Output unmapped items
UNMAP(FIL) ;
 N SIEN,GLBP,SOURCE,I
 D HDRU S HD="HDRU"
 S GLBP=$S(FIL="AUTTCMOD":$$GLBPATH^BCSVMP(TRG("GNAM"),"UNMAP"),1:$$GLBPATH^BCSVMP(SRC("GNAM"),"UNMAP"))
 I '$$MAPCNT^BCSVMP($S(FIL="AUTTCMOD":TRG("GNAM"),1:SRC("GNAM")),"UNMAP") W !,"There are no unmapped entries." Q
 S SIEN=0 F  S SIEN=$O(@GLBP@(SIEN)) Q:'SIEN  D  Q:FLAGQ
 .Q:$$PSTCSVCD(SIEN)=1  ;IHS/SD/SDR 4/14/09
 .S SDESC=$$GDESC^BCSVMP("S",SRC("NUM"),+SIEN,SRC("DFLD"),1)
 .D BLDARY("SOURCE",SDESC)
 .W !,?2,"*"
 .S I=0 F  S I=$O(SOURCE(I)) Q:'I  D
 ..W ?4,$G(SOURCE(I)) I $O(SOURCE(I)) W !
 .D INAFLAG(SIEN)
 .I $Y>SIZE D PAGE Q:FLAGQ
 .W !
 Q
 ;start new code IHS/SD/SDR 4/14/09
 ;check if code was added after 10/1/08; if so, skip it
PSTCSVCD(SIEN) ;
 ;CPT
 S BCSVF=0
 I SRC("NUM")=81 D
 .I $$VERSION^XPDUTL("BCSV")>0 D
 ..I $P($G(^ICPT(SIEN,9999999)),U,6)>3080930 S BCSVF=1
 .I +$$VERSION^XPDUTL("BCSV")=0 D
 ..I $P($G(^ICPT(SIEN,0)),U,6)>3080930 S BCSVF=1
 ;ICD0
 I SRC("NUM")=80.1 D
 .I $P($G(^ICD0(SIEN,9999999)),U,4)>3080930 S BCSVF=1
 ;ICD9
 I SRC("NUM")=80 D
 .I $P($G(^ICD9(SIEN,9999999)),U,4)>3080930 S BCSVF=1
 Q BCSVF
 ;end new code 4/14/09
 ;start new code 6/25/09
INAFLAG(SIEN) ;
 ;CPT
 I +$G(SIEN)=0 Q
 S SIFLG=0
 I SRC("NUM")=81 D
 .S SIFLG=$$GET1^DIQ(81,SIEN,7,"I")
 ;ICD0
 I SRC("NUM")=80.1 D
 .S SIFLG=$$GET1^DIQ(80.1,SIEN,102,"I")
 ;ICD9
 I SRC("NUM")=80 D
 .S SIFLG=$$GET1^DIQ(80,SIEN,102,"I")
 ;
 I SIFLG W " (INACTIVE)"
 Q
 ;end new code 6/25/09
 ; Output mapped items  IHS === VA
MAP(FIL) ;
 N SIEN,TIEN,GLBP,SOURCE,TARGET,I
 D HDRM S HD="HDRM"
 ;S GLBP=$$GLBPATH^BCSVMP(SRC("GNAM"),"MAP")
 S GLBP=$S(FIL="AUTTCMOD":$$GLBPATH^BCSVMP(TRG("GNAM"),"MAP"),1:$$GLBPATH^BCSVMP(SRC("GNAM"),"MAP"))
 ;I '$$MAPCNT^BCSVMP(SRC("GNAM"),"MAP")	W !,"There are no mapped entries." Q
 I '$$MAPCNT^BCSVMP($S(FIL="AUTTCMOD":TRG("GNAM"),1:SRC("GNAM")),"MAP") W !,"There are no mapped entries." Q
 S SIEN=0 F  S SIEN=$O(@GLBP@(SIEN)) Q:'SIEN  D  Q:FLAGQ
 .I ($G(RPTTYP)="A"!($G(RPTTYP)="M"))&($P($G(@GLBP@(SIEN)),U,2)'=RPTTYP) Q  ;only do auto/manually mapped
 .S SDESC=$$GDESC^BCSVMP("S",SRC("NUM"),+SIEN,SRC("DFLD"),1)
 .S TDESC=$$GDESC^BCSVMP("T",$$GLBPATH^BCSVMP(TRG("GNAM"),"DATA"),+@$$GLBPATH^BCSVMP(TRG("GNAM"),"MAP")@(+SIEN),TRG("DFLD"),1)
 .;I $L(SDESC)>30 D
 .;.W !,?2,SDESC,?35,ARW
 .;.I $Y>SIZE D PAGE Q:FLAGQ
 .;.W !,?10,TDESC
 .;E  W !,?2,SDESC,?46,TDESC
 .D BLDARY("SOURCE",SDESC)
 .W !,?1,"*"
 .S I=0 F  S I=$O(SOURCE(I)) Q:'I  D
 ..W ?4,$G(SOURCE(I)) I $O(SOURCE(I)) W !
 .W " ("_$P($G(@GLBP@(SIEN)),U,2)_")"
 .D BLDARY("TARGET",TDESC)
 .W !,ARW
 .S I=0 F  S I=$O(TARGET(I)) Q:'I  D
 ..W ?4,$G(TARGET(I)) I $O(SOURCE(I)) W !
 .I $Y>SIZE D PAGE Q:FLAGQ
 .W !
 Q
 ; Input  ARY - name of array where to store data
 ;        DESC - description as gathered from $$GDESC^BCSVMP
BLDARY(ARY,DESC) ;
 N WORD,STRING,I,LINE,NDESC
 K @ARY
 S STRING="",LINE=1
 I $L(DESC)<70 S @ARY@(LINE)=DESC Q
 S NDESC=$P(DESC,"  ")_" // "_$P(DESC,"  ",2),DESC=NDESC
 F I=1:1  D  Q:'$L(WORD)
 .S WORD=$P(DESC," ",I)
 .I '$L(WORD),$L(STRING)>0 S @ARY@(LINE)=$G(STRING) Q
 .Q:WORD="//"
 .I ($L(STRING)+$L(WORD)+1<70)!($L(STRING)+$L(WORD)+1=70) D  Q
 ..S STRING=$G(STRING)_$S($L(STRING)=0:"",1:" ")_WORD
 .E  D
 ..S @ARY@(LINE)=$G(STRING),LINE=LINE+1,STRING=""
 .I ($L(WORD)<70)!($L(WORD)=70) S STRING=WORD Q
 .E  D
 ..S @ARY@(LINE)=$E(WORD,1,70),LINE=LINE+1
 ..S @ARY@(LINE)=$E(WORD,71,140),LINE=LINE+1
 ;I DESC["NON-INVASIVE PERIPHERAL VASCULAR DIAGNOSTIC STUDIES" S A=B
 Q
HDR ;
 W @IOF Q:'FLAGP  W:IO'=IO(0) !!
 I '$D(RPTDATE) S RPTDATE=$$FMTE^XLFDT($$DT^XLFDT(),"2Z")
 W !,$E(EQUAL,1,IOM)
 W !?2,"File:---- ",FNAM," (",FNUM,")"
 W !?2,"Global:-- ",ZGL,?(IOM-17),"Date: ",RPTDATE
 W !?2,"Total Entries: ",ZGLCNT,?30,"Mapped: ",$$MAPCNT^BCSVMP(TRG("GNAM"),"MAP"),?50,"Unmapped: ",$$MAPCNT^BCSVMP(TRG("GNAM"),"UNMAP")
 W !,$E(EQUAL,1,IOM),!
 Q
HDRP ;
 W !?3,"Pointers TO the "_FNAM_" ("_FNUM_") file.."
 W !?5,"A # indicates that the field is a LOCAL pointer."
 W !?9,"GLOBAL",?22,"FILE  (Truncated to 25)",?50,"FIELD   (Truncated to 22)"
 W !?6,"-------------",?21,"-------------------------",?48,"------------------------------"
 Q
HDRU ; Unmapped items header
 W @IOF Q:'FLAGP  W:IO'=IO(0) !!
 W !,$E(EQUAL,1,IOM)
 W !,"The following entries have not been mapped to the VA codes."
 W !,"  IHS Value"
 W !,$E(EQUAL,1,IOM),!
 Q
HDRM ; Mapped Items header
 W @IOF Q:'FLAGP  W:IO'=IO(0) !!
 W !,$E(EQUAL,1,IOM)	
 W !,"The following items are mapped."
 W !," * IHS Value"
 W !," => VA Value"
 W !,$E(EQUAL,1,IOM),!
 Q
PAGE ;
 Q:FLAGQ
 N I F I=$Y:1:SIZE W !
 I FLAGP,IO'=IO(0)!($D(ZTQUEUED)) W @IOF,!!! D:HD'="" @HD Q
 R !!?2,"<RETURN> to continue, '^' to quit, '^^' to exit: ",Z1:DTIME
 S:'$T Z1=U
 I Z1[U S FLAGQ=1 S:Z1="^^" FLAGE=1
 W:'$G(FLAGE) @IOF
 Q:FLAGQ!($D(FLAGE))
 D:$L(HD) @HD
 Q
PAUSE ;
 ;
 Q
INIT7 ;
 ;I FLAGP,IO=IO(0),IOSL>25,IOST["C-" D SCROLL Q:FLAGQ
 I FLAGP U IO ;W:IO'=IO(0) "Printing.."
 D HDR Q
EX ;	
 K FLAGPT,^UTILITY($J,"GROUP")
 Q
SCROLL ;Adjust scroll rate
 W !!?8,"SCROLLING:  [N]ormal  [S]mooth . . . . ","Select: N//"
 R SCROLL:DTIME S:'$T SCROLL="^" S SCROLL=$E(SCROLL) I SCROLL="^" S FLAGQ=1 Q
 I SCROLL="?" W !?8,"Since you're printing to your CRT and you've asked for a page",!?8,"length greater than 25, you may now adjust the scroll rate.",!?8,"For DEC VT-100 compatible devices only." G SCROLL
 S:SCROLL="" SCROLL="N" Q:"S,s"'[SCROLL  S FLAGS=1 W *27,"[?4h"
 Q
