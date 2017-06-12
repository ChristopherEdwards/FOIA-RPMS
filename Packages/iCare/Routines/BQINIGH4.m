BQINIGH4 ;GDIT/HS/ALA-Nightly process ; 02 Jan 2015  12:21 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
 ;
REG ;EP - Check for register updates and apply in iCare
 ; Process register records into tags
 NEW REGIEN,RDATA,TAG,FILE,FIELD,XREF,STFILE,STFLD,STEX,SUBREG,GLBREF,GLBNOD
 NEW DFN,RIEN,QFL,DATE,TGNM,PSTAT,DATA
 S REGIEN=0
 F  S REGIEN=$O(^BQI(90507,REGIEN)) Q:'REGIEN  D
 . S RDATA=^BQI(90507,REGIEN,0)
 . ; If the register is inactive, quit
 . I $P(RDATA,U,8)=1 Q
 . ; Check if register is associated with a tag, if there isn't one, quit
 . S TAG=$O(^BQI(90506.2,"AD",REGIEN,"")) I TAG="" Q
 . S FILE=$P(RDATA,U,7),FIELD=$P(RDATA,U,5),XREF=$P(RDATA,U,6)
 . S STFILE=$P(RDATA,U,15),STFLD=$P(RDATA,U,14),STEX=$G(^BQI(90507,REGIEN,1))
 . S SUBREG=$P(RDATA,U,9)
 . S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 . S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 . I GLBNOD="" Q
 . ;
 . I '$D(@GLBNOD@(0)) Q
 . ;
 . S DFN=""
 . F  S DFN=$O(@GLBREF@(DFN)) Q:DFN=""  D
 .. ; If patient is deceased, quit
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in last 3 years, quit
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. ;
 .. I $G(SUBREG)'="" S QFL=0 D  Q:'QFL
 ... Q:FILE'=9002241
 ... S RIEN=""
 ... F  S RIEN=$O(@GLBREF@(DFN,RIEN)) Q:RIEN=""  D
 .... I $P($G(@GLBNOD@(RIEN,0)),U,5)=SUBREG S QFL=1,IENS=RIEN
 .. ; Check register status
 .. I $G(SUBREG)="" S IENS=$O(@GLBREF@(DFN,""))
 .. I STEX'="" X STEX Q:'$D(IENS)
 .. S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I")
 .. S DATE=$P($G(^BQIPAT(DFN,20,TAG,0)),U,2)
 .. I $O(^BQIREG("C",DFN,TAG,""))'="" Q
 .. I PSTAT="U"!(PSTAT="") D  Q
 ... ; If patient is already tagged, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))'="" Q
 ... ; else build a "proposed" record
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT) Q
 .. I PSTAT="D" Q
 .. I PSTAT="I" D  Q
 ... ; If the patient was not tagged and is inactive on register, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))="" Q
 ... ; If the patient was tagged and is inactive on register
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT) Q
 .. D EN^BQITDPRC(.DATA,DFN,TAG,"A",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT)
 .. ; Remove any temporary BQIPAT data
 .. NEW DA,DIK
 .. S DA(1)=DFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 Q
 ;
RTAX ;EP - Check for report taxonomies
 ;determine if any taxonomies need deconstruction for Source and layouts
 ; For HIV/AIDS Quality of Care
 S RGN=1
 ; Clean up labs
 NEW DA,IENS,CIEN,TXN,TXDATA,DFLG,TAX,TREF,LBIEN,LLIST,LAB,RGN,BQQN
 S CIEN=$O(^BQI(90506.5,"B","HIV QoC","")) I CIEN="" Q
 S DA=0,DA(1)=CIEN
 F  S DA=$O(^BQI(90506.5,CIEN,10,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90506.51,IENS,.09)=1
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 S TXN=0
 F  S TXN=$O(^BQI(90507,RGN,20,1,10,TXN)) Q:'TXN  D
 . S TXDATA=^BQI(90507,RGN,20,1,10,TXN,0)
 . S DFLG=+$P(TXDATA,"^",4)
 . I 'DFLG Q
 . S TAX=$P(TXDATA,"^",1),TREF=$NA(^TMP("BKMTAX",$J)) K @TREF
 . I $P(TXDATA,"^",2)["ATXLAB" D BLD^BQITUTL(TAX,.TREF,"L")
 . I $P(TXDATA,"^",2)'["ATXLAB" D BLD^BQITUTL(TAX,.TREF,"")
 . S LBIEN=""
 . F  S LBIEN=$O(@TREF@(LBIEN)) Q:LBIEN=""  D
 .. ;I $T(@("DECON^BKMCMLBP"))'="" D DECON^BKMCMLBP(LBIEN,.LLIST)
 .. ;I $T(@("LBT^BKMCMLBP"))'="" D LBT^BKMCMLBP(.LLIST)
 .. K LLIST
 .. ;
 K @TREF
 Q
