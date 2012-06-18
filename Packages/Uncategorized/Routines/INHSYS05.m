INHSYS05 ;slt,JPD,WOM; 15 Jun 99 16:27;gis sys con data installation utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 6-OCT-1997
 ;COPYRIGHT 1994 SAIC
 Q
INST(%DRVR,%PASS,INREPRT) ;installation utility entry point
 ;input:
 ; %DRVR - Internal installation driver routine
 ; %PASS - 0 or null - display report only
 ;         1 - save off old files - create required fields
 ;         2 - populate rest of file
 ; INREPRT - 0 or null - off 1 - on
 ;local:
 ; %LINE - file information stored in ";;" comment form
 ; %FNUM - file number
 ; %ROOT - global root
 ;
 N B,%FNUM,%FLDS,%ROOT,%OIEN,%XNODE,%UNQ,Y,DA,%FILES,AA,%SAV
 N DIC,X,DLAYGO,QT,I,%RQ,%MSG,%MSG2,%OMT,%FILES,%DIC0,%GLB
 S INREPRT=$G(INREPRT),%PASS=$G(%PASS),(%MSG,%MSG2)=0
 I '%PASS X "D EN^@%DRVR"   ;used eXecute so that ^TCQ program does not crash!
 I INREPRT U IO D HEAD^INHSYSUT(%PASS)
 ;set up variables
 D RQ^INHSYSUT(.%RQ),OMT^INHSYSUT(.%OMT),SAVE^INHSYSUT(.%SAV),XRF^INHSYSUT(.%FILES)
 S QT=$C(34)
 ;Get each cross reference
 F AA=1:1 S %FNUM=$P(%FILES,U,AA) Q:%FNUM=""  D
 .;get root name of file
 .;Cant do exact match lookup since names>30 in length
 .S %ROOT=$G(^DIC(%FNUM,0,"GL")),%DIC0="X"
 .I %ROOT="" W !,"Note .. DD file "_%FNUM_" is missing." Q
 .I %PASS S %DIC0="LX"
 .;loop thru utility using cross reference to get ien
 .S %OIEN="" F  S %OIEN=$O(^UTILITY("INHSYS",$J,%FNUM,%OIEN)) Q:'%OIEN  D
 ..N DA,DINUM
 ..S %XNODE=^UTILITY("INHSYS",$J,%FNUM,%OIEN,0)
 ..;if Transaction Type file
 ..I %FNUM=4000,$P(%XNODE,U,4)]"" D
 ...;get unique identifier
 ...S %UNQ=$P(%XNODE,U,4),%GLB=$$RUT^INHSYSUT(%ROOT),Y=$O(@%GLB@("ID",%UNQ,""))
 ...;If no unique ID laygo the file
 ...I 'Y S Y=$$DIC(%ROOT,$P(%XNODE,U),%FNUM,%DIC0) D:Y<0 MSG^INHSYSUT(%XNODE,%FNUM,.%MSG,0,%PASS) Q
 ...E  S Y=Y_U_$P(%XNODE,U)
 ..E  S Y=$$DIC(%ROOT,$P(%XNODE,U),%FNUM,%DIC0) D:Y<0 MSG^INHSYSUT(%XNODE,%FNUM,.%MSG,0,%PASS)
 ..I INREPRT,Y>0 D PG^INHSYSUT(%PASS) W !,%FNUM,?14,$P($G(^DIC(%FNUM,0)),U),?42
 ..;Save ien Kill off node
 ..I %PASS=1,+Y>0 D  I +Y<0 D MSG^INHSYSUT(%XNODE,%FNUM,.%MSG,0,%PASS) Q
 ...;if we want to save old values from export environment
 ...I $D(%SAV(%FNUM)) D FLSV^INHSYSUT(%FNUM,+Y,%ROOT)
 ...S DINUM=+Y,DIK=%ROOT,DA=+Y D ^DIK
 ...;create stub node
 ...S Y=$$DIC(%ROOT,$P(%XNODE,U),%FNUM,%DIC0,"","",.DINUM)
 ..S DA=+Y
 ..I INREPRT,Y>0 D
 ...W:%PASS'=1 ?42,".01",?56
 ...I %FNUM=4020 W $P($G(^INRHT($P(Y,U,2),0)),U)
 ...E  W:%PASS'=1 $P(Y,U,2)
 ...W !,%ROOT_DA I '%PASS W !
 ..I INREPRT,Y'>0,%PASS=1 W ?42,".01"
 ..I '%PASS,Y>0 D CMP^INHSYS07(+Y,%ROOT,%FNUM,%OIEN,1)
 ..I %PASS D STUFF(Y,%FNUM,%ROOT,"^UTILITY(""INHSYS"","_$J_","_QT_%FNUM_QT_","_%OIEN_",",1,DA,%PASS,.%MSG2,INREPRT)
 ;I '%PASS,'INREPRT,'%MSG W !,"All files currently exist in this environment",!,"and will be overwritten",!
 I INREPRT,%MSG2 D PG^INHSYSUT(%PASS) W !,"*** Denotes ommitted, and not filed in system."
 I INREPRT D PG^INHSYSUT(%PASS)
 W !!,"Pass "_%PASS_" Done! "
 I INREPRT,%PASS=1,$E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 Q
 ;
