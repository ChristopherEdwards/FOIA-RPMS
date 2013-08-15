ADE6P241 ;IHS/OIT/GAB - ADE6.0 PATCH 24 [ 11/17/2012  8:37 AM ]
 ;;6.0;ADE;**24**;NOV 17, 2012
 ;Adds new codes and updates existing ADA codes
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD24(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P241","SETX^ADE6P241")
 Q
AC ;EP
 ;SET Dental Edit File "AC" xref for new ADA Codes
 ; calls to S1 & S2 removed, for codes in previous ADA update
 Q
S1 ;Code 1352,3354,6254,6795,7251 is the same as 2950
 ;
 ;S ADENO=2950,ADEAC=0
 ;F  S ADEAC=$O(^ADEDIT("AC",ADENO,1,ADEAC)) Q:'ADEAC  D ZSE
 ;K ADENO,ADEAC
 Q
ZSE ;  /IHS/OIT/GAB removed below, specific "AC" cross reference sets
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
ADDADA ;
 ;;D0191^2^0.30^PTASSESS^^assessment of a patient^PTASSESS^n
 ;;a limited clinical inspection that is performed to
 ;;identify possible signs of oral or systemic disease,
 ;;malformation, or injury, and the potential need for
 ;;referral for diagnosis and treatment
 ;;D0364^5^12.00^CBCTCI^^cone beam CT capture and interpretation with limited field of view - less than one whole jaw^CBCTCI^
 ;;D0365^5^14.00^CBCTCI MD^^cone beam CT capture and interpretation with field of view of one full dental arch - mandible^CBCTCIMD^n
 ;;D0366^5^14.00^CBCTCI MX^^cone beam CT capture and interpretation with field of view of one full dental arch - maxilla, with or without cranium^CBCTCIMX^n
 ;;D0367^5^16.00^CBCTCI MD MX^^cone beam CT capture and interpretation with field of view of both jaws, with or without cranium^CBCTCIMDMX^n
 ;;D0368^5^12.50^CBCTCI TMJ^^cone beam CT capture and interpretation for TMJ series including two or more exposures^CBCTCITMJ^n
 ;;D0369^5^12.50^MRICI^^maxillofacial MRI capture and interpretation^MRICI^n
 ;;D0370^5^12.50^USCI^^maxillofacial ultrasound capture and interpretation^USCI^n
 ;;D0371^5^12.50^SIACI^^sialoendoscopy capture and interpretation^SIACI^n
 ;;D0380^5^10.00^CBCTCO^^cone beam CT image capture with limited field of view - less than one whole jaw^CBCTCO^
 ;;D0381^5^10.00^CBCTCO MD^^cone beam CT image capture with field of view of one full dental arch - mandible^CBCTCOMD^n
 ;;D0382^5^10.00^CBCTCO MX^^cone beam CT image capture with field of view of one full dental arch - maxilla, with or without cranium^CBCTCOMX^n
 ;;D0383^5^10.00^CBCTCO MD MX^^cone beam CT image capture with field of view of both jaws, with or without cranium^CBCTCOMDMX^n
 ;;D0384^5^10.00^CBCTCO TMJ^^cone beam CT image capture for TMJ series including two or more exposures^CBCTCOTMJ^n
 ;;D0385^5^10.00^MRICO^^maxillofacial MRI image capture^MRICO^n
 ;;D0386^5^10.00^USCO^^maxillofacial ultrasound image capture^USCO^n
 ;;D0391^5^3.00^DIIO^^interpretation of diagnostic image by a practitioner not associated with capture of the image, including report^DIIO^n
 ;;D1208^2^0.56^TOPFL^^topical application of fluoride^TOPFL^n
 ;;D2990^2^1.50^RESINFL^^resin infiltration of incipient smooth surface lesions^RESINFL^
 ;;Placement of an infiltrating resin restoration for strengthening, stabilizing and/or limiting the progression of the lesion.
 ;;D2929^5^6.50^PFAB CER CRN^^prefabricated porcelain/ceramic crown - primary tooth^PFABCERCRN^
 ;;D2981^1^4.58^INLREP^^inlay repair necessitated by restorative material failure^INLREP^
 ;;D2982^1^4.58^ONREP^^onlay repair necessitated by restorative material failure^ONREP^
 ;;D2983^1^4.58^VENREP^^veneer repair necessitated by restorative material failure^VENREP^
 ;;D4212^4^4.56^GINREST^^gingivectomy or gingivoplasty to allow access for restorative procedure, per tooth^GINREST^
 ;;D4277^5^14.07^FRSTGFT^^free soft tissue graft procedure (including donor site surgery), first tooth or edentulous tooth position in graft^FRSTGFT^
 ;;D4278^5^14.07^FRSTGFT AT^^free soft tissue graft procedure (including donor site surgery), each additional contiguous tooth or edentulous tooth position in same graft site^FRSTGFTAT^
 ;;D6101^4^2.10^DEIMP^^debridement of a periimplant defect and surface cleaning of exposed implant surfaces, including flap entry and closure^DEIMP^
 ;;D6102^5^5.42^DEOSIMP^^debridement and osseous contouring of a periimplant defect; includes surface cleaning of exposed implant surfaces and flap entry and closure^DEOSIMP^
 ;;D6103^5^5.25^BGIMP^^bone graft for repair of periimplant defect - not including flap entry and closure or, when indicated, placement of a barrier membrane or biologic materials to aid in osseous regeneration^BGIMP^
 ;;D6104^5^5.25^BGIMPPL^^bone graft at time of implant placement^GBIMPPL^
 ;;Placement of a barrier membrane, or biologic materials to aid in
 ;;osseous regeneration are reported separately.
 ;;D6051^5^2.79^INTABUT^^interim abutment^INTABUT^
 ;;Includes placement and removal.  A healing cap is not an interim abutment.
 ;;D7921^5^18.00^AUTOBL^^collection and application of autologous blood concentrate product^AUTOBL^n
 ;;The augmentation of the sinus to increase alveolar height by vertical access
 ;;through the ridge crest by raising the floor of the sinus and grafting as
 ;;necessary.  This includes obtaining the bone or bone substitutes.
 ;;D7952^5^30.51^^^sinus augmentation via a vertical approach^^n
 ;;D9975^9^4.50^EXBLHOME^^external bleaching for home application, per arch; includes materials and fabrication of custom trays^EXBLHOME^
 ;;***END***
