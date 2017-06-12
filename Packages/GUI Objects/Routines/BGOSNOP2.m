BGOSNOP2 ; IHS/MSC/MGH - SNOMED PREFERENCES MANAGER 2 ;07-Apr-2016 07:54;du
 ;;1.1;BGO COMPONENTS;**13,14,20**;Mar 20, 2007;Build 1
 ; Clone a preference
 ;  INP = Pref IEN (from) ^ Pref IEN (to)
CLONE(RET,INP) ;EP
 N FROM,TO,ITM,SFN,GBL,FNUM,X1
 S FNUM=90362.34
 K RET
 S RET=$$GBLROOT^BGOPFUTL(FNUM,.GBL,.SFN)
 Q:RET
 I $G(INP)="" S RET=$$ERR^BGOUTL(1008) Q
 S FROM=+INP
 I 'FROM S RET=$$ERR^BGOUTL(1038) Q
 I '$D(@GBL@(FROM,0)) S RET=$$ERR^BGOUTL(1039) Q
 S TO=$P(INP,U,2)
 I 'TO S RET=$$ERR^BGOUTL(1040) Q
 I '$D(@GBL@(TO,0)) S RET=$$ERR^BGOUTL(1041) Q
 S ITM=0
 F  S ITM=$O(@GBL@(FROM,1,ITM)) Q:'ITM  D  Q:RET
 .N FDA,X
 .Q:$O(@GBL@(TO,1,"B",ITM,0))
 .S X=@GBL@(FROM,1,ITM,0)
 .S X1=@GBL@(FROM,1,ITM,1)
 .S FDA=$NA(FDA(SFN,"+1,"_TO_","))
 .S @FDA@(.01)=+X
 .S @FDA@(.02)=$P(X,U,2)
 .S @FDA@(.03)=$P(X,U,3)
 .S @FDA@(6)=$P(X1,U,1)
 .S RET=$$UPDATE^BGOUTL(.FDA,"@")
 Q
 ; Execute query
 ;  INP = Category IEN [1] ^ Provider IEN [2] ^ Clinic IEN [3] ^ Provider Class [4] ^ Hospital Location [5] ^
 ;        Start Date [6] ^ End Date [7] ^ Max Hits [8]
QUERY(RET,INP) ;EP
 N CAT,PRV,CLN,CLS,HL,BEGDT,ENDDT,VD,VIEN,VIS,PIEN,DX,ICD,REC,ICD,TXT,CNT,MAX,X
 N SNO,DESCT
 S RET=""
 S CAT=$P(INP,U)
 S PRV=$P(INP,U,2)
 S CLN=$P(INP,U,3)
 S CLS=$P(INP,U,4)
 S HL=$P(INP,U,5)
 S BEGDT=$P(INP,U,6)
 S ENDDT=$P(INP,U,7)
 S MAX=+$P(INP,U,8)
 I CLN="",CLS="",PRV="",HL="" S RET=$$ERR^BGOUTL(1022) Q
 S RET=$$QRYINIT^BGOPFUTL(90362.34,CAT)
 Q:RET
 S VD=$S(BEGDT:BEGDT,1:DT-20000)
 S:'ENDDT ENDDT=DT
 S CNT=0
 F  S VD=$O(^AUPNVSIT("B",VD)) Q:'VD!RET!(VD>ENDDT)  D
 .S VIEN=0
 .S VIEN=$O(^AUPNVSIT("B",VD,VIEN)) Q:'VIEN!RET  D
 ..S VIS=$G(^AUPNVSIT(VIEN,0))
 ..Q:VIS=""
 ..I CLN,$P(VIS,U,8)'=CLN Q
 ..I HL,$P(VIS,U,22)'=HL Q
 ..I PRV!CLS,'$$VISPRCL^BGOPFUTL(VIEN,PRV,CLS) Q
 ..S DX=0
 ..F  S DX=$O(^AUPNVPOV("AD",VIEN,DX)) Q:'DX!RET  D
 ...S SNO=$P($G(^AUPNVPOV(DX,11)),U)
 ...I SNO'="" D
 ....S CNT=CNT+1
 ....S DESCT=$P($G(^AUPNVPOV(DX,11)),U,2)
 ....S:CNT=MAX RET=CNT
 ....S REC=^AUPNVPOV(DX,0)
 ....S TXT=$$GET1^DIQ(9000010.07,DX,.04)
 ....D QRYADD^BGOPFUTL(90362.34,CAT,SNO,TXT)
 S RET=$$QRYDONE^BGOPFUTL(90362.34,CAT)
 Q
