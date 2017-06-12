BGOVPOV1 ; MSC/IND/DKM - Fix VPOV sequencing (primary first) ;15-Jun-2016 18:44;PLS
 ;;1.1;BGO COMPONENTS;**3,13,19,20**;Mar 20, 2007;Build 1
 ; Display routine help
HELP ;EP
 N LP,X
 F LP=0:1 S X=$P($T(HELPDATA+LP),";;",2,99)  Q:X="<END>"  W X,!
 Q
 ; Finds all visits with improperly sequenced VPOVs
 ; If FIX is true, the VPOVs will be resequenced
FINDALL(FIX) ;EP
 N VIEN,FND,FIXED,LP
 K ^XTMP("BGOVPOV1")
 S ^XTMP("BGOVPOV1",0)=DT_U_DT
 S (FND,FIXED,VIEN)=0,FIX=+$G(FIX)
 F LP=0:1  S VIEN=$O(^AUPNVPOV("AD",VIEN)) Q:'VIEN  D
 .W:'(LP#1000) "."
 .Q:$$GETVPOVS(VIEN)
 .S FND=FND+1
 .I FIX,$$FIXVPOVS(VIEN)=1 S FIXED=FIXED+1,^XTMP("BGOVPOV1","FIXED",VIEN)=""
 .E  S ^XTMP("BGOVPOV1","NOT FIXED",VIEN)=""
 S ^XTMP("BGOVPOV1","FIXED")=FIXED,^("NOT FIXED")=FND-FIXED
 W !,"Visits with improperly sequenced VPOVs: ",FND,!
 W !,"Visits with successfully resequenced VPOVs: ",FIXED,!
 Q
 ; Called from BGOVPOV to insure that the primary is the first entry.
 ;  VIEN = IEN of visit to inspect
 ; .VPOV = IEN of entry to track (optional - returned as new IEN if changed)
 ;  Returns: 0 = VPOV entries require no resequencing
 ;           1 = VPOV entries were successfully resequenced
 ;           2 = VPOV entries were not successfully resequenced
FIXVPOVS(VIEN,VPOV) ;EP
 N VPOV1,VPOV2,RET
 Q:$$GETVPOVS(VIEN,.VPOV1,.VPOV2) 0
 S RET=$$SWAP(VPOV1,VPOV2)
 Q:'RET 2
 S VPOV=$G(VPOV)
 S VPOV=$S(VPOV=VPOV1:VPOV2,VPOV=VPOV2:VPOV1,1:VPOV)
 Q 1
 ; Returns two VPOVs to be swapped.
 ;  VIEN = IEN of visit to inspect
 ;  VPOV1, VPOV2 = VPOV's to be swapped
 ;  Return value is 1 if VPOVs are in correct order
GETVPOVS(VIEN,VPOV1,VPOV2) ;EP
 S VPOV1=$$FNDPRI(VIEN)
 Q:'VPOV1 1
 S VPOV2=$O(^AUPNVPOV("AD",VIEN,0))
 Q:'VPOV2!(VPOV2=VPOV1) 1
 Q 0
 ; Swap VPOVs
 ; Returns true if successful
SWAP(VPOV1,VPOV2) ;
 N FDA,RET,NEWNUM
 Q:'$$BLDFDA(VPOV1,VPOV2,.FDA) 0
 S RET=$$UPDATE^BGOUTL(.FDA,"@")
 Q $S(RET<0:0,1:1)
 ; Build FDA array for swap
 ; Returns true if successful
BLDFDA(VPOV1,VPOV2,FDA,FLG) ;
 N REC,ERR,FLD,FNUM,IENS1,IENS2,FUM,FNUM2,SIEN,MULT,MULT2,RET
 S RET=""
 S IENS1=VPOV1_",",IENS2=VPOV2_",",FNUM=9000010.07
 D GETS^DIQ(FNUM,IENS1,"**","I","REC","ERR")
 Q:$$REFERR 0
 S FLD=""
 F  S FLD=$O(REC(FNUM,IENS1,FLD)) Q:'$L(FLD)  D
 .Q:$$GET1^DID(FNUM,FLD,,"TYPE")="COMPUTED"
 .S FDA(FNUM,IENS2,FLD)=REC(FNUM,IENS1,FLD,"I")
 F FUM=13,14,17,18 D
 .;Delete subfile if any
 .D DELSUB(.RET,$P(IENS1,",",1),FUM)
 .Q:+RET
 .S FNUM2=FNUM_FUM
 .S MULT=""
 .F  S MULT=$O(REC(FNUM2,MULT)) Q:'$L(MULT)  D
 ..S NUMNEW=$G(NUMNEW)+1
 ..S FLD="" F  S FLD=$O(REC(FNUM2,MULT,FLD)) Q:'$L(FLD)  D
 ...Q:FLD=.019
 ...Q:$$GET1^DIQ(FNUM2,FLD,,"TYPE")="COMPUTED"
 ...S SIEN="+"_NUMNEW_",",MULT2=SIEN_IENS2
 ...S FDA(FNUM2,MULT2,FLD)=REC(FNUM2,MULT,FLD,"I")
 Q:'$G(FLG) $$BLDFDA(VPOV2,VPOV1,.FDA,1)
 S FLD=""
 F  S FLD=$O(FDA(FNUM,IENS1,FLD)) Q:'$L(FLD)  D
 .I FDA(FNUM,IENS1,FLD)=FDA(FNUM,IENS2,FLD) D
 ..K FDA(FNUM,IENS1,FLD),FDA(FNUM,IENS2,FLD)
 Q:$D(FDA(FNUM,IENS1,.03)) 0
 Q:$D(FDA(FNUM,IENS1,.02)) 0
 Q 1
