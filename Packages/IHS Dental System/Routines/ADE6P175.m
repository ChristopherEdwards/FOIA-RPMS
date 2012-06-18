ADE6P175 ;IHS/OIT/ENM - ADE6.0 PATCH 17 [ 03/26/2007  9:29 AM ]
 ;;6.0;ADE;**17**;JAN 29, 2007
 ;
MODCDT5 ;EP
 D UPDATE^ADEUPD7(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P175","SETX^ADE6P175")
 ;D UPDATE^ADEUPD7(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P173","SETX^ADE6P175")
 ;D MODEDT ;IHS/ENM NO NEED TO RUN THIS LINE IN P17
 Q
 ;
MODEDT ;EP Modify DENTAL CODE EDIT GROUP and Reindex DENTAL EDIT file
 ;D UPDATE^ADEUPD7(9002007.91,".01,1",,"?+1,","EDITX^ADE6P175","SETEDX^ADE6P175")
 ;D REINDX
 ;
 Q
SETEDX ;
 S ADEN=$P(ADEX,U)
 Q
 ;
EDITX ;Data for DENTAL CODE EDIT GROUP modifications
 Q
 ;;PRIMARY TOOTH PROCEDURES^2121|2930|3230
 ;;
 ;;***END***
 Q
 ;
REINDX ;EP Kill and Re-index AC, AD AND B Cross References on DENTAL EDIT file
 ;
 N DIK
 K ^ADEDIT("AC"),^ADEDIT("AD"),^ADEDIT("B")
 S DIK="^ADEDIT("
 D IXALL^DIK
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
 ;;D4265^65^biologic materials to aid in soft and osseous tissue regeneration^
 ;;Biologic materials may be used alone or with other regenerative substrates 
 ;;such as bone and barrier membranes, depending upon their formulation and 
 ;;the presentation of the periodontal defect.  This procedure does not include 
 ;;surgical entry and closure, wound debridement, osseous contouring, or the 
 ;;placement of graft materials and/or barrier membranes.  Other separate 
 ;;procedures may be required concurrent to D4265 and should be reported using 
 ;;their own unique codes.
 ;;D4266^57^guided tissue regeneration - resorbable barrier, per site^
 ;;A membrane is placed over the root surfaces or defect area following surgical 
 ;;exposure and debridement.  The mucoperiosteal flaps are then adapted over 
 ;;the membrane and sutured. The membrane is placed to exclude epithelium and
 ;; gingival connective tissue from the healing wound.  This procedure may require 
 ;;subsequent surgical procedures to correct the gingival contours.  Guided tissue
 ;; regeneration may also be carried out in conjunction with bone replacement 
 ;;grafts or to correct deformities resulting from inadequate faciolingual bone width
 ;; in an edentulous area.  When guided tissue regeneration is used in association
 ;; with a tooth, each site on a specific tooth should be reported separately.  Other
 ;; separate procedures may be required concurrent to D4266 and should be 
 ;;reported using their own unique codes.  Definition for the term "site" precedes
 ;; code D4210.
 ;;D4267^87^guided tissue regeneration - nonresorbable barrier, per site (includes membrane removal)^
 ;;This procedure is used to regenerate lost or injured periodontal tissue by
 ;; directing differential tissue responses.  A membrane is placed over the root 
 ;;surfaces or defect area following surgical exposure and debridement.  The 
 ;;mucoperiosteal flaps are then adapted over the membrane and sutured.  
 ;;This procedure does not include flap entry and closure, wound debridement, 
 ;;osseous contouring, bone replacement grafts, or the placement of biologic 
 ;;materials to aid in osseous tissue regeneration.  The membrane is placed to 
 ;;exclude epithelium and gingival connective tissue from the healing wound.  
 ;;This procedure requires subsequent surgical procedures to remove the 
 ;;membranes and/or to correct the gingival contours.  Guided tissue regeneration 
 ;;may be used in conjunction with bone replacement grafts or to correct 
 ;;deformities resulting from inadequate faciolingual bone width in an edentulous 
 ;;area.  When guided tissue regeneration is used in association with a tooth, 
 ;;each site on a specific tooth should be reported separately with this code.  
 ;;When no tooth is present, each site should be reported separately.  Other 
 ;;separate procedures may be required concurrent to D4267 and should be 
 ;;reported using their own unique codes.  Definition for the term "site" 
 ;;precedes code D4210.
 ;;D6970^81^post and core in addition to fixed partial denture retainer, indirectly fabricated^
 ;;Post and core are custom fabricated as a single unit.
 ;;D6976^55^each additional indirectly fabricated post - same tooth^
 ;;To be used with D6970.
 ;;D7310^94^alveoloplasty in conjunction with extractions  four or more teeth or tooth spaces, per quadrant^
 ;;Usually in preparation for a prosthesis.
 ;;D7320^98^alveoloplasty not in conjunction with extractions four or more teeth or tooth spaces, per quadrant^
 ;;No extractions performed in an edentulous area.  See D7310 if teeth are being 
 ;;extracted concurrently with the alveoplasty.
 ;;D7944^34^osteotomy - segmented or subapical^
 ;;Report by range of tooth numbers within segment.
 ;;D7950^112^osseous, osteoperiosteal, or cartilage graft of the mandible or maxilla - autogenous or nonautogenous, by report^
 ;;This code may be used for ridge augmentation or reconstruction to increase 
 ;;height, width and/or volume or residual alveolar ridge.  It includes obtaining 
 ;;autograft and/or allograft material.  Placement of a barrier membrane, if used,
 ;; should be reported separately.
 ;;D7953^55^bone replacement graft for ridge preservation  per site^
 ;;Osseous autograft, allograft or non-osseous graft is placed in an extraction 
 ;;site at the time of the extraction to preserve ridge integrity (e.g., clinically 
 ;;indicated in preparation for implant reconstruction or where alveolar contour 
 ;;is critical to planned prosthetic reconstruction).  Membrane, if used should 
 ;;be reported separately.
 ;;7955^54^repair of maxillofacial soft and/or hard tissue defect^
 ;;Reconstruction of surgical, traumatic, or congenital defects of the facial 
 ;;bones, including the mandible, may utilize autograft, allograft, or alloplastic
 ;; materials in conjunction with soft tissue procedures to repair and restore 
 ;;the facial bones to form and function.  This does not include obtaining the 
 ;;graft and these procedures may require multiple surgical approaches.  
 ;;This procedure does not include edentulous maxilla and mandibular 
 ;;reconstruction for prosthetic considerations.  See code D7950.
 ;;D9310^109^consultation - diagnostic service provided by dentist or physician other than requesting dentist or physician^
 ;;A patient encounter with a practitioner whose opinion or advice regarding 
 ;;evaluation and/or management of a specific problem; may be requested by 
 ;;another practitioner or appropriate source.  The consultation includes an 
 ;;oral evaluation.  The consulted practitioner may initiate diagnostic and/or 
 ;;therapeutic services.
 ;;D9610^50^therapeutic parenteral drug, single administration^
 ;;Includes single administration of antibiotics, steroids, anti-inflammatory 
 ;;drugs, or other therapeutic medications.  This code should not be used 
 ;;to report administration of sedative, anesthetic or reversal agents.
 ;;D9951^29^occlusal adjustment - limited^
 ;;May also be known as equilibration; reshaping the occlusal surfaces of 
 ;;teeth to create harmonious contact relationships between the maxillary 
 ;;and mandibular teeth.  Presently includes discing/odontoplasty/enamoplasty.
 ;;  Typically reported on a "per visit" basis.  This should not be reported when 
 ;;the procedure only involves bite adjustment in the routine post-delivery care 
 ;;for a direct/indirect restoration or fixed/removable prosthodontics.
 ;;
 ;;***END***