STUFF(INY,%FILNUM,%ROOT,%BFR,%LEVEL,DA,%PASS,%MSG2,INREPRT) ;recursive data stuffer 
 ;input:
 ; INY     - ien^.01
 ; %FILNUM - file number
 ; %ROOT   - global root
 ; %BFR    - storage buffer
 ; %LEVEL  - file/sub-file level
 ; DA      - same as fileman documented DA
 ; %PASS - 0 or null - report
 ;         1 - save off old files - create required fields
 ;         2 - populate rest of file
 ;local:
 ; %NODE   - node
 ; %PIECE  - uparrow piece
 ; %FLDNUM - field number
 ; %OIEN   - old ien for sub-files
 ; %NBFR   - the new storage buffer root name
 ; %DATA   - node data strage variable
 ; P01     - .01 value
 ; %NRT    - new global root
 ;
 N %NODE,%NODE1,%PIECE,%FLDNUM,DIE,%OIEN,%NBFR,%DATA,P01,%NRT,YY,DR,I,J
 S %NODE=""
 I %LEVEL>1,INREPRT D PG^INHSYSUT(%PASS) W !,"m ",%FILNUM,?14,$P($G(^DD(%FILNUM,0)),U)
 F  S %NODE=$O(^DD(%FILNUM,"GL",%NODE)) Q:%NODE=""  D
 .S %NODE1=%NODE
 .I $L(%NODE),+%NODE'=%NODE S %NODE=""""_%NODE_""""
 .;set new storage buffer root name
 .S %NBFR=%BFR_%NODE_","
 .;Loop through DD to get each piece of every node
 .S %PIECE=""
 .F  S %PIECE=$O(^DD(%FILNUM,"GL",%NODE1,%PIECE)) Q:%PIECE=""  D
 ..S %FLDNUM=""
 ..;get fieldnum for each piece of every node
 ..F  S %FLDNUM=$O(^DD(%FILNUM,"GL",%NODE1,%PIECE,%FLDNUM)) Q:'%FLDNUM  D
 ...I %PASS=1,'$D(%RQ(%FILNUM,%FLDNUM)) Q
 ...I INREPRT D:%FLDNUM'=".01" PG^INHSYSUT(%PASS) W:%FLDNUM'=".01"!(%LEVEL=1) !,?42,%FLDNUM
 ...I INREPRT,%LEVEL>1,%FLDNUM=".01" D PG^INHSYSUT(%PASS) W !,?42,%FLDNUM
 ...; Don't do it because already populated in PASS 1
 ...I %PASS=2,$D(%RQ(%FILNUM,%FLDNUM)) Q
 ...I $D(%OMT(%FILNUM,%FLDNUM)) D:INREPRT  Q
 ....D DATA^INHSYSUT($$RUT^INHSYSUT(%NBFR),%PIECE,.%DATA)
 ....W " ***",?56,%DATA
 ....S %MSG2=1
 ...;If word processing field
 ...I $$WP^INHSYSUT(+%FILNUM,%FLDNUM) D WORD(%NBFR,%ROOT,DA,%NODE,%PASS) Q
 ...;If piece is 0 could be multiple
 ...I %PIECE=0 D MULT(%NBFR,%NODE,%ROOT,.DA,%FILNUM,%FLDNUM,%LEVEL,%PASS,.%MSG2) Q
 ...D DATA^INHSYSUT($$RUT^INHSYSUT(%NBFR),%PIECE,.%DATA)
 ...I INREPRT W ?56,%DATA
 ...;If not .01, if not blank, and not omitted File the data
 ...I %DATA'="",%FLDNUM'=".01" D FILE^INHSYSUT(.DA,%DATA,%FLDNUM,%ROOT,INREPRT)
 .S %NODE=%NODE1
 Q
