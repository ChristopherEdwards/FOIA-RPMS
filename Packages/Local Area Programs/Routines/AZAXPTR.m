AZAXPTR ;IHS/PHXAO/AEF - FIND POINTERS TO REVENUE CODES
 ;;V1.0;ANNE'S SPECIAL ROUTINES;;FEB 26, 2004
 ;
 ;      FINDS POINTERS TO THE REVENUE CODES FILE AND PUTS THEM INTO ARRAY
 ;      ^TMP("AZAX",$J,"PTR",CNT,0)=GLOBALREF^PIECE^PTRVALUE
 ;      
 ;      
EN ;EP -- MAIN ENTRY POINT
 ;
 D ^XBKVAR
 ;
 D BLD
 ;
 K ^TMP("AZAX",$J,"PTR")
 ;
 D FIND
 ;
 Q
FIND ;FIND THE POINTERS
 ;
 N CNT,D0,D1,D2,DATA,DUZ,I,T
 ;
 S CNT=0
 ;
 F I=1:1:7,18,29,30 S T="P"_I D @T
 ;
 Q
P1 ;DEFAULT REVENUE CODE field (#9999999.02) of the CPT File (#81)
 S D0=0
 F  S D0=$O(^ICPT(D0)) Q:'D0  D
 . S PTR=$P($G(^ICPT(D0,9999999)),U,2)
 . D SET(2,.PTR)
 Q
 ;
P2 ;DEFAULT REVENUE CODE field (#9999999.01) of the CPT CATEGORY File (#81.1)
 S D0=0
 F  S D0=$O(^DIC(81.1,D0)) Q:'D0  D
 . S PTR=$P($G(^DIC(81.1,D0,9999999)),U)
 . D SET(1,.PTR)
 Q
 ;
P3 ;REVENUE CODE field (#.09) of the V TRANSACTION CODES File (#9000010.33)
 S D0=0
 F  S D0=$O(^AUPNVTC(D0)) Q:'D0  D
 . S PTR=$P($G(^AUPNVTC(D0,0)),U,9)
 . D SET(9,.PTR)
 Q
 ;
P4 ;CPT/ADA/REV CODE field (#.01) of the CPT,ADA, OR REV INFORMATION sub-field
 ;  (#9002080.197) of the DOCUMENT sub-field (#9002080.01) of the CHS FACILITY
 ;  File (#9002080)
 ;  NOTE: this is a variable pointer so is handled differently
 S D0=0
 F  S D0=$O(^ACHSF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ACHSF(D0,"D",D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^ACHSF(D0,"D",D1,11,D2)) Q:'D2  D
 . . . S DATA=$P($G(^ACHSF(D0,"D",D1,11,D2,0)),U)
 . . . S PTR=$P(DATA,";")
 . . . Q:PTR']""
 . . . I $D(PTR(PTR)),DATA=PTR_";AUTTREVN(" D
 . . . . S CNT=CNT+1
 . . . . S ^TMP("AZAX",$J,"PTR",CNT,0)=$ZR_U_1_U_PTR
 Q
 ;
P5 ;REVENUE CODE Field (#.01) of the REVENUE CODE sub-field (#9002274.0131)
 ;  of the 3P FEE TABLE File (#9002274.01)
 S D0=0
 F  S D0=$O(^ABMDFEE(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ABMDFEE(D0,31,D1)) Q:'D1  D
 . . S PTR=$P($G(^ABMDFEE(D0,31,D1,0)),U)
 . . D SET(1,.PTR)
 Q
 ;
P6 ;REVENUE CODE field (#.03) of the VISIT TYPE sub-field (#9002274.091) of
 ;  the 3P INSURER File (#9002274.09)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMNINS(DUZ(2))) Q:'DUZ(2)  D
 . S D0=0
 . F  S D0=$O(^ABMNINS(DUZ(2),D0)) Q:'D0  D
 . . S D1=0
 . . F  S D1=$O(^ABMNINS(DUZ(2),D0,1,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMNINS(DUZ(2),D0,1,D1,0)),U,3)
 . . . D SET(3,.PTR)
 Q
 ;
P7 ;*REVENUE CODE field (#.97) of the 3P CLAIM DATA File (#9002274.3)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2)))  Q:'DUZ(2)  D
 . S D0=0
 . F  S D0=$O(^ABMDCLM(DUZ(2),D0)) Q:'D0  D
 . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,9)),U,7)
 . . D SET(7,.PTR)
 . . ;
P8 . . ;REVENUE CODE field (#.03) of the Surgical Procedure sub-field
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,21,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,21,D1,0)),U,3)
 . . . D SET(3,.PTR)
 . . ;
P9 . . ;REVENUE CODE field (#.02) of the Pharmacy sub-field (#9002274.3023)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,23,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,23,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P10 . . ;REVENUE CODE field (#.01) of the REVENUE CODE sub-field (#9002274.3025)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,25,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,25,D1,0)),U)
 . . . D SET(1,.PTR)
 . . ;
P11 . . ;REVENUE CODE field (#.02) of the Medical Procedure sub-field (#9002274.3027)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,27,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,27,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P12 . . ;REVENUE CODE field (#.02) of the Dental sub-field (#9002274.3033) of the
 . . ;3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,33,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,33,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P13 . . ;REVENUE CODE field (#.02) of the Radiology sub-field (#9002274.3035) of
 . . ;the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,35,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,35,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P14 . . ;REVENUE CODE field (#.02) of the Laboratory sub-field (#9002274.3037)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,37,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,37,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P15 . . ;REVENUE CODE field (#.02) of the Anesthesia sub-field (#9002274.3039)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,39,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,39,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P16 . . ;REVENUE CODE field (#.02) of the Misc. Services sub-field (#9002274.3043)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,43,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,43,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P17 . . ;REVENUE CODE field (#.05) of the Charge Master sub-field (#9002274.3045)
 . . ;of the 3P CLAIM DATA File (#9002274.3)
 . . S D1=0
 . . F  S D1=$O(^ABMDCLM(DUZ(2),D0,45,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDCLM(DUZ(2),D0,45,D1,0)),U,5)
 . . . D SET(5,.PTR)
 Q
 ;
P18 ;*REVENUE CODE field (#.97) of the 3P BILL File (#9002274.4)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDBILL(DUZ(2))) Q:'DUZ(2)  D
 . S D0=0
 . F  S D0=$O(^ABMDBILL(DUZ(2),D0)) Q:'D0  D
 . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,9)),U,7)
 . . D SET(7,.PTR)
 . . ;
P19 . . ;REVENUE CODE field (#.03) of the Med/Surg Procedure sub-field (#9002274.4021)
 . . ;of the 3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,21,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,21,D1,0)),U,3)
 . . . D SET(3,.PTR)
 . . ;
P20 . . ;REVENUE CODE field (#.02) of the Pharmacy sub-field (#9002274.4023) of the
 . . ;3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,23,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,23,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P21 . . ;REVENUE CODE field (#.01) of the Revenue Code sub-field (#9002274.4025) of
 . . ;the 3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,25,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,25,D1,0)),U)
 . . . D SET(1,.PTR)
 . . ;
P22 . . ;REVENUE CODE field (#.02) of the Medical PRocedures sub-field (#9002274.4027)
 . . ;of the 3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,27,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,27,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P23 . . ;REVENUE CODE field (#.02) of the Dental sub-field (#9002274.4033) of the
 . . ;3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,33,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,33,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P24 . . ;REVENUE CODE field (#.02) of the Radiology sub-field (#9002274.4035) of the
 . . ;3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,35,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,35,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P25 . . ;REVENUE CODE field (#.02) of the Laboratory sub-field (#9002274.4037) of the
 . . ;3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,37,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,37,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P26 . . ;REVENUE CODE field (#.02) of the Anesthesia sub-field (#9002274.4039) of the
 . . ;3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,39,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,39,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P27 . . ;REVENUE CODE field (#.02) of the Misc. Services sub-field (#9002274.4043)
 . . ;of the 3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,43,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,43,D1,0)),U,2)
 . . . D SET(2,.PTR)
 . . ;
P28 . . ;REVENUE CODE field (#.05) of the Charge Master sub-field (#9002274.4045)
 . . ;of the 3P BILL File (#9002274.4)
 . . S D1=0
 . . F  S D1=$O(^ABMDBILL(DUZ(2),D0,45,D1)) Q:'D1  D
 . . . S PTR=$P($G(^ABMDBILL(DUZ(2),D0,45,D1,0)),U,5)
 . . . D SET(5,.PTR)
 Q
 ;
P29 ;REVENUE CODE field (#.02) of the 3P CHARGE MASTER File (#9002274.75)
 S D0=0
 F  S D0=$O(^ABMCM(D0)) Q:'D0  D
 . S PTR=$P($G(^ABMCM(D0,0)),U,2)
 . D SET(2,.PTR)
 Q
 ;
P30 ;REVENUE CODE field (#.03) of the VISIT TYPE sub-field (#9999999.183901)
 ;of the INSURER File (#999999.18)
 S D0=0
 F  S D0=$O(^AUTNINS(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^AUTNINS(D0,39,D1)) Q:'D1  D
 . . S PTR=$P($G(^AUTNINS(D0,39,D1,0)),U,3)
 . . D SET(3,.PTR)
 Q
SET(PIECE,PTR) ;
 ;----- SET ^TMP GLOBAL
 ;
 Q:'$D(PTR(+PTR))
 S CNT=CNT+1
 S ^TMP("AZAX",$J,"PTR",CNT,0)=$ZR_U_PIECE_U_PTR
 Q
BLD ;----- BUILD ARRAY OF POINTER VALUES
 ;
 N I
 K PTR
 F I=999:1:9999 S PTR(I)=I
 Q
