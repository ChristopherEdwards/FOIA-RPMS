GMRAOR ;HIRMFO/WAA,RM-OERR UTILITIES ;02-Aug-2011 11:45;DU
 ;;4.0;Adverse Reaction Tracking;**2,13,1002,1003**;Mar 29, 1996;Build 18
 ;IHS/MSC/MGH Updated order check to screen out inactive entries
ORCHK(DFN,TYP,PTR) ; Given a patient IEN (DFN), this function will
 ; return 1 (true) if the patient has an allergy to an agent defined
 ; by TYP and PTR, else it returns 0 (false). See table below.
 ; The Contrast Media Reaction check will return a null if the patient
 ; is not in the ART database.
 ;
 ;    Contrast Media Reaction:  TYP="CM", PTR (undefined)
 ;              Drug Reaction:  TYP="DR", PTR=IEN in ^PSNDF(.
 ;           Drug Ingredients:  TYP="IN", PTR=IEN in ^PS(50.416,
 ;                 Drug Class:  TYP="CL", PTR=IEN in ^PS(50.605,
 ;
 N GMRAFLG
 S GMRAFLG=0
 I $G(DFN)<1!("^CM^DR^IN^CL^"'[("^"_$G(TYP)_"^"))!($G(TYP)'="CM"&($G(PTR)<1)) S GMRAFLG=""
 E  D
 .I TYP="CM" S GMRAFLG=$$RAD(DFN) ; check for Contrast Media Reaction
 .I TYP="DR" S GMRAFLG=$$DRUG(DFN,PTR) ; check for Drug Reaction
 .I TYP="IN" S GMRAFLG=$$ING(DFN,PTR) ; Check for Drug Ingredients
 .I TYP="CL" S GMRAFLG=$$CLASS(DFN,PTR) ; Check for Drug Class
 .Q
 Q GMRAFLG
RAD(DFN) ; Subroutine checks for Contrast Media Reaction, returns 1 or 0.
 N FLG,GMRAL,GMRAPA
 D EN1^GMRADPT S FLG=GMRAL
 I GMRAL S GMRAPA=0 F  S GMRAPA=$O(GMRAL(GMRAPA)) Q:GMRAPA<1  D  Q:FLG
 .S FLG=$$RALLG^GMRARAD(GMRAPA)
 .Q
 Q FLG
DRUG(DFN,PTR) ; Subroutine checks for Drug Reaction, returns 1 or 0.
 N %,FLG,GMRAC,GMRADR,GMRAI,PSNVPN,PSNDA S FLG=0
 K GMRAING,GMRADRCL
 S PSNDA=$P(PTR,"."),PSNVPN=$P(PTR,".",2)
 I $G(@($$NDFREF_PSNDA_",0)"))'="" D
 .; Check for rxn to ingredients.
 .; If use the new entry point if there.
 .I $T(DISPDRG^PSNNGR)]"",PSNVPN]"" D
 ..K ^TMP("PSNDD",$J) D DISPDRG^PSNNGR ; get ingredients
 ..;IHS/MSC/MGH added check for active entries
 ..S GMRAI=0,%=1 F  S GMRAI=$O(^TMP("PSNDD",$J,GMRAI)) Q:GMRAI<1  I $D(^GMR(120.8,"API",DFN,GMRAI)) D
 ...S X1="" S X1=$O(^GMR(120.8,"API",DFN,GMRAI,X1)) Q:X1=""  D
 ....I $$ACTIVE(X1) S FLG=1,GMRAING(%)=^TMP("PSNDD",$J,GMRAI),%=%+1
 ..K ^TMP("PSNDD",$J)
 ..Q
 .E  D  ; get ingredients
 ..K ^TMP("PSN",$J) D ^PSNNGR
 ..;IHS/MSC/MGH Added check for inactive entries
 ..S GMRAI=0,%=1 F  S GMRAI=$O(^TMP("PSN",$J,GMRAI)) Q:GMRAI<1  I $D(^GMR(120.8,"API",DFN,GMRAI)) D
 ...S X1="" S X1=$O(^GMR(120.8,"API",DFN,GMRAI,X1)) Q:X1=""  D
 ....I $$ACTIVE(X1) S FLG=1,GMRAING(%)=^TMP("PSN",$J,GMRAI),%=%+1
 ..K ^TMP("PSN",$J)
 ..Q
 .Q:FLG  ; Rxn to ingredient, quit now.
 .; Check for rxn to VA Drug Class
 .S PSNDA=$P(PTR,"."),PSNVPN=$P(PTR,".",2)
 .N CLASS
 .I PSNVPN S CLASS=$$DCLCODE^PSNAPIS(PSNDA,PSNVPN) D DRCL(CLASS) Q
 .N CLASS,LIST
 .S LIST=$$CLIST^PSNAPIS(PSNDA,.LIST) Q:'$G(LIST)
 .S LIST=0 F  S LIST=$O(LIST(LIST)) Q:'LIST  D DRCL($P(LIST(LIST),U,2))
 .Q
 Q FLG
DRCL(CODE) ;return any rxn's in GMRADRCL(
 N X1
 I '$D(^GMR(120.8,"APC",DFN,CODE)) Q
 S X1="" S X1=$O(^GMR(120.8,"APC",DFN,CODE,X1)) Q:X1=""  D
 .I $$ACTIVE(X1) D
 ..N J S J=$S('$D(GMRADRCL):1,1:$O(GMRADRCL(999),-1)+1)
 ..;S GMRADRCL(J)=$$CLASS2^PSNAPIS(CODE)
 ..N CLSFN
 ..S CLSFN=$P(^PS(50.605,+$O(^PS(50.605,"B",CODE,0)),0),U,2)
 ..S GMRADRCL(J)=CODE_"^"_CLSFN
 ..S FLG=2
 Q
ING(DFN,PTR) ; Subroutine checks for Drug Ingredients, returns:
 ;                  If found FLG= 1 with GMRAIEN Array Drug Ingredients
 ;                 Not found FLG= 0
 N GMRAX K GMRAIEN
 S FLG=0
 S GMRAX=0
 ;IHS/MSC/MGH added check for inactive entries
 F  S GMRAX=$O(^GMR(120.8,"API",DFN,PTR,GMRAX)) Q:GMRAX<1  D
 .S X1="" S X1=$O(^GMR(120.8,"API",DFN,GMRAI,X1)) Q:X1=""  D
 ..I $$ACTIVE(X1) S FLG=1,GMRAIEN(GMRAX)=""
 Q FLG
CLASS(DFN,PTR) ; Subroutine checks for Drug Class, returns:
 ;                  If found FLG= 1 with GMRAIEN Array Drug Class
 ;                 Not found FLG= 0
 N GMRAC,GMRAX K GMRAIEN,X1
 S GMRAX=0,FLG=0,GMRAC=$P($G(^PS(50.605,PTR,0)),U)
 I GMRAC'="" F  S GMRAX=$O(^GMR(120.8,"APC",DFN,GMRAC,GMRAX)) Q:GMRAX<1  D
 .I $$ACTIVE(GMRAX) S FLG=1,GMRAIEN(GMRAX)=""
 Q FLG
NDFREF() ;get version dependent NDF reference
 I $$VERSION^XPDUTL("PSN")<4 Q "^PSNDF("
 Q "^PSNDF(50.6," ; new reference for ver 4.0
ACTIVE(ALL) ;Check allergy to see if it is inactive
 N IN,Z,INACT,REACT
 S IN=1
 I '$D(^GMR(120.8,ALL,9999999.12)) Q IN
 S Z=$O(^GMR(120.8,ALL,9999999.12,$C(0)),-1) I +Z D
 .S INACT=$P($G(^GMR(120.8,ALL,9999999.12,Z,0)),U,1)
 .S REACT=$P($G(^GMR(120.8,ALL,9999999.12,Z,0)),U,4)
 .I +INACT&(REACT="") S IN=0
 Q IN
