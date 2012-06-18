CIAZGRU ;MSC/IND/DKM - Generic Retrieval Utility ;29-Aug-2011 13:52;PLS
 ;;1.4;GENERIC RETRIEVAL UTILITY;;Feb 14, 2008
 ;;Copyright 2000-2008, Medsphere Systems Corporation
 ;=================================================================
 ;Modification 09/03/2010;MSC/MMT;Implement specific code to handle the AUDIT file
 ; EP: Main entry point for user interaction
ENTRY N GRU,CRT,ABORT,WHEN
 S GRU=$$GETIEN^CIAZGUTP(19950.41,"Select Retrieval: ","N X S X=^(0) I $P(X,U,3)=DUZ!$P(X,U,4)",.ABORT)
 Q:$G(ABORT)
 D GETCRT(GRU,.CRT,,.ABORT)
 Q:$G(ABORT)
 S WHEN=$$DIR^CIAZGUTP("DO^::FR","Run at what time","NOW",,.ABORT)
 D:'$G(ABORT) SUBMIT(GRU,WHEN,.CRT)
 Q
 ; EP: Submit a query
SUBMIT(GRU,WHEN,CRT,GBL) ;
 N SRT,PRT,RSLT
 D GETITEMS(GRU,30,.SRT),GETITEMS(GRU,40,.PRT)
 S RSLT=$$SUBMIT2(GRU,.WHEN,.CRT,.SRT,.PRT,.GBL)
 Q:$Q RSLT
 Q
 ; EP: Submit a query (alternate entry)
SUBMIT2(GRU,WHEN,CRT,SRT,PRT,GBL) ;
 N FDA,RSLT,IEN
 S RSLT=$$RSLTID^CIAZGUTL,IEN(1)=RSLT
 S FDA=$NA(FDA(19950.49,"+1,"))
 S @FDA@(.01)=$$NOW^XLFDT
 S @FDA@(1)=DUZ
 S @FDA@(2)=$P(^CIAZG(19950.41,GRU,0),U)
 S @FDA@(5)=0
 S @FDA@(7)=0
 S @FDA@(8)=0
 S @FDA@(9)=GRU
 D UPDATE^DIE(,"FDA","IEN")
 I '$G(WHEN) D
 .D TASK
 E  D RSLTUPD^CIAZGUTL(RSLT,6,$$QUEUE^CIAUTSK("TASK^CIAZGRU","Generic Retrieval Query",.WHEN,"CRT(^SRT(^PRT(^RSLT^GRU^GBL"))
 Q:$Q RSLT
 Q
 ; EP: Taskman entry point
TASK N GBLRT,GBLS,ABORT,INTRV,X,$ET,$ES
 S $ET="D TASKERR^CIAZGRU",ZTREQ="@"
 D RSLTUPD^CIAZGUTL(RSLT,5,1,1)
 D RSLTUPD^CIAZGUTL(RSLT,3,$$NOW^XLFDT)
 S GBLRT=$NA(^XTMP("CIAZGRU",RSLT)),(GBLS,PRT,ABORT)=0,INTRV=$$GET^XPAR("ALL","CIAZG UPDATE INTERVAL")
 S:INTRV<100 INTRV=100
 K @GBLRT
 S @GBLRT@(0)=DT+10000_U_DT_U_GRU
 F X="CRT","SRT","PRT" M @GBLRT@(X)=@X
 D OUTPRT($NA(@GBLRT@("FLD")),GRU)
 D RETRIEVE(GRU,.GBL,1)
 D RSLTUPD^CIAZGUTL(RSLT,5,$S(ABORT:3,1:2),1)
 D RSLTUPD^CIAZGUTL(RSLT,4,$$NOW^XLFDT)
 Q
 ; Error handler for task
TASKERR D ^%ZTER,RSLTUPD^CIAZGUTL(RSLT,5,5),UNWIND^%ZTER
 Q
 ; Output field list to result global
 ; Format in output global is:
 ;   Item Name^Width^Format^Datatype^Item IEN^Definition IEN^Multiple IEN
