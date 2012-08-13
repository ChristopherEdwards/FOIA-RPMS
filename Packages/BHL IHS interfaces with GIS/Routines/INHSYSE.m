INHSYSE ;JPD;3 Sep 96;Save single file entries 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 14-APR-1997
 ;COPYRIGHT 1996 SAIC
 Q
EN ;Entry point for single element mover
 N INPOP,INRTN,INROU K ^UTILITY($J)
 S INPOP=0
 S INRTN=$$READ
 Q:INRTN=""
 D START^INHSYS09
 Q:'$D(^UTILITY($J))
 D RTNBFR(INRTN,.INROU)
 D NTRNL^INHSYS04(.INROU,$E($O(INROU(""),-1),1,6)_"W")
 Q
RTNBFR(%TT,INROU) ;routine buffer/builder machine
 ;input:
 ;  %TT   --> (required) Routine name to store data in
 ;output:
 ;  INROU --> array of compiled routines in the IB* name-space.
 ;            format: INROU(routine name)=""
 ;local:
 ;  %RTN  --> routine root name to build
 ;  %NODE --> global node result of $Q
 ;  %DATA --> string of data
 ;  INMAX --> maximum allowable routine source size
 ;  INOS  --> operating system ien
 ;  INZI  --> code to insert line into the routine directory
 ;  %ODD  --> odd numbered offset
 ;  %EVEN --> even numbered offset
 ;
 N %CC,%LC,INMAX,INOS,INZI,%RTN,%NODE,%DATA,%T,%RTNBFR,%ODD,%EVEN,%RC
 K ^UTILITY($J,0)
 S INMAX=^DD("ROU"),INOS=^("OS"),INZI=^("OS",INOS,"ZS")
 S %CC=INMAX*2,%LC=0,%RC="00",%NODE="^UTILITY($J)"
 S %RTN="IB"_$E(%TT,1,4)
 S %RTNBFR="^UTILITY(""""INHSYS"""","
 F  S %NODE=$Q(@%NODE) Q:$QS(%NODE,1)'=$J  D
 .S %DATA=@%NODE
 .I %CC+$L(%DATA)+$L(%NODE)'<INMAX D NEWR^INHSYS04
 .D LN^INHSYS04(" ;;"_%NODE,.%CC,.%LC)
 .D LN^INHSYS04(" ;;"_%DATA,.%CC,.%LC)
 I $O(^UTILITY($J,0,0)) D
 .D LN^INHSYS04(" Q",.%CC,.%LC) S X=%RTN_$S($L(%RC)=1:"0"_%RC,1:%RC) X INZI W !,X_" filed." S INROU(X)=""
 .K ^UTILITY($J,0)
 K ^UTILITY($J)
 Q
READ(INX) ;read 4 characters
 S INX=$G(INX)
 I INX="" S INX="Enter last 4 character of sir for routine name: "
 F  D  Q:'$$CHECK
 .S INRTN=$$READ^%ZTF(1,4,INX,"",13)
 Q INRTN
CHECK() ;check validity of 4 characters
 N INLN
 I INRTN="^" S INRTN="" Q 0
 Q:INRTN="" 0
 S INLN=$L(INRTN)
 I INLN,INLN<4 W !,"You must enter EXACTLY 4 characters",! Q 1
 I $D(^INRHT("ID",INRTN)) D  Q 1
 .W !,"The 4 characters you chose are the same as a unique ID"
 .W !,"Choose different characters",!
 I $F(INRTN," ") W !,"Name cannot have spaces",! Q 1
 Q 0
RESTORE(%DRVR) ;Restore data from any element
 ;Loop through PASS1 and PASS2
 N %PASS,%LFILES,AA,%SAV,DFN,INMSG
 D ENV^UTIL,^%ZIST
 S INREPRT=+$G(INREPRT)
 K ^UTILITY($J),^UTILITY("INHSYS",$J),^UTILITY("INHSYSUT",$J)
 D EN^@%DRVR
 I $D(^UTILITY("INHSYS")) F %PASS=1:1:2 D INST(%DRVR,.%PASS,INREPRT,.INFLD,.INMSG)
 I $D(INMSG) D COMP(.INMSG)
 ;Clean up ^UTILITY/Remove IB routines
 K ^UTILITY($J),^UTILITY("INHSYS",$J),^UTILITY("INHSYSUT",$J)
 W !!,"File transfer completed."
 Q
