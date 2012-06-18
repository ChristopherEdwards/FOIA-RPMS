AUPNPCTR ; IHS/CMI/LAB - XREF TRIGGER FROM #1117 (RESIDENCE COMMUNITY PT) TO LAST PREVIOUS COMMUNITY 24-MAY-1993 ; [ 10/03/2007  8:57 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**6,9,10,18,19**;JUN 13, 2003
S ;ENTRY POINT FOR SET TRIGGERS       
 S DFN=DA(1),AUPN51DA=DA NEW (DFN,DT,DUZ,U,AUPN51DA)
 D LD I AUPN5LD,AUPN5LD=AUPN51DA
 E  G END ; quit if date being edited is not the last date
 D SET G END
 ;-------------------------------------------------
K ;ENTRY POINT FOR KILL TRIGGER
 S DFN=DA(1),AUPN51DA=DA NEW (DFN,DT,DUZ,U,AUPN51DA)
 D LD I AUPN5LD,AUPN5LD=AUPN51DA
 E  G END ;exit if day being deleted is not the last date
 ; find next to last date
 S (AUPN5,AUPN5NLD)=0 I ($D(^AUPNPAT(DFN,51))>1) F  S AUPN5=$O(^AUPNPAT(DFN,51,AUPN5)) Q:'AUPN5  Q:AUPN5=AUPN5LD  S AUPN5NLD=AUPN5
 S AUPN5LD=AUPN5NLD
 D SET G END
 ;
 ;------------------------------------------------------------
LD ; find last date
 S (AUPN5,AUPN5LD)=0
 I ($D(^AUPNPAT(DFN,51))>1) F  S AUPN5=$O(^AUPNPAT(DFN,51,AUPN5)) Q:'AUPN5  S AUPN5LD=AUPN5
 Q
 ;-------------------------------------------------
SET ; Set Current Community , Current Residence PTR, Current Residence Date ; IHS/PAO/TMJ Fix of Subscript and DIE Call
 I AUPN5LD D  I AUPNCC>0,AUPNCCN]""
 . S AUPNCC=$P($G(^AUPNPAT(DFN,51,AUPN5LD,0)),"^",3)
 . Q:AUPNCC=""
 . S AUPNCCN=$P($G(^AUTTCOM(AUPNCC,0)),U) ; pickup Current Community Pointer and name
 E  S AUPNCC="@",AUPNCCN="@"
 S DIE="^AUPNPAT(",DA=DFN,DR="1118///"_AUPNCCN D ^DIE
 K AUPNTEMP("MFI",$J) S DR="1117///"_$S(AUPNCC="@":"",1:"`")_AUPNCC D ^DIE K AUPNTEMP("MFI",$J)
 S Y="@" I AUPN5LD S Y=AUPN5LD D DD^%DT
 S DR="1113///"_Y D ^DIE K AUPNTEMP("MFI",$J)
 Q
 ;------------------------------------------------------------
END ;
EXIT ; all entry points  NEW (DFN,DUZ,DT,U)  and exit here
 K AUPN51DA
 Q
 ;------------------------------------------------------------
 ;------------------------------------------------------------
MFI ;ENTRY POINT FOR MFI
 Q:$G(XDRGID)  ;IHS/OIT/LJF 02/28/2008 PATCH 19 skip if in Patient Merge
 S DFN=DA NEW (DFN,DT,DUZ,U,AUPN51DA,AUPNDOB,AUPNDOD,AUPNTEMP)
 I $D(AUPNTEMP("MFI",$J,DFN,1117)),$D(AUPNTEMP("MFI",$J,DFN,1113))
 E  Q  ; wait for both fields to be set by MFI
 D SETMFI K AUPNTEMP("MFI",$J,DFN)
 D LD D SET
 G END
 ;
 ;--------------------------------------------------
SETMFI ;
 S:'$D(^AUPNPAT(DFN,51,0)) ^AUPNPAT(DFN,51,0)="^9000001.51D^^"
 S AUPNCC=$P(^AUPNPAT(DFN,11),U,17),AUPNDT=$P(^AUPNPAT(DFN,11),U,13)
 I $D(^AUPNPAT(DFN,51,AUPNDT,0)),$P(^(0),U)=AUPNDT,$P(^(0),U,3)=AUPNCC Q  ; if node matches do not reset
 S AUPNX=0 F  S AUPNX=$O(^AUPNPAT(DFN,51,AUPNX)) Q:'AUPNX  S AUPNLPC=$P(^AUPNPAT(DFN,51,AUPNX,0),U,3),AUPNX1=AUPNX
 I $D(AUPNLPC),AUPNLPC=AUPNCC D DELCC
 S Y=AUPNDT D DD^%DT S X=Y,DIC="^AUPNPAT("_DFN_",51,",DIC(0)="ML",DA(1)=DFN D ^DIC K DIC,DR Q:'+Y
 S DA=AUPNDT,DA(1)=DFN,DIE="^AUPNPAT("_DFN_",51,",DR=".03////"_AUPNCC
 I $P(^AUPNPAT(DFN,51,DA,0),U,2)="" S DR=DR_";.02////"_DT
 D ^DIE
 Q
 ;
DELCC ; Delete Last Previous community multiple
 S DA(1)=DFN,DA=AUPNX1,DIK="^AUPNPAT("_DA(1)_",51,"
 D ^DIK K DA,DIK
 Q
 ;
LASTEM(PAT) ;EP - called from trigger on previous email field
 NEW A,B,C
 K B
 S C=""
 S A=0 F  S A=$O(^AUPNPAT(PAT,82,A)) Q:A'=+A  D
 .Q:$P(^AUPNPAT(PAT,82,A,0),U,1)=""  ;no date yet
 .S B(9999999-$P(^AUPNPAT(PAT,82,A,0),U,1))=$P(^AUPNPAT(PAT,82,A,0),U,2)
 .Q
 S C=$O(B(0))
 I C Q B(C)
 Q ""
 ;
LASTADDR(P,V) ;EP - called to update .111 in file 2
 NEW A,B,C
 K B
 S A=0,C="" F  S A=$O(^AUPNPAT(P,83,A)) Q:A'=+A  D
 .Q:$P(^AUPNPAT(P,83,A,0),U,1)=""  ;no date yet
 .S B(9999999-$P(^AUPNPAT(P,83,A,0),U,1))=$P(^AUPNPAT(P,83,A,0),U,V)
 .Q
 S C=$O(B(0))
 I C Q B(C)
 Q ""
 ;
