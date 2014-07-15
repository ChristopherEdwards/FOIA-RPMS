ADE6P252 ;IHS/OIT/GAB - ADE6.0 PATCH 25 [ 11/13/2013  2:35 PM ]
 ;;6.0;ADE*6.0*25;;Nov 14, 2013;Build 4
 ;;ADA Code Update
 ;;Modification of Code
MODCDT5 ;EP
 D UPDATE^ADEUPD25(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P252","SETX^ADE6P252")
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
MODADA ;  Code^Nomenclature    /   Descriptor on next line
 ;;D0350^^oral/facial photographic images obtained intraorally or extraorally
 ;;D2950^^core buildup, including any pins when required
 ;;Refers to building up of coronal structure when there is insufficient retention 
 ;;for a separate extracoronal restorative procedure.  A core buildup is not a filler
 ;;to eliminate any undercut, box form, or concave irregularity in a preparation.
 ;;D3351^^apexification/recalcification - initial visit (apical closure/calcific repair of perforations, root resorption, pulp space disinfection, etc.)
 ;;Includes opening tooth, preparation of canal spaces, first placement of medication 
 ;;and necessary radiographs.  (This procedure may include first phase of complete root 
 ;;canal therapy.)
 ;;D3352^^apexification/recalcification - interim medication replacement (apical closure/calcific repair of perforations, root resorption, pulp space disinfection, etc.)
 ;;For visits in which the intra-canal medication is replaced with new medication.  
 ;;Includes any necessary radiographs.
 ;;D3410^^apicoectomy - anterior
 ;;For surgery on root of anterior tooth.  Does not include placement of retrograde filling material.
 ;;D3421^^apicoectomy - bicuspid (first root)
 ;;For surgery on one root of a bicuspid.  Does not include placement of retrograde filling material. If more than one root is treated, see D3426.
 ;;D3425^^apicoectomy - molar (first root)
 ;;For surgery on one root of a molar tooth.  Does not include placement of retrograde 
 ;;filling material. If more than one root is treated, see D3426.
 ;;D3426^^apicoectomy (each additional root)
 ;;Typically used for bicuspids and molar surgeries when more than one root is treated 
 ;;during the same procedure.  This does not include retrograde filling material placement.
 ;;D4263^^bone replacement graft - first site in quadrant
 ;;This procedure involves the use of grafts to stimulate periodontal regeneration when 
 ;;the disease process has led to a deformity of the bone.  This procedure does not include 
 ;;flap entry and closure, wound debridement, osseous contouring, or the placement of 
 ;;biologic materials to aid in osseous tissue regeneration or barrier membranes.  
 ;;Other separate procedures delivered concurrently are documented with their own codes.
 ;;D4264^^bone replacement graft - each additional site in quadrant
 ;;This procedure involves the use of grafts to stimulate periodontal regeneration 
 ;;when the disease process has led to a deformity of the bone. This procedure does 
 ;;not include flap entry and closure, wound debridement, osseous contouring, or the 
 ;;placement of biologic materials to aid in osseous tissue regeneration or barrier 
 ;;membranes. This procedure is performed concurrently with one or more bone replacement
 ;;grafts to document the number of sites involved.
 ;;D4920^^unscheduled dressing change (by someone other than treating dentist or their staff)
 ;;D5991^^vesiculobullous disease medicament carrier
 ;;A custom fabricated carrier that covers the teeth and alveolar mucosa, or alveolar 
 ;;mucosa alone, and is used to deliver prescription medicaments for treatment of 
 ;;immunologically mediated vesiculobullous disease.
 ;;D6010^^surgical placement of implant body: endosteal implant
 ;;D6080^^implant maintenance procedures when prostheses are removed and reinserted, including cleansing of prostheses and abutments
 ;;This procedure includes active debriding of the implant(s) and examination of all 
 ;;aspects of the implant system(s), including the occlusion and stability of the 
 ;;superstructure.  The patient is also instructed in thorough daily cleansing of 
 ;;the implant(s).  This is not a per implant code, and is indicated for implant 
 ;;supported fixed prostheses.
 ;;D7950^^osseous, osteoperiosteal, or cartilage graft of the mandible or maxilla - autogenous or nonautogenous, by report
 ;;This procedure is for ridge augmentation or reconstruction to increase height, 
 ;;width and/or volume of residual alveolar ridge.  It includes obtaining graft 
 ;;material.  Placement of a barrier membrane, if used, should be reported separately.
 ;;D7953^^bone replacement graft for ridge preservation - per site 
 ;;Graft is placed in an extraction or implant removal site at the time of the 
 ;;extraction or removal to preserve ridge integrity (e.g., clinically indicated 
 ;;in preparation for implant reconstruction or where alveolar contour is critical 
 ;;to planned prosthetic reconstruction).  Does not include obtaining graft material.  
 ;;Membrane, if used should be reported separately.
 ;;D7955^^repair of maxillofacial soft and/or hard tissue defect
 ;;Reconstruction of surgical, traumatic, or congenital defects of the facial bones, 
 ;;including the mandible, may utilize graft materials in conjunction with soft tissue 
 ;;procedures to repair and restore the facial bones to form and function.  This does 
 ;;not include obtaining the graft and these procedures may require multiple surgical 
 ;;approaches.  This procedure does not include edentulous maxilla and mandibular 
 ;;reconstruction for prosthetic considerations.
 ;;D8693^^rebonding or recementing of fixed retainers
 ;;D0363^^cone beam - three-dimensional image reconstruction using existing data, includes multiple images
 ;;D3354^^pulpal regeneration - (completion of regenerative treatment in an immature permanent tooth with a necrotic pulp); does not include final restoration
 ;;Includes removal of intra-canal medication and procedures necessary to regenerate 
 ;;continued root development and necessary radiographs.  This procedure includes 
 ;;placement of a seal at the coronal portion of the root canal system.  Conventional 
 ;;root canal treatment is not performed.
 ;;D5860^^overdenture - complete, by report
 ;;Describe and document procedures as performed.  Other separate procedures may be 
 ;;required concurrent to D5860.
 ;;D5861^^overdenture - partial, by report
 ;;Describe and document procedures as performed.  Other separate procedures may be 
 ;;required concurrent to D5861.
 ;;***END***
