BUSAUTIL ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Utility Program ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
 Q
 ;
SINPUT(PARM) ;PEP - Return Single Input Parameter Value
 ;
 ;Required Application Variables
 ;BUSARPC - The name of the called RPC
 ;BUSABKR - The broker making the call
 ;
 ;Input variable
 ;PARM - The RPC input parameter piece to pull
 ;
 NEW OUT
 ;
 I +$G(PARM)<1 Q ""
 I $G(BUSABKR)="" Q ""
 I $G(BUSARPC)="" Q ""
 ;
 ;Retrieve information
 D VAL("I",PARM,BUSABKR,BUSARPC,.OUT)
 ;
 ;Return first record
 Q $G(OUT)
 ;
SOUTPUT(PARM) ;PEP - Return Single Output Parameter Value
 ;
 ;Required Application Variables
 ;BUSARPC - The name of the called RPC
 ;BUSABKR - The broker making call
 ;
 ;Input variable
 ;PARM - The RPC input parameter piece to pull
 ;
 NEW OUT
 ;
 I +$G(PARM)<1 Q ""
 I $G(BUSABKR)="" Q ""
 I $G(BUSARPC)="" Q ""
 ;
 ;Retrieve information
 D VAL("R",PARM,BUSABKR,BUSARPC,.OUT)
 ;
 ;Return first record
 Q $G(OUT)
 ;
VAL(TYPE,LOCATION,BROKER,RPC,RVAL) ;PEP - Return information located in specified location
 ;
 ;Input:
 ; TYPE - The area to look (I:Input Parameter, R:Results)
 ; LOCATION - The input parameter number, the return piece or column name
 ; BROKER - The broker making the call (B:BMXNet,C:CIA,W:XWB)
 ; RPC - The RPC name
 ; RVAL - The return value array
 ;
 S TYPE=$G(TYPE),LOCATION=$G(LOCATION),BROKER=$G(BROKER),RPC=$G(RPC)
 ;
 I TYPE'="I",TYPE'="R" Q "0^Invalid Type"
 I LOCATION="" Q "0^Missing Location"
 I BROKER'="B",BROKER'="C",BROKER'="W" Q "0^Invalid Broker"
 I RPC="" Q "0^Missing RPC Call"
 ;
 ;Process data in input parameters
 I TYPE="I" D  G XVAL
 . I BROKER="B" D BINP(LOCATION,.RVAL)  ;BMXNet
 . I BROKER="C" D CINP(LOCATION,.RVAL)  ;CIA
 . I BROKER="W" D WINP(LOCATION,.RVAL)  ;XWB
 ;
 ;Process data in results
 I TYPE="R" D  G XVAL
 . I BROKER="B" D BRES(LOCATION,RPC,.RVAL) ;BMXNet
 . I BROKER="C" D CRES(LOCATION,RPC,.RVAL) ;CIA
 . I BROKER="W" D WRES(LOCATION,RPC,.RVAL) ;XWB
XVAL Q 1
 ;
BINP(LOC,RVAL) ;EP - Return BMXNet input parameter value
 S RVAL=$G(BUSAP(3,"P",LOC-1))
 Q
 ;
WINP(LOC,RVAL) ;EP - Return XWB input parameter value
 S RVAL=$G(BUSAP(3,"P",LOC-1))
 Q
 ;
CINP(LOC,RVAL) ;EP - Return CIA input parameter value
 S RVAL=$G(@("P"_LOC))
 Q
 ;
BRES(LOC,RPC,RVAL) ;EP - Return BMXNet result value
 ;
 NEW RPCIEN,RTVAL
 S RPCIEN=$O(^XWB(8994,"B",RPC,0))
 ;
 ;Retrieve global return value
 S RTVAL=$$GET1^DIQ(8994,RPCIEN_",",.04,"I")
 ;
 ;Global Array
 I RTVAL=4 D BGARES(LOC,.RVAL)
 ;
 Q
 ;
WRES(LOC,RPC,RVAL) ;EP - Return BMXNet result value
 ;
 NEW RPCIEN,RTVAL
 S RPCIEN=$O(^XWB(8994,"B",RPC,0))
 ;
 ;Retrieve global return value
 S RTVAL=$$GET1^DIQ(8994,RPCIEN_",",.04,"I")
 ;
 ;Global Array
 I RTVAL=4 D WGARES(LOC,.RVAL)
 ;
 Q
 ;