MULT(%NBFR,%NODE,%ROOT,DA,%FILNUM,%FLDNUM,%LEVEL,%PASS,%MSG2) ;Process multiple
 ;This module will process multiple as if it were an entire
 ;node and process each entry one piece at a time
 ;  %NBFR   - the new storage buffer root name
 ;  %NODE   - node
 ;  %ROOT   - global root
 ;  DA - ien and "Multiple entry"
 ;  %FILNUM - file number
 ;  %FLDNUM - field number
 ;  %LEVEL  - file/sub-file level
 ;  %PASS - 0 or null - report
 ;            1 - save off old files - create required fields
 ;            2 - populate rest of file
 N %OIEN,%NRT,X,NFLN,YY,%X,%Y,%NFLN,%DIC0,INMSGID
 S %DIC0="LX"
 S %OIEN=0 F  S %OIEN=$O(@$$RUT^INHSYSUT(%NBFR)@(%OIEN)) Q:'%OIEN  S X=^(%OIEN,0) D
 .N %NRT,ODA,%INFAKE,%DICS
 .;set x to current multiple node of UTILITY global
 .;get new root
 .S %NRT=%ROOT_DA_","_%NODE_","
 .S %NFLN=$P(^DD(%FILNUM,%FLDNUM,0),U,2)
 .I +%NFLN="4001.19" D  Q
 ..N INIEN
 ..S INMSGID=$P(@(%NBFR_%OIEN_",0)"),U,2)
 ..S INIEN=$O(^INTHU("C",INMSGID,"")) Q:'INIEN
 ..D UPSINGMS^INTSUT3(DA,"NML",INIEN)
 .S YY=$$DIC(%NRT,$P(X,U),%NFLN,%DIC0,.DA,%LEVEL,.INFAKE) I YY<0 D MSG^INHSYSUT(X,%NFLN,"",1,%PASS) Q
 .S ODA=DA,%X="DA",%Y="ODA" M @%Y=@%X
 .D SETDA(.DA,%LEVEL,+YY)
 .;every time you recusion into stuff, it processes multiple
 .;completely for each entry
 .D STUFF(YY,+%NFLN,%NRT,%NBFR_%OIEN_",",%LEVEL+1,.DA,%PASS,.%MSG2,INREPRT)
 .K DA S DA=ODA,%Y="DA",%X="ODA" M @%Y=@%X
 .I INREPRT D PG^INHSYSUT(%PASS) W !,"----",!,"r "_%FILNUM
 Q
WORD(%NBFR,%ROOT,DA,%NODE,%PASS) ;Process word processing field
 ; input:
 ;   %NBFR - Utility Global Buffer
 ;   %ROOT - Root node of global to stuff
 ;   DA - ien
 ;   %NODE - node
 N %INX,%INCNT,%X,%Y,I,L
 ;Check if data exists to move
 I $D(@(%NBFR_"0)")) D
 .;move data from utility to correct multiple
 .S L=$L(%NBFR),%X=$E(%NBFR,1,L-1)_$S($E(%NBFR,L)="(":"",1:")"),%Y=%ROOT_DA_","_%NODE_")"
 .M @%Y=@%X
 Q
SETDA(DA,%LEVEL,Y) ;Set DA level so fileman doesn't choke
 ; Input:
 ;    DA - ien and "Multiple" entry #'s
 ;    %LEVEL - level in multiple
 ;    Y - New entry number
 ; Output:
 ;    DA - IEN and "Multiple" entry #'s
 N I
 F I=%LEVEL:-1:3 S DA(I-1)=DA(I-2)
 S DA(1)=DA,DA=+Y
 Q
DIC(DIC,X,DLAYGO,%IPS,DOA,%L,DINUM) ;dic lookup
 ;input:
 ;  DIC - Global Root: Can be a string or file number
 ;        If a file number, this function returns -1
 ;             when looking at a multiple
 ;  X - Stuff this bud
 ;  DLAYGO - file number and formatting
 ;  %IPS - input parameter string; see DIC(0) documentation
 ;  DOA  - array of previous DA values; passed by referrence
 ;  %L   - current level
 ;  DINUM (opt) - force this ien
 ;output:
 ;  Y    - What DIC returns
 N G,DA,I,Y,INDD0
 I DIC Q:DIC'>0!($G(DOA)&$G(%L)) -1 S DIC=$G(^DIC(DIC,0,"GL")) Q:DIC="" -1
 ;Check for files whose .01 is a pointer. Currently only check 4020.
 I $D(DINUM),DIC="^INRHR(" S INDD0=$G(^DD(4020,.01,0)) I $P(INDD0,U,2)["P" D  I Y<0 Q Y
 .  ;Get file for next lookup
 .  S INFILE="^"_$P(INDD0,U,3)
 .  ;Do recursive lookup on file
 .  S Y=$$DIC(INFILE,X,"","X")
 .  S X=+Y
 I $G(DOA),($G(%L)) D
 .F I=%L:-1:2 S DA(I)=DOA(I-1)
 .S DA(1)=DOA
 S G=DIC_"0)" S:'$D(@G) @G="^"_DLAYGO_"^^"
 S DIC(0)=%IPS
 I '$D(DINUM) D ^DIC
 I $D(DINUM) D ^DICN D:Y=-1
 .F I=1,2 D  Q:$G(IO)=$G(IO(0))
 ..I I=2,$D(IO(0))#10,$D(IO)#10 U IO(0)
 ..W *7,!,!,"Warning, the GIS TRANSACTION MOVER has failed to update ",!
 ..W DIC," with the .01 field=",X,!,"This could possibly be due to corruption of the"
 ..W "FILEMAN data structure.",!,"This installation cannot be aborted at this time but"
 ..W "YOU MUST CONTACT THE SUPPORT CENTER IMMEDIATELY",!!
 ..I I=2,$D(IO)#10 U IO
 Q Y
