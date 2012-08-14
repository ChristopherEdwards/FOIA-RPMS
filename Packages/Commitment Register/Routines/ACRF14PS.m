ACRF14PS ;IHS/PHXAO/AEF - ARMS PATCH 14 POST INSTALL ROUTINE [ 10/28/2004  11:08 AM ]
 ;;2.1;ADMINISTRATIVE RESOURCE MGMT SYSTEM;**14**;MAY 27, 2004
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 D ^XBKVAR
 D HOME^%ZIS
 D COMPP
 D COMPC
 D POPCLC
 Q
COMPP ;----- RECOMPILE PRINT TEMPLATES
 ;
 N ACRPTEMP,I,X
 ;
 D BMES^XPDUTL("Recompiling print templates...")
 ;
 F I=1:1 S X=$T(PTEMP+I) Q:X["$$END"  S ACRPTEMP($P(X,";;",2))=""
 ;
 S ACRPTEMP=""
 F  S ACRPTEMP=$O(ACRPTEMP(ACRPTEMP)) Q:ACRPTEMP']""  D
 . D ONEP(ACRPTEMP)
 Q
ONEP(ACRPTEMP)     ;
 ;----- RECOMPILE ONE PRINT TEMPLATE
 ;
 ;      ACRPTEMP  =  PRINT TEMPLATE NAME
 ;
 N ACRFILE,ACRIEN,DMAX,X,Y
 ;
 S ACRFILE=$P(ACRPTEMP,U,2)
 S ACRPTEMP=$P(ACRPTEMP,U)
 S ACRIEN=0
 F  S ACRIEN=$O(^DIPT("B",ACRPTEMP,ACRIEN)) Q:'ACRIEN  D
 . Q:$P($G(^DIPT(ACRIEN,0)),U,4)'=ACRFILE
 . S X=$P($G(^DIPT(ACRIEN,"ROU")),U,2)
 . Q:X']""
 . S Y=ACRIEN
 . S DMAX=$$ROUSIZE^DILF
 . D EN^DIPZ
 Q
COMPC ;----- COMPILE CROSSREFERENCES
 ;
 N DMAX,X,Y
 ;
 S Y=9002196
 S X=$G(^DD(Y,0,"DIK"))
 Q:X']""
 S DMAX=$$ROUSIZE^DILF
 D EN^DIKZ
 Q
POPCLC ;----- POPULATE CONTRACT LOCATION CODE AND TURN ON EXPANDED DOCUMENT
 ;      NUMBER PRINTING
 ;
 N ACRCLC,DA,DIE,DR,X,Y
 ;
 D BMES^XPDUTL("Entering Contract Location Code...")
 D BMES^XPDUTL("Turning on Expanded Document Number printing...")
 ;
 S ACRCLC=$$CLC($$HOST)
 I 'ACRCLC D  Q
 . D BMES^XPDUTL(">>> Cannot find Contract Location Code")
 . D BMES^XPDUTL(">>> Cannot turn on Expanded Document Number printing")
 . D BMES^XPDUTL(">>> Please update FMS System Defaults file manually")
 ;
 S DIE="^ACRSYS("
 S DA=1
 S DR="601.1///^S X=ACRCLC;601.2////^S X=1"
 D ^DIE
 ;
 Q
HOST() ;----- RETURNS HOST NAME FROM RPMS SITE FILE
 ;
 N Y
 S Y=""
 S Y=$P($G(^AUTTSITE(1,0)),U,14)
 S Y=$TR(Y,"-")
 Q Y
CLC(X) ;----- RETURNS CONTRACT LOCATION CODE  
 ;
 ;      X  =  AREA HOST NAME
 ;
 N Y
 S Y=""
 S X=$E(X,1,3)
 X ^%ZOSF("UPPERCASE")
 S X=Y
 S Y=""
 I X="ABR" S Y=241
 I X="AKA" S Y=243
 I X="ALB" S Y=242
 I X="BIL" S Y=244
 I X="BJI" S Y=239
 I X="CAO" S Y=235
 I X="CMB" S Y=242
 I X="DPS" S Y=236
 I X="NAV" S Y=245
 I X="NSA" S Y=285
 I X="OKC" S Y=246
 I X="PHX" S Y=247
 I X="POR" S Y=248
 I X="TUC" S Y=249
 Q Y
PTEMP ;----- PRINT TEMPLATES TO BE COMPILED
 ;;ACR BPA^9002196
 ;;ACR EQUIPMENT CERTIFICATION^9002196
 ;;ACR ORDER FOR SUP HEAD^9002196
 ;;ACR ORDER FOR SUP/SER^9002196
 ;;ACR PURCHASE ORDER AMENDMENT^9002196
 ;;ACR PURCHASE ORDER HEAD^9002196
 ;;ACR PURCHASE ORDER INFO^9002196
 ;;ACR PURCHASE ORDER INFO HEAD^9002196
 ;;ACR RECEIVING REPORT^9002196
 ;;ACR RECEIVING REPORT HEAD^9002196
 ;;ACR REQUEST FOR QUOTATION-H^9002196
 ;;ACR REQUISITION-TX^9002196
 ;;ACR SEPARATE TRAVEL ITINERARY^9002196
 ;;ACR TRAINING 350^9002196
 ;;ACR TRAINING EVALUATION^9002191.6
 ;;ACR TRAVEL ITINERARY^9002196
 ;;ACR TRAVEL ORDER^9002196
 ;;ACR TRAVEL ORDER HEAD^9002196
 ;;ACR TRAVEL ORDER SUMMARY^9002196
 ;;ACR TRAVEL VOUCHER^9002196
 ;;ACR TRAVEL VOUCHER SUMMARY^9002196
 ;;$$END