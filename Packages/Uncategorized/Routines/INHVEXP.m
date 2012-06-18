INHVEXP ;BAR ; 24 Nov 95 15:02; PRINT EXCEPTIONS BETWEEN INH MAP AND LOCAL DATA
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN ;Main entry point
 ;NEW statements
 N %ZIS,A,INEXIT,INHDR,INPAGE,X,ZTDESC,ZTIO,ZTRTN,ZTSAVE,INSYS,INOSYS,K,INFUNC,INFUNCN,INRECID,INDA,INDIC,INGL,INDE,X,N,F
 S U="^" K ^UTILITY($J)
ENUSE ;User input
 ;Setup FileMan
 D ENV^UTIL
 ;System Check and verify by user
 ; INSYS = current system
 ; INOSYS = other system
 S INSYS=$$SYS^INHUTIL1()
 I '$L(INSYS) W *7,!!,"Sorry, I don't know what kind of system we're on.",! G QUIT
 W !!," I think this is a ",$$SYSNAME^INHUTIL1(INSYS)," system"
 ;Standard reader
 S Y=$$YN^UTSRD("Do you want to continue? ;1","") G:'+Y QUIT
 S INOSYS=$S(INSYS="SC":"VA",1:"SC")
 ;
 ;Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ",%ZIS("RM")="S^132" D ^%ZIS G:POP QUIT
 S IOM=132,IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) S ZTDESC="Map File Exception Report",ZTIO=IOP,ZTRTN="ENQUE^INHVEXP" D  G QUIT
 .F X="IN*","IO*" S ZTSAVE(X)=""
 .D ^%ZTLOAD
 ;
ENQUE ;Taskman entry point
 ;
 ;*********************************************************
 ;Main loop thru 4090.1 x-ref
 N ND S ND="^INVD(4090.1,INSYS)"
 F  S ND=$Q(ND) Q:$QS(ND,2)'=INSYS  D
 .S INFUNC=$QS(ND,3),INRECID=$QS(ND,4),INDA=$QS(ND,5),BRCT=0
 .D FUNC
 .Q:INRECID=""
 .S INEX=0 D RECID
 .Q:INDA=""
 .D DA
 .K:INEX'>1 ^UTILITY($J,"EX",INFUNC,INRECID)
 .D:$L(INGL) LF
 ;initialize print variables
 S INPAGE=0,INEXIT=0,IOM=132
 D HSET,HEADER
 ;
 ;Loop thru ^UTILITY file and print
 S ND="^UTILITY($J,""MF"")",L=1
 F  S ND=$Q(@ND) Q:$QS(ND,2)'="MS"  D
 .S N=5,X=^(INFUNC),INFUNC=$QS(ND,3),INRECID=$QS(ND,4),INDA=$QS(ND,5),A=$QS(ND,6)
 .D WRITE
 .S N=10,X=$G(^(INRECID)) D:$L(X) WRITE
 .I INDA'="" S N=1,X=INDA_"     "_INRECID_"     "_$P($G(^INVD(4090.1,INDA,0)),"^",1) D WRITE
 .S L=0,N=$S($X<30:30,1:$X+2)
 .I A'="" S X=^UTILITY($J,"MF",INFUNC,INRECID,INDA,A) D:$L(X) WRITE
 .;Write out NON EXCLUDE conflicts
 .D:$D(^UTILITY($J,"EX",INFUNC)) WRITEE
 .;Call to output data pointer exceptions
 .D:$D(^UTILITY($J,"LF",INFUNC)) WRITEL
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0)) R !,"Press <RETURN> to continue ",A:DTIME
 E  W !!,"*** End Of Report ***",!,IOF
 G QUIT
 ;
 ;*********************************************************
FUNC ;Verify map function exists and log error if not
 S INFUNCN=$P($G(^INVD(4090.2,INFUNC,0)),"^",1),INDIC=$G(^INVD(4090.2,INFUNC,INSYS)),INGL=""
 I '$L(INFUNCN) S ^UTILITY($J,"MF",INFUNC)="Map function "_INFUNC_" not defined and contains the following entries:" Q
 S ^UTILITY($J,"MF",INFUNC)="Map function "_INFUNC_" - "_INFUNCN_$S(+INDIC:" (file)",1:" (non-file)")
 Q:'+INDIC
 S INGL=$G(^DIC(INDIC,0,"GL"))
 I '$L(INGL) S ^UTILITY($J,"MF",INFUNC,0)="File #"_INDIC_" does not have a ""GL"" reference in ^DIC"
 Q
 ;
RECID ;Processing at INRECID loop
 ;Quit if not a file reference
 S INDE="" Q:'+INDIC
 ;returns data element of function type - INDE
 ;set quotes around INRECID in case it's not a number
 S T=$C(34)_INRECID_$C(34) S INDE=$G(@(INGL_T_",0)"))
 Q
 ;