CRES(LOC,RPC,RVAL) ;EP - Return CIA result value
 ;
 ;Handle single value returns
 I XWBPTYPE=1 D  Q
 . S RVAL(1)=$P($G(CIAD),U,LOC)
 ;
 I XWBPTYPE=5 D  Q
 . S RVAL(1)=$P($G(@CIAD),U,LOC)
 ;
 ;Handle Array, Word Processing, Global Array
 I XWBPTYPE=2 D CROUT("CIAD",LOC,.RVAL) Q
 I XWBPTYPE=3 D CROUT("CIAD",LOC,.RVAL) Q
 I XWBPTYPE=4 D CROUT(CIAD,LOC,.RVAL) Q
 Q
 ;
 ;Return result information
CROUT(ARY,LOC,RVAL) ;
 N X,L,K,II
 S K=$E(ARY)'="~"
 S:'K ARY=$E(ARY,2,999)
 Q:'$L(ARY)
 S ARY=$NA(@ARY)
 S X=ARY,L=$QL(ARY)
 F  S X=$Q(@X) Q:'$L(X)  Q:$NA(@X,L)'=ARY  S II=$G(II)+1,RVAL(II)=$P($G(@X),U,LOC)
 Q
 ; 
BGARES(LOC,RVAL) ;EP - Return BMXNet Global Array Value
 ;
 NEW BMXIEN,FCOL,COL,FHDR,BMXHDR
 ;
 ;Pull header row and locate column
 S BMXHDR=@BMXY@(0)
 S FCOL="" F COL=1:1:$L(BMXHDR,U) S FHDR=$TR($E($P(BMXHDR,U,COL),7,99),$C(30)) I FHDR=LOC S FCOL=COL
 ;
 ;Find the field
 I FCOL]"" S BMXIEN=0 F  S BMXIEN=$O(@BMXY@(BMXIEN)) Q:BMXIEN=""  D
 . ;
 . NEW VAL
 . ;
 . ;Quit on last record
 . I $TR(@BMXY@(BMXIEN),$C(31))="" Q
 . ;
 . ;Pull the column value if populated
 . S VAL=$P($G(@BMXY@(BMXIEN)),U,FCOL)
 . I VAL]"" S RVAL(BMXIEN)=$TR(VAL,$C(30))
 Q
 ;
WGARES(LOC,RVAL) ;EP - Return XWB Global Array Value
 ;
 NEW XWBIEN,FCOL,COL,FHDR,XWBHDR
 ;
 ;Pull header row and locate column
 S XWBHDR=@XWBY@(0)
 S FCOL="" F COL=1:1:$L(XWBHDR,U) S FHDR=$TR($E($P(XWBHDR,U,COL),7,99),$C(30)) I FHDR=LOC S FCOL=COL
 ;
 ;Find the field
 I FCOL]"" S XWBIEN=0 F  S XWBIEN=$O(@XWBY@(XWBIEN)) Q:XWBIEN=""  D
 . ;
 . NEW VAL
 . ;
 . ;Quit on last record
 . I $TR(@XWBY@(XWBIEN),$C(31))="" Q
 . ;
 . ;Pull the column value if populated
 . S VAL=$P($G(@XWBY@(XWBIEN)),U,FCOL)
 . I VAL]"" S RVAL(XWBIEN)=$TR(VAL,$C(30))
 Q
 ;