OUTPRT(GBL,GRU) ;
 N PRTX,LNK,ITM,FMT,TYP,WID,DTP,X
 S PRTX=0
 F  S PRTX=$O(PRT("C",GRU,PRTX)) Q:'PRTX  D
 .S X=PRT(PRTX,0),LNK=$P(X,U,3),FMT=$P(X,U,4),WID=$P(X,U,5)
 .S X=PRT(PRTX,-1),ITM=$P(X,U),TYP=$P(X,U,4),DTP=$P(X,U,7),LNK=$S(LNK:$P(X,U,6),1:0)
 .I $L(FMT),FMT'=2,TYP<2 S @GBL@(PRTX)=ITM_U_WID_U_FMT_U_DTP_U_PRT(PRTX)
 .Q:'LNK
 .I TYP>1 D
 ..S @GBL@(PRTX)=ITM
 ..D OUTPRT($NA(@GBL@(PRTX)),LNK)
 .E  D OUTPRT(GBL,LNK)
 Q
 ; Collect criteria for query
 ;   GRU  = GR Definition IEN
 ;  .ARY  = Array to receive data
 ;  .VALS = Supplied values (optional)
 ;  .ABORT= Abort flag (returned)
GETCRT(GRU,ARY,VALS,ABORT) ;
 N ARYX
 D GETITEMS(GRU,20,.ARY)
 S ARYX=0
 F  S ARYX=$O(ARY(ARYX)) Q:'ARYX  D  Q:$G(ABORT)
 .N GRU,VAL,LP,LPX,MLT,IENS
 .S GRU=+$P(ARY(ARYX),U,2),MLT=+$P(ARY(ARYX),U,3),IENS=MLT_","_GRU_","
 .I $D(VALS(IENS)) M VAL=VALS(IENS)
 .E  D
 ..S (LP,LPX)=0
 ..F  S LP=$O(ARY(ARYX,10,LP)) Q:'LP  S LPX=LPX+1,VAL(LPX)=ARY(ARYX,10,LP,0)
 ..I $P(ARY(ARYX,0),U,6) D
 ...N DTP,OPR,VTP,PROMPT
 ...M PROMPT=ARY(ARYX,20)
 ...K PROMPT(0)
 ...S DTP=+$P(ARY(ARYX,-1),U,7),OPR=+$P(ARY(ARYX,0),U,5),VTP=+$P(ARY(ARYX,0),U,6)
 ...S:VTP VTP=+$P($G(^CIAZG(19950.44,OPR,0)),U,2)
 ...X:VTP $G(^CIAZG(19950.43,DTP,10,VTP,1))
 .K ARY(ARYX,10),ARY(ARYX,20)
 .Q:'$D(VAL)!$G(ABORT)
 .S LP=0
 .F  S LP=$O(VAL(LP)) Q:'LP  S:$D(VAL(LP))#2 VAL("B",$S($L(VAL(LP)):VAL(LP),1:$C(1)))=""
 .M ARY(ARYX,"V")=VAL
 K:$G(ABORT) ARY
 Q
 ; Perform the retrieval
 ;   GRU  = GR Definition IEN
 ;   IENS = IENS of subfile
 ;       or global root for a join
 ;   TOP  = Flag indicating top level file
 ;
