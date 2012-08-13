CIAZGUTL ;MSC/IND/DKM - Generic Retrieval Utility Functions ;29-Aug-2011 14:05;PLS
 ;;1.4;GENERIC RETRIEVAL UTILITY;;Feb 14, 2008
 ;;Copyright 2000-2008, Medsphere Systems Corporation
 ;=================================================================
 ; Return unique result id
RSLTID() ; EP
 N X
 L +^CIAZG(19950.41,-1):5
 F  S (X,^(-1))=$G(^CIAZG(19950.41,-1))+1 Q:'$D(^(X))
 L -^CIAZG(19950.41,-1)
 Q X
 ; Return temp global reference
TMPGBL(NMSP) ; EP
 K ^TMP("CIAZG."_$G(NMSP),$J) Q $NA(^($J))
 ; Return true if operator is valid for given item.
OPRITM(OPR,ITM) ; EP
 N DTP
 S DTP=+$P($G(^CIAZG(19950.42,+ITM,0)),U,7)
 Q $D(^CIAZG(19950.43,DTP,20,"B",+OPR))
 ; Return a list of fields that point from one file (FROM)
 ; to a second file (TO) and that have a standard xref.
 ; Returns list in the format:
 ;   <field #>^<field name>^<xref>
FLDJOIN(TO,FROM,LST) ;
 N FLD,CNT,DD,XRF,X
 S (FLD,CNT)=0,TO=+TO,FROM=+FROM
 F  S FLD=$O(^DD(TO,0,"PT",FROM,FLD)) D:FLD  Q:'FLD
 .S DD=$G(^DD(FROM,FLD,0)),X=0,XRF=""
 .Q:+$P($P(DD,U,2),"P",2)'=TO
 .F  S X=$O(^DD(FROM,FLD,1,X)) Q:'X  S XRF=$G(^(X,0)) D  Q:$L(XRF)
 ..I $P(XRF,U,3)="" S XRF=$P(XRF,U,2)
 ..E  S XRF=""
 .Q:'$L(XRF)
 .S CNT=CNT+1
 .I $D(LST) S @LST@(CNT)=FLD_U_$P(DD,U)_U_XRF
 .E  S FLD=0
 Q:$Q CNT
 Q
 ; Return root global for a standard xref
XRFROOT(FIL,XRF,IEN) ; EP
 N GBL
 S GBL=$$ROOT^DILFD(FIL,,1)
 S:$L(GBL) GBL=$NA(@GBL@(XRF,IEN))
 Q GBL
 ; Returns true if query can be a cohort for another query.
COHORTOK(RSLT,DEFN1) ;
 N DEFN2,SRC1,SRC2
 Q:'$D(^XTMP("CIAZGRU",RSLT,"IEN")) 0
 S DEFN2=+$P($G(^CIAZG(19950.49,RSLT,0)),U,10)
 Q:'DEFN1!'DEFN2 0
 S SRC1=+$P($G(^CIAZG(19950.41,DEFN1,0)),U,2)
 S SRC2=+$P($G(^CIAZG(19950.41,DEFN2,0)),U,2)
 Q:SRC1=SRC2 1
 Q:$$DINUM(SRC1)=SRC2 1
 Q:$$DINUM(SRC2)=SRC1 1
 Q 0
 ; Returns file # of linked file if DINUM'd
DINUM(SRC) ;
 N X
 S X=$G(^DD(SRC,.01,0))
 Q:$P(X,U,5)'[" DINUM=X" 0
 S X=$P(X,U,2)
 Q:X'["P" 0
 Q +$P(X,"P",2)
 ; Update a field in the result file
RSLTUPD(RSLT,FLD,VAL,NOBR) ; EP
 N FDA
 S FDA(19950.49,RSLT_",",FLD)=VAL
 D UPDATE^DIE(,"FDA")
 D:'$G(NOBR) BRDCAST^CIANBEVT("CIAZG.RESULT."_RSLT,FLD)
 Q
 ; Abort a query in progress