DA ;DA MODULE - STARTS HERE
 ;Init INDAVD - DA VALIDATION FLAG
 ;Verify ien exists in 4090.1 and log error if not
 I '($D(^INVD(4090.1,INDA,0))#2) S ^UTILITY($J,"MF",INFUNC,INRECID,INDA,0)="Record does not exist in file 4090.1" Q
 ;
 ;Record valid records if INFUNC is invalid
 I '$L(INFUNCN) S ^UTILITY($J,"MF",INFUNC,INRECID,INDA,0)="Exists under undefined map function  "_INFUNC
 ;
 ;Verify map function number matches x-ref map function
 S X=$P(^INVD(4090.1,INDA,0),"^",2) I X'=INFUNC D
 .S N=$P($G(^INVD(4090.2,X,0)),"^",1)
 .S ^UTILITY($J,"MF",INFUNC,INRECID,INDA,1)="Map function no. "_X_"-"_N_" does not match x-ref map no. "_INFUNC_"-"_INFUNCN
 ;
 ;Validate INRECID
 I +INDIC,'$L(INDE) S INDE=$G(@(INGL_(+INRECID)_",0)")) I $L(INDE) S ^UTILITY($J,"MF",INFUNC,INRECID,INDA,2)=INSYS_" Record ID """_INRECID_""" is not fully numeric but info was found under """_(+INRECID)_""""
 ;
 ;Verify record id number matches record id (INRECID)
 S X=$G(^INVD(4090.1,INDA,$S(INSYS="SC":1,1:10))) I X'=INRECID S ^UTILITY($J,"MF",INFUNC,INRECID,INDA,3)="Data element record id "_X_" does not match with x-ref id "_INRECID
 ;
 ;Verify data name matches data element name
 I +INDIC S X=$G(^INVD(4090.1,INDA,$S(INSYS="SC":2,1:11))),Y=$P(INDE,"^",1) I X'=Y,$D(^DD(INDIC,.01,0))#2 S C=$P(^DD(INDIC,.01,0),U,2) D Y^DIQ
 I +INDIC,X'=Y S ^UTILITY($J,"MF",INFUNC,INRECID,INDA,4)="Data element name "_X_" does not match with file entry "_Y
 ;
 ;Setup exclude array - INEX is non-exclude counter
 S ^UTILITY($J,"EX",INFUNC,INRECID,INDA)=+$G(^INVD(4090.1,INDA,$S(INSYS="SC":3,1:12)))
 I '+^(INDA) S INEX=INEX+1,^UTILITY($J,"LFX",INFUNC,INRECID)=""
 Q
 ;
 ;*********************************************************
LF ;Check each data element points to a valid NOT EXCLUDE reference
 S X=0 F  S X=$O(@(INGL_X_")")) Q:'+X  I '$D(^UTILITY($J,"LFX",INFUNC,X)) S ^UTILITY($J,"LF",INFUNC,X)="Data element "_X_" - "_$P($G(@(INGL_X_",0)")),"^",1)_" does not have data pointing to it"
 Q
 ;*********************************************************
 ;
HEADER ;output header in local array INHDR(x)
 N A
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0))&(INPAGE>0) R !,"Press <RETURN> to continue ",A:DTIME I A[U S INEXIT=1 Q
 S INPAGE=INPAGE+1 W @IOF
 S A=0 F  S A=$O(INHDR(A)) Q:'A  U IO W !,@INHDR(A)
 Q
 ;
WRITE ;output a line
 I ($Y>(IOSL-3))&(INPAGE>0)&(L) D HEADER
 Q:INEXIT
 I L W !,?N,X Q
 K F D FORMAT^UTIL(X,(132-N),"F") W ?N,F(1) F F=2:1 Q:'$D(F(F))  W !?N,F(F)
 S L=1 Q
 ;
WRITEE ;output exclude problems
 S N=5,L=1,X="These multiple NOT EXCLUDE's exist:" D WRITE
 ;
 S N=3,INRECID="" F  S INRECID=$O(^UTILITY($J,"EX",INFUNC,INRECID)) Q:INRECID=""  D
 .S INDA="" F  S INDA=$O(^UTILITY($J,"EX",INFUNC,INRECID,INDA)) Q:INDA=""  I '^(INDA) S X="Local file "_INDA_" of "_INSYS_" record id "_INRECID_" is not excluded" D WRITE
 Q
 ;
WRITEL ;Output data exceptions
 S N=5,L=1,X="These records do not have data pointing to them:" D WRITE
 S N=3,INRECID="" F  S INRECID=$O(^UTILITY($J,"LF",INFUNC,INRECID)) Q:INRECID=""  S X=^(INRECID) D WRITE
 Q
 ;
HSET ;set up header
 S Y=DT D DD^%DT
 S INHDR(1)="""Interface Exception Report for "_$$SYSNAME^INHUTIL1(INSYS)_" System"",?(IOM-22),"""_Y_" PAGE: "",INPAGE"
 S INHDR(2)=""" File # / Record ID / Name     Exception Description"""
 S INHDR(4)="",$P(INHDR(4),"-",IOM-1)="",INHDR(4)=""""_INHDR(4)_""",!"
 Q
 ;
QUIT ;exit module
 D ^%ZISC
 S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP
 K ^UTILITY($J)  ;CLEAN UP UTIL GLOB
 Q
 ;
