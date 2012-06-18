ADE6P181 ;IHS/OIT/ENM - ADE6.0 PATCH 18 [ 09/17/2008  8:37 AM ]
 ;;6.0;ADE;**18**;SEP 17, 2008
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD8(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P181","SETX^ADE6P181")
 Q
AC  ;EP
 ;SET Dental Edit File "AC" xref for new ADA Codes
 D S1,S2
 Q
S1 ;Code 3222 is the same as 2750
 S ADENO=2750,ADEAC=0
 F  S ADEAC=$O(^ADEDIT("AC",ADENO,1,ADEAC)) Q:'ADEAC  D ZSE
 K ADENO,ADEAC
 Q
S2  ;Code 5991 is the same as 4341
 S ADENO=4341,ADEAC=0
 F ADEAC=$O(^ADEDIT("AC",ADENO,1,ADEAC)) Q:'ADEAC  D ZSE
 K ADENO,ADEAC
 Q
ZSE ;
 I ADENO=2750 S ^ADEDIT("AC",3222,1,ADEAC)=""
 I ADENO=4341 S ^ADEDIT("AC",5991,1,ADEAC)=""
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;
 ;;D0007^0^0.00^SP NASN^50^sealants present; no additional sealants indicated^SPNASN^n
 ;;Patient age 6 through 15 presents with at least one existing sealant AND no
 ;;additional sealants indicated
 ;;D0417^9^0.00^SAL SAMP COL^77^collection and preparation of saliva sample for laboratory diagnostic testing^SSCOL^n
 ;;D0418^9^0.00^SAL SAMP ANAL^25^analysis of saliva sample^SSANAL^n
 ;;Chemical or biological analysis of saliva sample for diagnostic purposes.
 ;;D3222^3^3.00^PP APXGEN^85^partial pulpotomy for apexogenesis - permanent tooth with incomplete root development^PPAPXGEN^
 ;;Removal of a portion of the pulp and application of a medicament with the aim
 ;; of maintaining the vitality of the remaining portion to encourage continued 
 ;;physiological development and formation of the root.  This procedure is not to 
 ;;be construed as the first stage of root canal therapy.
 ;;D5991^3^3.24^TOP MED CAR^26^topical medicament carrier^TOPMEDCAR^
 ;;A custom fabricated carrier that covers the teeth and alveolar mucosa, or 
 ;;alveolar mucosa alone, and is used to deliver topical corticosteroids and 
 ;;similar effective medicaments for maximum sustained contact with the 
 ;;alveolar ridge and/or attached gingival tissues for the control and management
 ;; of immunologically mediated vesiculobullous mucosal, chronic recurrent 
 ;;ulcerative, and other desquamative diseases of the gingiva and oral mucosa.
 ;;***END***
