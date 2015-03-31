APSPESG1 ;IHS/MSC/MGH - Display entries from refill queue in APSP REFILL REQUEST file ;02-Jul-2013 14:24;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1016**;Sep 23,2004;Build 74
 ;==================================================================
DETAIL(DATA,IEN) ;EP for RPC call
 N APSPPID,APSPDG1,APSPRXE,APSPRXO,APSPORC,STR,UNITS,ROUTE,NOUN,USCHDUR,MEDUNITS,SIGNAT,DONE,SCHITEM,SCHUPD,INTERVAL,SCHARY,TOTDUR,CONJ
 N HLECH,DEL,APSPMSH,APSPRXR,APSPRXD,DUR,SIGDAT,ITEM,MSGID,I
 S HLECH=$P($G(APSPMSH),"|",2) I '$L(HLECH) S HLECH="^~\&"
 F I=1:1:4 D
 .S HLECH(I)=$E(HLECH,I)
 S MSGID=$$GET1^DIQ(9009033.91,IEN,.01,"E"),HLMSG=$$GHLDAT(IEN)
 S DEL="|"
 D SHLVARS^APSPESG
 D HL7DATA(.HL7,IEN)
 D MAPDATA(.MAP,IEN)
 ;Put together dosing information
 S STR=$P($G(APSPRXO),DEL,3),UNITS=$P($P($G(APSPRXO),DEL,5),HLECH(1),2),ROUTE=$P($G(APSPRXR),DEL,2)
 S NOUN=$P($G(APSPRXO),DEL,6) I $L(NOUN) S NOUN=$O(^APSPNCP(9009033.7,"B",NOUN,0)),NOUN=$$GET1^DIQ(9009033.7,NOUN,1,"E")
 S USCHDUR=$P($G(APSPORC),DEL,8),MEDUNITS=$P($P($G(APSPRXO),DEL,20),HLECH(1),2)
 S SIGDAT=$P($P(APSPRXO,DEL,8),"^",2)
 S DONE=0
 F I=1:1 D  Q:DONE
 .S SCHITEM=$P(USCHDUR,HLECH(2),I)
 .I '$L(SCHITEM) S DONE=1 Q
 .S SCHUPD=$P(SCHITEM,HLECH(1)) I 'SCHUPD S SCHUPD=1
 .S INTERVAL=$P(SCHITEM,HLECH(1),2),DUR=$P(SCHITEM,HLECH(1),3),CONJ=$P(SCHITEM,HLECH(1),9)
 .S SCHARY(I)=SCHUPD_U_INTERVAL_U_DUR_U_CONJ
 .S TOTDUR=$G(TOTDUR)+DUR
 S DATA=$$TMPGBL^CIAVMRPC
 D CAPTURE^CIAUHFS("D DISPHL7^APSPESG1(.HL7,.MAP,STR,UNITS,ROUTE,NOUN,.SCHARY,MEDUNITS,SIGDAT)",DATA)
 Q
MAPDATA(MAP,IEN) ; Get the data that was mapped
 K MAP
 N PAT,DPT,DOB,SEX,HRCN,Y,PHARM,PROV
 S (PAT,DPT,DOB,SEX,HRCN,PROV)=""
 S DPT=$$GET1^DIQ(9009033.91,IEN,1.2,"I")
 I DPT'="" D
 .S PAT=$$GET1^DIQ(2,DPT,.01,"E")
 .S DOB=$$GET1^DIQ(2,DPT,.03,"I")
 .S Y=DOB D DD^%DT S DOB=Y
 .S SEX=$$GET1^DIQ(2,DPT,.02,"E")
 .S HRCN=$$HRCN(DPT,$G(DUZ(2)))
 .S MAP("PADDR")=$$PTADDR(DPT)
 .S MAP("PPHONE")=$$FMTPHN^APSPES2($$GET1^DIQ(2,DPT,.131,"I"))
 E  S PAT="**UNKNOWN**"
 S MAP("PAT")=PAT
 S MAP("EXT")="DOB: "_DOB_" SEX: "_SEX_" HRCN: "_HRCN
 S PHARM=$$GET1^DIQ(9009033.91,IEN,1.7,"I")
 S MAP("PHARM")=$$GET1^DIQ(9009033.91,IEN,1.7,"E")_" Ph: "_$$FMTPHN^APSPES2($$GET1^DIQ(9009033.9,PHARM,2.1,"I"))
 S MAP("PHARMA")=$$PADDR(PHARM)
 S MAP("SUP")=$$GET1^DIQ(9009033.91,IEN,1.5,"E")
 S MAP("QTY")=$$GET1^DIQ(9009033.91,IEN,1.4,"E")
 S MAP("TIME")=$$GET1^DIQ(9009033.91,IEN,0.4,"E")
 S MAP("DAW")=$$GET1^DIQ(9009033.91,IEN,1.12,"E")
 S PROV=$$GET1^DIQ(9009033.91,IEN,1.3,"I")
 S MAP("PROV")=$$GET1^DIQ(9009033.91,IEN,1.3,"E")
 S MAP("OFF")=$$FMTPHN^APSPES2($$GET1^DIQ(200,PROV,.132,"I"))
 S MAP("PROVAD")=$$PROVAD(PROV)
 S MAP("DRUG")=$$GET1^DIQ(9009033.91,IEN,1.1,"E")
 S MAP("SIG")=$$GET1^DIQ(9009033.913,"1,"_IEN_",",.01)
 ;S MAP("NOTES")=$$GET1^DIQ(9009033.91,IEN,4.1)
 S MAP("DX")=$$GET1^DIQ(9009033.91,IEN,7.1)
 S MAP("REFIL")=$$GET1^DIQ(9009033.91,IEN,1.9)
 Q
