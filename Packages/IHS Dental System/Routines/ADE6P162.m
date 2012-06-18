ADE6P162 ; IHS/OIT/MJL - ADE6.0 PATCH 16 ;  [ 08/08/2005  11:09 AM ]
 ;;6.0;ADE;**16**;JUL 28, 2005
 ;
MODCDT5 ;EP
 D UPDATE^ADEUPD(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P162","SETX^ADE6P162")
 D UPDATE^ADEUPD(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P163","SETX^ADE6P162")
 D MODEDT
 Q
 ;
MODEDT ;EP Modify DENTAL CODE EDIT GROUP and Reindex DENTAL EDIT file
 D UPDATE^ADEUPD(9002007.91,".01,1",,"?+1,","EDITX^ADE6P162","SETEDX^ADE6P162")
 D REINDX
 ;
 Q
SETEDX ;
 S ADEN=$P(ADEX,U)
 Q
 ;
EDITX ;Data for DENTAL CODE EDIT GROUP modifications
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
 ;;D0150^58^comprehensive oral evaluation - new or established patient^
 ;;Typically used by a general dentist and/or a specialist when evaluating a patient comprehensively.  This
 ;;applies to new patients; established patients who have had a significant change in health conditions or
 ;;other unusual circumstances, by report, or est
 ;;D0160^67^detailed and extensive oral evaluation - problem focused, by report^
 ;;A detailed and extensive problem focused evaluation entails extensive diagnostic and cognitive modalities
 ;;based on the findings of a comprehensive oral evaluation. Integration of more extensive diagnostic modalities
 ;;to develop a treatment plan for a specific problem is required.  The condition requiring this type of
 ;;evaluation should be described and documented.  Examples of conditions requiring this type of evaluation
 ;;may include dentofacial anomalies, complicated perio-prosthetic conditions, complex temporomandibular
 ;;dysfunction, facial pain of unknown origin, conditions requiring multi-disciplinary consultation, etc.
 ;;D0350^31^oral/facial photographic images^
 ;;This includes photographic images, including those obtained by intraoral and extraoral cameras, excluding
 ;;radiographic images.  These photographic images should be a part of the patient’s clinical record
 ;;D0415^57^collection of microorganisms for culture and sensitivity ^
 ;;
 ;;D0480^61^processing and interpretation of exfoliative cytologic smears^
 ;;
 ;;D1110^19^prophylaxis - adult^
 ;;Removal of plaque, calculus and stains from the tooth structures in the permanent and transitional dentition.
 ;;It is intended to control local irritational factors.
 ;;D1120^19^prophylaxis - child^
 ;;Removal of plaque, calculus and stains from the tooth structures in the primary and transitional dentition.
 ;;It is intended to control local irritational factors.
 ;;^45^TOPICAL FLUORIDE TREATMENT (OFFICE PROCEDURE)^
 ;;Prescription strength fluoride product designed solely for use in the dental office, delivered to the
 ;;dentition under the direct supervision of a dental professional.  Fluoride must be applied separately
 ;;from prophylaxis paste.
 ;;;;D2000-D2999^11^Restorative^
 ;;;;Local anesthesia is usually considered to be part of Restorative procedures.
 ;;^27^CLASSIFICATION OF MATERIALS^
 ;;Classification of Metals (Source:  ADA Council on Scientific Affairs) The noble metal classification system
 ;;has been adopted as a more precise method of reporting various alloys used in dentistry.  The alloys are
 ;;defined on the basis of the percentage of metal content: high noble - Gold (Au), Palladium (Pd), and/or
 ;;Platinum (Pt) > 60% (with at least 40% Au); titanium and titanium alloys – Titanium (Ti) > 85%; noble
 ;;- Gold (Au), Palladium (Pd), and/or Platinum (Pt)> 25%; predominantly base - Gold (Au), Palladium (Pd),
 ;;and/or Platinum (Pt) < 25%.   Porcelain/ceramic
 ;;D2710^40^crown - resin-based composite (indirect)^
 ;;Unfilled or non-reinforced resin crowns should be reported using D2999.
 ;;D2910^54^recement inlay, onlay, or partial coverage restoration^
 ;;
 ;;;;D3000-D3999^11^Endodontics^
 ;;;;Local anesthesia is usually considered to be part of Endodontic procedures.
 ;;D3332^74^incomplete endodontic therapy; inoperable, unrestorable or fractured tooth^
 ;;Considerable time is necessary to determine diagnosis and/or provide initial treatment before the fracture
 ;;makes the tooth unretainable.
 ;;;;D4000-D4999^12^Periodontics^
 ;;;;Local anesthesia is usually considered to be part of Periodontal procedures.
 ;;D4210^98^gingivectomy or gingivoplasty - four or more contiguous teeth or bounded teeth spaces per quadrant^
 ;;Involves the excision of the soft tissue wall of the periodontal pocket by either an external or an internal
 ;;bevel.  It is performed to eliminate suprabony pockets after adequate initial preparation, to allow access
 ;;for restorative dentistry in the presence of suprabony pockets, and to restore normal architecture when
 ;;gingival enlargements or asymmetrical or unesthetic topography is evident with normal bony configuration.
 ;;D4211^98^gingivectomy or gingivoplasty - one to three contiguous teeth or bounded teeth spaces per quadrant^
 ;;Involves the excision of the soft tissue wall of the periodontal pocket by either an external or an internal
 ;;bevel.  It is performed to eliminate suprabony pockets after adequate initial preparation, to allow access
 ;;for restorative dentistry in the presence of suprabony pockets, and to restore normal architecture when
 ;;gingival enlargements or asymmetrical or unesthetic topography is evident with normal bony configuration.
 ;;D4240^116^gingival flap procedure, including root planing - four or more contiguous teeth or bounded teeth spaces per quadrant^
 ;;A soft tissue flap is reflected or resected to allow debridement of the root surface and the removal of
 ;;granulation tissue.  Osseous recontouring is not accomplished in conjunction with this procedure.  May
 ;;include open flap curettage, reverse bevel flap surgery, modified Kirkland flap procedure, Widman surgery,
 ;;and modified Widman surgery.  This procedure is performed in the presence of moderate to deep probing
 ;;depths, loss of attachment, need to maintain esthetics, need for increased access to the root surface
 ;;and alveolar bone, and to determine the presence of a cracked tooth, fractured root, or external root
 ;;resorption.  Other separate procedures including, but not limited to, D3450, D3920, D4263, D4265, D4266,
 ;;D4267 and D7140 may be required concurrent to D4240.
 ;;D4241^116^gingival flap procedure, including root planing - one to three contiguous teeth or bounded teeth spaces per quadrant^
 ;;A soft tissue flap is reflected or resected to allow debridement of the root surface and the removal of
 ;;granulation tissue.  Osseous recontouring is not accomplished in conjunction with this procedure.  May
 ;;include open flap curettage, reverse bevel flap surgery, modified Kirkland flap procedure, Widman surgery,
 ;;and modified Widman surgery.  This procedure is performed in the presence of moderate to deep probing
 ;;depths, loss of attachment, need to maintain esthetics, need for increased access to the root surface
 ;;and alveolar bone, and to determine the presence of a cracked tooth, fractured root, or external root
 ;;resorption.  Other separate procedures including, but not limited to, D3450, D3920, D4263, D4265, D4266,
 ;;D4267 and D7140 may be required concurrent to D4240.
 ;;D4260^119^osseous surgery (including flap entry and closure) - four or more contiguous teeth or bounded teeth spaces per quadrant^
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar process to achieve a more
 ;;physiologic form.  This may include the removal of supporting bone (ostectomy) and/or non-supporting bone
 ;;(osteoplasty).  Other separate procedures including, but not limited to, D3450, D3920, D4263, D4264, D4265,
 ;;D4266, D4267, D6010 and D7140 may be required concurrent to D4260.
 ;;D4261^119^osseous surgery (including flap entry and closure) - one to three contiguous teeth or bounded teeth spaces per quadrant^
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar process to achieve a more
 ;;physiologic form.  This may include the removal of supporting bone (ostectomy) and/or non-supporting bone(osteoplasty).
 ;;Other separate procedures including, but not limited to, D3450, D3920, D4263, D4264, D4265, D4266, D4267,
 ;;D6010 and D7140 may be required concurrent to D4260.
 ;;D4263^47^bone replacement graft - first site in quadrant^
 ;;This procedure involves the use of osseous autografts, osseous allografts, or non-osseous grafts to stimulate
 ;;periodontal regeneration when the disease process has led to a deformity of the bone.  This procedure
 ;;does not include flap entry and closure, wound debridement, osseous contouring, or the placement of biologic
 ;;materials to aid in osseous tissue regeneration of barrier membranes,  including, but not limited to,
 ;;D4240, D4241, D4260, and D4261, D4265, D4266 and D4267.   Definition for the term “site” precedes code
 ;;D4210. This procedure involves the use of osseous autografts, osseous allografts, or non-osseous grafts
 ;;to stimulate periodontal regeneration when the disease process has led to a deformity of the bone.  This
 ;;procedure does not include flap entry and closure, wound debridement, osseous contouring, or the placement
 ;;of biologic materials to aid in osseous tissue regeneration of barrier membranes,  including, but not
 ;;limited to, D4240, D4241, D4260, and D4261, D4265, D4266 and D4267.   Definition for the term “site” precedes
 ;;code D4210.
 ;;D4265 ^65^biologic materials to aid in soft and osseous tissue regeneration^
 ;;Biologic materials may be used alone or with other regenerative substrates such as bone and barrier membranes,
 ;;depending upon their formulation and the presentation of the periodontal defect.  This procedure does
 ;;not include surgical entry and closure, wound debridement, osseous contouring, or the placement of graft
 ;;materials and/or barrier membranes, including, but not limited to D4240, D4241, D4260, D4261, D4263, D4264,
 ;;D4266, and D4267.
 ;;D4273^59^subepithelial connective tissue graft procedures, per tooth^
 ;;This procedure is performed to create or augment gingiva, to obtain root coverage to eliminate sensitivity
 ;;and to prevent root caries, to eliminate frenum pull, to extend the vestibular fornix, to augment collapsed
 ;;ridges, to provide an adequate gingival interface with a restoration or to cover bone or ridge regeneration
 ;;sites when adequate gingival tissues are not available for effective closure.  There are two surgical
 ;;sites.  The recipient site utilizes a split thickness incision, retaining the overlying flap of gingiva
 ;;and/or mucosa.  The connective tissue is dissected from the donor site leaving an epithelialized flap
 ;;for closure.  After the graft is placed on the recipient site, it is covered with the retained overlying
 ;;flap.
 ;;D4276^62^combined connective tissue and double pedicle graft, per tooth^
 ;;Advanced gingival recession often cannot be corrected with a single procedure.  Combined tissue grafting
 ;;procedures are needed to achieve the desired outcome.
 ;;D4341^70^periodontal scaling and root planing - four or more teeth per quadrant^
 ;;This procedure involves instrumentation of the crown and root surfaces of the teeth to remove plaque and
 ;;calculus from these surfaces.  It is indicated for patients with periodontal disease and is therapeutic,
 ;;not prophylactic, in nature.  Root planing is the definitive procedure designed for the removal of cementum
 ;;and dentin that is rough, and/or permeated by calculus or contaminated with toxins or microorganisms.
 ;;Some soft tissue removal occurs.  This procedure may be used as a definitive treatment in some stages
 ;;of periodontal disease and/or as a part of pre-surgical procedures in others.
 ;;D4355^71^full mouth debridement to enable comprehensive evaluation and diagnosis^
 ;;The gross removal of plaque and calculus that interfere with the ability of the dentist to perform a comprehensive
 ;;oral evaluation.  This preliminary procedure does not preclude the need for additional procedures.
 ;;D4381^129^localized delivery of antimicrobial agents via a controlled release vehicle into diseased crevicular tissue, per tooth, by report^
 ;;FDA approved subgingival  delivery devices containing antimicrobial medication(s) are inserted into  periodontal
 ;;pockets to suppress the pathogenic microbiota.  These devices slowly release the pharmacological agents
 ;;so they can remain at the intended site of action in a therapeutic concentration for a sufficient length
 ;;of time.
 ;;
 ;;***END***
