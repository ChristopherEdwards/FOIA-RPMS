ADE6P251 ;IHS/OIT/GAB - ADE6.0 PATCH 25 [ 11/17/2013  8:37 AM ]
 ;;6.0;ADE*6.0*25;;Nov 14, 2013;Build 4
 ;Adds new codes and updates existing ADA codes
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD25(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P251","SETX^ADE6P251")
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
 ;;D0393^5^12.50^TXSIM^^treatment simulation using 3D image volume^TXSIM^n
 ;;The use of 3D image volumes for simulation of treatment including, but not limited to, 
 ;;dental implant placement, orthognathic surgery and orthodontic tooth movement.
 ;;D0394^5^12.50^DIGSUB^^digital subtraction of two or more image volumes of the same modality^DIGSUB^n
 ;;To demonstrate changes that have occurred over time.
 ;;D0395^5^12.50^DIIO^^fusion of two or more 3D image volumes of one or more modalities^DIIO^n
 ;;D0601^2^0.30^CARIESLOW^^caries risk assessment and documentation, with a finding of low risk^CARIESLOW^n
 ;;Using recognized assessment tools.
 ;;D0602^2^0.30^CARIESMOD^^caries risk assessment and documentation, with a finding of moderate risk^CARIESMOD^n
 ;;Using recognized assessment tools.
 ;;D0603^2^0.30^CARIESHIGH^^caries risk assessment and documentation, with a finding of high risk^CARIESHIGH^n
 ;;Using recognized assessment tools.
 ;;D1999^2^0.30^UNSPPREV^^unspecified preventive procedure, by report^UNSPPREV^n
 ;;D2921^3^3.00^REFRAG^^reattachment of tooth fragment, incisal edge or cusp^REFRAG^
 ;;D2941^3^2.00^ITRPRIM^^interim therapeutic restoration - primary dentition^ITRPRIM^
 ;;Placement of an adhesive restorative material following caries debridement by hand 
 ;;or other method for the management of early childhood caries.  Not considered a 
 ;;definitive restoration.
 ;;D2949^4^3.50^RFIDR^^restorative foundation of an indirect restoration^RFIDR^
 ;;Placement of an adhesive material to yield a more ideal form, including 
 ;;elimination of undercuts.
 ;;D3355^3^12.73^PGENINIT^^pulpal regeneration - initial visit^PGENINIT^
 ;;Includes opening tooth, preparation of canal spaces, placement of medication.
 ;;D3356^3^15.41^PGENINTERIM^^pulpal regeneration - interim medication replacement^PGENINTERIM^
 ;;D3357^3^8.93^PGENCOMP^^pulpal regeneration - completion of treatment^PGENCOMP^
 ;;Does not include final restoration.
 ;;D3427^4^8.00^PERIRADWO^^periradicular surgery without apicoectomy^PERIRADWO^
 ;;D3428^5^10.00^BGPERIRAD^^bone graft in conjunction with periradicular surgery - per tooth, single site^BGPERIRAD^
 ;;Includes non-autogenous graft material.
 ;;D3429^5^8.00^BGPERIRAD2^^bone graft in conjunction with periradicular surgery - each additional contiguous tooth in the same surgical site^BGPERIRAD2^
 ;;Includes non-autogenous graft material.
 ;;D3431^5^5.25^BIOMAT^^biologic materials to aid in soft and osseous tissue regeneration in conjunction with periradicular surgery^BIOMAT^
 ;;D3432^5^17.00^GTR^^guided tissue regeneration, resorbable barrier, per site, in conjunction with periradicular surgery^GTR^
 ;;D4921^4^0.80^GINGIRRIG^^gingival irrigation - per quadrant^GINGIRRIG^
 ;;Irrigation of gingival pockets with medicinal agent.  Not to be used to report 
 ;;use of mouth rinses or non-invasive chemical debridement.
 ;;D5863^5^29.59^ODMAXCOM^^overdenture - complete maxillary^ODMAXCOM^
 ;;D5864^5^30.15^ODMAXPAR^^overdenture - partial maxillary^ODMAXPAR^
 ;;D5865^5^29.59^ODMANDCOM^^overdenture - complete mandibular^ODMANDCOM^
 ;;D5866^5^30.15^ODMANDPAR^^overdenture - partial mandibular^ODMANDPAR^
 ;;D5994^5^3.35^PERIMEDCARR^^periodontal medicament carrier with peripheral seal - laboratory processed^PERIMEDCARR^
 ;;A custom fabricated, laboratory processed carrier that covers the teeth and 
 ;;alveolar mucosa.  Used as a vehicle to deliver prescribed medicaments for 
 ;;sustained contact with the gingiva, alveolar mucosa, and into the periodontal 
 ;;sulcus or pocket.
 ;;D6011^5^4.00^IMSX2^^second stage implant surgery^IMSX2^
 ;;Surgical access to an implant body for placement of a healing cap or to enable 
 ;;placement of an abutment.
 ;;D6013^5^36.85^MINIIMPLANT^^surgical placement of mini implant^MINIIMPLANT^
 ;;D6052^9^8.93^SEMIPRECABUT^^semi-precision attachment abutment^SEMIPRECABUT^
 ;;Includes placement of keeper assembly.
 ;;D8694^1^3.63^FIXEDRETREP^^repair of fixed retainers, includes reattachment^FIXEDRETREP^
 ;;D9985^9^0.00^TAX^^sales tax^TAX^n
 ;;***END***