BFILE(BUSAOVAL,BUSADVAL,PIECE,EXE,MULT,MINP) ;EP - BMX: Format and file data detail array
 ;
 ;Result output filing
 I $G(MULT)=1 D  Q
 . NEW BMXIEN
 . S BMXIEN=0 F  S BMXIEN=$O(@BMXY@(BMXIEN)) Q:BMXIEN=""  D
 .. NEW X,DFN,VIEN
 .. ;
 .. ;Pull DFN/VIEN so they can be used (if populated)
 .. S DFN=$P($G(BUSADVAL(BMXIEN)),U) I PIECE>2,DFN="" Q
 .. S VIEN=$P($G(BUSADVAL(BMXIEN)),U,2)
 .. ;
 .. ;Process desired piece
 .. S X=$G(BUSAOVAL) ;Look in variable first
 .. S:X="" X=$G(BUSAOVAL(BMXIEN)) ;Look in array second
 .. I $G(EXE)]"" X EXE
 .. I $G(X)]"" S $P(BUSADVAL(BMXIEN),U,PIECE)=X
 .. ;
 .. ;If VIEN piece - check if DFN needs filled in
 .. I PIECE'=2 Q
 .. ;
 .. ;Quit if already populated
 .. I DFN]"" Q
 .. ;
 .. ;Plug in DFN
 .. S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 .. I DFN]"" S $P(BUSADVAL(BMXIEN),U)=DFN
 ;
 ;Multiple input filing
 I $G(MINP)=1 D  Q
 . ;
 . ;DFN/VIEN pieces already processed
 . I (PIECE=1)!(PIECE=2) Q
 . ;
 . NEW BMXIEN
 . ;
 . S BMXIEN=0 F  S BMXIEN=$O(BUSADVAL(BMXIEN)) Q:BMXIEN=""  D
 .. ;
 .. NEW X,DFN,VIEN
 .. ;
 .. ;Pull populated values
 .. S DFN=$P(BUSADVAL(BMXIEN),U) I PIECE>2,DFN="" Q
 .. S VIEN=$P(BUSADVAL(BMXIEN),U,2)
 .. ;
 .. ;Pull field value
 .. S X=$P(BUSADVAL(BMXIEN),U,PIECE)
 .. ;
 .. ;Call executable
 .. I $G(EXE)]"" X EXE
 .. ;
 .. ;Save value
 .. I $G(X)]"" S $P(BUSADVAL(BMXIEN),U,PIECE)=X
 ;
 ;Single record output
 ;
 NEW X,DFN,VIEN
 ;
 ;Pull DFN/VIEN so they can be used (if populated)
 S DFN=$P($G(BUSADVAL(1)),U) I PIECE>2,DFN="" Q
 S VIEN=$P($G(BUSADVAL(1)),U,2)
 ;
 ;Now populate correct piece 
 S X=$G(BUSAOVAL) S:X="" X=$G(BUSAOVAL(1))
 I $G(EXE)]"" X EXE
 I $G(X)]"" S $P(BUSADVAL(1),U,PIECE)=X
 ;
 ;If VIEN piece - check if DFN needs filled in
 I PIECE'=2 Q
 ;
 ;Quit if already populated
 I DFN]"" Q
 ;
 ;Plug in DFN
 S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 I DFN]"" S $P(BUSADVAL(1),U)=DFN
 ;
 Q
 ;