RSLTABR(RSLT) ; EP
 N RTN
 S RTN=$$RSLTSTA(RSLT)
 I 'RTN D
 .N ZTSK
 .S ZTSK=$P($G(^CIAZG(19950.49,RSLT,0)),U,7)
 .D:ZTSK KILL^%ZTLOAD
 D:RTN<2 RSLTUPD(RSLT,5,$S(RTN:4,1:3))
 Q:$Q RTN<2
 Q
 ; Return query status
RSLTSTA(RSLT) ; EP
 Q $P($G(^CIAZG(19950.49,+RSLT,0)),U,6)
 ; Fetch query result in XML format
 ;   DATA:   Global to receive data
 ;   RSLT:   Query result IEN
 ;   STRT:   Starting position
 ;   COUNT:  # of record to retrieve (-1=all,0=none,>0=#)
 ;   SCHEMA: If nonzero, include schema
 ;   Returned data is XML recordset except first node is:
 ;     Records Retrieved^Last Record Retrieved^Total Records
RSLTGET(DATA,RSLT,STRT,COUNT,SCHEMA) ; EP
 N FLDS,TDTP
 M FLDS=^XTMP("CIAZGRU",RSLT,"FLD")
 S @DATA@(0)="0^0^"_$P(^CIAZG(19950.49,RSLT,0),U,8),SCHEMA=+$G(SCHEMA),COUNT(0)=COUNT,TDTP=$$FIND1^DIC(19950.43,,,"TEXT")
 Q:$D(FLDS)<10
 D ADD("<xml xmlns:s='uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882'")
 D ADD("xmlns:dt='uuid:C2F41010-65B3-11d1-A29F-00AA00C14882'")
 D ADD("xmlns:rs='urn:schemas-microsoft-com:rowset'")
 D ADD("xmlns:z='#RowsetSchema'>")
 D:SCHEMA ADD("<s:Schema id='RowsetSchema'>")
 D ADDFLDS("FLDS","row")
 D:SCHEMA ADD("</s:Schema>")
 D ADD("<rs:data>")
 D:COUNT RSLTADD(1,"FLDS",.STRT,,"z:row")
 D ADD("</rs:data>")
 D ADD("</xml>")
 S $P(@DATA@(0),U,1,2)=(COUNT(0)-COUNT)_U_STRT
 Q
 ; Add field attribute to output global
ADDFLD(NAM,DTP,ALIAS) ;
 N X
 S ORD=ORD+1
 S X="<s:AttributeType name='"_NAM_"'"
 S X=X_" rs:number='"_ORD_"'"
 S:$L($G(ALIAS)) X=X_" rs:name='"_ALIAS_"'"
 D ADD(X_" "_DTP_" />")
 Q
 ; Add field names to output global
ADDFLDS(ARY,NAM,REL,PAR) ;
 N ARYX,FLD,DTP,ITM,TYPE,FMT,WIDTH,ORD,X
 S ORD=0
 I SCHEMA D
 .D ADD("<s:ElementType name='"_$$ESCAPE(NAM)_"' content='eltOnly'"_$G(REL)_">")
 .D ADDFLD("id_"_$$ESCAPE(NAM),"dt:type='i4'")
 .D:$D(PAR) ADDFLD("id_"_PAR,"dt:type='i4'")
 S ARYX=0
 F  S ARYX=$O(@ARY@(ARYX)) Q:'ARYX  D
 .I $P(@ARY@(ARYX),U,5) D
 ..D FIXFLD
 ..Q:'SCHEMA
 ..S FLD=@ARY@(ARYX)
 ..S WIDTH=$P(FLD,U,2),FMT=$P(FLD,U,3),DTP=$S(FMT:TDTP,1:$P(FLD,U,4))
 ..S DTP=$P($G(^CIAZG(19950.43,$S(DTP:DTP,1:TDTP),0)),U,2)
 ..D ADDFLD("f"_ARYX,$$MSG^CIAU(DTP),$$ESCAPE($P(FLD,U)))
 .I $D(@ARY@(ARYX))>9 D
 ..D FIXFLD
 ..Q:'SCHEMA
 ..S FLD=@ARY@(ARYX)
 ..D ADDFLDS($NA(@ARY@(ARYX)),"f"_ARYX," rs:name='"_$$ESCAPE($P(FLD,U))_"' rs:relation='010000000200000000000000'",NAM)
 D:SCHEMA ADD("<s:extends type='rs:rowbase' />"),ADD("</s:ElementType>")
 Q
 ; Return XML attribute for a string datatype
