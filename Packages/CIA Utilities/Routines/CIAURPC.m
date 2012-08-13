CIAURPC ;MSC/IND/DKM - RPC Encapsulations for CIAU routines ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; RPC: CIAUDIC
DIC(CIADATA,CIABM,CIACMD,CIAARG) ;
 S CIADATA(0)=$$ENTRY^CIAUDIC(CIABM,CIACMD)
 Q
 ; RPC: CIAUSTX
MSYNTAX(CIADATA,CIACODE,CIAOPT) ;
 S CIADATA=$$ENTRY^CIAUSTX(CIACODE,.CIAOPT)
 Q
 ; RPC: Return a group of entries from a file
 ; CIAFN   = File #
 ; CIAFROM = Starting entry (default is null)
 ; CIADIR  = Direction (default = 1)
 ; CIASCN  = Screening logic (optional)
 ; CIAMAX  = Maximum entries (default = 20)
 ; CIAXRF  = Cross reference (default = B)
FILGET(CIADATA,CIAFN,CIAFROM,CIADIR,CIASCN,CIAMAX,CIAXRF) ;
 N CIAIEN,CIAGBL,CIATOT,Y
 S CIAFROM=$G(CIAFROM),CIADIR=$S($G(CIADIR)<0:-1,1:1),CIAMAX=$G(CIAMAX,20),CIAXRF=$G(CIAXRF,"B"),CIASCN=$G(CIASCN),CIAGBL=$$ROOT^DILFD(CIAFN,,1),CIATOT=0
 Q:'$L(CIAGBL)
 F  Q:CIATOT'<CIAMAX  S CIAFROM=$O(@CIAGBL@(CIAXRF,CIAFROM),CIADIR),CIAIEN=0 Q:'$L(CIAFROM)  D
 .F  S CIAIEN=$O(@CIAGBL@(CIAXRF,CIAFROM,CIAIEN)) Q:'CIAIEN  D
 ..Q:'$D(@CIAGBL@(CIAIEN,0))
 ..I $L(CIASCN) S Y=CIAIEN X CIASCN E  Q
 ..S CIATOT=CIATOT+1,@CIADATA@(CIATOT)=CIAIEN_U_CIAFROM
 Q
 ; RPC: Show all or selected entries for a file
 ; CIAGBL = File # or closed global reference
 ; CIAIEN = Optional list of IENs to retrieve (default=ALL)
 ;          May be passed as single IEN or array with IENs as subscripts
FILENT(CIADATA,CIAGBL,CIAIEN) ;
 N CIAG,CIAX
 S:CIAGBL=+CIAGBL CIAGBL=$$ROOT^DILFD(CIAGBL,,1)
 S CIADATA=$$TMPGBL
 Q:'$L(CIAGBL)
 S:$G(CIAIEN) CIAIEN(+CIAIEN)=""
 S CIAG=$S($D(CIAIEN):"CIAIEN",1:CIAGBL),CIAIEN=0
 F  S CIAIEN=$O(@CIAG@(CIAIEN)) Q:'CIAIEN  D
 .S CIAX=$P($G(@CIAGBL@(CIAIEN,0)),U)
 .S:$L(CIAX) @CIADATA@(CIAIEN)=CIAIEN_U_CIAX
 Q
 ; RPC: Show IEN of next/previous entry in a file
FILNXT(CIADATA,CIAGBL,CIAIEN) ;
 N CIAD
 S:CIAGBL=+CIAGBL CIAGBL=$$ROOT^DILFD(CIAGBL,,1)
 I CIAIEN<0 S CIAIEN=-CIAIEN,CIAD=-1
 E  S CIAD=1
 S CIADATA=+$O(@CIAGBL@(CIAIEN),CIAD)
 Q
 ; RPC: Convert date input to FM format
