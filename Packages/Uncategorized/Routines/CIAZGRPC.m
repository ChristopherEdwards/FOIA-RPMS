CIAZGRPC ;MSC/IND/DKM - Generic Retrieval RPC's;09-Dec-2011 10:12;PLS
 ;;1.4;GENERIC RETRIEVAL UTILITY;;Feb 14, 2008
 ;;Copyright 2000-2011, Medsphere Systems Corporation
 ;=================================================================
 ; RPC: CIAZG USER
 ; Returns info about user as IEN^Name
USERGET(DATA) ;
 S DATA=DUZ_U_$$GET1^DIQ(200,DUZ,.01)_U_$$HASKEY^BEHOUSCX("CIAZGRU")
 Q
 ; RPC: CIAZG DEFINITION DELETE
 ; Deletes a definition and its associated items and subdefinitions.
DEFNDEL(DATA,DEFN) ;
 S DATA=$$DEFNDEL^CIAZGUTL(DEFN)
 Q
 ; RPC: CIAZG DEFINITION CLONE
 ; Clones a definition
DEFNCLN(DATA,DEFN) ;
 S DEFN=$$DEFNCLN^CIAZGUTL(DEFN)
 I DEFN S DATA=0_U_DEFN
 E  S DATA="-1^Failed to clone the specified entry."
 Q
 ; RPC: CIAZG DEFINITION CHILD
 ; Create a new child definition
DEFNSUB(DATA,DEFN,FLD,SOURCE) ;
 S DATA=$$DEFNSUB^CIAZGUTL(DEFN,FLD,SOURCE)
 Q
 ; RPC: CIAZG DEFINITION CLEANUP
 ; Cleanup orphaned child definitions
DEFNCLP(DATA) ;
 D DEFNDLO^CIAZGUTL
 S DATA=1
 Q
 ; RPC: CIAZG DEFINITION CRITERIA
 ; Get criteria for definition
DEFNCRT(DATA,DEFN) ;
 N ARY,CNT,VTP,X
 D GETITEMS^CIAZGRU(DEFN,20,.ARY)
 S (CNT,ARY)=0
 F  S ARY=$O(ARY(ARY)) Q:'ARY  D
 .S X=ARY(ARY,0),VTP=+$P($G(^CIAZG(19950.44,+$P(X,U,5),0)),U,2)
 .Q:'VTP!'$P(X,U,6)
 .S $P(ARY(ARY),U,4)=VTP
 .D ADDCRT(ARY(ARY)),ADDCRT(ARY(ARY,-1)),ADDCRT(ARY(ARY,0))
 .D ADDCRTW(10),ADDCRTW(20)
 Q
ADDCRTW(MLT) ;
 N X,Y
 S X=+$P($G(ARY(ARY,MLT,0)),U,4)
 D ADDCRT(X)
 F Y=1:1:X D ADDCRT(ARY(ARY,MLT,Y,0))
 Q
ADDCRT(VAL) ;
 S CNT=CNT+1,DATA(CNT)=VAL
 Q
 Q
 ; RPC: CIAZG QUERY FETCH
 ; Fetch query result in XML format
 ;   DATA:  Global to receive data
 ;   RSLT:  Query result IEN
 ;   STRT:  Last record retrieved
 ;   COUNT: # of record to retrieve (-1=all,0=none,>0=#)
 ;   META:  If nonzero, include metadata
RSLTGET(DATA,RSLT,STRT,COUNT,META) ;
 D RSLTGET^CIAZGUTL(.DATA,.RSLT,.STRT,.COUNT,.META)
 Q
 ; RPC: CIAZG QUERY ABORT
 ; Abort a query
RSLTABR(DATA,RSLT) ;
 S DATA=$$RSLTABR^CIAZGUTL(RSLT)
 Q
 ; RPC: CIAZG ITEMS CLEANUP
ITEMSCLP(DATA,ITEMS) ;
 D ITEMDLO^CIAZGUTL(.ITEMS)
 S DATA=1
 Q
 ; RPC: CIAZG QUERY RUN
 ; Run the specified query
 ;   DEFN: IEN of query definition
 ;   VALS: Value list for user-supplied criteria
 ;   WHEN: Optional date/time to run
 ; COHORT: Optional selection cohort
QRYRUN(DATA,DEFN,VALS,WHEN,COHORT) ;
 N CRT,GBL
 D GETCRT^CIAZGRU(DEFN,.CRT,.VALS)
 S:$G(COHORT) GBL=$NA(^XTMP("CIAZGRU",COHORT,"IEN"))
 S DATA=$$SUBMIT^CIAZGRU(DEFN,.WHEN,.CRT,.GBL)
 Q
 ; RPC: CIAZG QUERY RERUN
 ; Rerun a query
 ;   RSLT: IEN of query result
 ;   WHEN: Optional date/time to run
QRYAGN(DATA,RSLT,WHEN,COHORT) ;
 N CRT,PRT,SRT,DEFN,GBL,X
 S DATA=0
 Q:'$D(^XTMP("CIAZGRU",RSLT,0))
 S DEFN=$P(^(0),U,3)
 Q:'$D(^CIAZG(19950.41,DEFN,0))
 F X="CRT","SRT","PRT" M @X=^XTMP("CIAZGRU",RSLT,X)
 S:$G(COHORT) GBL=$NA(^XTMP("CIAZGRU",COHORT,"IEN"))
 S DATA=$$SUBMIT2^CIAZGRU(DEFN,.WHEN,.CRT,.SRT,.PRT,.GBL)
 Q
 ; RPC: CIAZG JOIN FIELDS
 ; Return a list of fields that point from one file (FROM)
 ; to a second file (TO) and that have a standard xref.
 ; Returns list in the format:
 ;   <field #>^<field name>^<xref>
FLDJOIN(DATA,TO,FROM) ;
 D FLDJOIN^CIAZGUTL(.TO,.FROM,.DATA)
 Q