STRING() Q "dt:type='string'"_$S(WIDTH>0:" dt:maxLength='"_WIDTH_"'",1:"")
 ; Format date/time as XML
 ;  X  = Date/time in FM format
 ;  XF = 0 = date/time; 1=date only; 2=time only
DT(X,XF) N %DT,D,T,Y
 S %DT="TS"
 D ^%DT
 Q:Y'>0 ""
 S Y=+$$FMTHL7^XLFDT(Y)
 S D=$E(Y,1,8),T=$E(Y,9,15)
 S:$L(T) T=T_"000000"
 S:XF<2 X=$E(D,1,4)_"-"_$$VR($E(D,5,6),"01",12)_"-"_$$VR($E(D,7,8),"01",31)_$S('XF&$L(T):"T",1:"")
 S:$L(T)&(XF'=1) X=X_$$VR($E(T,1,2),0,24)_":"_$$VR($E(T,3,4),0,59)_":"_$$VR($E(T,5,6),0,59)
 Q X
 ; Validate range
VR(VAL,LO,HI) ;
 Q $S(VAL<LO:LO,VAL>HI:HI,1:VAL)
 ; Fix field name to avoid dups
FIXFLD N F
 S F=$P(@ARY@(ARYX),U)
 F  Q:$G(FLD(F),ARYX)=ARYX  S F=F_"_"
 S $P(@ARY@(ARYX),U)=F,FLD(F)=ARYX
 Q
 ; Add results to output global
RSLTADD(LVL,ARY,RECN,LINK,TAG,IDS) ;
 F  S RECN=$O(^XTMP("CIAZGRU",RSLT,LVL,RECN)) Q:'RECN  D  Q:'COUNT
 .N ARYX,LVX,CLS,FMT,DTP,WID,ITM,LNK,OVF,X
 .D ADD("<"_TAG_" ")
 .S IDS(TAG)=$G(IDS(TAG))+1
 .S LNK="id_"_$S(TAG[":":$P(TAG,":",2),1:TAG)_"='"_IDS(TAG)_"'"
 .D ADD(LNK)
 .D:$D(LINK) ADD(LINK)
 .S ARYX=0,CLS=1
 .F  S ARYX=$O(@ARY@(ARYX)) Q:'ARYX  D
 ..S X=@ARY@(ARYX),WID=$P(X,U,2),FMT=$P(X,U,3),DTP=$S(FMT:TDTP,1:$P(X,U,4)),ITM=$P(X,U,5)
 ..S X=$G(^XTMP("CIAZGRU",RSLT,LVL,RECN,ARYX)),OVF=$S(WID:0,1:$O(^(ARYX,0)))
 ..Q:'$L(X)
 ..X $G(^CIAZG(19950.43,+DTP,2))
 ..Q:'ITM
 ..D ADD("f"_ARYX_"='"_$$ESCAPE(X,WID)_$S(OVF:"",1:"'"))
 ..I OVF D
 ...F  D  Q:'OVF
 ....S X=^XTMP("CIAZGRU",RSLT,LVL,RECN,ARYX,OVF),OVF=$O(^(OVF))
 ....D ADD($$ESCAPE(X)_$S(OVF:"",1:"'"))
 .F  S ARYX=$O(@ARY@(ARYX)) Q:'ARYX  D
 ..Q:$P(@ARY@(ARYX),U,5)
 ..S LVX=+$G(^XTMP("CIAZGRU",RSLT,LVL,RECN,ARYX))
 ..Q:'LVX
 ..D:CLS ADD(">")
 ..S CLS=0
 ..D RSLTADD(LVX,$NA(@ARY@(ARYX)),0,LNK,"f"_ARYX,.IDS)
 .D ADD($S(CLS:"/>",1:"</"_TAG_">"))
 .S:LVL=1 COUNT=COUNT-1
 Q
 ; Add result to output global
ADD(X) S @DATA@($O(@DATA@(""),-1)+1)=X
 Q
 ; Replace reserved characters with XML escape codes
ESCAPE(STR,MAX) ;
 N X,Y
 I $G(MAX),$L(STR)>MAX S STR=$E(STR,1,MAX)
 F X="&;amp","<;lt",">;gt","';apos",""";quot" D
 .S STR=$$SUBST^CIAU(STR,$P(X,";"),"&"_$P(X,";",2)_";")
 F X=1:1 S Y=$A(STR,X) Q:Y<0  S:Y>126 $E(STR,X)="&#"_Y_";",X=X+5
 Q STR
 ; Delete a query definition
 ;   DEFN: IEN of definition
 ;   FLAG: 0 = delete definition and all children
 ;         1 = delete items and children only
DEFNDEL(DEFN,FLAG) ; EP
 N FDA,ERR,X
 S X=$G(^CIAZG(19950.41,+DEFN,0))
 Q:'$L(X) "1^Cannot find query definition"
 S X=$P(X,U,3)
 I X,X'=DUZ Q "2^Insufficient privilege"
 D DDL2(DEFN,+$G(FLAG))
 D:$D(FDA)>1 UPDATE^DIE(,"FDA",,"ERR")
 Q:$G(DIERR) "3^"_$G(ERR("DIERR","1","TEXT",1))
 Q 0
DDL2(DEFN,FLAG) ;
 N SUB,IEN,LNK,ITM
 S:'FLAG FDA(19950.41,DEFN_",",.01)="@"
 F SUB=20,30,40 D
 .S IEN=0
 .F  S IEN=$O(^CIAZG(19950.41,DEFN,SUB,IEN)) Q:'IEN  S ITM=$P(^(IEN,0),U,2) D
 ..S LNK=$P(^CIAZG(19950.42,ITM,0),U,6)
 ..D:LNK DDL2(LNK,0)
 ..S FDA(19950.42,ITM_",",.01)="@"
 Q
 ; Delete orphaned child definitions
DEFNDLO ; EP
 N DEFN
 S DEFN=0
 F  S DEFN=$O(^CIAZG(19950.41,DEFN)) Q:'DEFN  D:'$P(^(DEFN,0),U,3)
 .I '$D(^CIAZG(19950.42,"ALINK",DEFN)),$$DEFNDEL(DEFN)
 Q
 ; Create a new query definition
DEFNNEW(NAME,SOURCE,OWNER,ACCESS,DESC) ; EP
 N FDA,IEN
 S FDA=$NA(FDA(19950.41,"+1,"))
 S @FDA@(.01)=NAME
 S @FDA@(1)=SOURCE
 S @FDA@(2)=OWNER
 S @FDA@(3)=ACCESS
 S:$D(DESC) @FDA@(99)="DESC"
 D UPDATE^DIE(,"FDA","IEN")
 Q:$Q $G(IEN(1))
 Q
 ; Create a child query definition
DEFNSUB(DEFN,FLD,SOURCE) ; EP
 N IEN,DESC,PNAM
 S PNAM=$P(^CIAZG(19950.41,DEFN,0),U),DESC(1,0)="Child definition of "_PNAM,PNAM=PNAM_"."_FLD
 F  Q:$L(PNAM)'>80  S PNAM=$P(PNAM,".",2,999)
 S IEN=$$DEFNNEW(PNAM,SOURCE,"","",.DESC)
 Q:$Q IEN
 Q
 ; Find a definition by name
DEFNFND(NAME) ; EP
 N X,IEN
 S X=$E(NAME,1,30),IEN=0
 F  S IEN=$O(^CIAZG(19950.41,"B",X,IEN)) Q:'IEN  Q:$P($G(^CIAZG(19950.41,IEN,0)),U)=NAME
 Q +IEN
 ; Clone a query definition
DEFNCLN(DEFN) ; EP
 N DEFN2,SUB,X,Y
 S OLD=^CIAZG(19950.41,DEFN,0),X=$P(OLD,U)
 S:X?1.E1"_"1.N X=$P(X,"_",1,$L(X,"_")-1)
 F Y=1:1 S DEFN2=X_"_"_Y Q:'$$DEFNFND(DEFN2)
 S DEFN2=$$DEFNNEW(DEFN2,$P(OLD,U,2),$S($P(OLD,U,3):DUZ,1:""),$P(OLD,U,4))
 I DEFN2 D
 .N ITM,LNK
 .S OLD=^CIAZG(19950.41,DEFN2,0)
 .K ^CIAZG(19950.41,DEFN2)
 .M ^(DEFN2)=^(DEFN)
 .S ^(DEFN2,0)=OLD
 .F SUB=20,30,40 D DC2(SUB)
 .D REINDEX(19950.41,DEFN2)
 Q:$Q DEFN2
 Q
 ; Clone all items in multiple
DC2(SUB) N ITMX,ITM0
 S ITMX=0
 F  S ITMX=$O(^CIAZG(19950.41,DEFN2,SUB,ITMX)) Q:'ITMX  S ITM=$P(^(ITMX,0),U,2) D
 .S LNK=$P(^CIAZG(19950.42,ITM,0),U,6)
 .I LNK,'$G(LNK(LNK)) S LNK(LNK)=$$DEFNCLN(LNK)
 .S:'$G(ITM(ITM)) ITM(ITM)=$$ITEMCLN(ITM,DEFN2,$S(LNK:LNK(LNK),1:""))
 .S $P(^CIAZG(19950.41,DEFN2,SUB,ITMX,0),U,2)=ITM(ITM)
 Q
 ; Reindex an entry in a file
REINDEX(DIK,DA) ;
 S DIK=$$ROOT^DILFD(DIK)
 D IX1^DIK
 Q
 ; Clone an item entry
ITEMCLN(ITEM,DEFN,LNK) ; EP
 N FDA,IEN
 S FDA=$NA(FDA(19950.42,"+1,"))
 S @FDA@(.01)=$P(^CIAZG(19950.42,ITEM,0),U)
 D UPDATE^DIE(,"FDA","IEN")
 S IEN=$G(IEN(1))
 I IEN D
 .M ^CIAZG(19950.42,IEN)=^CIAZG(19950.42,ITEM)
 .S $P(^CIAZG(19950.42,IEN,0),U,2)=DEFN,$P(^(0),U,6)=LNK
 .D REINDEX(19950.42,IEN)
 Q:$Q IEN
 Q
 ; Delete orphaned items
 ;   ITEMS: List of items to check (optional)
ITEMDLO(ITEMS) ; EP
 N ITEM,XREF,FDA,ALL,OK
 S ITEM=0,ALL=$D(ITEMS)<10
 F  S ITEM=$S(ALL:$O(^CIAZG(19950.42,ITEM)),1:$O(ITEMS(ITEM))) Q:'ITEM  D
 .S OK=1
 .F XREF="AITEMC","AITEMS","AITEME" I $D(^CIAZG(19950.41,XREF,ITEM)) S OK=0 Q
 .S:OK FDA(19950.42,ITEM_",",.01)="@"
 D:$D(FDA) UPDATE^DIE(,"FDA")
 Q
