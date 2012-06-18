GMRAOR1 ;HIRMFO/RM,WAA-OERR UTILITIES ;04-Nov-2010 10:04;DU
 ;;4.0;Adverse Reaction Tracking;**21,1002**;Mar 29, 1996;Build 32
EN1(DFN,ARRAY) ; This entry returns a list of patient allergies/adverse
 ; reactions.
 ; Input variables:
 ;     DFN = IEN of patient in Patient (2) file
 ;     ARRAY = Return array for Patient reactions.
 ;             If ARRAY="" or undefined default will be GMRARXN.
 ;IHS/MSC/MGH added call to rerurn unaccessible
 Q:$G(DFN)'>0
 S ARRAY=$S($G(ARRAY)'="":ARRAY,1:ARRAY="GMRARXN") Q:ARRAY="GMRAL"
 K GMRARXN,GMRAL,GMRUN
 D EN1^GMRADPT ; Get Patient Allergies
 I GMRAL D  ; If the patient has reaction then reprocess to OERR Fmt
 .N GMRAIEN,GMRADFN,%,GMRASVR,X
 .S GMRARXN=1,GMRAIEN=0
 .F  S GMRAIEN=$O(GMRAL(GMRAIEN)) Q:GMRAIEN<1  D
 ..S GMRARXN(GMRARXN)=$P(GMRAL(GMRAIEN),U,2)_U ; Get freetext of agent.
 ..; Loop through 120.85 file to find all observed reacting reports for
 ..; this reaction.  Grab severity and store only the highest value.
 ..S GMRADFN=0,%="",GMRASVR="" F  S GMRADFN=$O(^GMR(120.85,"C",GMRAIEN,GMRADFN)) Q:GMRADFN<1  S %=$P($G(^GMR(120.85,GMRADFN,0)),U,14) S:%>+GMRASVR GMRASVR=%
 ..S GMRARXN(GMRARXN)=GMRARXN(GMRARXN)_$S(GMRASVR=1:"MILD",GMRASVR=2:"MODERATE",GMRASVR=3:"SEVERE",1:"")_U_GMRAIEN
 ..;Loop through the S/S multiple and get the external format and possibly the date/time.
 ..S %=0 F  S %=$O(GMRAL(GMRAIEN,"S",%)) Q:%<1  S GMRARXN(GMRARXN,"S",%)=$P(GMRAL(GMRAIEN,"S",%),";")_$S($G(GMRAIDT):";"_$P(^GMR(120.8,GMRAIEN,10,$O(^GMR(120.8,GMRAIEN,10,"B",$P(GMRAL(GMRAIEN,"S",%),";",2),0)),0),U,4),1:"") ;21
 ..S GMRARXN=GMRARXN+1
 ..Q
 .S GMRARXN=1
 .Q
 E  S GMRARXN=GMRAL
 I ARRAY'="GMRARXN" M @ARRAY=GMRARXN K GMRARXN
 K GMRAL
 Q
UNASS(ORPT) ;
 N Y,RESULT
 S RESULT=1
 S Y=$O(^GMR(120.86,ORPT,9999999.11,$C(0)),-1) I +Y D
 .I $P($G(^GMR(120.86,ORPT,9999999.11,Y,0)),U,4)="" D
 ..S RESULT=0
 Q RESULT
