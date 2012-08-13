INHSG ;JSH,LD; 19 Oct 1999 11:27 ;Generic Interface - Generator routines  [ 06/26/2001  10:51 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 4; 21-APR-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
TRX(INX,INT,IND) ;Transformation entry point
 ;  called from INTX FileMan function
 ;INX = data
 ;INT = type of data (from file 4012.1)
 ;IND = direction (I or O)
 N X,Y,DIC
 I IND=""!("IO"'[IND) Q INX
 S X=INT,DIC="^INTHL7FT(",DIC(0)="MZ" D ^DIC
 Q:Y<0 INX
 S INT=+Y,X=INX
 I IND="I" X $G(^INTHL7FT(INT,2)) Q $G(X)
 X $G(^INTHL7FT(INT,3)) Q $G(X)
 ;
MEDT ;Message Entry/Edit
 ; INSTD = INTERFACE STANDARD
 ;
 K DIC,DIE,DA,Y,DWN
 N INSTD,DDSFILE,DR,DDSPAGE,DDSPARM,DDSSAVE,INFORM
 W !! S DIC="^INTHL7M(",DIC(0)="QAELM",DIC("A")="Select MESSAGE: " D ^DIC K DIC Q:Y<0
 S BHL("MSG")=+Y ;cmi/sitka/maw get message ien
 ;Determine namespace, default to "HL" (HL7)
 S INSTD=$P(^INTHL7M(+Y,0),U,12),INSTD=$S(INSTD="NCPDP":"NC",INSTD="HL7":"HL7",INSTD="X12":"X12",1:"HL")
 S DIE="^INTHL7M(",DA=+Y
 S DWN=$S($G(INSTD)="X12":"INHSG X12 MESSAGE",$G(INSTD)="NC":"INHSG NCPDP MESSAGE",1:"INHSG MESSAGE")
 I $$SC^INHUTIL1 D  G:'$D(DWFILE) MEDT
 .S INFORM=1 D ^DWC
 ;IHS Branch
 I '$$SC^INHUTIL1,$D(^DIST(.403,"B",DWN)) D  G:'$G(DDSSAVE) MEDT
 .S DDSFILE=DIE,DR="["_DWN_"]",DDSPAGE=1,DDSPARM="SC",INFORM=1
 .D ^DDS
 I '$$SC^INHUTIL1,'$G(INFORM) S DR="[INHSG MESSAGE]" D ^DIE
 D CHARUP^BHLU(BHL("MSG"))  ;cmi/sitka/maw update enc chars
 W !! S X=$$YN^UTSRD("Generate Scripts? ;1","") G:'X MEDT
 S Y=DA D EN^INHSGZ G MEDT
 ;
FEDT ;Field Entry/Edit
 K DIC,DIE,DA,Y,DWN
 W !! S DIC="^INTHL7F(",DIC(0)="QAELM",DIC("A")="Select FIELD: " D ^DIC K DIC Q:Y<0
 S DIE="^INTHL7F(",DA=+Y D EDIT^INHT("INHSG FIELD") G FEDT
 ;
SEDT ;Segment Entry/Edit
 K DIC,DIE,DA,Y,DWN
 W !! S DIC="^INTHL7S(",DIC(0)="QAELM",DIC("A")="Select SEGMENT: " D ^DIC K DIC Q:Y<0
 S DIE="^INTHL7S(",DA=+Y D EDIT^INHT("INHSG SEGMENT") G SEDT
 ;
DEDT ;Data Type Entry/Edit
 K DIC,DIE,DA,Y,DWN
 W !! S DIC="^INTHL7FT(",DIC(0)="QAELM",DIC("A")="Select DATA TYPE: " D ^DIC K DIC Q:Y<0
 S DIE="^INTHL7FT(",DA=+Y D EDIT^INHT("INHSG DATA TYPE") G DEDT
 ;
OTHER ;Other functionality in window
 Q:'$D(DWFCHG)  Q:'X  N DIC,Y,INF
 I X D
 . D MESS^DWD() S DIC=1,DIC(0)="QAEM" D ^DIC S:Y>0 DWSFLD(.05)=$P(Y,U,2),INF=+Y I Y<0 S DWSFLD(.04)="NO" Q
 . S DIC=.402,DIC(0)="QAE",DIC("S")="I $P(^(0),U,4)=INF" D ^DIC
 . I Y<0 S DWSFLD(.04)="NO" Q
 . S DWSFLD(.06)=$P(Y,U,2)
 . W ! S X=$$SOC^UTIL("Lookup Parameter: ;;;;FORCED LAYGO;;;1","","FORCED LAYGO^NO LAYGO^LAYGO ALLOWED",0) I X=""!($E(X)=U) S DWSFLD(.04)="NO" Q
 . S DWSFLD(.07)=$E(X)
 Q
 ;
 ;
