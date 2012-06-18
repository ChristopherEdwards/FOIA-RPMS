AUPNVSIT ; IHS/CMI/LAB - EDITS FOR AUPNVSIT (VISIT:9000010) 24-MAY-1993 ; 30 Sep 2010  2:13 PM
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;IHS/CMI/LAB - added VCN entry point
 ;IHS/CMI/LAB - patch 14 added set of duz and dt to deleted visits
 ;fixed bgp to bdw
 ;
VSIT01 ;EP;9000010,.01 (VISIT,VISIT/ADMIT DATE&TIME)
 I '$D(AUPNPAT) W:'$D(AUPNTALK)&('$D(ZTQUEUED)) "  <No direct entry allowed>" K X Q
 I $D(AUPNDOB),$D(AUPNDOD),AUPNDOB,$D(DT),DT D VSIT01B Q
 I '$D(AUPNTALK),'$D(ZTQUEUED) W "  <Required variables do not exist>"
 K X
 Q
VSIT01B ;
 ;added check so that chart review visits can be created after DOD
 NEW S
 S S=$G(APCDCAT) I S="",$G(DA) S S=$P($G(^AUPNVSIT(DA,0)),U,7)
 I '$D(APCDFVOK),DT_".9999"<X W:'$D(AUPNTALK)&('$D(ZTQUEUED)) "  <Future dates not allowed>" K X Q
 I DUZ("AG")="I",AUPNDOD,S'="C",$P(X,".",1)>AUPNDOD W:'$D(AUPNTALK)&('$D(ZTQUEUED)) "  <Patient died before this date>" K X Q
 I $P(X,".",1)<AUPNDOB W:'$D(AUPNTALK)&('$D(ZTQUEUED)) "  <Patient born after this date>" K X Q
 Q
 ;
POSTSLCT ;
 S AUPNVSIT=+Y,AUPNY=Y
 I '$D(AUPNPAT),$P(^AUPNVSIT(AUPNVSIT,0),U,5) S Y=$P(^(0),U,5) D ^AUPNPAT
 S Y=AUPNY K AUPNY
 Q
 ;
ADD ; ADD TO DEPENDENCY COUNT
 L +^AUPNVSIT(X,0):10 E  W:'$D(ZTQUEUED) !!,"VISIT locked.  Notify programmer!",! Q
 S:$P(^AUPNVSIT(X,0),U,9)<0 $P(^(0),U,9)=0
 S $P(^AUPNVSIT(X,0),U,9)=$P(^AUPNVSIT(X,0),U,9)+1 ;,$P(^(0),U,11)="" ;*** WILL NOT UNDELETE ***
 I $D(^AUPNVSIT("AMFI",X)),^AUPNVSIT("AMFI",X)="M"
 E  I DUZ'=".5",$D(^AUTTSITE(1,0)),$P(^AUTTSITE(1,0),U,16)="V",$P(^AUPNVSIT(X,0),U,15)'="A",$P(^(0),U,15)'="D" S $P(^AUPNVSIT(X,0),U,15)="M",^AUPNVSIT("AMFI",X)="M"
 L -^AUPNVSIT(X,0)
 Q
SUB ; SUBTRACT FROM DEPENDENCY COUNT
 L +^AUPNVSIT(X,0):10 E  W:'$D(ZTQUEUED) !!,"VISIT locked.  Notify programmer!",! Q
 S $P(^AUPNVSIT(X,0),U,9)=$P(^AUPNVSIT(X,0),U,9)-1 ;S:$P(^(0),U,9)<1 $P(^(0),U,11)=1 *** DON'T DELETE ***
 I $P(^AUPNVSIT(X,0),U,9)<0 S $P(^(0),U,9)=0 ; Should not happen but does
 I $P(^AUPNVSIT(X,0),U,15)="A"
 E  I DUZ'=.5,$D(^AUTTSITE(1,0)),$P(^AUTTSITE(1,0),U,16)="V" S $P(^AUPNVSIT(X,0),U,15)="D",^AUPNVSIT("AMFI",X)="D"
 L -^AUPNVSIT(X,0)
 Q
 ;
MOD ;PEP;MODIFY A VISIT OR V FILE ENTRY 
 ;*******CANNOT BE CALLED FROM DIE **********CALLS DIE
 Q:$G(AUPNVSIT)=""
 Q:AUPNVSIT<0
 Q:'$D(^AUPNVSIT(AUPNVSIT,0))
 S DA=AUPNVSIT,DIE="^AUPNVSIT(",DR=".13////"_DT D ^DIE K DA,DIE,DIU,DIV,DR
 I $T(A08^BTSEVENT)]"" D A08
 I $$BH(AUPNVSIT) D QBHV
 ;the following updates MFI information
 Q:'$D(^AUTTSITE(1,0))
 Q:$P(^AUTTSITE(1,0),U,16)'="V"
 Q:DUZ=.5
 I $P(^AUPNVSIT(AUPNVSIT,0),U,15)'="A",$P(^(0),U,15)'="D" S DR=".15///M",DA=AUPNVSIT,DIE="^AUPNVSIT(" D ^DIE
 K DIE,DA,DR,DIU,DIV
 Q
BH(V) ;
 ;is this a BH visit from EHR or PCC d/e that needs to be moved to BH?
 ;clinic=14, 46, 48, C4
 ;or provider discipline equals one of the codes in the BH PROVIDER CLASS CODE file
 I $T(EN^AMHEHR)="" Q 0  ;bh patch 8 not installed yet
 NEW C,%,G
 S C=$$CLINIC^APCLV(V,"C")
 I C=14!(C=43)!(C=48)!(C="C4")!(C="C9") Q 1  ;clinic code
 S (G,%)=0
 F  S %=$O(^AUPNVPRV("AD",V,%)) Q:%'=+%!(G)  D
 .S C=$P($G(^AUPNVPRV(%,0)),U)
 .Q:C=""
 .S C=$P($G(^VA(200,C,"PS")),U,5)
 .Q:C=""
 .S C=$P($G(^DIC(7,C,9999999)),U)
 .Q:C=""
 .I $D(^AMHBHPC("C",C)) S G=1  ;provider class
 .Q
 Q G
 ;
QBHV ;queue BH visit creation/update to background
 ;if visit was created by BH then quit
 Q:$T(EN^AMHEHR)=""
 NEW G,ZTSK,ZTRTN,ZTSAVE,ZTDESC,ZTIO,ZTDTH
 S G=$O(^AMHREC("AVISIT",AUPNVSIT,0))
 I G,$P($G(^AMHREC(G,11)),U,11) Q  ;this visit was created by BH
 I "ACHINRT"'[$P(^AUPNVSIT(AUPNVSIT,0),U,7)  Q  ;only these service categories are applicable
 I '$D(^AUPNVPRV("AD",AUPNVSIT)) Q
 I '$D(^AUPNVPOV("AD",AUPNVSIT)) Q
 I $T(EN^AMHEHR)]"" D EN^XBNEW("EN^AMHEHR","AUPNVSIT") Q
 Q
 ;queue to background ????
 Q:$T(EN^AMHEHR)=""
 F %="AUPNVSIT" S ZTSAVE(%)=""
 S ZTRTN="EN^AMHEHR"
 S ZTDESC="BH VISIT CREATION FROM EHR/PCC"
 S ZTIO=""
 S ZTDTH=$H
 D ^%ZTLOAD
 K ZTSK
 Q
 ;*******CANNOT BE CALLED FROM DIE**********CALLS DIE
