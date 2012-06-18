ADE6P222 ;IHS/OIT/ENM - ADE6.0 PATCH 22 [ 12/01/2010  2:35 PM ]
 ;;6.0;ADE;**22**;SEP 17, 2008
 ;
MODCDT5 ;EP
 D UPDATE^ADEUPD22(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P222","SETX^ADE6P222")
 Q
 ;
SETX ;EP
 I $G(ADERPEAT) D  Q:ADERPEAT
 .S:ADERPEAT=1 ADECURX=ADEX,ADERPEAT=2
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEX=ADECURX,ADEN="" Q
 .S ADEX=ADESVX,$P(ADEX,U)=ADEN,ADERPEAT=2
 Q:ADEDONE
 I $P(ADEX,U)["-" D  Q:'ADERPEAT
 .S ADERPEAT=1,ADESVX=ADEX,ADESTART=$P($P($P(ADEX,U),"-"),"D",2),ADEEND=$P($P($P(ADEX,U),"-",2),"D",2),ADEN=$O(^AUTTADA("B",ADESTART),-1)
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEN="" Q
 .S $P(ADEX,U)=ADEN
 I 'ADERPEAT S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN
 S $P(ADEX,U,3)=$TR($P(ADEX,U,3),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S:ADERPEAT ADESVX=ADEX
 Q
 ;
MODADA ;
 ;;D0486^118^accession of transepithelial cytologic sample, microscopic examination, preparation and transmission of written report
 ;;Pathological analysis, and written report of findings, of cytologic sample of
 ;;disaggregated transepithelial cells.
 ;;D2940^22^protective restoration
 ;;Direct placement of a temporary restorative material to protect tooth and/or 
 ;;tissue.  This procedure may be used to relieve pain, promote healing, or
 ;;prevent further deterioration.  Not to be used for endodontic access closure,
 ;;or as a base or liner under a restoration.
 ;;D3351^162^apexification/recalcification/pulpal regeneration – initial visit (apical closure/calcific repair of perforations, root resorption, pulp space disinfection, etc.)
 ;;Includes opening tooth, preparation of canal spaces, first placement of
 ;;medication and necessary radiographs.  (This procedure may include first phase
 ;;of complete root canal therapy.)
 ;;D3352^179^apexification/recalcification/pulpal regeneration - interim medication replacement (apical closure/calcific repair of perforations, root resorption, pulp space disinfection, etc.)
 ;;For visits in which the intra-canal medication is replaced with new medication
 ;;and necessary radiographs.  There may be several of these visits.
 ;;D4263^47^bone replacement graft - first site in quadrant
 ;;This procedure involves the use of osseous autografts, osseous allografts, or
 ;;non-osseous grafts to stimulate periodontal regeneration when the disease
 ;;process has led to a deformity of the bone.  This procedure does not include
 ;;flap entry and closure, wound debridement, osseous contouring, or the placement
 ;;of biologic materials to aid in osseous tissue regeneration or barrier
 ;;membranes.  Other separate procedures may be required concurrent to D4263 and
 ;;should be reported using their own unique codes.
 ;;D4264^57^bone replacement graft - each additional site in quadrant
 ;;This procedure involves the use of osseous autografts, osseous allografts, or
 ;;non-osseous grafts to stimulate periodontal regeneration when the disease
 ;;process has led to a deformity of the bone.  This procedure does not include
 ;;flap entry and closure, wound debridement, osseous contouring, or the placement
 ;;of biologic materials to aid in osseous tissue regeneration or barrier
 ;;membranes.  This code is used if performed concurrently with D4263 and allows
 ;;reporting of the exact number of sites involved.
 ;;D4266^57^guided tissue regeneration - resorbable barrier, per site
 ;;A membrane is placed over the root surfaces or defect area following surgical
 ;;exposure and debridement.  The mucoperiosteal flaps are then adapted over the
 ;;membrane and sutured. The membrane is placed to exclude epithelium and
 ;;gingival connective tissue from the healing wound.  This procedure may require
 ;;subsequent surgical procedures to correct the gingival contours.  Guided
 ;;tissue regeneration may also be carried out in conjunction with bone
 ;;replacement grafts or to correct deformities resulting from inadequate
 ;;faciolingual bone width in an edentulous area.  When guided tissue
 ;;regeneration is used in association with a tooth, each site on a specific
 ;;tooth should be reported separately.  Other separate procedures may be
 ;;required concurrent to D4266 and should be reported using their own unique
 ;;codes.
 ;;D4267^88^guided tissue regeneration - nonresorbable barrier, per site (includes membrane removal)
 ;;This procedure is used to regenerate lost or injured periodontal tissue by
 ;;directing differential tissue responses.  A membrane is placed over the root
 ;;surfaces or defect area following surgical exposure and debridement.  The
 ;;mucoperiosteal flaps are then adapted over the membrane and sutured.  This
 ;;procedure does not include flap entry and closure, wound debridement,
 ;;osseous contouring, bone replacement grafts, or the placement of biologic
 ;;materials to aid in osseous tissue regeneration.  The membrane is placed
 ;;to exclude epithelium and gingival connective tissue from the healing wound.
 ;;This procedure requires subsequent surgical procedures to remove the
 ;;membranes and/or to correct the gingival contours.  Guided tissue
 ;;regeneration may be used in conjunction with bone replacement grafts or to
 ;;correct deformities resulting from inadequate faciolingual bone width in
 ;;an edentulous area.  When guided tissue regeneration is used in
 ;;association with a tooth, each site on a specific tooth should be reported
 ;;separately with this code.  When no tooth is present, each site should be
 ;;reported separately.  Other separate procedures may be required concurrent
 ;;to D4267 and should be reported using their own unique codes.
 ;;D4320^36^provisional splinting - intracoronal
 ;;This is an interim stabilization of mobile teeth.  A variety of methods and
 ;;appliances may be employed for this purpose.  Identify the teeth involved.
 ;;D4321^36^provisional splinting - extracoronal
 ;;This is an interim stabilization of mobile teeth.  A variety of methods and
 ;;appliances may be employed for this purpose.  Identify the teeth involved.
 ;;D6055^56^connecting bar – implant supported or abutment supported
 ;;Utilized to stabilize and anchor a prosthesis.
 ;;D6950^20^precision attachment
 ;;A male and female pair constitutes one precision attachment, and is separate
 ;;from the prosthesis.
 ;;D7210^147^surgical removal of erupted tooth requiring removal of bone and/or sectioning of tooth, and including elevation of mucoperiosteal flap if indicated
 ;;Includes related cutting of gingiva and bone, removal of tooth structure,
 ;;minor smoothing of socket bone and closure.
 ;;D7953^56^bone replacement graft for ridge preservation – per site
 ;;Osseous autograft, allograft or non-osseous graft is placed in an extraction
 ;;or implant removal site at the time of the extraction or removal to preserve
 ;;ridge integrity (e.g., clinically indicated in preparation for implant
 ;;reconstruction or where alveolar contour is critical to planned prosthetic
 ;;reconstruction).  Membrane, if used should be reported separately.
 ;;D7960^109^frenulectomy – also known as frenectomy or frenotomy – separate procedure not incidental to another procedure
 ;;Surgical removal or release of mucosal and muscle elements of a buccal,
 ;;labial or lingual that is associated with a pathological condition, or
 ;;interferes with proper oral development or treatment.
 ;;D9215^69^local anesthesia in conjunction with operative or surgical procedures
 ;;D9230^51^inhalation of nitrous oxide / anxiolysis, analgesia
 ;;D9420^43^hospital or ambulatory surgical center call
 ;;Care provided outside the dentist’s office to a patient who is in a hospital
 ;;or ambulatory surgical center. Services delivered to the patient on the date
 ;;of service are documented separately using the applicable procedure codes.
 ;;***END***