WFILE(BUSAOVAL,BUSADVAL,PIECE,EXE,MULT,MINP) ;EP - XWB: Format and file data detail array
 ;
 ;Result output filing
 I $G(MULT)=1 D  Q
 . NEW XWBIEN
 . S XWBIEN=0 F  S XWBIEN=$O(@BXWB@(XWBIEN)) Q:XWBIEN=""  D
 .. NEW X,DFN,VIEN
 .. ;
 .. ;Pull DFN/VIEN so they can be used (if populated)
 .. S DFN=$P($G(BUSADVAL(XWBIEN)),U) I PIECE>2,DFN="" Q
 .. S VIEN=$P($G(BUSADVAL(XWBIEN)),U,2)
 .. ;
 .. ;Process desired piece
 .. S X=$G(BUSAOVAL) ;Look in variable first
 .. S:X="" X=$G(BUSAOVAL(XWBIEN)) ;Look in array second
 .. I $G(EXE)]"" X EXE
 .. I $G(X)]"" S $P(BUSADVAL(XWBIEN),U,PIECE)=X
 .. ;
 .. ;If VIEN piece - check if DFN needs filled in
 .. I PIECE'=2 Q
 .. ;
 .. ;Quit if already populated
 .. I DFN]"" Q
 .. ;
 .. ;Plug in DFN
 .. S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 .. I DFN]"" S $P(BUSADVAL(XWBIEN),U)=DFN
 ;
 ;Multiple input filing
 I $G(MINP)=1 D  Q
 . ;
 . ;DFN/VIEN pieces already processed
 . I (PIECE=1)!(PIECE=2) Q
 . ;
 . NEW XWBIEN
 . ;
 . S XWBIEN=0 F  S XWBIEN=$O(BUSADVAL(XWBIEN)) Q:XWBIEN=""  D
 .. ;
 .. NEW X,DFN,VIEN
 .. ;
 .. ;Pull populated values
 .. S DFN=$P(BUSADVAL(XWBIEN),U) I PIECE>2,DFN="" Q
 .. S VIEN=$P(BUSADVAL(XWBIEN),U,2)
 .. ;
 .. ;Pull field value
 .. S X=$P(BUSADVAL(XWBIEN),U,PIECE)
 .. ;
 .. ;Call executable
 .. I $G(EXE)]"" X EXE
 .. ;
 .. ;Save value
 .. I $G(X)]"" S $P(BUSADVAL(XWBIEN),U,PIECE)=X
 ;
 ;Single record output
 ;
 NEW X,DFN,VIEN
 ;
 ;Pull DFN/VIEN so they can be used (if populated)
 S DFN=$P($G(BUSADVAL(1)),U) I PIECE>2,DFN="" Q
 S VIEN=$P($G(BUSADVAL(1)),U,2)
 ;
 ;Now populate correct piece 
 S X=$G(BUSAOVAL) S:X="" X=$G(BUSAOVAL(1))
 I $G(EXE)]"" X EXE
 I $G(X)]"" S $P(BUSADVAL(1),U,PIECE)=X
 ;
 ;If VIEN piece - check if DFN needs filled in
 I PIECE'=2 Q
 ;
 ;Quit if already populated
 I DFN]"" Q
 ;
 ;Plug in DFN
 S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 I DFN]"" S $P(BUSADVAL(1),U)=DFN
 ;
 Q
 ;
CFILE(BUSAOVAL,BUSADVAL,PIECE,EXE,MULT,MINP) ;EP - Format and file CIA data detail array
 ;
 ;Multiple input filing
 I $G(MINP)=1 D  Q
 . ;
 . ;DFN/VIEN pieces already processed
 . I (PIECE=1)!(PIECE=2) Q
 . ;
 . NEW BMXIEN
 . ;
 . S BMXIEN=0 F  S BMXIEN=$O(BUSADVAL(BMXIEN)) Q:BMXIEN=""  D
 .. ;
 .. NEW X,DFN,VIEN
 .. ;
 .. ;Pull populated values
 .. S DFN=$P(BUSADVAL(BMXIEN),U) I PIECE>2,DFN="" Q
 .. S VIEN=$P(BUSADVAL(BMXIEN),U,2)
 .. ;
 .. ;Pull field value
 .. S X=$P(BUSADVAL(BMXIEN),U,PIECE)
 .. ;
 .. ;Call executable
 .. I $G(EXE)]"" X EXE
 .. ;
 .. ;Save value
 .. I $G(X)]"" S $P(BUSADVAL(BMXIEN),U,PIECE)=X
 ;
 ;Single return value
 ;
 I (XWBPTYPE=1)!(XWBPTYPE=5)!'MULT D  Q
 . ;
 . NEW X,DFN,VIEN
 . ;
 . ;Pull DFN/VIEN so they can be used (if populated)
 . S DFN=$P($G(BUSADVAL(1)),U) I PIECE>2,DFN="" Q
 . S VIEN=$P($G(BUSADVAL(1)),U,2)
 . ;
 . ;Now populate correct piece
 . S X=$G(BUSAOVAL) S:X="" X=$G(BUSAOVAL(1))
 . I $G(EXE)]"" X EXE
 . I $G(X)]"" S $P(BUSADVAL(1),U,PIECE)=X
 . ;
 . ;If VIEN piece - check if DFN needs filled in
 . I PIECE'=2 Q
 . ;
 . ;Quite if already populated
 . I DFN]"" Q
 . ;
 . ;Plug in DFN
 . S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 . I DFN]"" S $P(BUSADVAL(1),U)=DFN
 ;
 ;Multiple return values
 ;Handle Array, Word Processing, Global Array Types
 I XWBPTYPE=2 D CLOOP("CIAD",.BUSAOVAL,.BUSADVAL)
 I XWBPTYPE=3 D CLOOP("CIAD",.BUSAOVAL,.BUSADVAL)
 I XWBPTYPE=4 D CLOOP(CIAD,.BUSAOVAL,.BUSADVAL)
 Q
 ;
 ;Loop through output and fill in piece