STRTODAT(DATA,VAL,FMT) ;
 N %DT,X,Y
 I VAL'["@",VAL[" " S VAL=$TR(VAL," ","@")
 I VAL["@",$TR($P(VAL,"@",2),":0")="" S $P(VAL,"@",2)="00:00:01"
 S %DT=$G(FMT,"TS"),X=VAL
 D ^%DT
 S DATA=$S(Y>0:Y,1:"")
 Q
 ; Return reference to temp global
TMPGBL(X) ;EP
 K ^TMP("CIAURPC"_$G(X),$J) Q $NA(^($J))
 ; Register/unregister RPCs within a given namespace to a context
REGNMSP(NMSP,CTX,DEL) ;EP
 N RPC,IEN,LEN
 S LEN=$L(NMSP),CTX=+$$GETOPT(CTX)
 I $G(DEL) D
 .S IEN=0
 .F  S IEN=$O(^DIC(19,CTX,"RPC","B",IEN)) Q:'IEN  D
 ..I $E($G(^XWB(8994,IEN,0)),1,LEN)=NMSP,$$REGRPC(IEN,CTX,1)
 E  D
 .Q:LEN<2
 .S RPC=NMSP
 .F  D:$L(RPC)  S RPC=$O(^XWB(8994,"B",RPC)) Q:NMSP'=$E(RPC,1,LEN)
 ..F IEN=0:0 S IEN=$O(^XWB(8994,"B",RPC,IEN)) Q:'IEN  I $$REGRPC(IEN,.CTX)
 Q
 ; Register/unregister an RPC to/from a context
 ; RPC = IEN or name of RPC
 ; CTX = IEN or name of context
 ; DEL = If nonzero, the RPC is unregistered (defaults to 0)
 ; Returns -1 if already registered; 0 if failed; 1 if succeeded
REGRPC(RPC,CTX,DEL) ;EP
 S RPC=+$$GETRPC(RPC)
 Q $S(RPC<1:0,1:$$REGMULT(19.05,"RPC",RPC,.CTX,.DEL))
 ; Add/remove a context to/from the ITEM multiple of another context.
REGCTX(SRC,DST,DEL) ;EP
 S SRC=+$$GETOPT(SRC)
 Q $S('SRC:0,1:$$REGMULT(19.01,10,SRC,.DST,.DEL))
 ; Add/delete an entry to/from a specified OPTION multiple.
 ; SFN = Subfile #
 ; NOD = Subnode for multiple
 ; ITM = Item IEN to add
 ; CTX = Option to add to
 ; DEL = Delete flag (optional)
REGMULT(SFN,NOD,ITM,CTX,DEL) ;
 N FDA,IEN
 S CTX=+$$GETOPT(CTX)
 S DEL=+$G(DEL)
 S IEN=+$O(^DIC(19,CTX,NOD,"B",ITM,0))
 Q:'IEN=DEL -1
 K ^TMP("DIERR",$J)
 I DEL S FDA(SFN,IEN_","_CTX_",",.01)="@"
 E  S FDA(SFN,"+1,"_CTX_",",.01)=ITM
 D UPDATE^DIE("","FDA")
 S FDA='$D(^TMP("DIERR",$J)) K ^($J)
 Q FDA
 ; Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
REGPROT(P,C,ERR) ;EP
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 Q:$Q $G(ERR)=""
 Q
 ; Remove nonexistent RPCs from context
CLNRPC(CTX) ;EP
 N IEN
 S CTX=+$$GETOPT(CTX)
 F IEN=0:0 S IEN=$O(^DIC(19,CTX,"RPC","B",IEN)) Q:'IEN  D:'$D(^XWB(8994,IEN)) REGRPC(IEN,CTX,1)
 Q
 ; Return IEN of option
GETOPT(X) ;EP
 N Y
 Q:X=+X X
 S Y=$$FIND1^DIC(19,"","X",X)
 W:'Y "Cannot find option "_X,!!
 Q Y
 ; Return IEN of RPC
GETRPC(X) ;EP
 N Y
 Q:X=+X X
 S Y=$$FIND1^DIC(8994,"","X",X)
 W:'Y "Cannot find RPC "_X,!!
 Q Y