UPDITEM(FNUM,CAT,PTR,CNT,TXT,NEW,ITM) ;EP
 N FDA,IEN,GBL,SFN,RET,DESCT,X,IEN,ERR,SNO,TXT2
 S RET=$$GBLROOT^BGOPFUTL(FNUM,.GBL,.SFN)
 Q:RET RET
 S ITM=$S($G(NEW):0,1:$O(@GBL@(CAT,1,"B",PTR,0)))
 S:$E($G(CNT))="+" CNT=$S(ITM:$P(@GBL@(CAT,1,ITM,0),U,3),1:0)+CNT
 S FDA=$NA(FDA(SFN,$S(ITM:ITM,1:"+1")_","_CAT_","))
 ;IHS/MSC/MGH use new API
 ;S X=$$CONC^BSTSAPI(PTR_"^^^1")
 S X=$$CONC^AUPNSICD(PTR_"^^^1")
 S DESCT=$P(X,U,3),TXT2=$P(X,U,4)
 S @FDA@(.01)=PTR
 S:$D(CNT) @FDA@(.03)=CNT
 S:$G(DESCT) @FDA@(.02)=DESCT
 I TXT2'="" S @FDA@(6)=TXT2
 ;D UPDATE^DIE(,"FDA","IEN","ERR")
 ;I '$D(ERR),'ITM S ITM=IEN(1)
 S RET=$$UPDATE^BGOUTL(.FDA,"E@",.IEN)
 I 'RET,'ITM S ITM=IEN(1)
 Q RET
UPSTAT(RET,PICK) ;Update status to default on a picklist
 N LP,OUT,BGOS,BGODEF,BGOSNO,IN,BGOSNO,BGODEF,DATA,SNODATA,FDA,BGODEF,DEFST
 S RET=0,CNT=0
 S SFN=90362.342
 ;Loop through all the SNOMEDS on the picklist
 S LP=0 F  S LP=$O(^BGOSNOPR(PICK,1,LP)) Q:'+LP  D
 .S BGOSNO=$P($G(^BGOSNOPR(PICK,1,LP,0)),U,1)
 .;get this snomed's default status
 .S SNODATA=$$CONC^AUPNSICD(BGOSNO_"^^^1")
 .S DEFST=$P(SNODATA,U,9)
 .S DEFST=$S(DEFST="Chronic":"A",DEFST="Sub-acute":"S",DEFST="Episodic":"E",DEFST="Social/Environmental":"O",DEFST="Routine/Admin":"R",DEFST="Admin":"R",1:"")
 .I DEFST'="" D
 ..S FDA=$NA(FDA(SFN,LP_","_PICK_","))
 ..S @FDA@(.06)=DEFST
 ..S @FDA@(.04)=$$NOW^XLFDT
 ..S DATA=$$UPDATE^BGOUTL(.FDA,"")
 ..I 'DATA S CNT=CNT+1
 ..K DATA
 S RET=CNT
 Q
SETSUB ;
 N X,Y
 S X=$$SUBLST^BSTSAPI(OUT,IN)
 ;SET UP INDEX
 S Y=0 F  S Y=$O(^TMP($J,BGOS,Y)) Q:Y'=+Y  D
 .S X=$P(^TMP($J,BGOS,Y),U,1)
 .S ^TMP($J,"I",X,BGOS)=""
 .Q
 Q
UPDATE ;Update all picklist items to default status
 N ZTRTN,TSK,ZTDESC
 W !,"Update all picklist items to default status",!!
 S ZTRTN="OUT^BGOSNOP2"
 S ZTDESC="Update picklists to default status"
 S TSK=$$QUEUE^CIAUTSK(ZTRTN,ZTDESC,"","","","","")
 W !,"Picklist update has scheduled task number: "_TSK
 Q
OUT ;Update all subset with default status
 N IEN,SIEN,RET,PICK
 N LP,OUT,BGOS,BGODEF,BGOSNO,IN,BGOSNO,BGODEF,DATA,SFN,FDA
 S RET=0,CNT=0
 S SFN=90362.342
 S PICK=0
 ;Loop through the picklists
 S IEN=0 F  S IEN=$O(^BGOSNOPR(IEN)) Q:'+IEN!(PICK>3)  D
 .S PICK=PICK+1
 . ;Loop through all the SNOMEDS on the picklist
 .S LP=0 F  S LP=$O(^BGOSNOPR(IEN,1,LP)) Q:'+LP  D
 ..S BGOSNO=$P($G(^BGOSNOPR(IEN,1,LP,0)),U,1)
 ..;get this snomed's default status
 ..S SNODATA=$$CONC^AUPNSICD(BGOSNO_"^^^1")
 ..S DEFST=$P(SNODATA,U,9)
 ..S DEFST=$S(DEFST="Chronic":"A",DEFST="Sub-acute":"S",DEFST="Episodic":"E",DEFST="Social/Environmental":"O",DEFST="Routine/Admin":"R",DEFST="Admin":"R",1:"")
 ..I DEFST'="" D
 ...S FDA=$NA(FDA(SFN,LP_","_IEN_","))
 ...S @FDA@(.06)=DEFST
 ...S @FDA@(.04)=$$NOW^XLFDT
 ...S DATA=$$UPDATE^BGOUTL(.FDA,"")
 ...I 'DATA S CNT=CNT+1
 ...K DATA
 S RET=CNT
 Q
