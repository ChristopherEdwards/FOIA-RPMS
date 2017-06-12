ADE6P301 ;IHS/OIT/GAB - ADE6.0 PATCH 30 [ 11/02/2015  8:37 AM ]
 ;;6.0;ADE*6.0*30;;March 25, 1999;Build 19
 ;Adds new codes and updates existing ADA codes
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD30(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P301","SETX^ADE6P301")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;      
ADDADA ;    code^Level of care^RVU^Syn^Nomen.^Mnem^Op Site Prompt / next line is the descriptor
 ;;D0251^5^0.68^EXORALPOSTXRAY^^extra-oral posterior dental radiographic image^EXORALPOSTXRAY^n
 ;;Image limited to exposure of complete posterior teeth in both dental arches.
 ;;This is a unique image that is not derived from another image.
 ;;D0422^9^0.00^GENETICSAMPLE^^collection and preparation of genetic sample material for laboratory analysis and report^GENETICSAMPLE^n
 ;;D0423^9^0.00^GENETICTEST^^genetic test for susceptibility to diseases - specimen analysis^GENETICTEST^n
 ;;Certified laboratory analysis to detect specific genetic variations associated with
 ;;increased susceptibility for diseases.
 ;;D1354^3^0.80^INTCARIESARREST^^interim caries arresting medicament application^INTCARIESARREST^
 ;;Conservative treatment of an active, non-symptomatic carious lesion by 
 ;;topical application of a caries arresting or inhibiting medicament and 
 ;;without mechanical removal of sound tooth structure.
 ;;D4283^5^8.00^AUTOCONGRAFT^^autogenous connective tissue graft procedure (including donor and recipient surgical sites) - each additional contiguous tooth, implant or edentulous tooth position in same graft site^AUTOCONGRAFT^
 ;;Used in conjunction with D4273.
 ;;D4285^5^6.00^NONAUTOCONGRAFT^^non-autogenous connective tissue graft procedure (including recipient surgical site and donor material) - each additional contiguous tooth, implant or edentulous tooth position in same graft site^NONAUTOCONGRAFT^
 ;;Used in conjunction with D4275.
 ;;D5221^5^15.00^IMMXPARTRES^^immediate maxillary partial denture - resin base (including any conventional clasps, rests and teeth)^IMMXPARTRES^
 ;;Includes limited follow-up care only; does not include future rebasing / relining procedure(s).
 ;;D5222^5^15.00^IMMDPARTRES^^immediate mandibular partial denture - resin base (including any conventional clasps, rests and teeth)^IMMDPARTRES^
 ;;Includes limited follow-up care only; does not include future rebasing / relining procedure(s).
 ;;D5223^5^22.00^IMMXPARTMET^^immediate maxillary partial denture - cast metal framework with resin denture bases (including any conventional clasps, rests and teeth)^IMMXPARTMET^
 ;;Includes limited follow-up care only; does not include future rebasing / relining procedure(s).
 ;;D5224^5^22.00^IMMDPARTMET^^immediate mandibular partial denture - cast metal framework with resin denture bases (including any conventional clasps, rests and teeth)^IMMDPARTMET^
 ;;Includes limited follow-up care only; does not include future rebasing / relining procedure(s).
 ;;D7881^1^1.25^OCCORTHOTICADJ^^occlusal orthotic device adjustment^OCCORTHOTICADJ^
 ;;D8681^1^1.00^REMORTHORETADJ^^removable orthodontic retainer adjustment^REMORTHORETADJ^
 ;;D9223^5^3.00^GENGA^^deep sedation/general anesthesia - each 15 minute increment^GENGA^n
 ;;Anesthesia time begins when the doctor administering the anesthetic agent 
 ;;initiates the appropriate anesthesia and non-invasive monitoring protocol 
 ;;and remains in continuous attendance of the patient.  Anesthesia services 
 ;;are considered completed when the patient may be safely left under the 
 ;;observation of trained personnel and the doctor may safely leave the room 
 ;;to attend to other patients or duties.The level of anesthesia is determined 
 ;;by the anesthesia providers documentation of the anesthetics effects upon 
 ;;the central nervous system and not dependent upon the route of administration.
 ;;D9243^5^2.00^IVSED^^intravenous moderate (conscious) sedation/analgesia - each 15 minute increment^IVSED^n
 ;;Anesthesia time begins when the doctor administering the anesthetic agent
 ;;initiates the appropriate anesthesia and non-invasive monitoring protocol 
 ;;and remains in continuous attendance of the patient.  Anesthesia services 
 ;;are considered completed when the patient may be safely left under the
 ;;observation of trained personnel and the doctor may safely leave the room
 ;;to attend to other patients or duties.
 ;;D9932^2^0.75^CLEANMXFULL^^cleaning and inspection of removable complete denture, maxillary^CLEANMXFULL^
 ;;This procedure does not include any adjustments.
 ;;D9933^2^0.75^CLEANMDFULL^^cleaning and inspection of removable complete denture, mandibular^CLEANMDFULL^
 ;;This procedure does not include any adjustments.
 ;;D9934^2^0.75^CLEANMXPART^^cleaning and inspection of removable partial denture, maxillary^CLEANMXPART^
 ;;This procedure does not include any adjustments.
 ;;D9935^2^0.75^CLEANMNPART^^cleaning and inspection of removable partial denture, mandibular^CLEANMNPART^
 ;;This procedure does not include any adjustments.
 ;;D9943^1^1.15^OCCLGUARDADJ^^occlusal guard adjustment^OCCLGUARDADJ^
 ;;***END***