CLOOP(ARY,BUSAOVAL,BUSADVAL) ;
 NEW CL,L,K,II
 S K=$E(ARY)'="~"
 S:'K ARY=$E(ARY,2,999)
 Q:'$L(ARY)
 S ARY=$NA(@ARY)
 S CL=ARY,L=$QL(ARY)
 F  S CL=$Q(@CL) Q:'$L(CL)  Q:$NA(@CL,L)'=ARY  D
 . ;
 . NEW X,DFN,VIEN
 . S II=$G(II)+1
 . ;
 . ;Pull DFN/VIEN so they can be used (if populated)
 . S DFN=$P($G(BUSADVAL(II)),U) I PIECE>2,DFN="" Q
 . S VIEN=$P($G(BUSADVAL(II)),U,2)
 . ;
 . ;Pull field value
 . S X=$S($G(BUSAOVAL)]"":BUSAOVAL,1:$G(BUSAOVAL(II)))
 . ;
 . ;Call executable
 . I $G(EXE)]"" X EXE
 . ;
 . ;Save value
 . I $G(X)]"" S $P(BUSADVAL(II),U,PIECE)=X
 . ;
 . ;If VIEN piece - check if DFN needs filled in
 . I PIECE'=2 Q
 . ;
 . ;Quit if already populated
 . I DFN]"" Q
 . ;
 . ;Plug in DFN
 . S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 . I DFN]"" S $P(BUSADVAL(II),U)=DFN
 ;
 Q
 ;
PNLNAME(USER,PIEN) ;EP - Return the iCare panel name
 ;
 NEW DA,IENS
 ;
 S USER=$G(USER),PIEN=$G(PIEN)
 ;
 I USER=""!(PIEN="") Q ""
 ;
 S DA(1)=USER,DA=PIEN,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90505.01,IENS,".01","I")
 ;
VFETCH(X,DESC) ;EP - Return the visit information
 ;
 ;Fetch existing visit
 S X=$P(X,";",4) Q:X]"" X
 ;
 ;Visit stub
 S X=$$SOUTPUT^BUSAUTIL(6)
 I X="" S DESC="EHR: Created new visit stub" Q ""
 ;
 ;New visit
 S DESC="EHR: Created new visit"
 Q X
 ;
WRAP(OUT,TEXT,RM,IND) ;EP - Wrap the text and insert in array
 ;
 NEW SP
 ;
 I $G(TEXT)="" S OUT(1)="" Q
 I $G(RM)="" Q
 I $G(IND)="" S IND=0
 S $P(SP," ",80)=" "
 ;
 ;Strip out $c(10)
 S TEXT=$TR(TEXT,$C(10))
 ;
 F  I $L(TEXT)>0 D  Q:$L(TEXT)=0
 . NEW PIECE,SPACE,LINE
 . S PIECE=$E(TEXT,1,RM)
 . ;
 . ;Check if line is less than right margin
 . I $L(PIECE)<RM S OUT=$G(OUT)+1,OUT(OUT)=PIECE,TEXT="" Q
 . ;
 . ;Locate last space in line and handle if no space
 . F SPACE=$L(PIECE):-1:(IND+1) I $E(PIECE,SPACE)=" " Q
 . I (SPACE=(IND+1)) D  S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT Q
 .. S LINE=PIECE,OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,RM+1,999999999))
 . ;
 . ;Handle line with space
 . S LINE=$E(PIECE,1,SPACE-1),OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,SPACE+1,999999999))
 . S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT
 ;
 Q
 ;
STZ(TEXT) ;EP - Strip Leading Spaces
 NEW START
 F START=1:1:$L(TEXT) I $E(TEXT,START)'=" " Q
 Q $E(TEXT,START,9999999999)
 ;