HL7DATA(HL7,IEN) ;Get the data from the HL7 file
 N PAT,DOB,SEX,HRCN,PROV,PROVDAT,SUB,DSUB,DCODE,DRG,DCODEQ
 K HL7
 S PAT=$$PATNAME^APSPESLP(APSPPID) I '$L(PAT) S PAT="**UNKNOWN**"
 S HRCN=$P($P(APSPPID,DEL,4),HLECH(1),1)
 S DOB=$$FMTE^XLFDT($$FMDATE^HLFNC($P(APSPPID,DEL,8)))
 S SEX=$P(APSPPID,DEL,9)
 S HL7("PAT")=PAT
 S HL7("EXT")="DOB: "_DOB_" SEX: "_SEX_" HRCN: "_HRCN
 S HL7("PPHONE")=$$FMTPHN^APSPES2($P($P(APSPPID,DEL,14),HLECH(1),1))
 S HL7("PADD")=$$FMTADD($P(APSPPID,DEL,12))
 S HL7("PHARM")=$P($P(APSPRXE,DEL,41),HLECH(1),2)_" Ph "_$$FMTPHN^APSPES2($P($P(APSPRXE,DEL,46),HLECH(1),1))
 S HL7("DRUG")=$P($P(APSPRXO,DEL,2),HLECH(1),2)
 S HL7("SUP")=$P($P($P(APSPORC,DEL,8),HLECH(1),3),"~",1)
 S HL7("QTY")=$P($P(APSPRXO,DEL,12),HLECH(1),1)
 S HL7("SIG")=$P($P(APSPRXO,DEL,8),HLECH(1),2)
 ;S HL7("INST")=$P($P(APSPRXO,DEL,7),HLECH(1),2)
 S HL7("NOTE")=$P($P(APSPRXO,DEL,7),HLECH(1),2)
 ;S HL7("NTE")=$P($P(APSPRXO,DEL,7),HLECH(1),2)
 S HL7("REFIL")=$P($P(APSPRXO,DEL,14),HLECH(1),1)
 S SUB=$P(APSPRXO,DEL,10)
 S HL7("SUB")=$S(SUB="G":"Allow Generics",SUB="N":"Dispense as Written",1:"Allow Theraputic Substitutions")
 S PROVDAT=$P(APSPORC,DEL,13),PROV=$P(PROVDAT,HLECH(1),2)_","_$P(PROVDAT,HLECH(1),3)
 S HL7("PROV")=PROV
 S HL7("PRADD")=$$FMTADD($P(APSPORC,DEL,25))
 S HL7("PRPH")=$$FMTPHN^APSPES2($P($P(APSPORC,DEL,24),HLECH(1),1))
 S HL7("ISSUE")=$$FMTE^XLFDT($$FMDATE^HLFNC($P($P(APSPORC,DEL,10),HLECH(1),1)),"5DZ0")
 S HL7("PHADD")=$$FMTADD($P(APSPRXE,DEL,42))
 S HL7("LFIL")=$$FMTE^XLFDT($$FMDATE^HLFNC($P($P(APSPORC,DEL,27),HLECH(1),1)),"5DZ0")
 S DCODE=$P($P(APSPRXD,DEL,3),HLECH(1),1)
 S DRG=$P($P(APSPRXD,DEL,3),HLECH(1),2)
 S DCODEQ=$P($P(APSPRXD,DEL,3),HLECH(1),3)
 S HL7("DDRG")=DRG_$S($L(DCODE):" ("_DCODEQ_":"_DCODE_")",1:"")
 S HL7("DSIG")=$P($P(APSPRXD,DEL,10),HLECH(1),1)
 S HL7("DSUP")=$P($P(APSPRXD,DEL,23),HLECH(1),1)
 S HL7("DQTY")=$P($P(APSPRXD,DEL,5),HLECH(1),1)
 S HL7("DREFILL")=$P($P(APSPRXD,DEL,9),HLECH(1),1)
 S HL7("DNOTE")=$P($P(APSPRXD,DEL,16),HLECH(1),2)
 S HL7("DDATE")=$$FMTE^XLFDT($$FMDATE^HLFNC($P($P(APSPRXD,DEL,4),HLECH(1),1)),"5DZ0")
 S DSUB=$P(APSPRXO,DEL,10)
 S HL7("DSUB")=$S(DSUB="G":"Allow Generics",DSUB="N":"Dispense as Written",1:"Allow Theraputic Substitutions")
 I APSPDG1'="" D
 .S HL7("DX")=$P($P(APSPDG1,DEL,4),HLECH(1),U,1)_" "_$P($P(APSPDG1,DEL,4),HLECH(1),2)
 Q