DELSUB(RET,IEN,SFIL) ;Delete the subfile entries
 N I,SIEN
 S SIEN="" F  S SIEN=$O(^AUPNVPOV(IEN,SFIL,SIEN)) Q:SIEN=""!(+RET)  D
 .S DA(1)=IEN,DA=SIEN
 .S DIK="^AUPNVPOV(DA(1),SFIL,"
 .S:DA RET=$$DELETE^BGOUTL(DIK,.DA)
 Q
REFERR() I $D(ERR("DIERR",1,"TEXT",1)) D  Q 1
 .S ^XTMP("BGOVPOV1","ERROR",VPOV1)=ERR("DIERR",1,"TEXT",1)
 Q 0
 ; Display POVs associated with a visit
DISPPOVS(VIEN) ;
 N VPOV,X,Y
 S VPOV=0
 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D
 .S X=$G(^AUPNVPOV(VPOV,0)),Y=$G(^(12))
 .W !,VIEN,": ",VPOV,!?5,"0: ",X,!?4,"12: ",Y,!!
 Q
 ; Return IEN of primary POV for a visit
FNDPRI(VIEN) ;EP
 N VPOV,RET,X
 S VPOV=0
 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D  Q:$D(RET)
 .S X=$G(^AUPNVPOV(VPOV,0))
 .I $P(X,U,3)=VIEN,$P(X,U,12)="P" S RET=VPOV
 Q $G(RET)
UPREV(RET,DFN,VIEN) ;Update review data
 N VSTR,ERR,TYPE,UTYP,INP
 S ERR=""
 S VSTR=$$VIS2VSTR^BEHOENCX(DFN,VIEN,ERR)
 I ERR'="" S RET=ERR Q
 F TYPE="PROBLEM LIST REVIEWED","PROBLEM LIST UPDATED" D
 .S UTYP=$O(^AUTTCRA("B",TYPE,""))
 .Q:'+UTYP
 .S INP=UTYP_U_0_U_DFN_U_VSTR_U_U_DUZ
 .D SET^BGOVUPD(.RET,INP)
 Q
QUAL(RET,POV,QUAL) ;EP
 ;Store the episodicity qualifiers
 N FNUM,IEN,SNO,DEL
 S FNUM=9000010.0714
 S IEN=+$P(QUAL,U,3)
 S SNO=$P(QUAL,U,4)
 S DEL=$P(QUAL,U,7)
 I '$D(^AUPNVPOV(POV,14,"B")) S IEN=""
 E  S IEN=0 S IEN=$O(^AUPNVPOV(POV,14,IEN))
 I +IEN&(DEL=1) D DELQ(RET,POV,IEN)
 E  D STORE(.RET,POV,SNO,FNUM,IEN)
 Q
STORE(RET,POV,SNO,FNUM,IEN) ;Store the qualifier data
 N AIEN,IEN2,ERR,FDA
 I IEN="" S AIEN="+1,"_POV_","
 E  S AIEN=IEN_","_POV_","
 S SNO=$TR(SNO," ","")
 S FDA(FNUM,AIEN,.01)=SNO
 D UPDATE^DIE(,"FDA","IEN2","ERR")
 I $G(ERR("DIERR",1)) S RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1)
 Q
QUALB(RET,PROB,POV) ;EP
 ;Move the qualfiers from the problem over to the POV fields
 N FUM,SNO,FNUM,I,IEN
 Q:$G(PROB)=""
 F FUM=13,17,18 D
 .S I=0 F  S I=$O(^AUPNPROB(PROB,FUM,I)) Q:'+I  D
 ..S SNO=$P($G(^AUPNPROB(PROB,FUM,I,0)),U,1)
 ..I SNO'="" D
 ...S FNUM=$S(FUM=13:9000010.0713,FUM=17:9000010.0717,FUM=18:9000010.0718)
 ...S IEN=""
 ...D STORE(.RET,POV,SNO,FNUM,IEN)
 Q