SEND(BUSAIEN,BUSAXPDA) ;EP - Determine whether to include RPC in KIDS build
 ;
 ;This function is call by code placed in the 'Screen to Select Data' field
 ;in the KIDS File List/Data Export Option
 ;
 ;Check for needed values
 I '$G(BUSAIEN) Q 0
 I '$G(BUSAXPDA) Q 0
 ;
 NEW TIEN,BIEN
 ;
 ;First look for RPC in BUSA RPC TRANSPORT LIST
 S TIEN=$O(^BUSATR("B",BUSAIEN,"")) Q:TIEN="" 0
 ;
 ;Now see if in build
 S BIEN=$O(^BUSATR(TIEN,1,"B",BUSAXPDA,"")) Q:BIEN="" 0
 ;
 ;Send in build
 Q 1
 ;
MINP(BUSALIST,BUSADLM,BUSATYPE,BUSAEXE,BUSADVAL) ;EP - Process Multiple input DFN/VIEN
 ;
 ;Updates the detail BUSADVAL array
 ;
 ;Input variables:
 ;BUSALIST - Variable containing list of DFNs/VIENs
 ;BUSADLM  - The list delimiter, in quotes, ex. "^",";","$C(28)",use "U" for "^"
 ;BUSATYPE - "D" for DFN list, "V" for VIEN list
 ;BUSAEXE  - Field executable code
 ;BUSADVAL - Array to update
 ;
 ;Input validation
 I $G(BUSALIST)="" Q
 I $G(BUSADLM)="" Q
 I $G(BUSATYPE)="" Q
 ;
 NEW PIECE,DETPC,DTCNT,DLM,X
 ;
 ;Format delimiter
 S DLM=$S(BUSADLM="U":"^",BUSADLM["$C(":$C($P($P(BUSADLM,"(",2),")")),1:BUSADLM)
 ;
 ;Determine piece to save
 S DETPC=$S(BUSATYPE="D":1,BUSATYPE="V":2,1:"") Q:DETPC=""
 ;
 ;Loop through list and save entry for each
 S DTCNT=0 F PIECE=1:1:$L(BUSALIST,DLM) S X=$P(BUSALIST,DLM,PIECE) D
 . NEW DFN
 . ;
 . ;Run executable code
 . I $G(BUSAEXE)]"" X BUSAEXE
 . ;
 . ;Quit if no value
 . I X="" Q
 . ;
 . ;Value defined - save entry
 . S DTCNT=DTCNT+1
 . S $P(BUSADVAL(DTCNT),U,DETPC)=X
 . ;
 . ;On type VIEN, check if DFN needed
 . Q:BUSATYPE="D"
 . ;
 . ;Quit if populated
 . I $P(BUSADVAL(DTCNT),U)]"" Q
 . ;
 . ;Plug in DFN
 . S DFN=$$GET1^DIQ(9000010,X_",",".05","I")
 . S $P(BUSADVAL(DTCNT),U)=DFN
 ;
 Q
 ;
CHECKAV(BUSAAV) ;EP - Authenticate AC/VC and Return DUZ
 ;
 ; Input: BUSAAV - ACCESS CODE_";"_VERIFY CODE
 ; Output: DUZ value
 ;
 N BUSADUZ,XUF
 ;
 S:$G(U)="" U="^"
 S:$G(DT)="" DT=$$DT^XLFDT
 ;
 S XUF=0
 S BUSADUZ=$$CHECKAV^XUS(BUSAAV)
 I BUSADUZ=0 Q 0
 ;
 ;Return DUZ if user inactive
 I (+$P($G(^VA(200,BUSADUZ,0)),U,11)'>0)!(+$P($G(^VA(200,BUSADUZ,0)),U,11)'<DT) Q BUSADUZ
 Q 0
 ;
AUTH(BUSADUZ) ;EP - Authenticate User for BUSA REPORT Access
 ;
 ; Input: BUSADUZ - User's DUZ value
 ; Output: 0 - No Authorized/1 - Authorized
 ;
 N BUSAKEY
 ;
 S:$G(U)="" U="^"
 ;
 I $G(BUSADUZ)<1 Q 0
 S BUSAKEY=$O(^DIC(19.1,"B","BUSAZRPT","")) I BUSAKEY="" Q 0
 I '$D(^VA(200,"AB",BUSAKEY,BUSADUZ,BUSAKEY)) Q 0
 Q 1