DISPHL7(HL7,MAP,STR,UNITS,ROUTE,NOUN,SCHARY,MEDUNITS,SIG,ARY) ; Display HL7 data
 N LINE,K
 W !!
 S $P(LINE,"-",80)=""
 W LINE
 W !,"  DISPLAYING incoming HL7 data:",!
 W !,"        Patient: "_$G(HL7("PAT"))
 W !,"        Pt Data: "_$G(HL7("EXT"))
 W !,"     Pt Address: "_$G(HL7("PADD"))
 W !,"       Pt Phone: "_$G(HL7("PPHONE"))
 W !,"       Provider: "_$G(HL7("PROV"))_" Ph: "_$G(HL7("PRPH"))
 W !,"   Prov Address: "_$G(HL7("PRADD"))
 W !!,"     Medication: "_$G(HL7("DRUG"))
 W !,"            SIG: "_$G(HL7("SIG"))
 ;W !,"       Pt Instr: "_$G(HL7("INST"))
 W !,"         Supply: "_$G(HL7("SUP"))
 W !,"       Quantity: "_$G(HL7("QTY"))
 W !,"        Refills: "_$G(HL7("REFIL"))
 W !,"             Dx: "_$G(HL7("DX"))
 W !,"            Sub: "_$G(HL7("SUB"))
 W !,"       Pharmacy: "_$G(HL7("PHARM"))
 W !,"     Ph Address: "_$G(HL7("PHADD"))
 W !," Notes to Pharm: "_$G(HL7("NOTE"))
 W !,"       Issue Dt: "_$G(HL7("ISSUE"))
 W !!,"  DISPENSED Drug Information",!
 W !," Dispensed Drug: "_$G(HL7("DDRG"))
 W !,"            SIG: "_$G(HL7("DSIG"))
 W !,"         Supply: "_$G(HL7("DSUP"))
 W !,"       Quantity: "_$G(HL7("DQTY"))
 W !,"        Refills: "_$G(HL7("DREFILL"))
 W !,"            Sub: "_$G(HL7("DSUB"))
 W !,"   Written Date: "_$G(HL7("DDATE"))
 W !,"  Notes to Prov: "_$G(HL7("DNOTE"))
 W !,""
 W LINE
 W !,"   MAPPED DATA:",!
 W !,"       Patient: "_$G(MAP("PAT"))
 W !,"       Pt Data: "_$G(MAP("EXT"))
 W !,"       Address: "_$G(MAP("PADDR"))
 W !,"      Pt Phone: "_$G(MAP("PPHONE"))
 W !,"      Provider: "_$G(MAP("PROV"))_" Ph: "_$G(MAP("OFF"))
 W !,"  Prov Address: "_$G(MAP("PROVAD"))
 W !!,"    Medication: "_$G(MAP("DRUG"))
 W !,"           SIG: "_$G(MAP("SIG"))
 W !,"        Supply: "_$G(MAP("SUP"))
 W !,"      Quantity: "_$G(MAP("QTY"))
 W !,"       Refills: "_$G(MAP("REFIL"))
 W !,"            Dx: "_$G(MAP("DX"))
 W !,"           Sub: "_$G(MAP("DAW"))
 W !,"      Pharmacy: "_$G(MAP("PHARM"))
 W !,"    Ph Address: "_$G(MAP("PHARMA"))
 ;W !,"        Notes: "_$G(MAP("NOTES"))
 W !!,"  Dosing information: (multiple line items indicates complex dosing)"
 W:$D(SCHARY) !,?3,"Units/Dose",?15,"Interval",?25,"Duration",?35,"Conjunction"
 F K=1:1 D  Q:'$D(SCHARY(K))
 .I $D(SCHARY(K)) W !,?5,$P(SCHARY(K),U),?15,$P(SCHARY(K),U,2),?25,$P(SCHARY(K),U,3),?35,$P(SCHARY(K),U,4)
 W !,LINE
 Q
 ;