RETRIEVE(GRU,IENS,TOP) ;
 N IEN,FILE,ROOT,TMP,GBL,RTN,SRTL,CNT,TOT,FILEIEN,AUDIEN
 S (RTN,GBLS)=GBLS+1,GBL=$NA(@GBLRT@(GBLS)),TMP=$$TMPGBL^CIAZGUTL(GBLS),TOP=+$G(TOP),IENS=$G(IENS)
 S FILE=$P(^CIAZG(19950.41,GRU,0),U,2)
 I $E(IENS)=U S ROOT=IENS,IENS=""
 E  S ROOT=$$ROOT^DILFD(FILE,","_IENS,1)
 S (CNT,TOT,IEN,CNT(0))=0,TOT(0)=INTRV
 ;If processing the AUDIT file, branch to separate logic
 G:FILE="1.1" RETAUDIT
 F  Q:$$ABORT  S IEN=$O(@ROOT@(IEN)) Q:'IEN  D
 .N CRTV,PRTV,SRTV,IENX
 .I TOP,TOT'<TOT(0) D UPDCNT
 .S IENX=IEN_","_IENS,TOT=TOT+1
 .D FETCH(GRU,IENX,.CRT,.CRTV)
 .Q:'$$SCREEN(.CRT,.CRTV)
 .S:TOP @GBLRT@("IEN",IEN)=""
 .S CNT=CNT+1
 .D FETCH(GRU,IENX,.PRT,.PRTV,.CRTV)
 .D FETCH(GRU,IENX,.SRT,.SRTV,.PRTV)
 .D:'$D(SRTL) BLDSRT
 .D SUBFIL(GRU,IENX)
 .D SORT
 D MOVE
 D:TOP UPDCNT
 Q:$Q RTN
 Q
 ;Handle AUDIT file differently due to different IEN structure (^DIA(File#,IEN,...))
RETAUDIT ;
 S (FILEIEN,AUDIEN)=0
 F  Q:$$ABORT  S FILEIEN=$O(@ROOT@(FILEIEN)) Q:'FILEIEN  S AUDIEN=0 D
 .I '$D(CRT(2)),$D(CRT(1,"V",1)),$D(CRT(1,"V",2)),$G(CRT(1,-1))["DATE/TIME RECOR" D  Q
 ..N MSCI,MSCEND S MSCI=CRT(1,"V",1)-.01,MSCEND=$S(CRT(1,"V",2)[".":CRT(1,"V",2),1:CRT(1,"V",2)+.9) F  S MSCI=$O(@ROOT@(FILEIEN,"C",MSCI)) Q:('MSCI)!(MSCI>MSCEND)  D
 ...S AUDIEN=0 F  Q:$$ABORT  S AUDIEN=$O(@ROOT@(FILEIEN,"C",MSCI,AUDIEN)) Q:'AUDIEN  D MSC
 .F  Q:$$ABORT  S AUDIEN=$O(@ROOT@(FILEIEN,AUDIEN)) Q:'AUDIEN  D MSC
 D MOVE
 D:TOP UPDCNT
 Q:$Q RTN
 Q
MSC S IEN=FILEIEN_","_AUDIEN
 N CRTV,PRTV,SRTV,IENX
 I TOP,TOT'<TOT(0) D UPDCNT
 S IENX=IEN_","_IENS,TOT=TOT+1
 D FETCHAUD(GRU,IENX,.CRT,.CRTV)
 Q:'$$SCREEN(.CRT,.CRTV)
 S:TOP @GBLRT@("IEN",IEN)=""
 S CNT=CNT+1
 D FETCHAUD(GRU,IENX,.PRT,.PRTV,.CRTV)
 D FETCHAUD(GRU,IENX,.SRT,.SRTV,.PRTV)
 D:'$D(SRTL) BLDSRT
 D SUBFIL(GRU,IENX)
 D SORT
 Q
 ; Update counts in result file
UPDCNT D RSLTUPD^CIAZGUTL(RSLT,7,CNT,1):CNT'=CNT(0)
 D RSLTUPD^CIAZGUTL(RSLT,8,TOT)
 S TOT(0)=TOT\INTRV*INTRV+INTRV,CNT(0)=CNT
 Q
 ; Returns true if task should abort
ABORT() Q:ABORT 1
 S:$$S^%ZTLOAD ABORT=1
 S:$$RSLTSTA^CIAZGUTL(RSLT)>2 ABORT=1
 Q ABORT
 ; Iterate over subfiles
SUBFIL(GRU,IENS) ;
 N PRTX,LINK,TYPE,X
 S PRTX=0
 F  S PRTX=$O(PRT("C",GRU,PRTX)) Q:'PRTX  D
 .S LINK=$P(PRT(PRTX,0),U,3),TYPE=$P(PRT(PRTX,-1),U,4)
 .S:LINK LINK=$P(PRT(PRTX,-1),U,6)
 .Q:'LINK
 .I TYPE=2 D
 ..S X=$$RETRIEVE(LINK,IENS),PRTV(PRTX,"I")=X,PRTV(PRTX,"E")=X
 .E  I TYPE=3 D
 ..X ^CIAZG(19950.42,+PRT(PRTX),20)
 ..S X=$$RETRIEVE(LINK,X),PRTV(PRTX,"I")=X,PRTV(PRTX,"E")=X
 .E  D:$G(PRTV(PRTX,"I")) SUBFIL(LINK,PRTV(PRTX,"I")_",")
 Q
 ; Apply screening criteria.  Returns true if all criteria met.
SCREEN(CRT,CRTV) ;EP-
 N CRTX,OK,FLG,NEG
 S CRTX=0,(FLG,OK)=1
 F  S CRTX=$O(CRTV(CRTX)) Q:'CRTX  D
 .N VAL,OPR,EXE,DTP,OR,X,Y
 .S Y=CRT(CRTX,0),ITM=+CRT(CRTX),OPR=$P(Y,U,5),OR=$P(Y,U,4),NEG=$P(Y,U,7),DTP=$P(CRT(CRTX,-1),U,7)
 .Q:'OPR
 .I 'FLG,OK=OR Q
 .S X=CRTV(CRTX,"I"),X("I")=X,X("E")=CRTV(CRTX,"E")
 .M VAL=CRT(CRTX,"V")
 .S VAL(1)=$G(VAL(1)),VAL(2)=$G(VAL(2))
 .I 1
 .X $G(^CIAZG(19950.43,DTP,20,OPR,1))
 .S Y=$S(NEG:'$T,1:$T)
 .I FLG S OK=Y,FLG=0
 .E  I OR S OK=OK!Y
 .E  S OK=OK&Y
 Q OK
 ; Build list of sort items
BLDSRT S SRTL=0
 F  S SRTL=$O(SRTV(SRTL)) Q:'SRTL  S SRTL(SRTL)=$S($P($G(SRT(SRTL,0)),U,5):-1,1:1)
 S SRTL(999999999999)=1
 Q
 ; Save the result of a single record retrieval in sort order
 ; Result saved as
 ;   @TMP@(S1,S2...,Sn,N,S)
 ;   where Sn = sort field values
 ;          N = sequence # within identical sort values
 ;          S = sequence # in PRT control array
SORT N KEY,VAL,FMT,SRTX,KEYX,PRTX
 S SRTX=0,KEY=TMP
 F  S SRTX=$O(SRTV(SRTX)) Q:'SRTX  D
 .S FMT=$P(SRT(SRTX,0),U,4)
 .S VAL=$G(SRTV(SRTX,$S(FMT:"E",1:"I")))
 .S:VAL="" VAL=$C(0)
 .S KEY=$NA(@KEY@(VAL))
 S KEYX=$O(@KEY@(""),-1)+1,PRTX=0
 F  S PRTX=$O(PRTV(PRTX)) Q:'PRTX  D
 .S FMT=$P(PRT(PRTX,0),U,4)
 .S:$P(PRT(PRTX,-1),U,4)>1 FMT=0
 .M:$L(FMT)&(FMT'=2) @KEY@(KEYX,PRTX)=PRTV(PRTX,$S(FMT:"E",1:"I"))
 Q
 ; Move sorted results into target global
 ; Iterates over each sort value in ascending or descending order
MOVE N GBLX
 S GBLX=0
 D MOVEX(TMP,0)
 K @TMP
 Q
 ; Recurse over each sort subscript.
MOVEX(TMP,SRTX) ;
 N ORD,NXT
 S SRTX=$O(SRTL(SRTX))
 I 'SRTX D:$D(@TMP)  Q
 .S GBLX=GBLX+1
 .M @GBL@(GBLX)=@TMP
 S ORD=SRTL(SRTX),NXT=""
 F  S NXT=$O(@TMP@(NXT),ORD) Q:'$L(NXT)  D
 .D MOVEX($NA(@TMP@(NXT)),SRTX)
 Q
 ; Build item array from multiple
 ;  GRU  = IEN of GR Definition
 ;  NODE = Multiple root node
 ;  ARY  = Local array to receive data
 ;         where N = sequence #
 ;               I = IEN of GR Item
 ;               D = IEN of GR Definiton
 ;               M = IEN in multiple
 ;         ARY(N)       = I^D^M
 ;         ARY(N,-1)    = 0 node of GR Item entry
 ;         ARY(N,x)     = x node of multiple
 ;         ARY("B",I,N) = xref
 ;         ARY("C",D,N) = xref
GETITEMS(GRU,NODE,ARY,ARYX) ;
 N SEQ,MLT,ITM,LNK
 S SEQ="",ARYX=+$G(ARYX)
 F  S SEQ=$O(^CIAZG(19950.41,GRU,NODE,"B",SEQ)),MLT=0 Q:'$L(SEQ)  D
 .F  S MLT=$O(^CIAZG(19950.41,GRU,NODE,"B",SEQ,MLT)) Q:'MLT  D
 ..S ARYX=ARYX+1
 ..M ARY(ARYX)=^CIAZG(19950.41,GRU,NODE,MLT)
 ..S ITM=$P(ARY(ARYX,0),U,2),ARY("B",ITM,ARYX)="",ARY("C",GRU,ARYX)=""
 ..S ARY(ARYX)=ITM_U_GRU_U_MLT,ARY(ARYX,-1)=^CIAZG(19950.42,ITM,0)
 ..S LNK=$P(ARY(ARYX,0),U,3)
 ..S:LNK LNK=$P(ARY(ARYX,-1),U,6)
 ..D:LNK GETITEMS(LNK,NODE,.ARY,.ARYX)
 Q
 ; Fetch specified items
 ;   GRU  = GR Definition IEN
 ;   IENS = IENS of entry to fetch
 ;  .ITEMS= Items control array
 ;  .VALS = Array to receive values
 ;  .CACHE= Array of cached values (optional)
FETCH(GRU,IENS,ITEMS,VALS,CACHE) ;
 N FILE,FLDS,TYPE,DATA,LINK,ITMX,ITM,IEN,X,Y
 ; Build list of fields, computed values, and linked items
 S FLDS="",ITMX=0,FILE=$P(^CIAZG(19950.41,GRU,0),U,2),IEN=+IENS
 F  S ITMX=$O(ITEMS("C",GRU,ITMX)) Q:'ITMX  D
 .S LINK=$P(ITEMS(ITMX,0),U,3)
 .S X=ITEMS(ITMX,-1),TYPE=+$P(X,U,4),LINK=$S(LINK:$P(X,U,6),1:0)
 .Q:TYPE>1
 .S VALS(ITMX,"I")="",VALS(ITMX,"E")=""
 .S:LINK LINK(ITMX)=LINK
 .S Y=$O(CACHE("B",+ITEMS(ITMX),""))
 .I Y M VALS(ITMX)=CACHE(Y) Q
 .S TYPE(TYPE,ITMX)=""
 .I 'TYPE D
 ..S X=$P(X,U,5)
 ..I 'X S (VALS(ITMX,"I"),VALS(ITMX,"E"))=IEN
 ..E  S FLDS=FLDS_$S($L(FLDS):";",1:"")_X
 ; Fetch field values and move into ITEMS array
 S DATA=$$TMPGBL^CIAZGUTL("FETCH")
 D:$L(FLDS) GETS^DIQ(FILE,IENS,FLDS,"IE",DATA)
 S ITMX=0
 F  S ITMX=$O(TYPE(0,ITMX)) Q:'ITMX  D
 .N X,Y,Z
 .S X=$P(ITEMS(ITMX,-1),U,5),Y=$O(@DATA@(FILE,IENS,X,0))
 .I 'Y M VALS(ITMX)=@DATA@(FILE,IENS,X)
 .E  D  ; WP Field
 ..S (VALS(ITMX,"I"),VALS(ITMX,"E"))=@DATA@(FILE,IENS,X,Y)
 ..F  S Y=$O(@DATA@(FILE,IENS,X,Y)) Q:'Y!(Y>10000)  D
 ...S (VALS(ITMX,"I",Y-1),VALS(ITMX,"E",Y-1))=$S(Y=10000:"<DATA TRUNCATED",1:@DATA@(FILE,IENS,X,Y))
 K @DATA
 ; Evaluate computed values and move into ITEMS array
 S ITMX=0
 F  S ITMX=$O(TYPE(1,ITMX)) Q:'ITMX  D
 .N X
 .X $G(^CIAZG(19950.42,+ITEMS(ITMX),20))
 .S VALS(ITMX,"I")=$G(X("I"),$G(X))
 .S VALS(ITMX,"E")=$G(X("E"),$G(X))
 ; Iterate over linked items
 S ITMX=0
 F  S ITMX=$O(LINK(ITMX)) Q:'ITMX  D
 .S X=$G(VALS(ITMX,"I"))
 .D:X FETCH(LINK(ITMX),X_",",.ITEMS,.VALS,.CACHE)
 Q
 ;AUDIT file specific FETCH routine
FETCHAUD(GRU,IENS,ITEMS,VALS,CACHE) ;
 N FILE,FLDS,TYPE,DATA,LINK,ITMX,ITM,IEN,X,Y
 K DATA M DATA=^DIA(FILEIEN,AUDIEN)
 ; Build list of fields, computed values, and linked items
 S FLDS="",ITMX=0,FILE=$P(^CIAZG(19950.41,GRU,0),U,2),IEN=+IENS
 F  S ITMX=$O(ITEMS("C",GRU,ITMX)) Q:'ITMX  D
 .S LINK=$P(ITEMS(ITMX,0),U,3)
 .S X=ITEMS(ITMX,-1),TYPE=+$P(X,U,4),LINK=$S(LINK:$P(X,U,6),1:0)
 .Q:TYPE>1
 .S VALS(ITMX,"I")="",VALS(ITMX,"E")=""
 .S:LINK LINK(ITMX)=LINK
 .S Y=$O(CACHE("B",+ITEMS(ITMX),""))
 .I Y M VALS(ITMX)=CACHE(Y) Q
 .S TYPE(TYPE,ITMX)=""
 .I 'TYPE D
 ..S X=$P(X,U,5)
 ..I 'X S (VALS(ITMX,"I"),VALS(ITMX,"E"))=IEN
 ..E  D
 ...S VALS(ITMX,"I")=$$AUDINT(X)
 ...S VALS(ITMX,"E")=$$AUDEXT(X)
 ; Evaluate computed values and move into ITEMS array
 S ITMX=0
 F  S ITMX=$O(TYPE(1,ITMX)) Q:'ITMX  D
 .N X
 .X $G(^CIAZG(19950.42,+ITEMS(ITMX),20))
 .S VALS(ITMX,"I")=$G(X("I"),$G(X))
 .S VALS(ITMX,"E")=$G(X("E"),$G(X))
 ; Iterate over linked items
 S ITMX=0
 F  S ITMX=$O(LINK(ITMX)) Q:'ITMX  D
 .S X=$G(VALS(ITMX,"I"))
 .D:X FETCH(LINK(ITMX),X_",",.ITEMS,.VALS,.CACHE)
 Q
 ;FETCH AUDIT internal values
AUDINT(FLD) ;EP-
 N X
 I FLD=".001" Q $P(IENS,",",2)
 I FLD=".01" Q $P(DATA(0),U,1)
 I FLD=".02" Q $P(DATA(0),U,2)
 I FLD=".03" Q $P(DATA(0),U,3)
 I FLD=".04" Q $P(DATA(0),U,4)
 I FLD=".05" Q $P(DATA(0),U,5)
 I FLD="1" Q $S($P(DATA(0),U,1)'="":$$GET1^DIQ(FILEIEN,$P(DATA(0),U,1),.01),1:"")
 I FLD="1.1" Q $P(^DD(FILEIEN,$P($P(DATA(0),U,3),",",1),0),U,1)
 I FLD="2" Q $G(DATA(2))
 I FLD="2.1" Q $P($G(DATA(2.1)),U,1)
 I FLD="2.2" Q $P($G(DATA(2.1)),U,2)
 I FLD="3" Q $G(DATA(3))
 I FLD="3.1" Q $P($G(DATA(3.1)),U,1)
 I FLD="3.2" Q $P($G(DATA(3.1)),U,2)
 I FLD="4.1" Q $P($G(DATA(4.1)),U,1)
 I FLD="4.2" Q $P($G(DATA(4.1)),U,2)
 I FLD=".06" Q $P(DATA(0),U,6)
 I FLD="2.9" N X,D0 S DIA=+$P(IENS,",",1),D0=+$P(IENS,",",2) X ^DD(1.1,2.9,9.1) Q X
 Q FLD_"intunk"
 Q
 ;FETCH AUDIT external values
AUDEXT(FLD) S INTVAL=$$AUDINT(FLD)
 ;RETURN INTERNAL VALUES FOR FIELDS NOT NEEDING TRANSLATION
 Q:(FLD=".001")!(FLD=".01")!(FLD=".03")!(FLD="1")!(FLD="1.1")!(FLD="2")!(FLD="2.1")!(FLD="3")!(FLD="3.1") INTVAL
 ;Get external values for other fields
 I FLD=".02" S Y=INTVAL D DD^%DT Q Y
 I FLD=".04" Q $$GET1^DIQ(200,INTVAL,".01")
 I FLD=".05" Q $S(INTVAL="A":"Added Record",1:"")
 I FLD=".06" Q $S(INTVAL="i":"Inquired",1:"")
 I FLD="2" Q $S(INTVAL="":"<no previous value>",1:INTVAL)
 I (FLD="2.2")!(FLD="3.2") Q $S(INTVAL="S":"Set",INTVAL="P":"Pointer",INTVAL="V":"Variable Pointer",1:"")
 I FLD="3" Q $S(INTVAL="":"<deleted>",1:INTVAL)
 I FLD="4.1" Q $$GET1^DIQ(19,INTVAL,".01")
 I FLD="4.2" Q INTVAL ; THIS NEEDS TO DETERMINE HOW TO EVALUATE THIS "VARIABLE POINTER"
 I FLD=2.9 Q $P($G(^DPT(+INTVAL,0)),U)
 Q FLD_"exunk"
 Q