DEL ;EP;*** EXTERNAL ENTRY POINT ***  SET DELETE FLAG
 ; The following exclusive NEW excepted from SAC by the Director, DSD. Request dated 12.14.92.  No suspense was mandated.
 N (DT,DUZ,AUPNVSIT,U)
 I $P(^AUPNVSIT(AUPNVSIT,0),U,9) S AUPNVSIT=-1 Q
 S DIK="^AUPNVSIT(",DA=AUPNVSIT,X=2 D DD^DIK,1^DIK1
 S DA=AUPNVSIT,DR=".11///1",DIE="^AUPNVSIT(" D ^DIE K DA,DIE,DR
 I $G(DUZ) S $P(^AUPNVSIT(AUPNVSIT,0),U,27)=DUZ ;IHS/CMI/LAB - store user who deleted in .27
 I $G(DT) S $P(^AUPNVSIT(AUPNVSIT,0),U,13)=DT ;IHS/CMI/LAB - visits being deleted w dec
 I $G(DT)]"" S ^AUPNVSIT("APCIS",DT,AUPNVSIT)="" ;IHS/CMI/LAB for apcp patch 6 send deletes
 I $G(DT),$P($G(^BDWSITE(1,0)),U,2)]"",DT>$P(^BDWSITE(1,0),U,2) S ^AUPNVSIT("ADWO",DT,AUPNVSIT)=""  ;IHS/CMI/LAB - for data warehouse deletes.
 I $P($G(^AUPNVSIT(AUPNVSIT,22)),U,1)="" S $P(^AUPNVSIT(AUPNVSIT,22),U,1)="UNKNOWN/NON DATA ENTRY"
 I DUZ'=.5,$D(^AUTTSITE(1,0)),$P(^AUTTSITE(1,0),U,16)="V",$P(^AUPNVSIT(AUPNVSIT,0),U,15)="A" S DA=AUPNVSIT,DR=".15///@",DIE="^AUPNVSIT(" D ^DIE K DA,DIE,DR Q
 I DUZ'=.5,$D(^AUTTSITE(1,0)),$P(^AUTTSITE(1,0),U,16)="V",$P(^AUPNVSIT(AUPNVSIT,0),U,15)'="A" S DA=AUPNVSIT,DR=".15///D",DIE="^AUPNVSIT(" D ^DIE K DA,DIE,DR Q
 Q
 ;