INST(%DRVR,%PASS,INREPRT,INFLD,INMSG) ;installation utility entry pnt
 ;input:
 ; %DRVR - Internal installation driver routine
 ; %PASS - 0 or null - display report only
 ;         1 - save off old files - create required fields
 ;         2 - populate rest of file
 ; INREPRT - 0 or null - off 1 - on
 ; INFLD - Array of 4012 Script Generator Field entries
 ;Output:
 ; INMSG - Array of GIS entries
 ;local:
 ; %LINE - file information stored in ";;" comment form
 ; %FNUM - file number
 ; %ROOT - global root
 ;
 N B,%FNUM,%FLDS,%ROOT,%OIEN,%XNODE,%UNQ,Y,DA,%FILES,AA,%SAV
 N DIC,X,DLAYGO,QT,I,%RQ,%MSG,%MSG2,%OMT,%FILES,%DIC0,%GLB,INPOP,INFLD
 D ENV^UTIL
 S INREPRT=$G(INREPRT),%PASS=$G(%PASS),(%MSG,%MSG2)=0,INPOP=0,INCR=1
 S INFLG=$G(INFLG)
 I '%PASS D EN^@%DRVR
 I INREPRT U IO D HEAD^INHSYSUT(%PASS)
 S QT=$C(34)
 S %FNUM="" F  S %FNUM=$O(^UTILITY("INHSYS",$J,%FNUM)) Q:%FNUM=""  D
 .;get root name of file
 .S %ROOT=$G(^DIC(%FNUM,0,"GL")),%DIC0="X"
 .I %ROOT="" W !,"Note .. DD file "_%FNUM_" is missing." Q
 .I %PASS S %DIC0="LX"
 .;loop thru utility using cross reference to get ien
 .S %OIEN="" F  S %OIEN=$O(^UTILITY("INHSYS",$J,%FNUM,%OIEN)) Q:'%OIEN  D
 ..N DA,DINUM
 ..S %XNODE=$G(^UTILITY("INHSYS",$J,%FNUM,%OIEN,0))
 ..I %XNODE="" Q
 ..S Y=0
 ..;Universal Interface custom
 ..I %FNUM=4001 S Y=$O(^INTHU("C",$P(%XNODE,U,5),""))
 ..;not criteria file
 ..I %FNUM'="4001.1",'Y S Y=$$DIC^INHSYS05(%ROOT,$P(%XNODE,U),%FNUM,%DIC0) D:Y<0 MSG^INHSYSUT(%XNODE,%FNUM,.%MSG,0,%PASS)
 ..;Criteria file custom code
 ..I %FNUM="4001.1" D
 ...N INOPT
 ...S INOPT("TYPE")="TEST"
 ...S (DIPA("DA"),Y)=$$NEW^INHUTC1(.INOPT,"U")
 ...I Y<0 W !,"ERROR - UNABLE TO CREATE NEW CRITERIA" Q
 ..;patient file
 ..I %FNUM=2,%PASS=1 S DFN=+Y
 ..;Files that require message to recompile
 ..I %FNUM=4012!(%FNUM=4010)!(%FNUM=4012.1)!(%FNUM=4011) S INMSG(%FNUM,+Y)=$P(Y,U,2)
 ..I INREPRT,Y>0 D PG^INHSYSUT(%PASS) W !,%FNUM,?14,$P($G(^DIC(%FNUM,0)),U),?42
 ..;Save ien Kill off node
 ..I %PASS=1,+Y>0 D  I +Y<0 D MSG^INHSYSUT(%XNODE,%FNUM,.%MSG,0,%PASS) Q
 ...S DINUM=+Y,DIK=%ROOT,DA=+Y D ^DIK
 ...;create stub node
 ...S Y=$$DIC^INHSYS05(%ROOT,$P(%XNODE,U),%FNUM,%DIC0,"","",.DINUM)
 ..S DA=+Y
 ..I INREPRT,Y>0 D
 ...W:%PASS'=1 ?42,".01",?56
 ...W:%PASS'=1 $P(Y,U,2)
 ...W !,%ROOT_DA I '%PASS W !
 ..I INREPRT,Y'>0,%PASS=1 W ?42,".01"
 ..I '%PASS,Y>0 D CMP^INHSYS07(+Y,%ROOT,%FNUM,%OIEN,1)
 ..I %PASS D STUFF^INHSYS05(Y,%FNUM,%ROOT,"^UTILITY(""INHSYS"","_$J_","_QT_%FNUM_QT_","_%OIEN_",",1,DA,%PASS,.%MSG2,INREPRT)
 I INREPRT,%MSG2 D PG^INHSYSUT(%PASS) W !,"*** Denotes ommitted, and not filed in system."
 I INREPRT D PG^INHSYSUT(%PASS) W !!,"Pass "_%PASS_" Done! "
 I INREPRT,%PASS=1,$E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 Q
 ;
