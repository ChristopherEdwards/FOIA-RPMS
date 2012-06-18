ADE6P161 ; IHS/OIT/MJL - ADE6.0 PATCH 16 ; 
 ;;6.0;ADE;**16**;JUL 28, 2005
 ;
ADDCDT5 ;EP
 D UPDATE^ADEUPD(9999999.31,".01,.05,501,,,.02,.06,.09",1101,"?+1,","ADDADA^ADE6P161","SETX^ADE6P161")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;
 ;;D0416^9^0.60^D0415^13^viral culture^VC^
 ;;A diagnostic test to identify viral organisms, most often herpes virus.
 ;;D0421^9^0.00^^48^genetic test for susceptibility to oral diseases^GT^n
 ;;Sample collection for the purpose of certified laboratory analysis to detect specific genetic variations
 ;;associated with increased susceptibility for oral diseases such as severe periodontal disease.
 ;;D0431^1^1.30^D7286^31^adjunctive pre-diagnostic test ^PDXTEST^
 ;;
 ;;D0475^9^0.00^^25^decalcification procedure^DECALC^
 ;;Procedure in which hard tissue is processed in order to allow sectioning and subsequent microscopic examination.
 ;;D0476^9^0.00^^33^special stains for microorganisms^SSMICRO^n
 ;;Procedure in which additional stains are applied to biopsy or surgical specimen in order to identify microorganisms.
 ;;D0477^9^0.00^^38^special stains, not for microorganisms^SSNMICRO^n
 ;;Procedure in which additional stains are applied to a biopsy or surgical specimen in order to identify
 ;;such things as melanin, mucin, iron, glycogen, etc.
 ;;D0478^9^0.00^^26^immunohistochemical stains^IMHS^n
 ;;A procedure in which specific antibody based reagents are applied to tissue samples in order to facilitate
 ;;diagnosis. A procedure in which specific antibody based reagents are applied to tissue samples in order
 ;;to facilitate diagnosis.
 ;;D0479^9^0.00^^54^tissue in-situ hybridization, including interpretation^TISH^
 ;;A procedure which allows for the identification of nucleic acids, DNA and RNA, in the tissue sample in
 ;;order to aid in the diagnosis of microorganisms and tumors.
 ;;D0481^9^0.00^^32^electron microscopy - diagnostic^EMDX^
 ;;An extreme high magnification diagnostic procedure that enables identification of cell components and
 ;;microorganisms that are otherwise not identifiable under light microscopy.
 ;;D0482^9^0.00^^25^direct immunofluorescence^DIMF^n
 ;;A technique used to identify immunoreactants which are localized to the patient's skin or mucous membranes.
 ;;D0483^9^0.00^^27^indirect immunofluorescence^IIMF^n
 ;;A technique used to identify circulating immunoreactants.
 ;;D0484^9^0.00^^41^consultation on slides prepared elsewhere^SLCON^
 ;;A service provided in which microscopic slides of a biopsy specimen prepared at another laboratory are
 ;;evaluated to aid in the diagnosis of a difficult case or to offer a consultative opinion at the patient's
 ;;request.  The findings are delivered by written report.
 ;;D0485^9^0.00^^95^consultation, including preparation of slides from biopsy material supplied by referring source^BIOPCON^
 ;;A service that requires the consulting pathologist to prepare the slides as well as render a written report.
 ;;The slides are evaluated to aid in the diagnosis of a difficult case or to offer a consultative opinion
 ;;at the patient's request.
 ;;D2712^9^6.78^D2710^42^crown - 3/4 resin-based composite (indirect)^CRN 3/4 RES^
 ;;This code does not include facial veneers.
 ;;D2794^4^7.67^D2790^16^crown - titanium^CRN TI^
 ;;
 ;;D2915^1^1.00^D2920^44^recement cast or prefabricated post and core^REC P&C^
 ;;
 ;;D2934^3^2.00^D2930^67^prefabricated esthetic coated stainless steel crown - primary tooth^SSC PF PRI^
 ;;Stainless steel primary crown with exterior esthetic coating.
 ;;D2971^5^0.53^D2999^85^additional procedures to construct new crown under existing partial denture framework^CRNRPD^
 ;;To be reported in addition to a crown code.
 ;;D2975^4^7.67^D2790^6^coping^COP^
 ;;A thin covering of the remaining portion of a tooth, usually fabricated of metal and devoid of anatomic
 ;;contour.  This is to be used as a definitive restoration.
 ;;D5225^9^10.00^D5213^81^maxillary partial denture - flexible base (including any clasps, rests and teeth)^FLEX RPD MX^
 ;;
 ;;D5226^9^10.00^D5214^82^mandibular partial denture - flexible base (including any clasps, rests and teeth)^FLEX RPD MD^
 ;;
 ;;D6094^5^27.92^D6067^37^abutment supported crown - (titanium)^AB SUP CRN TI^
 ;;A single  restoration that is retained, supported and stabilized by an abutment on an implant.  May be
 ;;cast or milled and is screw retained or cemented.
 ;;D6194^5^27.92^D6067^54^abutment supported retainer crown for FPD - (titanium)^AB SUP RET TI^
 ;;A retainer for a fixed partial denture that gains retention, support and stability from an abutment on
 ;;an implant.  May be cast or milled and is screw retained or cemented.
 ;;D6190^5^11.95^D5988^46^radiographic/surgical implant index, by report^RSIMP^
 ;;An appliance, designed to relate osteotomy or fixture position to existing anatomic structures, to be
 ;;utilized during radiographic exposure for treatment planning and/or during osteotomy creation for fixture
 ;;installation. An appliance, designed to relate osteotomy or fixture position to existing anatomic structures,
 ;;to be utilized during radiographic exposure for treatment planning and/or during osteotomy creation for
 ;;fixture installation.
 ;;D6205^9^2.79^D6253^39^pontic - indirect resin based composite^PON ID RES^
 ;;Not to be used as a temporary or provisional prosthesis.
 ;;D6214^5^22.23^D6210^17^pontic - titanium^PON TI^
 ;;
 ;;D6624^5^11.05^D6603^16^inlay - titanium^INLAY TI^
 ;;
 ;;D6634^5^11.84^D6611^16^onlay - titanium^ONLYA TI^
 ;;
 ;;D6710^9^18.98^D6792^40^crown - indirect resin based composite  ^CRN ID RES^
 ;;Not to be used as a temporary or provisional prosthesis.
 ;;D6794^5^21.22^D6790^16^crown - titanium^CRN TI^
 ;;
 ;;D7283^5^1.63^^60^placement of device to facilitate eruption of impacted tooth^ERUP DEV^
 ;;Placement of an orthodontic bracket, band or other device on an unerupted tooth, after its exposure, to
 ;;aid in its eruption.  Report the surgical exposure separately using D7280.
 ;;D7288^1^0.17^D7287^48^brush biopsy - transepithelial sample collection^BB^
 ;;For collection of oral disaggregated transepithelial cells via rotational brushing of the oral mucosa.
 ;;D7311^4^3.59^^96^alveoloplasty in conjunction with extractions - one to three teeth or tooth spaces, per quadrant^ALV W/EXT 1-3^
 ;;The alveoloplasty is distinct (separate procedure) from extractions and/or surgical extractions.
 ;;D7321^4^5.22^^100^alveoloplasty not in conjunction with extractions - one to three teeth or tooth spaces, per quadrant^ALV W/O EXT 1-3^
 ;;
 ;;D7511^1^2.48^D7510^117^incision and drainage of abscess - intraoral soft tissue - complicated (includes drainage of multiple fascial spaces)^ID IO^
 ;;Incision is made intraorally and dissection is extended into adjacent fascial space(s) to provide adequate
 ;;drainage of abscess/cellulitis.
 ;;D7521^1^6.70^D7520^118^incision and drainage of abscess - extraoral soft tissue - complicated (includes drainage of multiple fascial spaces) ^ID EO^
 ;;Incision is made extraorally and dissection is extended into adjacent fascial space(s) to provide adequate
 ;;drainage of abscess/cellulitis.
 ;;D7953^5^48.01^D7950^56^bone replacement graft for ridge preservation - per site^BRG^
 ;;Osseous autograft, allograft or non-osseous graft is placed in an extraction site to preserve ridge integrity
 ;;(e.g., clinically indicated in preparation for implant reconstruction or where alveolar contour is critical
 ;;to planned prosthetic reconstruction).  Membrane, if used should be reported separately.
 ;;D7963^5^6.70^D7960^13^frenuloplasty^FP^
 ;;Excision of frenum with accompanying excision or repositioning of aberrant muscle and z-plasty or other
 ;;local flap closure.
 ;;D9942^1^1.21^D5410^38^repair and/or reline of occlusal guard^REOC^
 ;;***END***
