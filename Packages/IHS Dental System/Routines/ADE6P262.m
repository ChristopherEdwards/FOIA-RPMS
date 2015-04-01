ADE6P262 ;IHS/OIT/GAB - ADE6.0 PATCH 26 [ 10/17/2014  2:35 PM ]
 ;;6.0;ADE*6.0*26;;March 25, 1999;Build 13
 ;;ADA Code Update
 ;;Modification of Code
MODCDT5 ;EP
 D UPDATE^ADEUPD26(9999999.31,".01,.05,.02",1101,"?+1,","MODADA^ADE6P262","SETX^ADE6P262")
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
 ;;D2392^3^RESIN-BASED COMPOSITE - TWO SURFACES, POSTERIOR
 ;;D2393^4^RESIN-BASED COMPOSITE - THREE SURFACES, POSTERIOR
 ;;D2394^5^RESIN-BASED COMPOSITE - FOUR OR MORE SURFACES, POSTERIOR
 ;;D0350^^2D oral/facial photographic image obtained intra-orally or extra-orally
 ;;D0481^^electron microscopy
 ;;D1208^^topical application of fluoride - excluding varnish
 ;;D1550^^re-cement or re-bond space maintainer
 ;;D2910^^re-cement or re-bond inlay, onlay, veneer or partial coverage restoration
 ;;D2915^^re-cement or re-bond indirectly fabricated or prefabricated post and core
 ;;D2920^^re-cement or re-bond crown
 ;;D2975^^coping
 ;;A thin covering of the coronal portion of a tooth, usually devoid of anatomic contour, that can be used as a definitive restoration.
 ;;D3351^^apexification/recalcification - initial visit (apical closure/calcific repair of perforations, root resorption, etc.)
 ;;Includes opening tooth, preparation of canal spaces, first placement of medication and necessary radiographs. (This procedure may 
 ;;include first phase of complete root canal therapy.)
 ;;D4249^^clinical crown lengthening - hard tissue
 ;;This procedure is employed to allow a restorative procedure on a tooth with little or no tooth structure exposed to the oral cavity.  
 ;;Crown lengthening requires reflection of a full thickness flap and removal of bone, altering the crown to root ratio.  It is performed 
 ;;in a healthy periodontal environment, as opposed to osseous surgery, which is performed in the presence of periodontal disease.
 ;;D4260^^osseous surgery (including elevation of a full thickness flap and closure) ? four or more contiguous teeth or tooth bounded spaces per quadrant
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar process to achieve a more physiologic form during the surgical procedure.  
 ;;This must include the removal of supporting bone (ostectomy) and/or non-supporting bone (osteoplasty).  Other procedures may be required 
 ;;concurrent to D4260 and should be reported using their own unique codes.
 ;;D4261^^osseous surgery (including elevation of a full thickness flap and closure) ? one to three contiguous teeth or tooth bounded spaces per quadrant
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar process to achieve a more physiologic form during the surgical procedure.
 ;;This must include the removal of supporting bone (ostectomy) and/or non-supporting bone (osteoplasty).  Other procedures may be required concurrent to D4261 
 ;;and should be reported using their own unique codes.
 ;;D6058^^abutment supported porcelain/ceramic crown 
 ;;A single crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6059^^abutment supported porcelain fused to metal crown (high noble metal)
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6060^^abutment supported porcelain fused to metal crown (predominantly base metal)
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6061^^abutment supported porcelain fused to metal crown (noble metal)
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6062^^abutment supported cast metal crown (high noble metal)
 ;;A single cast metal crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6063^^abutment supported cast metal crown (predominantly base metal)
 ;;A single cast metal crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6064^^abutment supported cast metal crown (noble metal)
 ;;A single cast metal crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6065^^implant supported porcelain/ceramic crown
 ;;A single crown restoration that is retained, supported and stabilized by an implant.
 ;;D6066^^implant supported porcelain fused to metal crown (titanium, titanium alloy, high noble metal)
 ;;A single metal-ceramic  crown restoration that is retained, supported and stabilized by an implant.
 ;;D6067^^implant supported metal crown (titanium, titanium alloy, high noble metal)
 ;;A single cast metal or milled crown restoration that is retained, supported and stabilized by an implant.
 ;;D6068^^abutment supported retainer for porcelain/ceramic FPD
 ;;A ceramic retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6069^^abutment supported retainer for porcelain fused to metal FPD (high noble metal)
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6070^^abutment supported retainer for porcelain fused to metal FPD (predominantly base metal)
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6071^^abutment supported retainer for porcelain fused to metal FPD (noble metal)
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6072^^abutment supported retainer for cast metal FPD (high noble metal)
 ;;A cast metal retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6073^^abutment supported retainer for cast metal FPD (predominantly base metal)
 ;;A cast metal retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6074^^abutment supported retainer for cast metal FPD (noble metal)
 ;;A cast metal retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6075^^implant supported retainer for ceramic FPD
 ;;A ceramic retainer for a fixed partial denture that gains retention, support and stability from an implant.
 ;;D6076^^implant supported retainer for porcelain fused to metal FPD (titanium, titanium alloy, or high noble metal)
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support and stability from an implant.
 ;;D6077^^implant supported retainer for cast metal FPD (titanium, titanium alloy, or high noble metal)
 ;;A cast metal retainer for a fixed partial denture that gains retention, support and stability from an implant.
 ;;D6092^^re-cement or re-bond implant/abutment supported crown
 ;;D6093^^re-cement or re-bond implant/abutment supported fixed partial denture abutment supported crown - (titanium)
 ;;D6094^^abutment supported crown - (titanium)
 ;;A single crown restoration that is retained, supported and stabilized by an abutment on an implant. May be cast or milled.
 ;;D6101^^debridement of a peri-implant defect or defects surrounding a single implant, and surface cleaning of the exposed implant surfaces, including flap entry and closure
 ;;D6102^^debridement and osseous contouring of a peri-implant defect or defects surrounding a single implant and includes surface cleaning of the exposed implant surfaces, including flap entry and closure
 ;;D6103^^bone graft for repair of peri-implant defect ? does not include flap entry and closure.  Placement of a barrier membrane or biologic materials to aid in osseous regeneration are reported separately
 ;;D6194^^abutment supported retainer crown for FPD (titanium)
 ;;A retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant. May be cast or milled.
 ;;D6930^^re-cement or re-bond fixed partial denture
 ;;D7285^^incisional biopsy of oral tissue-hard (bone,tooth)
 ;;For partial removal of specimen only. This procedure involves biopsy of osseous lesions and is not used for apicoectomy/periradicular surgery.  This procedure does not entail an excision.
 ;;D7286^^incisional biopsy of oral tissue-soft
 ;;For partial removal of an architecturally intact specimen only.  This procedure is not used at the same time as codes for apicoectomy/periradicular curettage.  
 ;;This procedure does not entail an excision.
 ;;D7292^^surgical placement of temporary anchorage device [screw retained plate] requiring flap; includes device removal
 ;;D7293^^surgical placement of temporary anchorage device requiring flap; includes device removal
 ;;D7294^^surgical placement of temporary anchorage device without flap; includes device removal
 ;;D8660^^pre-orthodontic treatment examination to monitor growth and development
 ;;Periodic observation of patient dentition, at intervals established by the dentist, to determine when orthodontic treatment should begin.
 ;;Diagnostic procedures are documented separately.
 ;;D8670^^periodic orthodontic treatment visit
 ;;D8693^^re-cement or re-bond fixed retainer
 ;;D9221^^deep sedation/general anesthesia - each additional 15 minutes
 ;;D9241^^intravenous moderate (conscious) sedation/analgesia - first 30 minutes
 ;;Anesthesia time begins when the doctor administering the anesthetic agent initiates the appropriate anesthesia and non-invasive
 ;;monitoring protocol and remains in continuous attendance of the patient. Anesthesia services are considered completed when the patient may be safely left under the observation of trained personnel and the doctor may safely leave the room to attend to other patients or duties.
 ;;The level of anesthesia is determined by the anesthesia provider?s documentation of the anesthetic?s effects upon the central nervous system and not dependent upon the route of administration.
 ;;D9242^^intravenous moderate (conscious) sedation/analgesia ? each additional 15 minutes
 ;;D9248^^non-intravenous moderate (conscious) sedation
 ;;A medically controlled state of depressed consciousness while maintaining the patient?s airway, protective reflexes and the ability to respond to stimulation or verbal commands. 
 ;;It includes non-intravenous administration of sedative and/or analgesic agent(s) and appropriate monitoring.
 ;;The level of anesthesia is determined by the anesthesia provider?s documentation of the anesthetic?s effects upon the central nervous system and not dependent upon the route of administration.
 ;;***END***
