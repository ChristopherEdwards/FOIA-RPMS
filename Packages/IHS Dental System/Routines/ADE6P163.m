ADE6P163 ; IHS/OIT/MJL - ADE6.0 PATCH 16 ; 
 ;;6.0;ADE;**16**;JUL 28, 2005
 ;
DELCDT5 ;EP
 D DELETES^ADEUPD("DELADA^ADE6P163","SETX^ADE6P163","^AUTTADA(")
 Q
 ;
SETX ;EP
 S ADEX=$P($P(ADEX,U),"D",2),ADEX=$O(^AUTTADA("B",ADEX,""))
 Q
 ;
DELADA ;
 ;;D2970^Temporary Crown
 ;;D6020^Abutment placement of substituition-endosteal implant
 ;;D7281^Surgical exposure of impacted or unerupted tooth to aid eruption
 ;;***END***
 ;
MODADA ;
 ;;D4910^24^periodontal maintenance ^
 ;;This procedure is instituted following periodontal therapy and continues at varying intervals, determined
 ;;by the clinical evaluation of the dentist, for the life of the dentition or any implant replacements.
 ;;It includes removal of the bacterial plaque and calculus from supragingival and subgingival regions, site
 ;;specific scaling and root planing where indicated, and polishing the teeth.  If new or recurring periodontal
 ;;disease appears, additional diagnostic and treatment procedures must be considered.
 ;;;;D5000-D5899^26^Prosthodontics (removable)^
 ;;;;Local anesthesia is usually considered to be part of Removable Prosthodontic procedures.
 ;;;;D6000-D6199^16^Implant Services^
 ;;;;Local anesthesia is usually considered to be part of Implant Services procedures.  Report surgical implant
 ;;;;procedure using codes in this section.
 ;;^27^CLASSIFICATION OF MATERIALS^
 ;;Classification of Metals (Source:  ADA Council on Scientific Affairs) The noble metal classification system
 ;;has been adopted as a more precise method of reporting various alloys used in dentistry.  The alloys are
 ;;defined on the basis of the percentage of metal content: high noble - Gold (Au), Palladium (Pd), and/or
 ;;Platinum (Pt) > 60% (with at least 40% Au); titanium and titanium alloys – Titanium (Ti) > 85%; noble
 ;;- Gold (Au), Palladium (Pd), and/or Platinum (Pt)> 25%; predominantly base - Gold (Au), Palladium (Pd),
 ;;and/or Platinum (Pt) < 25%.   Porcelain/ceramic
 ;;D6056^43^prefabricated abutment - includes placement^
 ;;A connection to an implant that is a manufactured component usually made of machined high noble metal,
 ;;titanium, titanium alloy or ceramic.  Modification of a prefabricated abutment may be necessary, and is
 ;;accomplished by altering its shape using dental burrs/diamonds.
 ;;D6057^36^custom abutment - includes placement^
 ;;A connection to an implant that is a fabricated component, usually by a laboratory, specific for an individual
 ;;application.  A custom abutment is typically fabricated using a casting process and usually is made of
 ;;noble or high noble metal.  A 'UCLA abutment' is an example of this type abutment.
 ;;;;D6200-D6999^21^Prosthodontics, fixed^
 ;;;;Each retainer and each pontic constitutes a unit in a fixed partial denture.  Local anesthesia is usually
 ;;;;considered to be part of Fixed Prosthodontic procedures.   The words “bridge” and “bridgework” have been
 ;;;;replaced by the statement “fixed partial denture” throughout this section.
 ;;^27^CLASSIFICATION OF MATERIALS^
 ;;Classification of Metals (Source:  ADA Council on Scientific Affairs) The noble metal classification system
 ;;has been adopted as a more precise method of reporting various alloys used in dentistry.  The alloys are
 ;;defined on the basis of the percentage of metal content: high noble - Gold (Au), Palladium (Pd), and/or
 ;;Platinum (Pt) > 60% (with at least 40% Au); titanium and titanium alloys – Titanium (Ti) > 85%; noble
 ;;- Gold (Au), Palladium (Pd), and/or Platinum (Pt)> 25%; predominantly base - Gold (Au), Palladium (Pd),
 ;;and/or Platinum (Pt) < 25%.   Porcelain/ceramic
 ;;D6975^14^coping - metal^
 ;;To be used as a definitive restoration when coping is an integral part of a fixed prosthesis.
 ;;;;D7000-D7999^30^Oral and Maxillofacial Surgery^
 ;;;;Local anesthesia is usually considered to be part of Oral and Maxillofacial Surgical procedures.  For
 ;;;;dental benefit reporting purposes a quadrant is defined as four or more contiguous teeth and/or teeth
 ;;;;spaces distal to the midline.
 ;;D7111^46^extraction, coronal remnants - deciduous tooth^
 ;;Removal of soft tissue-retained coronal remnants.
 ;;D7140^76^extraction, erupted tooth or exposed root (elevation and/or forceps removal)^
 ;;Includes routine removal of tooth structure, minor smoothing of socket bone, and closure, as necessary.
 ;;D7210^120^surgical removal of erupted tooth requiring elevation of mucoperiosteal flap and removal of bone and/or section of tooth^
 ;;Includes cutting of gingiva and bone, removal of tooth structure, minor smoothing of socket bone and closure.
 ;;D7280^37^surgical access of an unerupted tooth^
 ;;An incision is made and the tissue is reflected and bone removed as necessary to expose the crown of an
 ;;impacted tooth not intended to be extracted.
 ;;D7285^42^biopsy of oral tissue - hard (bone, tooth)^
 ;;For removal of specimen only. This code involves biopsy of osseous lesions and is not used for apicoectomy/periradicular
 ;;surgery. For removal of specimen only. This code involves biopsy of osseous lesions and is not used for
 ;;apicoectomy/periradicular surgery.
 ;;D7286^29^biopsy of oral tissue - soft ^
 ;;For surgical removal of an architecturally intact specimen only. This code is not used at the same time
 ;;as codes for apicoectomy/periradicular curettage.
 ;;D7287^41^exfoliative cytological sample collection^
 ;;For collection of non-transepithelial cytology sample via mild scraping of the oral mucosa.
 ;;D7490^41^radical resection of maxilla or mandible ^
 ;;Partial resection of maxilla or mandible; removal of lesion and defect with margin of normal appearing
 ;;bone.  Reconstruction and bone grafts should be reported separately.
 ;;D7950^117^osseous, osteoperiosteal, or cartilage graft of the mandible or facial bones - autogenous or nonautogenous, by report^
 ;;This code may be used for sinus lift procedure and/or for ridge augmentation.  It includes obtaining autograft
 ;;and/or allograft material.  Placement of a barrier membrane, if used, should be reported separately.
 ;;D7955^54^repair of maxillofacial soft and/or hard tissue defect^
 ;;Reconstruction of surgical, traumatic, or congenital defects of the facial bones, including the mandible,
 ;;may utilize autograft, allograft, or alloplastic materials in conjunction with soft tissue procedures
 ;;to repair and restore the facial bones to form and function.  This does not include obtaining the graft
 ;;and  these procedures may require multiple surgical approaches.
 ;;D9310^110^consultation (diagnostic service provided by dentist or physician other than practitioner providing treatment)^
 ;;Type of service provided by a dentist whose opinion or advice regarding evaluation and/or management of
 ;;a specific problem  may be requested by another dentist, physician or appropriate source.  The dentist
 ;;may initiate diagnostic and/or therapeutic services.
 ;;D2932^^prefabricated resin crown
 ;;In direct programs, if a resin crown is used on a permanent tooth
 ;;when cast restoration has not been planned, it should be coded as a temporary crown.
 ;;
 ;;***END***
