BDGILD61 ; IHS/ANMC/LJF - TRANS BETWEEN FAC(CALC) ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
INIT ; -- initialize variables
 NEW DGCT,DGI1,DGI2,DGO1,DATE,DFN,IEN,ATYP,FAC,SERV,SRV,END,CA
 K ^TMP("BDGILD6A",$J),^TMP("BDGILD6D",$J)
 ; -- DGI1 & DGI2 = transfer in types
 S DGI1=$O(^DG(405.1,"AIHS1","A2",0))
 S DGI2=$O(^DG(405.1,"AIHS1","A3",0))
 ; -- DGO1 = transfer out type
 S DGO1=$O(^DG(405.1,"AIHS1","D2",0))
 ;
ADMT ; -- loop admissions
 S DATE=BDGBD-.0001,END=BDGED+.2400
 F  S DATE=$O(^DGPM("AMV1",DATE)) Q:'DATE!(DATE>END)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DATE,DFN)) Q:'DFN  D
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV1",DATE,DFN,IEN)) Q:'IEN  D
 ... ;
 ... S ATYP=$$GET1^DIQ(405,IEN,.04,"I")             ;admit type
 ... I (ATYP'=DGI1)&(ATYP'=DGI2) Q                  ;admit not transfer
 ... S FAC=$$GET1^DIQ(405,IEN,.05) S:FAC="" FAC="??"  ;transfer facility
 ... S SERV=$$ADMSRV^BDGF1(IEN,DFN)                 ;admit srv
 ... S SRV=$P($$ADMSRVC^BDGF1(IEN,DFN)," ")         ;admit srv abbrev
 ... S:SERV="" SERV="??" S:SRV="" SRV="??"
 ... ;
 ... ; increment counts
 ... I BDGTYP>1 D
 .... I '$D(DGCT(FAC,SERV)) S DGCT(FAC,SERV)=1
 .... S $P(DGCT(FAC,SERV),U)=$P(DGCT(FAC,SERV),U)+1
 ... ;
 ... ; store patient data for types 1 and 3
 ... I BDGTYP'=2 S ^TMP("BDGILD6A",$J,DATE,SRV,FAC,IEN)=DFN
 ;
DSCH ; -- loop discharges
 S DATE=BDGBD-.0001,END=BDGED+.2400
 F  S DATE=$O(^DGPM("AMV3",DATE)) Q:'DATE!(DATE>END)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DATE,DFN)) Q:'DFN  D
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV3",DATE,DFN,IEN)) Q:'IEN  D
 ... ;
 ... I $$GET1^DIQ(405,IEN,.04,"I")'=DGO1 Q         ;disch not transfer
 ... S FAC=$$GET1^DIQ(405,IEN,.05) S:FAC="" FAC="??"  ;transfer facility
 ... S CA=$$GET1^DIQ(405,IEN,.14,"I")              ;corresp admission
 ... S SERV=$$LASTSRVN^BDGF1(CA,DFN)            ;disch serv abbrev
 ... S SRV=$P($$LASTSRVC^BDGF1(CA,DFN)," ")       ;disch serv abbrev
 ... S:SERV="" SERV="??" S:SRV="" SRV="??"
 ... ;
 ... ; increment counts
 ... I BDGTYP>1 D
 ... I '$D(DGCT(FAC,SERV)) S DGCT(FAC,SERV)="^1"
 ... S $P(DGCT(FAC,SERV),U,2)=$P(DGCT(FAC,SERV),U,2)+1
 ... ;
 ... ; store patient data for types 1 & 3
 ... I BDGTYP'=2 S ^TMP("BDGILD6D",$J,DATE,SRV,FAC,IEN)=DFN
 ;
 D ^BDGILD62 Q
