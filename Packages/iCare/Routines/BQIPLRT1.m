BQIPLRT1 ;PRXM/HC/DB-Retrieve Panel Related Tables ; 19 Oct 2005  12:26 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
SRCTYP(DATA,FAKE) ; EP -- BQI GET SOURCE TYPE LIST
 ;
 ;Description:
 ;  Return the list of acceptable Source Types associated with a Panel
 ;
 ;RPC:  BQI GET SOURCE TYPE LIST
 ;
 ;Input:
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;  
 ;Output:
 ;  ^TMP("BQIPLRT1",UID,"SRC") - Name of global (passed by reference) in which the data is stored.
 ;
 ;  ^TMP("BQIPLRT1",UID,"SRC",#) = Source Code ^ Source Description
 ;  where UID will be either $J or "Z" plus the Task
 ;'P' FOR Predefined
 ;'Q' FOR QMAN
 ;'M' FOR Manual
 ;'Y' FOR My Patients
 ;'E' FOR EZ Search ; *** will not be implemented for Phase 1
 ;'T' FOR Taxonomy  ; *** will not be implemented for Phase 1
 ;
 N UID,X,BQII,II,SET
 S BQII=0
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLRT1",UID,"SRC"))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERRSRC^BQIPLRT1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S BQII=BQII+1,@DATA@(BQII)="T00001CODE^T00030DESCRIPTION"_$C(30) ;Header
 ;Retrieve set of codes for Source Type
 D FIELD^DID(90505.01,.03,,"POINTER","SET")
 F II=1:1:$L(SET("POINTER"),";") D
 . S BQII=BQII+1,@DATA@(BQII)=$TR($P(SET("POINTER"),";",II),":","^")_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERRSRC ;Error trap for Source Type
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
PP(DATA,FAKE) ; EP -- BQI GET PREDEF PANEL LIST
 ;
 ;Description:
 ;  Return the list of active Pre-Defined panels
 ;
 ;RPC:  BQI GET PREDEF PANEL LIST
 ;
 ;Input:
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;Output:
 ;  ^TMP("BQIPLRT1",UID,"PP") - Name of global (passed by reference) in which the data is stored.
 ;
 ;  ^TMP("BQIPLRT1",UID,"PP",#) = Pre-Defined IEN ^ Pre-Defined Name ^ Pre-Defined Description
 ;  where UID will be either $J or "Z" plus the Task
 ;
 N UID,X,BQII,PPIEN,NM,DESC,STAT,TYPE
 S BQII=0
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLRT1",UID,"PP"))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERRPP^BQIPLRT1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Set header node
 S BQII=BQII+1,@DATA@(BQII)="I00010PREDEF_IEN^T00030PREDEF_NAME^T00001PREDEF_TYPE^T00250PREDEF_DESC"_$C(30)
 ;Loop through PreDefined Panels File and retrieve data
 S PPIEN=0
 F  S PPIEN=$O(^BQI(90506,PPIEN)) Q:'PPIEN  D
 . S STAT=$$GET1^DIQ(90506,PPIEN_",",.02,"I") I STAT Q  ; Inactive panel
 . S NM=$$GET1^DIQ(90506,PPIEN_",",.01,"I")
 . S TYPE=$$GET1^DIQ(90506,PPIEN_",",.04,"I")
 . S DESC=$$GET1^DIQ(90506,PPIEN_",",1,"I")
 . S BQII=BQII+1,@DATA@(BQII)=PPIEN_"^"_NM_"^"_TYPE_"^"_DESC_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERRPP ;Error trap for PreDefined Panel
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
USRQLST(DATA,FAKE) ; EP -- BQI GET QMAN TEMPLATE LIST
 ;
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ; Output
 ;  ^TMP("BQIPLRT1",UID,"QT",#)=TEMPLATE IEN_^_TEMPLATE NAME_"^"_FILE NUMBER
 ;  
 ; Variables
 ;  UID      - Unique ID for passing data to and from the GUI
 ;  CLINKEY  - IEN for AMQQZCLIN key
 ;  SRTTEMP  - Sort template IEN
 ;  TEMPUSER - User associated with a template
 ;  BQII     - Increment variable for setting Output nodes
 ;  FILE     - Used to hold the file number for the Patient and Visit files
 ;  TEMPNM   - Template Name
 ;  CHKTEMP  - Used to check if the template has any patients associated with them.
 ;  
 N UID,CLINKEY,SRTTEMP,TEMPUSER,BQII,FILE,TEMPNM,CHKTEMP,USER,CREATBY,SCOMPDT,FILNM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),BQII=0,U="^"
 S DATA=$NA(^TMP("BQIPLRT1",UID,"QT"))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERRQT^BQIPLRT1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S BQII=BQII+1,@DATA@(BQII)="I00010QMAN_IEN^T00085QMAN_TEMPLATE_NAME"_$C(30)
 ;THIS CODE HAS BEEN COMMENTED OUT PENDING ANSWERS FROM IHS.
 ;
 ;If this code is ever added back, also check BQIULSC which contains the start
 ;of a generic function for checking security keys for a user.
 ;
 ;S CLINKEY=$O(^DIC(19.1,"B","AMQQZCLIN","")) Q:CLINKEY=""
 ; If this user does not have the AMQQZCLIN security key, find only those
 ; templates that were created by this user.
 ;I '$D(^VA(200,DUZ,51,CLINKEY))  D  Q
 ;.F FILE="F9000001","F9000010"  D
 ;.S TEMPNM=""
 ;.F  S TEMPNM=$O(^DIBT(FILE,TEMPNM)) Q:TEMPNM=""  D
 ;..S SRTTEMP=$O(^DIBT(FILE,TEMPNM,"")) Q:'SRTTEMP
 ;..S CHKTEMP=$O(^DIBT(SRTTEMP,1,"")) I 'CHKTEMP Q
 ;..S TEMPUSER=$$GET1^DIQ(.401,SRTTEMP,5,"I")
 ;..Q:TEMPUSER'=DUZ
 ;..S BQII=BQII+1
 ;..S @DATA@(BQII)=SRTTEMP_U_TEMPNM_U_FILE_$C(30)
 ;.S BQII=BQII+1,@DATA@(BQII)=$C(31)
 ;
 ;
 ; If this user does have the AMQQZCLIN security key, create a list of ALL
 ; sort templates.
 ; 
 F FILE="F9000001","F9000010"  D
 .S TEMPNM=""
 .F  S TEMPNM=$O(^DIBT(FILE,TEMPNM)) Q:TEMPNM=""  D
 ..S SRTTEMP=0
 ..F  S SRTTEMP=$O(^DIBT(FILE,TEMPNM,SRTTEMP)) Q:'SRTTEMP  D
 ...; Check if there are any patients in the template, if not, quit
 ...S CHKTEMP=$O(^DIBT(SRTTEMP,1,"")) I 'CHKTEMP Q
 ...S USER=$$GET1^DIQ(.401,SRTTEMP,5,"I")
 ...S FILNM=$E($$GET1^DIQ(.401,SRTTEMP,4,"E"),1)
 ...S CREATBY=$$GET1^DIQ(200,USER,.01,"E")
 ...S SCOMPDT=$$GET1^DIQ(.401,SRTTEMP,9,"I"),SCOMPDT=$$FMTMDY^BQIUL1($P($G(SCOMPDT),"."))
 ...S BQII=BQII+1
 ...D PAD(.TEMPNM,35),PAD(.CREATBY,40),PAD(.FILNM,3)
 ...S @DATA@(BQII)=SRTTEMP_U_TEMPNM_FILNM_CREATBY_SCOMPDT_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
QMG(DATA,FAKE) ;EP -- BQI GET QMAN TEMPLATE GRID
 ; Variables
 ;  UID      - Unique ID for passing data to and from the GUI
 ;  CLINKEY  - IEN for AMQQZCLIN key
 ;  SRTTEMP  - Sort template IEN
 ;  TEMPUSER - User associated with a template
 ;  BQII     - Increment variable for setting Output nodes
 ;  FILE     - Used to hold the file number for the Patient and Visit files
 ;  TEMPNM   - Template Name
 ;  CHKTEMP  - Used to check if the template has any patients associated with them.
 ;  
 N UID,CLINKEY,SRTTEMP,TEMPUSER,BQII,FILE,TEMPNM,CHKTEMP,USER,CREATBY,SCOMPDT,FILNM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),BQII=0,U="^"
 S DATA=$NA(^TMP("BQIPLRT1",UID,"QT"))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERRQT^BQIPLRT1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010QMAN_IEN^T00030QMAN_TEMPLATE_NAME^T00001TEMPLATE_TYPE^T00035CREATED_BY^D00015COMPLETED_DATE"_$C(30)
 ; If this user does have the AMQQZCLIN security key, create a list of ALL
 ; sort templates.
 ; 
 F FILE="F9000001","F9000010"  D
 .S TEMPNM=""
 .F  S TEMPNM=$O(^DIBT(FILE,TEMPNM)) Q:TEMPNM=""  D
 ..S SRTTEMP=0
 ..F  S SRTTEMP=$O(^DIBT(FILE,TEMPNM,SRTTEMP)) Q:'SRTTEMP  D
 ...; Check if there are any patients in the template, if not, quit
 ...S CHKTEMP=$O(^DIBT(SRTTEMP,1,"")) I 'CHKTEMP Q
 ...S USER=$$GET1^DIQ(.401,SRTTEMP,5,"I")
 ...S FILNM=$E($$GET1^DIQ(.401,SRTTEMP,4,"E"),1)
 ...S CREATBY=$$GET1^DIQ(200,USER,.01,"E")
 ...S SCOMPDT=$$GET1^DIQ(.401,SRTTEMP,9,"I"),SCOMPDT=$$FMTMDY^BQIUL1($P($G(SCOMPDT),"."))
 ...S BQII=BQII+1
 ...S @DATA@(BQII)=SRTTEMP_U_TEMPNM_U_FILNM_U_CREATBY_U_SCOMPDT_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
PAD(STRING,FLDLNGTH) ;EP
 ; Input
 ;  STRING - string of data passed by reference
 ;  FLDLNGTH - Length you want the field to be. For example:
 ;     if you pass in a string with length of 15, and you need it to be padded
 ;     out to 30, then you enter 30 as the FLDLNGTH. This will provide for formatting
 ;     a string.
 ;     
 N SPACE,SPACESTR
 F SPACE=$L(STRING):1:FLDLNGTH S SPACESTR=$G(SPACESTR)_" "
 S STRING=$G(STRING)_$G(SPACESTR)
 Q
 ;
ERRQT ; Error trap for Q-Man Template
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