HRCN(DFN,SITE) ;EP; IHS/MSC/MGH return chart number
 Q $P($G(^AUPNPAT(DFN,41,SITE,0)),U,2)
GHLDAT(IEN) ; Get HL7 message data from APSP REFILL REQUEST FILE
 N HLMSG
 S HLMSG=$$GET1^DIQ(9009033.91,IEN,5,"","HLDATA")
 Q HLMSG
 ;
CHKDEF(IEN,TEXT) ;
 N FOUND,X
 S FOUND=0
 S X=0 F  S X=$O(^APSPRREQ(ITEM,3,X)) Q:'X  D
 .I $G(^APSPRREQ(ITEM,3,X,0))=TEXT S FOUND=1
 Q FOUND
FMTADD(FIELD) ;
 ;Format the incoming address in HL7 file
 N ADDR,STR,CITY,ST,ZIP
 S ADDR=""
 I FIELD="" Q ADDR
 S STR=$P(FIELD,HLECH(1),1)
 S CITY=$P(FIELD,HLECH(1),3)
 S ST=$P(FIELD,HLECH(1),4)
 S ZIP=$P(FIELD,HLECH(1),5)
 S ADDR=STR_" "_CITY_", "_ST_" "_ZIP
 Q ADDR
PADDR(IEN) ;
 ;format pharmacy address from APSP Pharmacy file
 N ADDR,STR,STR2,CITY,ST,ZIP
 S ADDR=""
 S STR=$$GET1^DIQ(9009033.9,IEN,1.1,"E")
 S STR2=$$GET1^DIQ(9009033.9,IEN,1.2,"E")
 S CITY=$$GET1^DIQ(9009033.9,IEN,1.3,"E")
 S ST=$$GET1^DIQ(9009033.9,IEN,1.4,"E")
 S ZIP=$$GET1^DIQ(9009033.9,IEN,1.5,"E")
 I STR2'="" S STR=STR_" "_STR2
 S ADDR=STR_" "_CITY_" ,"_ST_" "_ZIP
 Q ADDR
PTADDR(DFN) ;Format patient address
 N ADDR,STR,STR2,CITY,ST,ZIP
 S ADDR=""
 S STR=$$GET1^DIQ(2,DFN,.111,"E")
 S STR2=$$GET1^DIQ(2,DFN,.112,"E")
 S CITY=$$GET1^DIQ(2,DFN,.114,"E")
 S ST=$$GET1^DIQ(2,DFN,.115,"E")
 S ZIP=$$GET1^DIQ(2,DFN,.116,"E")
 I STR2'="" S STR=STR_" "_STR2
 S ADDR=STR_" "_CITY_" ,"_ST_" "_ZIP
 Q ADDR
PROVAD(PROV) ;Format provider address
 N ADDR,STR,STR2,CITY,ST,ZIP
 S ADDR=""
 S STR=$$GET1^DIQ(200,PROV,.111,"E")
 S STR2=$$GET1^DIQ(200,PROV,.112,"E")
 S CITY=$$GET1^DIQ(200,PROV,.114,"E")
 S ST=$$GET1^DIQ(200,PROV,.115,"E")
 S ZIP=$$GET1^DIQ(200,PROV,.116,"E")
 I STR2'="" S STR=STR_" "_STR2
 S ADDR=STR_" "_CITY_" ,"_ST_" "_ZIP
 Q ADDR
