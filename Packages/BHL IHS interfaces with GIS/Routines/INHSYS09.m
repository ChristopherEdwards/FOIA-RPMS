INHSYS09 ;JPD; 5 Nov 98 13:29;gis sys con data installation utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
START ;Single element transaction mover entry point
 ; This routine copy data from file entry to ^UTILITY($J,%FILE,%IEN
 ; Then expand the pointer fields to their actual value
 N INREPRT,INPOP,INCR,INNTRIES
 S INPOP=0,INCR=1
 D ENV^UTIL
 D DEBOFF
 W @IOF
 D GETFLE(.INNTRIES)
 I $D(INNTRIES) D
 .W !,"Do you want a report of what the file points to"
 .S INREPRT=$$YN^%ZTF(0)
 .I INREPRT D HEAD^INHSYS03(2)
 .S %FILE="" F  S %FILE=$O(INNTRIES(%FILE)) Q:%FILE=""  D
 ..S %OIEN="" F  S %OIEN=$O(INNTRIES(%FILE,%OIEN)) Q:%OIEN=""  D
 ...D COPY(%FILE,%OIEN,INREPRT)
 Q
GETFLE(INNTRIES) ;Get file entry
 ; Output:
 ;   INNTRIES - Array of Files and entries
 ;   format - INNTRIES(FILE,IEN)="ENTRY NAME"
 N %FIL,DIC,Y
 F  D  Q:%FIL=-1
 .S DIC="^DIC(",DIC(0)="AEQ",DIC("A")="Enter File Name:  "
 .D ^DIC
 .S %FIL=+Y
 .I +%FIL>0 F  D GETELE(.INNTRIES,.Y) Q:Y=-1
 Q
GETELE(INNTRIES,Y) ;Get file element
 ; Output:
 ;   INNTRIES - Array of Files and entries
 ;   format - INNTRIES(FILE,IEN)="ENTRY NAME"
 ;   Y - File element entry
 N DIC
 S DIC(0)="AEQ",DIC("A")="Enter File Element Name:  "
 S (%GBL,DIC)=^DIC($P(%FIL,U),0,"GL")
 D ^DIC
 I Y>0 S INNTRIES(%FIL,+Y)=$P(Y,U,2)
 Q
COPY(%FILE,%OIEN,INREPRT,INOMIT) ;Front end expand any pointer any file
 ; %FILE - File Number
 ; %OIEN - Internal Entry Number
 ; INREPRT - 0 no report 1 yes
 ; INOMIT - Array of file and field to omit from transporting
 N %ROOT,%X,%Y,%SVIEN
 K ^UTILITY($J,%FILE,%OIEN)
 S %ROOT=^DIC(%FILE,0,"GL"),%SVIEN=%OIEN
 ;Copy data to ^UTILITY global
 S %Y="^UTILITY("_$J_","_%FILE_","_%OIEN_")",%X=%ROOT_%OIEN_")"
 M @%Y=@%X
 ;Expand pointers
 D EXPND(%OIEN,%FILE,%ROOT,%ROOT_%OIEN_",",1,%OIEN,INREPRT,%SVIEN,0,.INOMIT)
 Q
EXPND(INY,%FILE,%ROOT,%BFR,%LEVL,DA,INREPRT,%SVIEN,%FND,INOMIT) ;Expand pointers 
 ;input:
 ; INY     - ien^.01
 ; %FILE - file number
 ; %ROOT   - global root
 ; %BFR    - storage buffer
 ; %LEVL  - file/sub-file level
 ; DA      - same as fileman documented DA
 ; INREPRT - if 1 reporting in effect, either user
 ;               requested or flat file
 ; %SVIEN - top level ien since we could be in a multiple
 ;          used at PRINT^INHSYS03 if INREPRT
 ;  %FND - 1 - Target file not in package
 ;         0 - Target file in package
 ;   Site specific files may not be exported. If
 ;   this is an entry in one of those files, %FND will
 ;   be equal to one. ex) DEVICE FILE
 ; INOMIT - Array of fields that are pointers to omit from package
 ;          INOMIT(FILE#,FIELD#)
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
 N %Z0
 S %NODE=""
 F  S %NODE=$O(^DD(%FILE,"GL",%NODE)) Q:%NODE=""  D  Q:INPOP
 .S %NODE1=%NODE
 .I $L(%NODE),+%NODE'=%NODE S %NODE=""""_%NODE_""""
 .;set new storage buffer root name
 .S %NBFR=%BFR_%NODE_","
 .;Loop through DD to get each piece of every node
 .S %PIECE=""
 .F  S %PIECE=$O(^DD(%FILE,"GL",%NODE1,%PIECE)) Q:%PIECE=""  D  Q:INPOP
 ..S %FLDNUM=""
 ..;get fieldnum for each piece of every node
 ..F  S %FLDNUM=$O(^DD(%FILE,"GL",%NODE1,%PIECE,%FLDNUM)) Q:'%FLDNUM  D  Q:INPOP
 ...;If word processing field
 ...I $$WP^INHSYSUT(+%FILE,%FLDNUM) Q
 ...;If piece is 0 could be multiple
 ...I %PIECE=0 D MULT(%NBFR,%NODE,%ROOT,.DA,%FILE,%FLDNUM,%LEVL,%SVIEN,.%FND) Q
 ...S %Z0=$G(^DD(%FILE,%FLDNUM,0))
 ...;If piece is not a pointer quit
 ...I $P(%Z0,U,2)'["P" Q
 ...D DATA^INHSYSUT($$RUT^INHSYSUT(%NBFR),%PIECE,.%DATA)
 ...I %DATA="" Q
 ...F K="2^%PTO","4^%NDPC" S @$P(K,U,2)=$P(%Z0,U,$P(K,U))
 ...I %LEVL>1 D MULT2(%NDPC,%FILE,%FLDNUM,%NBFR,%DATA,%SVIEN,INREPRT,.%FND) Q
 ...D FLD^INHSYS03(%PTO,%NDPC,.%FND,%FILE,%FLDNUM,.INOMIT)
 .Q:INPOP  S %NODE=%NODE1
 Q
MULT(%NBFR,%NODE,%ROOT,DA,%FILE,%FLDNUM,%LEVL,%SVIEN,%FND) ;Process multiple
 ;This module will process multiple as if it were an entire
 ;node and process each entry one piece at a time
 ;  %NBFR   - the new storage buffer root name
 ;  %NODE   - node
 ;  %ROOT   - global root
 ;  DA - ien and "Multiple entry"
 ;  %FILE - file number
 ;  %FLDNUM - field number
 ;  %LEVL  - file/sub-file level
 N %OIEN,%NRT,X,NFLN,YY,%X,%Y,%NFLN,%DIC0,%Z0,%GBL
 S %DIC0="X"
 S %OIEN=0 F  S %OIEN=$O(@$$RUT^INHSYSUT(%NBFR)@(%OIEN)) Q:'%OIEN  D
 .N %NRT,ODA
 .;set x to current multiple node of UTILITY global
 .S X=^(%OIEN,0)
 .;get new root
 .S %NRT=%ROOT_DA_","_%NODE_","
 .S %NFLN=$P(^DD(%FILE,%FLDNUM,0),U,2)
 .S %Z0=$G(^DD(%FILE,%FLDNUM,0))
 .I $P(%Z0,U,2)["P" D  I YY<0 D MSG^INHSYSUT(X,%NFLN,"",1,0) Q
 ..S %GBL="^"_$P(^DD(+%NFLN,.01,0),U,3)
 ..S X="`"_+X
 ..S YY=$$DIC^INHSYS05(%GBL,$P(X,U),%NFLN,%DIC0,.DA,%LEVL)
 .I $P(%Z0,U,2)'["P" S YY=$$DIC^INHSYS05(%NRT,$P(X,U),%NFLN,%DIC0,.DA,%LEVL) I YY<0 D MSG^INHSYSUT(X,%NFLN,"",1,0) Q
 .S ODA=DA,%X="DA",%Y="ODA" M @%Y=@%X ;D %XY^%RCR
 .D SETDA(.DA,%LEVL,+YY)
 .;every time you recusion into stuff, it processes multiple
 .;completely for each entry
 .D EXPND(YY,+%NFLN,%NRT,%NBFR_%OIEN_",",%LEVL+1,.DA,INREPRT,%SVIEN,.%FND)
 .K DA S DA=ODA,%Y="DA",%X="ODA" M @%Y=@%X ;D %XY^%RCR
 Q
SETDA(DA,%LEVL,Y) ;Set DA level so fileman doesn't choke
 ; Input:
 ;    DA - ien and "Multiple" entry #'s
 ;    %LEVL - level in multiple
 ;    Y - New entry number
 ; Output:
 ;    DA - IEN and "Multiple" entry #'s
 N I
 F I=%LEVL:-1:3 S DA(I-1)=DA(I-2)
 S DA(1)=DA,DA=+Y
 Q
MULT2(%NDPC,%FILE,%FLD,%NBFR,%DATA,%SVIEN,INREPRT,%FND) ;Process multiple
 ; Input:
 ;  %NDPC - The node;piece
 ;  %FILE - Source file number
 ;  %FLD - Source field number
 ;  %NBFR - Buffer of data
 ;  %DATA - ien to be expanded
 ;  %SVIEN - top level ien, used in PRINT^INHSYS03
 ;  INREPRT - 0 no report 1 report
 ;  %FND - 1 - Target file not in package
 ;         0 - Target file in package
 ;   Site specific files may not be exported. If
 ;   this is an entry in one of those files, %FND will
 ;   be equal to one. ex) DEVICE FILE
 N INP01,%GBFR,%GBL,%PTO,%UPFL,%GBLN,%NOD
 S %PC=$P(%NDPC,";",2)
 ;Global root of file pointed to
 S %GBL="^"_$P(^DD(+%FILE,%FLD,0),U,3)
 ; File number of pointed to file
 S %PTO=$P(^DD(+%FILE,%FLD,0),U,2)
 S %PTO=+$E(%PTO,$F(%PTO,"P"),$L(%PTO))
 S %GBLN=%GBL_%DATA_",0)"
 I '$D(@%GBLN) W !,%FILE,?10,$P($G(^DIC(%FILE,0)),U),?38,%FLD,"   Broken Pointer  ",%GBLN S INPOP=1 Q
 ;.01 of pointed to file
 S INP01=$P(@%GBLN,U)
 S %NOD=$P(%NBFR,@"^DIC($$UP^INHSYSUT(%FILE),0,""GL"")",2)
 S %GBFR=$$RUT^INHSYSUT("^UTILITY("_$J_","_$$UP^INHSYSUT(%FILE)_","_%NOD)
 S $P(@%GBFR,U,%PC)=INP01
 ;Root source file
 S %UPFL=$$UP^INHSYSUT(%FILE)
 I INREPRT D PRINT^INHSYS03(%FILE,%UPFL,%FLD,%PTO,INP01,%GBLN,%SVIEN,.%FND)
 Q
 ;
DEBOFF ;Turn off debug for all background process
 N INBN,INBD,INBP
 S INBN="" F  S INBN=$O(^INTHPC("B",INBN))  Q:INBN=""  D
 .S INBD=$O(^INTHPC("B",INBN,0))
 .I $D(^INTHPC(INBD,9)) D
 ..S INBP=$P(^INTHPC(INBD,9),U,1)
 ..I INBP>0 D
 ...W !,"WARNING: Debug will be turned off for Background Process: ",INBN
 ...R !!?25,"Press <RETURN> To Continue",X:$S($D(DTIME):DTIME,1:300)
 ...S DR="9.01///@",DA=INBD,DIE=4004 D ^DIE
 Q
 ;