DELQ(RET,POV,PRIEN) ;Delete a qualifer
 N ERR,DA,DIK,NODE
 S ERR=""
 S NODE=14
 S DA(1)=PRIEN,DA=IEN
 S DIK="^AUPNVPOV(DA(1),"_NODE_","
 S:DA ERR=$$DELETE^BGOUTL(DIK,.DA)
 I ERR'="" S RET=RET_"^"_ERR
 Q
GETQUAL(IEN) ;Get any qualifiers for this POV
 N AIEN,IEN2,BY,WHEN,X,FNUM,Q,STRING,STRING2,STRING3,STRING4
 S (STRING,STRING2,STRING3,STRING4)=""
 F X=13,17,18,14 D
 .S IEN2=0 F  S IEN2=$O(^AUPNVPOV(IEN,X,IEN2)) Q:'+IEN2  D
 ..S AIEN=IEN2_","_IEN_","
 ..I X=13 D
 ...S Q=$$GET1^DIQ(9000010.0713,AIEN,.01)
 ...S Q=$$CONCEPT^BGOPAUD(Q)
 ...I STRING="" S STRING=Q
 ...E  S STRING=STRING_" "_Q
 ..I X=17 D
 ...S Q=$$GET1^DIQ(9000010.0717,AIEN,.01)
 ...S Q=$$CONCEPT^BGOPAUD(Q)
 ...I STRING2="" S STRING2=Q
 ...E  S STRING2=STRING2_" "_Q
 ..I X=18 D
 ...S Q=$$GET1^DIQ(9000010.0718,AIEN,.01)
 ...S Q=$$CONCEPT^BGOPAUD(Q)
 ...I STRING3="" S STRING3=Q
 ...E  S STRING3=STRING3_" "_Q
 ..I X=14 D
 ...S Q=$$GET1^DIQ(9000010.0714,AIEN,.01)
 ...S Q=$$CONCEPT^BGOPAUD(Q)
 ...I STRING4="" S STRING4=Q
 ...E  S STRING4=STRING4_" "_Q
 S QUAL=STRING_"|"_STRING2_"|"_STRING3_"^"_STRING4
 Q QUAL
QUALLK(PROMPT,SNOMED,TYPE) ;Lookup for normal/abnormal qualifier added P19
 ;Determine if this snomed code needs to be prompted for normal/abnormal qualifiers
 N IN,SEARCH,X
 S PROMPT=0
 S SEARCH=$S(TYPE="N":"EHR IPL PROMPT ABN FINDINGS",1:"")
 I SEARCH'="" D
 .S IN=SNOMED_U_SEARCH_U_U_1
 .S PROMPT=$$VSBTRMF^BSTSAPI(IN)
 Q
 ;IHS/MSC/MGH check for duplicates
 ;INP=DFN ^ SNOMED Concept CT ^ PRIEN
LATCHK(RET,INP) ;EP-Check laterality
 N CNT,DFN,CONCID,PRIEN,LAT,LEF,RI,BI,DATA
 S RET=$$TMPGBL^BGOUTL
 S DFN=$P(INP,U,1)
 S CNT=0
 S LEF="272741003|7771000",RI="272741003|24028007",BI="272741003|51440002"
 S CONCID=$P(INP,U,2)
 S PRIEN=$P(INP,U,3)
 S DATA("None",PRIEN)=1
 ;start with left
 K ARR
 D EQUIV^BSTSAPI("ARR",CONCID_"^"_$P(LEF,"|",2))
 D CHKTR(.ARR,"Left",LEF)
 ;then right
 K ARR
 D EQUIV^BSTSAPI("ARR",CONCID_"^"_$P(RI,"|",2))
 D CHKTR(.ARR,"Right",RI)
 ;then bilateral
 K ARR
 D EQUIV^BSTSAPI("ARR",CONCID_"^"_$P(BI,"|",2))
 D CHKTR(.ARR,"Bilateral",BI)
 ;Set up the 4 types
 F TYP="None","Left","Right","Bilateral" D
 .S IEN=$O(DATA(TYP,""))
 .I 'IEN D NEW(CONCID,TYP)
 .E  D SETDATA(IEN,TYP)
 Q
