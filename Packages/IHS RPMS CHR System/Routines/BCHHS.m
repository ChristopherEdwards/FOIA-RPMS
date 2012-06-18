BCHHS ; IHS/TUCSON/LAB - CHR HEALTH SUMMARY CALL ;  [ 06/03/97  12:34 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**2**;OCT 28, 1996
 ;
 ;IHS/TUCSON/LAB - patch 2 - added line EN+2 to go to full screen
 ;from list man - 06/03/97
 ;
 ;Called to generate a CHR Health Summary Type.
 ;
EN ;EP
 ; generate health summary from protocol
 D FULL^VALM1 ;IHS/TUCSON/LAB - patch 2 added this line
 D GETPAT
 I 'APCHSPAT D EXIT Q
 D GETTYPE
 I 'APCHSTYP D EXIT Q
 D EN^APCHS
 W ! S DIR(0)="E",DIR("A")="End of Health Summary Display.  Hit return." K DA D ^DIR K DIR
 D EXIT
 Q
 ;GET PATIENT
GETPAT ;
 S APCHSPAT=""
 S DIC("A")="Enter PATIENT Name: ",DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCHSPAT=+Y
 Q
 ;
GETTYPE ;
 S APCHSTYP=$O(^APCHSCTL("B","CHR",0))
 I 'APCHSTYP W !!,$C(7),$C(7),"The CHR Health Summary type is Missing.  You need version 2.0 of Health Summary.",! H 4 Q
 I '$D(^APCHSCTL(APCHSTYP)) W !,"Error in Health Summary file!",$C(7),$C(7) S APCHSTYP="" Q
 Q
 ;
EXIT ;EP
 S VALMBCK="R"
 D GATHER^BCHUARL
 S VALMCNT=BCHRCNT
 D HDR^BCHUAR
 K BCHV,BCHF,BCHDR,APCHSPAT,BCHR,BCHQUIT,BCHRDEL,BCHV,BCHVDLT
 Q
