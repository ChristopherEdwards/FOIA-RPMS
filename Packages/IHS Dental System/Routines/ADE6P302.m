ADE6P302 ;IHS/OIT/GAB - ADE6.0 PATCH 30 [ 11/17/2013  8:37 AM ]
 ;;6.0;ADE*6.0*30;;March 25, 1999;Build 19
 ;;ADA Code Update
 ;;Modification of ADA-CDT Codes
MODCDT5 ;EP
 D UPDATE^ADEUPD30(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P302","SETX^ADE6P302")
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
MODADA ;  Code^^Nomenclature    /   Descriptor on next line
 ;;D0250^^extra-oral - 2D projection radiographic image created using a stationary radiation source, and detector
 ;;These images include, but are not limited to: Lateral Skull;
 ;;Posterior-Anterior Skull; Submentovertex; Waters; Reverse Tomes;
 ;;Oblique Mandibular Body; Lateral Ramus.
 ;;D0340^^2D cephalometric radiographic image - acquisition, measurement and analysis
 ;;Image of the head made using a cephalostat to standardize
 ;;anatomic positioning, and with reproducible x-ray beam geometry.
 ;;D4273^^autogenous connective tissue graft procedure (including donor and recipient surgical sites) first tooth, implant, or edentulous tooth position in graft
 ;;There are two surgical sites.  The recipient site utilizes
 ;;a split thickness incision, retaining the overlapping flap of
 ;;gingiva and/or mucosa.  The connective tissue is dissected from
 ;;a separate donor site leaving an epithelialized flap for closure.
 ;;D4275^^non-autogenous connective tissue graft (including recipient site and donor material) first tooth, implant, or edentulous tooth position in graft
 ;;There is only a recipient surgical site utilizing split thickness
 ;;incision, retaining the overlaying flap of gingiva and/or mucosa.
 ;;A donor surgical site is not present.
 ;;D4277^^free soft tissue graft procedure (including recipient and donor surgical sites) first tooth, implant or edentulous tooth position in graft
 ;;D4278^^free soft tissue graft procedure (including recipient and donor surgical sites) each additional contiguous tooth, implant or edentulous tooth position in same graft site
 ;;Used in conjunction with D4277.
 ;;D5130^^immediate denture - maxillary
 ;;Includes limited follow-up care only; does not include required
 ;;future rebasing / relining procedure(s).
 ;;D5140^^immediate denture - mandibular
 ;;Includes limited follow-up care only; does not include required
 ;;future rebasing / relining procedure(s).
 ;;D5630^^repair or replace broken clasp - per tooth
 ;;D5660^^add clasp to existing partial denture - per tooth
 ;;D5875^^modification of removable prosthesis following implant surgery
 ;;Attachment assemblies are reported using separate codes.
 ;;D9248^^non-intravenous conscious sedation
 ;;This includes non-IV minimal and moderate sedation.
 ;;A medically controlled state of depressed consciousness while 
 ;;maintaining the patients airway, protective reflexes and the
 ;;ability to respond to stimulation or verbal commands. It includes
 ;;non-intravenous administration of sedative and/or analgesic agent(s)
 ;;and appropriate monitoring.
 ;;The level of anesthesia is determined by the anesthesia providers 
 ;;documentation of the anesthetics effects upon the central nervous
 ;;system and not dependent upon the route of administration.
 ;;D1999^^
 ;;Used for procedure that is not adequately described by another CDT Code.
 ;;Describe procedure.
 ;;D2712^^crown - 3/4 resin-based composite (indirect)
 ;;This procedure does not include facial veneers.
 ;;D2783^^crown - 3/4 porcelain/ceramic
 ;;This procedure does not include facial veneers.
 ;;D5993^^maintenance and cleaning of a maxillofacial prosthesis (extra- or intra-oral) other than required adjustments, by report
 ;;D6103^^bone graft for repair of peri-implant defect - does not include flap entry and closure
 ;;Placement of a barrier membrane or biologic materials to aid in osseous regeneration, are reported separately.
 ;;D6600^^retainer inlay - porcelain/ceramic, two surfaces
 ;;D6601^^retainer inlay - porcelain/ceramic, three or more surfaces
 ;;D6602^^retainer inlay - cast high noble metal, two surfaces
 ;;D6603^^retainer inlay - cast high noble metal, three or more surfaces
 ;;D6604^^retainer inlay - cast predominantly base metal, two surfaces
 ;;D6605^^retainer inlay - cast predominantly base metal, three or more surfaces
 ;;D6606^^retainer inlay - cast noble metal, two surfaces
 ;;D6607^^retainer inlay - cast noble metal, three or more surfaces
 ;;D6608^^retainer onlay - porcelain/ceramic, two surfaces
 ;;D6609^^retainer onlay - porcelain/ceramic, three or more surfaces
 ;;D6610^^retainer onlay - cast high noble metal, two surfaces
 ;;D6611^^retainer onlay - cast high noble metal, three or more surfaces
 ;;D6612^^retainer onlay - cast predominantly base metal, two surfaces
 ;;D6613^^retainer onlay - cast predominantly base metal, three or more surfaces
 ;;D6614^^retainer onlay - cast noble metal, two surfaces
 ;;D6615^^retainer onlay - cast noble metal, three or more surfaces
 ;;D6624^^retainer inlay - titanium
 ;;D6634^^retainer onlay - titanium
 ;;D6710^^retainer crown - indirect resin based composite  
 ;;Not to be used as a temporary or provisional prosthesis.
 ;;D6720^^retainer crown - resin with high noble metal
 ;;D6721^^retainer crown - resin with predominantly base metal
 ;;D6722^^retainer crown - resin with noble metal
 ;;D6740^^retainer crown - porcelain/ceramic
 ;;D6750^^retainer crown - porcelain fused to high noble metal
 ;;D6751^^retainer crown - porcelain fused to predominantly base metal
 ;;D6752^^retainer crown - porcelain fused to noble metal
 ;;D6780^^retainer crown - 3/4 cast high noble metal
 ;;D6781^^retainer crown - 3/4 cast predominantly base metal
 ;;D6782^^retainer crown - 3/4 cast noble metal
 ;;D6783^^retainer crown - 3/4 porcelain/ceramic
 ;;D6790^^retainer crown - full cast high noble metal
 ;;D6791^^retainer crown - full cast predominantly base metal
 ;;D6792^^retainer crown - full cast noble metal
 ;;D6794^^retainer crown - titanium
 ;;***END***