CHKTR(ARR,LATNAME,LATTYP) ;EP- Find equivalent problems
 N I1,ENOD,ESNO,ELAT,EEXT,ELAT,IEN,STAT,PLAT
 S I1="" F  S I1=$O(ARR(I1)) Q:I1=""  D
 .S ENOD=$G(ARR(I1))
 .S ESNO=$P(ENOD,U,1)
 .S ELAT=$P(ENOD,U,2)
 .S EEXT=$P(ENOD,U,3)
 .I ELAT="" D
 ..S IEN="" F  S IEN=$O(^AUPNPROB("APCT",DFN,ESNO,IEN)) Q:'+IEN  D
 ...S STAT=$$GET1^DIQ(9000011,IEN,.12,"I")
 ...Q:STAT="D"
 ...S PLAT=$$GET1^DIQ(9000011,IEN,.22)
 ...Q:EEXT'=1
 ...S DATA(LATNAME,IEN)=1_U_LATTYP
 .I ELAT'="" D
 ..S IEN="" F  S IEN=$O(^AUPNPROB("ASLT",DFN,ESNO,ELAT,IEN)) Q:'+IEN  D
 ...S STAT=$$GET1^DIQ(9000011,IEN,.12,"I")
 ...Q:STAT="D"
 ...S DATA(LATNAME,IEN)=1_U_LATTYP
 Q
SETDATA(PRIEN,TYP) ;get data for exisitng problem
 N DESCT,PNAR,EXLAT,PLAT,ICD,STAT
 S DESCT=$$GET1^DIQ(9000011,PRIEN_",",80002) ;Description ID
 S PNAR=$$GET1^DIQ(9000011,PRIEN_",",.05)        ;Prov nar
 S PLAT=$$GET1^DIQ(9000011,PRIEN_",",.22,"I") ;Laterality
 S ICD=$$GET1^DIQ(9000011,PRIEN_",",.01)  ;ICD code
 S EXLAT=""
 I PLAT'="" S EXLAT=$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|",2))
 S STAT=$$GET1^DIQ(9000011,PRIEN,.12,"I")
 S CNT=CNT+1
 S @RET@(CNT)=TYP_U_PRIEN_U_CONCID_U_PLAT_U_DESCT_U_PNAR_U_EXLAT_U_ICD_U_STAT
 Q
NEW(CONCID,TYP) ;Enter data for a new item
 N DESCT,PNAR,EXLAT,PLAT,ICD,STAT,NODE,DEFST
 S PLAT=$S(TYP="Left":"272741003|7771000",TYP="Right":"272741003|24028007",TYP="Bilateral":"272741003|51440002",1:"")
 S NODE=$$CONC^BSTSAPI(CONCID_"^^^1^^"_$P(PLAT,"|",2))
 S DESCT=$P(NODE,U,3)
 S PNAR=$P(NODE,U,4)
 S ICD=$P(NODE,U,5)
 S EXLAT=""
 I PLAT'="" S EXLAT=$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|",2))
 S DEFST=$P(NODE,U,9)
 S DEFST=$S(DEFST="Chronic":"A",DEFST="Sub-acute":"S",DEFST="Episodic":"E",DEFST="Social/Environmental":"O",DEFST="Routine/Admin":"R",DEFST="Admin":"R",1:"")
 S CNT=CNT+1
 S @RET@(CNT)=TYP_U_0_U_CONCID_U_PLAT_U_DESCT_U_PNAR_U_EXLAT_U_ICD_U_DEFST
 Q
HELPDATA ;;
 ;;
 ;;When BGOVPOV files VPOV entries, it does not place the primary POV
 ;;first.  PCC expects the primary POV to always have the lowest IEN
 ;;of POV's associated with a visit.  This utility aids in identifying
 ;;and fixing VPOV entries that are improperly sequenced.  The following
 ;;entry points are available:
 ;;
 ;;FIXVPOVS: This entry point accepts a visit IEN as its parameter.
 ;;When invoked, it will examine the specified visit and resequence
 ;;the associated POV entries if necessary.  It will return one of
 ;;the following values:
 ;;
 ;;     0 = No resequencing required
 ;;     1 = Resequencing succeeded
 ;;     2 = Resequencing failed
 ;;
 ;;FINDALL: This entry point will search all visits with associated
 ;;POV entries and report any with improperly sequenced entries.
 ;;It accepts an optional parameter.  If this parameter is passed
 ;;and has a nonzero value, improperly sequenced entries will be
 ;;repaired automatically.
 ;;
 ;;This entry point stores the results of the search in the
 ;;^XTMP("BGOVPOV1") global.  This global may be examined to
 ;;determine which visits were successfully resequenced
 ;;(listed under ^XTMP("BGOVPOV1","FIXED")) and which were not
 ;;(listed under ^XTMP("BGOVPOV1","NOT FIXED")).
 ;;
 ;;
 ;;<END>
