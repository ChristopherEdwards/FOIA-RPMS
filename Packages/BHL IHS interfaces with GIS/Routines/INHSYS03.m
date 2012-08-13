INHSYS03 ;slt; 2 Oct 95 14:44;System Configuration data utility cont. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
RSLV(INREPRT) ;resolve pointer fields to .01 values
 ; Input:
 ;  INREPRT - 0 - No Report
 ;            1 - Display Report
 ;local:
 ;  %LINE - a single line from XRF^INHSYSUT line-tag
 ;  %FILE - the source file number
 ;  %FLD  - the source field number
 ;  %FLDS - a string of ";" delimited field numbers
 ;  %LEN  - the number of fields to process
 ;  %SFL  - sub file number
 ;  %SFLD - sub field number
 ;  %Z0   - zero node from ^DD(%FILE,%FLD,
 ;
 N %LINE,%FILE,%FLD,I,J,%FLDS,%LEN,%SFL,%SFLD,%Z0,%FND,%NDPC,%PTO,%FILES,AA
 S %FND=""
 I INREPRT D HEAD(2)
 D XRF^INHSYSUT(.%FILES)
 F AA=1:1 S %FILE=$P(%FILES,U,AA) Q:%FILE=""  D
 .S %FLDS=%FILES(%FILE),%LEN=$L(%FLDS,";")
 .;get one DD field at a time
 .F J=1:1:%LEN S %FLD=$P(%FLDS,";",J) I %FLD'="" D
 ..;if multiple
 ..I %FLD[":" D SUBFLD(%FILE,%FLD) Q
 ..S %Z0=$G(^DD(%FILE,%FLD,0)) Q:%Z0=""
 ..F K="2^%PTO","4^%NDPC" S @$P(K,U,2)=$P(%Z0,U,$P(K,U))
 ..;resolve ptr values
 ..D FLD(%PTO,%NDPC,.%FND,%FILE,%FLD)
 I INREPRT,%FND W !!,"*** Denotes pointed to file not put in package.",!!
 Q
EXPAND(INREPRT) ;Expand pointer values
 ; Input:
 ;  INREPRT - 0 - No Report
 ;            1 - Display Report 
 N INFL,INIEN,%ROOT,%FND
 I INREPRT D HEAD(2)
 F INFL=4012,4005,4011,4000,4004,4010,4090.2,4020,4006 D  Q:INPOP
 .S INIEN="0"
 .F  S INIEN=$O(^UTILITY($J,INFL,INIEN)) Q:'INIEN  D  Q:INPOP
 ..S %ROOT=^DIC(INFL,0,"GL"),%FND=0
 ..D EXPND^INHSYS09(INIEN,INFL,%ROOT,%ROOT_INIEN_",",1,INIEN,INREPRT,INIEN,.%FND)
 Q:INPOP  I INREPRT,%FND W !!,"*** Denotes pointed to file not put in package.",!!
 Q
 ;
SUBFLD(%FILE,%FLD) ;sub field processing for multiples
 ;  %FILE - the source file number
 ;  %FLD  - the source field number
 N %SFL,%SFLDS,%SFLD,INL,%Z0,%GBL,%PTO,%NDPC,%ND,%PC,INIEN,INDA,%DIEN
 N %GBLN,I,%PTNM,%PGBL
 S %SFL=$P(%FLD,":",2),INL=$L(%SFL,",")
 S %SFLDS=$P(%SFL,",",2,INL),INL=INL-1
 S %SFL=$P(%SFL,","),%FLD=$P(%FLD,":")
 F I=1:1:INL S %SFLD=$P(%SFLDS,",",I) D
 .S %Z0=^DD(%SFL,%SFLD,0)
 .F K="2^%PTO","3^%GBL","4^%NDPC" S @$P(K,U,2)=$P(%Z0,U,$P(K,U))
 .S %ND=$P(%NDPC,";"),%PC=$P(%NDPC,";",2)
 .S INIEN=""
 .F  S INIEN=$O(^UTILITY($J,%FILE,INIEN)) Q:'INIEN  D
 ..S INDA=0
 ..F  S INDA=$O(^UTILITY($J,%FILE,INIEN,%FLD,INDA)) Q:'INDA  D
 ...S %DIEN=$P(^(INDA,%ND),U,%PC) Q:'%DIEN
 ...S %GBLN="^"_%GBL_%DIEN_",0)"
 ...I '$D(@%GBLN),'$D(%PASS) D  Q
 ....W !,%SFL,?10,$P($G(^DIC(%FILE,0)),U),?38,%FLD,"  Broken Pointer  ",%GBLN
 ....W !,$G(^DIC(%FILE,0,"GL"))_INIEN
 ...S INP01=$P(@%GBLN,U)
 ...S $P(^UTILITY($J,%FILE,INIEN,%FLD,INDA,%ND),U,%PC)=INP01
 ...S %PTO=$$NUM^INHUT5(%PTO)
 ...I INREPRT D PRINT(%SFL,%FILE,%SFLD,%PTO,INP01,%GBLN,INIEN,.%FND)
 Q
FLD(%PTO,%NDPC,%FND,%FILE,%FLD,INOMIT) ;resolve pointer values to .01 text
 ;        from pointed too file
 ;input:
 ;  %PTO  - file pointed to
 ;  %NDPC - the node;piece
 ;  %FND - 1 - Target file not in package
 ;         0 - Target file in package
 ;   Site specific files may not be exported. If
 ;   this is an entry in one of those files, %FND will
 ;   be equal to one. ex) DEVICE FILE
 ;  %FILE - the source file number
 ;  %FLD  - the source field number
 ;  INOMIT - Omit pointer from being transported
 ;           INOMIT(FILE#,FIELD#)
 ;local:
 ;  %DIEN - the ien to convert to .01
 ;  %IEN  - the source/target file entry ien
 ;  %ND   - node
 ;  %PC   - piece
 ;  %GBL  - source global node
 ;  INP01 - .01 internal value from source
 ;  %NP  - No pointed file being brought
 ;
 N %DIEN,%IEN,%ND,%PC,%GBL,INP01,%GBLN,%NP,%PGBL,%PTNM
 S %ND=$P(%NDPC,";"),%PC=$P(%NDPC,";",2),%PTO=+$E(%PTO,$F(%PTO,"P"),$L(%PTO))
 ;get global being pointed to
 S %GBL=^DIC(%PTO,0,"GL")
 S %IEN=""
 F  S %IEN=$O(^UTILITY($J,%FILE,%IEN)) Q:'%IEN  D
 .S %DIEN=$P($G(^(%IEN,%ND)),U,%PC) Q:'%DIEN
 .I $D(INOMIT(%FILE,%FLD)) S $P(^UTILITY($J,%FILE,%IEN,%ND),U,%PC)="" Q
 .S %GBLN=%GBL_%DIEN_",0)"
 .I '$D(@%GBLN) D  Q
 ..W !,%FILE,?10,$P($G(^DIC(%FILE,0)),U),?38,%FLD,"  Broken Pointer  ",%GBLN
 ..W !,$G(^DIC(%FILE,0,"GL"))_%IEN
 .;look at global being pointed to, set UTILITY piece to that value
 .S INP01=$P(@%GBLN,U),$P(^UTILITY($J,%FILE,%IEN,%ND),U,%PC)=INP01
 .I INREPRT D PRINT(%FILE,%FILE,%FLD,%PTO,INP01,%GBLN,%IEN,.%FND)
 Q
PRINT(%SFL,%FILE,%FLD,%PTO,INP01,%GBLN,%IEN,%FND) ;
 ;  %SFL - the source sub file number
 ;  %FILE - the source file number
 ;  %FLD  - the source field number
 ;  %PTO  - file pointed to
 ;  INP01 - .01 internal value from source
 ;  %GBLN  - target global node
 ;  %IEN  - target file entry ien
 ; Output: %FND - 1 - Target file not in package
 ;                0 - Target file in package
 ;   Site specific files may not be exported. If
 ;   this is an entry in one of those files, %FND will
 ;   be equal to one. ex) DEVICE FILE
 N %PGBL,%PTNM,%NP
 S %NP="" I '$D(^UTILITY("SVD",$J,%GBLN)) S %NP=" *** ",%FND=1
 D PG(2) W !,%SFL,%NP,?10,$P($G(^DIC(%FILE,0)),U),?38,%FLD,?48,%PTO,?56,$P($G(^DIC(%PTO,0)),U)
 S %PGBL=$G(^DIC(%FILE,0,"GL"))_%IEN
 S %PTNM=$P(@(%PGBL_",0)"),U)
 I %FILE=4020 S %PTNM=$P($G(^INRHT(%PTNM,0)),U)
 W !,%PGBL_" ",?14,%PTNM,?48,$P(%GBLN,",")_" ",?62,INP01,!
 Q
HEAD(%TP) ;
 ; Input: %TP - 1 No Target file info
 ;              2 Target file info in report
 N %,%2,%3
 S %="Data",%2="File Name",%3=""
 I %TP=2 S %="Points to file",%2="",%3="Ptr ^Root(IEN"
 W @IOF
 W !!,"File",?10,%2,?38,"Field",?48,%
 W !,"^Root(IEN",?48,%3,!
 Q
PG(%TP) ;
 ; Input: %TP - 1 No Target file info
 ;              2 Target file info in report
 I IOSL-5'>$Y D
 .I $E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 .D HEAD(%TP)
 Q
