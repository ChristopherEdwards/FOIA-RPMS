ADE6P261 ;IHS/OIT/GAB - ADE6.0 PATCH 26 [ 10/17/2014  8:37 AM ]
 ;;6.0;ADE*6.0*26;;March 25, 1999;Build 13
 ;;ADA-CDT Code Update
 ;;Add New Code
ADDCDT5 ;EP
 D UPDATE^ADEUPD26(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P261","SETX^ADE6P261")
 Q
AC ;EP
 ;SET Dental Edit File "AC" xref for new ADA Codes
 ;D S1 calls to S1 & S2 removed, for codes in previous ADA update
 Q
S1 ;Code 1352,3354,6254,6795,7251 is the same as 2950
 ;
 ;S ADENO=2950,ADEAC=0
 ;F  S ADEAC=$O(^ADEDIT("AC",ADENO,1,ADEAC)) Q:'ADEAC  D ZSE
 ;K ADENO,ADEAC
 Q
ZSE ;  /IHS/OIT/GAB removed below, specific "AC" cross reference sets from previous patch
 ;S ^ADEDIT("AC",1352,1,ADEAC)="",^ADEDIT("AC",3354,1,ADEAC)="",^ADEDIT("AC",6254,1,ADEAC)="",^ADEDIT("AC",6795,1,ADEAC)="",^ADEDIT("AC",7251,1,ADEAC)=""
 Q
 ;
S2 ;Remove Codes 1352,3354,6254,6795,7251 that are the same as 2930
 ;K ^ADEDIT("AC",1352,1,26),^ADEDIT("AC",1352,1,27),^ADEDIT("AC",1352,1,28)
 ;K ^ADEDIT("AC",3354,1,26),^ADEDIT("AC",3354,1,27),^ADEDIT("AC",3354,1,28)
 ;K ^ADEDIT("AC",6254,1,26),^ADEDIT("AC",6254,1,27),^ADEDIT("AC",6254,1,28)
 ;K ^ADEDIT("AC",6795,1,26),^ADEDIT("AC",6795,1,27),^ADEDIT("AC",6795,1,28)
 ;K ^ADEDIT("AC",7251,1,26),^ADEDIT("AC",7251,1,27),^ADEDIT("AC",7251,1,28)
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
 ; Fields below: .01=code;.05=Level of Service;501=RVU;.06=synonym;.02=description;8801=mnemonic;.09=no opsite
ADDADA ;
 ;;D0171^1^0.70^REPOV^^re-evaluation - post-operative office visit^REPOV^n
 ;;D0351^5^6.00^THREEDPHOTO^^3D photographic image^THREEDPHOTO^n
 ;;D1353^2^0.80^SEALRPR^^sealant repair - per tooth^SEALRPR
 ;;D6110^5^35.00^ISRDEMX^^implant/abutment supported removable denture for edentulous arch - maxillary^ISRDEMX
 ;;D6111^5^35.00^ISRDEMN^^implant/abutment supported removable denture for edentulous arch - mandibular^ISRDEMN
 ;;D6112^5^35.00^ISRDPMX^^implant/abutment supported removable denture for partially edentulous arch - maxillary^ISRDPMX
 ;;D6113^5^35.00^ISRDPMN^^implant/abutment supported removable denture for partially edentulous arch - mandibular^ISRDPMN
 ;;D6114^5^35.00^ISFDEMX^^implant/abutment supported fixed denture for edentulous arch-maxillary^ISFDEMX
 ;;D6115^5^35.00^ISFDEMN^^implant/abutment supported fixed denture for edentulous arch-mandibular^ISFDEMN
 ;;D6116^5^35.00^ISFDPMX^^implant/abutment supported fixed denture for partially edentulous arch-maxillary^ISFDPMX
 ;;D6117^5^35.00^ISFDPMN^^implant/abutment supported fixed denture for partially edentulous arch-mandibular^ISFDPMN
 ;;D6549^4^10.00^RESRETRB^^resin retainer - for resin bonded fixed prosthesis^RESRETRB
 ;;D9219^5^1.77^EVALSED^^evaluation for deep sedation or general anesthesia^EVALSED^n
 ;;D9931^2^0.75^CLEANREM^^cleaning and inspection of a removable appliance^CLEANREM
 ;;D9986^9^0.00^BA^^missed appointment^BA^n
 ;;D9987^9^0.00^CA^^cancelled appointment^CA^n
 ;;***END***