PKG(CLASS,RTN) ;Create package of routines in VMS flat file
 ;  Input:
 ;    CLASS - name of flat file that stores saved routines
 ;    RTN - Name of beginning routine name to store in sequence
 ;          in the flat file.
 N %RTN K ^UTILITY($J)
 D ENV^UTIL
 S %RTN=RTN
 D ORDER^INHUT3("^ ","%RTN",RTN,"$E(%RTN,1,$L(RTN))'=RTN","S ^UTILITY($J,%RTN)=""""")
 D SAVEROU^INZTTC(CLASS)
 Q
UPKG(FNAME) ;replace routine into environment from flat file
 ; Input:
 ;   FNAME - Flat file name. Should end with .TT extention
 D FN^ZCMSLD1(FNAME,0)
 Q
COMP(INMSG) ;Compile Script Generator Messages
 ; Input: INMSG - Array of Script Generator Fields and Segments
 ;    format - INMSG(4010,ien)
 ;             INMSG(4012,ien)
 ;
 N INFL,INIEN,INMS,Y,INGALL
 ;get messages related to Script Data Types
 I $D(INMSG(4012.1)) D GETMSGDT^INHSYSU1(.INMSG,.INMS)
 ;loop through in order of most likely to occur
 F INFL=4012,4010,4011 I $D(INMSG(INFL)) D
 .S INIEN="" F  S INIEN=$O(INMSG(INFL,INIEN)) Q:INIEN=""  D
 ..;Get Script Generator Messages related to field
 ..I INFL=4012 D GETMSGF^INHSYSU1(INIEN,.INMS,.INMSG) Q
 ..;Get Script Generator Messages related to segment
 ..I INFL=4010 D GETMSGS^INHSYSU1(INIEN,.INMS,.INMSG) Q
 ..;Get Script Generator Messages from saved message
 ..I INFL=4011 S INMS(INIEN)=""
 ;compile Script Generator Messages
 S INMS="",INGALL=1 F  S (INMS,Y)=$O(INMS(INMS)) Q:'Y  D EN^INHSGZ
 Q
SV2FLT(INAME,INDONE) ;Save utility stuff to flat file
 ; Input:
 ;   INAME - Name of flat file
 ; Output: INDONE 0 did not finish 1 finished
 N %NODE,%DATA,$ET,INDATE
 S INDONE=0
 Q:'$D(^UTILITY($J))
 S %NODE="^UTILITY($J)",$ZT="ERR^INHSYSE"
 S INAME=$$OPENSEQ^%ZTFS1(INAME,"BW")
 I INAME="" W !,"Unable to open file" Q
 U INAME
 S INDATE=$$CDATASC^%ZTFDT($H,2,1)
 W $P(INDATE,"@")_"     "_$P(INDATE,"@",2),!,"Interactive Test Utility Save"
 F  S %NODE=$Q(@%NODE) Q:$QS(%NODE,1)'=$J  D
 .S %DATA=@%NODE
 .W !,%NODE
 .W !,%DATA
 W !,"**END**",!,"**END**"
 I $$CLOSESEQ^%ZTFS1(INAME)
 S INDONE=1
 Q
RSFRFLT(INAME) ;Restore from flat file
 ;Input: - INAME - Name of flat file to restore from
 N X,N,%RTNBFR,%ODD,%EVEN,%DATIM,%HEAD,$ET
 K ^UTILITY("INHSYS",$J)
 S %RTNBFR="^UTILITY(""INHSYS"",",$ZE="",$ZT="ERR^INHSYSE"
 S INAME=$$OPENSEQ^%ZTFS1(INAME,"RB")
 I INAME="" W !,"Unable to open file" Q
 U INAME
 R %DATIM:0,%HEAD:0
 I %HEAD="Interactive Test Utility Save" D
 .F  R %ODD:0 Q:'$T  Q:%ODD="**END**"  D
 ..R %EVEN:0 Q:'$T
 ..Q:%EVEN="**END**"
 ..S X=%RTNBFR_$J_","_$P(%ODD,",",2,99)
 ..S @X=%EVEN
 S X=$$CLOSESEQ^%ZTFS1(INAME)
 Q
ERR ;if error occurs on save or restore
 S X=$$CLOSESEQ^%ZTFS1(INAME),$ZT=""
 W !,"An error has ocurred"
 Q