VCN(AUPNVSIT,AUPNADD) ;EP; *** EXTERNAL ENTRY POINT ***
 ; Returns Visit Control Number (VCN) on visit if already there
 ; Creates VCN and adds to visit if AUPNADD set to 1
 ; Returns a number if VCN found or created; returns "" if not
 ; If asked to add VCN and failed, 2nd piece VCN = error code:msg
 ;
 ; VCN = patient ien + . + running count for patient+1 + last digit of pseudo code for the site  (ex. 234.56)
 ; Running count for patient is stored in ^AUPNVSIT("AVCN",DFN)
 ;
 ; Due to call to DICN an exclusive NEW is used
 ;
 NEW X
 I '$G(AUPNVSIT) Q $S($G(AUPNADD)=1:"^1:INVALID VISIT IEN",1:"")
 S X=$P($G(^AUPNVSIT(AUPNVSIT,11)),U,3) I X Q X  ;VCN already there
 I $G(AUPNADD)'=1 Q X    ;return result if add not an option
 ;
 NEW (DT,DUZ,U,AUPNVSIT,AUPNADD)  ;SAC Exemption on file as of August 31, 2007 per email from Mike Danielson
 Q:'$G(^AUPNVSIT(AUPNVSIT,0)) "^1:INVALID VISIT IEN"
 Q:$P(^AUPNVSIT(AUPNVSIT,0),U,11)=1 "^2:DELETED VISIT"
 S DFN=$P(^AUPNVSIT(AUPNVSIT,0),U,5) Q:'DFN "^3:INVALID PATIENT ON VISIT"
 Q:'$G(^AUPNPAT(DFN,0)) "^3:INVALID PATIENT ON VISIT"
 ; Q:"ASORH"'[$P(^AUPNVSIT(AUPNVSIT,0),U,7) "^4:INVALID SERVICE CATEGORY" ;IHS/ASDST/GTH AUPN*99.1*7 02/15/2002
 ;Q:"ASORHT"'[$P(^AUPNVSIT(AUPNVSIT,0),U,7) "^4:INVALID SERVICE CATEGORY"  ;add telephone per ANMC;IHS/ASDST/GTH AUPN*99.1*7 02/15/2002;IHS/SET/GTH AUPN*99.1*8 10/04/2002
 Q:"ASORHTC"'[$P(^AUPNVSIT(AUPNVSIT,0),U,7) "^4:INVALID SERVICE CATEGORY"  ;add telephone per ANMC;IHS/ASDST/GTH AUPN*99.1*7 02/15/2002;IHS/SET/GTH AUPN*99.1*8 10/04/2002
 ;
 ;if vcn already exists, add to count until a good one is found
 ;S COUNT=$P(^AUPNPAT(DFN,0),U,37)   ;last VCN
 ;F  S COUNT=COUNT+1 Q:COUNT>99999  Q:'$D(^AUPNVSIT("VCN",DFN_"."_COUNT))
 S COUNT=+$G(^AUPNVSIT("AVCN",DFN))
 S ALPHA=$$ALPHA(AUPNVSIT) I ALPHA="" Q "^7:NO PSEUDO PREFIX FOR SITE"
 I ALPHA=+ALPHA Q "^8:INVALID PSEUDO PREFIX FOR SITE"
 F  S COUNT=COUNT+1 Q:'$D(^AUPNVSIT("VCN",DFN_"."_COUNT_ALPHA))
 I COUNT>99999 Q "^5:LAST VCN INVALID"
 S AUPNVCN=DFN_"."_COUNT_ALPHA
 ;
 S DIE="^AUPNVSIT(",DA=AUPNVSIT,DR="1103///"_AUPNVCN D ^DIE
 I $P($G(^AUPNVSIT(AUPNVSIT,11)),U,3)'=AUPNVCN Q "^6:DIE CALL FAILED:"_AUPNVCN
 Q AUPNVCN
 ;
