ADE6P171 ;IHS/OIT/ENM - ADE6.0 PATCH 17 [ 02/27/2007  8:37 AM ]
 ;;6.0;ADE;**17**;JUL 28, 2005
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD7(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P171","SETX^ADE6P171")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;
 ;;D0145^3^0.70^ORAL EVAL <3^94^oral evaluation for a patient under three years of age and counseling with primary caregiver^EXU3^n
 ;;Diagnostic and preventive services performed for a child under the age of three, 
 ;;preferably within the first six months of the eruption of the first primary tooth,
 ;;including recording the oral and physical health history, evaluation of caries 
 ;;susceptibility, development of an appropriate preventive oral health regimen 
 ;;and communication with and counseling of the childs parent, legal guardian 
 ;;and/or primary caregiver.
 ;;D0273^3^0.79^BITE WINGS 3^23^bitewings - three films^BW3^n
 ;;D0360^5^10.00^CONE BEAM^40^cone beam ct - craniofacial data capture^CB^n
 ;;Includes axial, coronal and sagittal data.
 ;;D0362^5^12.00^CONE BEAM 2D^94^cone beam  two-dimensional image reconstruction using existing data, includes multiple images^CB2D^n
 ;;D0363^5^12.50^CONE BEAM 3D^96^cone beam  three-dimensional image reconstruction using existing data, includes multiple images^CB3D^n
 ;;D0486^9^0.00^BRUSH BIOPSY^105^accession of brush biopsy sample, microscopic examination, preparation and transmission of written report^BBS^n
 ;;To be used in reporting transepithelial, disaggregated cell samples by brush 
 ;;biopsy technique.
 ;;D1206^2^0.80^TOP FL VARNISH^91^topical fluoride varnish; therapeutic application for moderate to high caries risk patients^FVAR^n
 ;;Application of topical fluoride varnish, delivered in a single visit and 
 ;;involving the entire oral cavity.  Not to be used for desensitization.
 ;;D1555^3^0.50^REM SP MAINT^33^removal of fixed space maintainer^REFSM^
 ;;Procedure delivered by dentist who did not originally place the appliance, 
 ;;or by the practice where the appliance was originally delivered to the patient.
 ;;D2970^1^3.85^TEMP CROWN^33^temporary crown (fractured tooth)^TC^
 ;;Usually a preformed artificial crown, which is fitted over a damaged tooth as 
 ;;an immediate protective device.  This is not to be used as temporization during 
 ;;crown fabrication.
 ;;D4230^5^12.50^CROWN EXP 4+^70^anatomical crown exposure - four or more contiguous teeth per quadrant^CREX4+^
 ;;This procedure is utilized in an otherwise periodontally healthy area to remove 
 ;;enlarged gingival tissue and supporting bone (ostectomy) to provide an anatomically 
 ;;correct gingival relationship.
 ;;D4231^5^10.50^CROWN EXP 1-3^59^anatomical crown exposure - one to three teeth per quadrant^CREX1-3^
 ;;This procedure is utilized in an otherwise periodontally healthy area to remove 
 ;;enlarged gingival tissue and supporting bone (ostectomy) to provide an anatomically 
 ;;correct gingival relationship.
 ;;D6012^5^36.85^ENDOSTEAL IMP^89^surgical placement of interim implant body for transitional prosthesis: endosteal implant^PLINIMP^
 ;;Includes removal during later therapy to accommodate the definitive restoration, which may include placement of other implants.
 ;;D6091^5^9.94^REP ATTACH^137^replacement of semi-precision or precision attachment (male or female component) of implant/abutment supported prosthesis, per attachment^REATT^
 ;;This procedure applies to the replaceable male or female component of the attachment
 ;;D6092^1^1.43^RECEM CROWN^41^recement implant/abutment supported crown^RECIMCR^
 ;;D6093^1^1.92^RECEM FPD^56^recement implant/abutment supported fixed partial denture^REIMFPD^
 ;;D7292^5^36.85^PLATE W/FLAP^93^surgical placement: temporary anchorage device [screw retained plate] requiring surgical flap^PLWFLAP^n
 ;;Insertion of a temporary skeletal anchorage device that is attached to the bone 
 ;;by screws and requires a surgical flap.  Includes device removal.
 ;;D7293^5^25.85^ANCHOR W/FLAP^70^surgical placement: temporary anchorage device requiring surgical flap^ANCWFLAP^n
 ;;Insertion of a device for temporary skeletal anchorage when a surgical flap is 
 ;;required.  Includes device removal.
 ;;D7294^5^14.75^ANCHOR W/O FLAP^69^surgical placement: temporary anchorage device without surgical flap^ANCWOFLAP^n
 ;;Insertion of a device for temporary skeletal anchorage when a surgical flap 
 ;;is not required.  Includes device removal.
 ;;D7951^5^30.51^SINUS AUGMENT^48^sinus augmentation with bone or bone substitutes^SIAUGWBONE^n
 ;;The augmentation of the sinus cavity to increase alveolar height for reconstruction 
 ;;of edentulous portions of the maxilla.  This includes obtaining the bone or 
 ;;bone substitutes.  Placement of a barrier membrane, if used, should be reported separately.
 ;;D7998^5^35.17^FIX DEVICE^75^intraoral placement of a fixation device not in conjunction with a fracture^IMFWOFX^n
 ;;The placement of intermaxillary fixation appliance for documented medically 
 ;;accepted treatments not in association with fractures.
 ;;D8693^1^3.63^RECEM RET^72^rebonding or recementing; and/or repair, as required, of fixed retainers^RECRET^
 ;;D9120^4^3.83^SECTION FPD^32^fixed partial denture sectioning^SECFPD^
 ;;Separation of one or more connections between abutments and/or pontics when 
 ;;some portion of a fixed prosthesis is to remain intact and serviceable following 
 ;;sectioning and extraction or other treatment.  Includes all recontouring and 
 ;;polishing of retained portions.
 ;;D9612^1^0.96^THER DRUG 2+^80^therapeutic parenteral drugs, two or more administrations, different medications^TPD2+^n
 ;;Includes multiple administrations of antibiotics, steroids, anti-inflammatory drugs
 ;;or other therapeutic medications. This code should not be used to report 
 ;;administration of sedatives, anesthetic or reversal agents.  This code should 
 ;;be reported when two or more different medications are necessary and should 
 ;;not be reported in addition to code D9610 on the same date.
 ;;***END***