ALPHA(VISIT) ; - returns 3rd character of pseudo prefix form encounter location
 NEW X
 S X=$P($G(^AUPNVSIT(+$G(VISIT),0)),U,6) I 'X Q ""
 Q $E($P($G(^AUTTLOC(X,1)),U,2),3)
 ;
 ;begin new code IHS/ASDST/GTH AUPN*99.1*7 02/15/2002
UID(VISIT) ;EP - generate unique ID for visit
 I '$G(VISIT) Q VISIT
 NEW X
 I '$P($G(^AUTTSITE(1,1)),"^",3) S $P(^AUTTSITE(1,1),"^",3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),"^",1),0),"^",10)
 S X=$P(^AUTTSITE(1,1),"^",3)
 Q X_$$LZERO(VISIT,10)
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
 ;end new code IHS/ASDST/GTH AUPN*99.1*7 02/15/2002
 ;
INACLOC(Y) ;EP - return 1 if inactive, 0 if active
 I $G(Y)="" Q 1
 ;check to see if location of encounter is inactive based on visit date
 NEW X
 S X=$$CHKLOC(Y)
 I $D(^AUTTLOC(Y))
 Q X
CHKLOC(Y) ; SCREEN OUT E CODES AND INACTIVE CODES
 I $D(DIFGLINE) Q 0
 I $D(ACHSDIEN) Q 0
 I $G(DUZ("AG"))'="I" Q 0
 NEW A,I,D
 S I=$P(^AUTTLOC(Y,0),U,21)  ;inactive date
 S D="" I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 ;check date if have date
 I $G(APCDDATE),I]"",APCDDATE>I Q 1  ;have date, date after inactive date
 I D]"",I]"",D>I Q 1
 ;if have no date to check then check 21st piece
 I '$G(APCDVSIT),'$G(APCDDATE),$P(^AUTTLOC(Y,0),U,21) Q 1
 Q 0
 ;
A08 ;EP - for BTS per Christy Smith, Daou 5/12/05
 Q:'$G(AUPNVSIT)
 S AUPNHLER=$$A08^BTSEVENT(AUPNVSIT)
 K AUPNHLER
 Q
 ;
MFI(Y) ;EP - called to determine whether a visit is an MFI visit
 I 'Y Q ""
 I '$D(^AUPNVSIT(Y)) Q ""
 I $D(DIFGLINE) Q 1
 I $P($G(^AUPNVSIT(Y,11)),U,13) Q 1
 I $P($G(^AUPNVSIT(Y,0)),U,23)=.5 Q 1
 Q ""
 ;
UIDV(VISIT) ;EP - generate unique ID for visit
 I '$G(VISIT) Q VISIT
 NEW X
 ;I '$P($G(^AUTTSITE(1,1)),"^",3) S $P(^AUTTSITE(1,1),"^",3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),"^",1),0),"^",10)
 S X=$$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)
 I X="" S X="00000"
 Q X_$$LZERO(VISIT,10)
