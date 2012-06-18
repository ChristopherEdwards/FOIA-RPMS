ADE6P182 ;IHS/OIT/ENM - ADE6.0 PATCH 18 [ 09/17/2008  2:35 PM ]
 ;;6.0;ADE;**18**;SEP 17, 2008
 ;
MODCDT5 ;EP
 D UPDATE^ADEUPD8(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P182","SETX^ADE6P182")
 D R7670FIX
 ;D UPDATE^ADEUPD8(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P183","SETX^ADE6P182")
 ;D MODEDT ;IHS/ENM NO NEED TO RUN THIS LINE IN P18
 Q
 ;
R7670FIX ;EDIT THE SYNONYM FIELD FOR ADA CODE 7670
 S ADEXR=0
 S ADEXR=$O(^AUTTADA("B",7670,ADEXR)) Q:ADEXR'>0
 S $P(^AUTTADA(ADEXR,0),"^",6)="ALVEO FX,CLOSED R"
 K ADEXR
 Q
MODEDT ;EP Modify DENTAL CODE EDIT GROUP and Reindex DENTAL EDIT file
 ;D UPDATE^ADEUPD8(9002007.91,".01,1",,"?+1,","EDITX^ADE6P182","SETEDX^ADE6P182")
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
 ;;D1203^39^topical application of fluoride - child^
 ;;D1204^39^topical application of fluoride - adult^
 ;;D3220^139^therapeutic pulpotomy (excluding final restoration) - removal of pulp coronal to the dentinocemental junction and application of medicament^
 ;;Pulpotomy is the surgical removal of a portion of the pulp with the aim of
 ;; maintaining the vitality of the remaining portion by means of an adequate
 ;; dressing.
 ;;D3310^64^endodontic therapy, anterior tooth (excluding final restoration)^
 ;;D3320^64^endodontic therapy, bicuspid tooth (excluding final restoration)^
 ;;D3330^55^endodontic therapy, molar (excluding final restoration)^
 ;;D3331^56^treatment of root canal obstruction; non-surgical access^
 ;;In lieu of surgery, the formation of a pathway to achieve an apical seal without
 ;; surgical intervention because of a non-negotiable root canal blocked by 
 ;;foreign bodies, including but not limited to separated instruments, broken 
 ;;posts or calcification of 50% or more of the length of the tooth root.
 ;;D4210^98^gingivectomy or gingivoplasty - four or more contiguous teeth or tooth bounded spaces per quadrant^
 ;;Involves the excision of the soft tissue wall of the periodontal pocket by either
 ;; an external or an internal bevel.  It is performed to eliminate suprabony 
 ;;pockets after adequate initial preparation, to allow access for restorative 
 ;;dentistry in the presence of suprabony pockets, or to restore normal 
 ;;architecture when gingival enlargements or asymmetrical or unaesthetic 
 ;;topography is evident with normal bony configuration.
 ;;D4211^98^gingivectomy or gingivoplasty - one to three contiguous teeth or tooth bounded spaces per quadrant^
 ;;Involves the excision of the soft tissue wall of the periodontal pocket by 
 ;;either an external or an internal bevel.  It is performed to eliminate suprabony
 ;;pockets after adequate initial preparation, to allow access for restorative 
 ;;dentistry in the presence of suprabony pockets, or to restore normal 
 ;;architecture when gingival enlargements or asymmetrical or unaesthetic 
 ;;topography is evident with normal bony configuration
 ;;D4240^116^gingival flap procedure, including root planing - four or more contiguous teeth or tooth bounded spaces per quadrant^
 ;;A soft tissue flap is reflected or resected to allow debridement of the root 
 ;;surface and the removal of granulation tissue.  Osseous recontouring is not 
 ;;accomplished in conjunction with this procedure.  May include open flap 
 ;;curettage, reverse bevel flap surgery, modified Kirkland flap procedure, and 
 ;;modified Widman surgery.  This procedure is performed in the presence of 
 ;;moderate to deep probing depths, loss of attachment, need to maintain 
 ;;esthetics, need for increased access to the root surface and alveolar bone, 
 ;;or to determine the presence of a cracked tooth, fractured root, or external 
 ;;root resorption.  Other procedures may be required concurrent to D4240 
 ;;and should be reported separately using their own unique codes
 ;;D4241^116^gingival flap procedure, including root planing - one to three contiguous teeth or tooth bounded spaces per quadrant^
 ;;A soft tissue flap is reflected or resected to allow debridement of the root 
 ;;surface and the removal of granulation tissue.  Osseous recontouring is not
 ;;accomplished in conjunction with this procedure.  May include open flap 
 ;;curettage, reverse bevel flap surgery, modified Kirkland flap procedure, and 
 ;;modified Widman surgery.  This procedure is performed in the presence of 
 ;;moderate to deep probing depths, loss of attachment, need to maintain 
 ;;esthetics, need for increased access to the root surface and alveolar bone, 
 ;;or to determine the presence of a cracked tooth, fractured root, or external 
 ;;root resorption.  Other procedures may be required concurrent to D4241 
 ;;and should be reported separately using their own unique codes.
 ;;D4260^119^osseous surgery (including flap entry and closure) - four or more contiguous teeth or tooth bounded spaces per quadrant^
 ;;This procedure modifies the bony support of the teeth by reshaping the 
 ;;alveolar process to achieve a more physiologic form.  This may include the 
 ;;removal of supporting bone (ostectomy) and/or non-supporting bone 
 ;;(osteoplasty).  Other procedures may be required concurrent to D4260 and 
 ;;should be reported using their own unique codes
 ;;D4261^119^osseous surgery (including flap entry and closure) - one to three contiguous teeth or tooth bounded spaces per quadrant^
 ;;This procedure modifies the bony support of the teeth by reshaping the alveolar
 ;; process to achieve a more physiologic form.  This may include the removal of 
 ;;supporting bone (ostectomy) and/or non-supporting bone (osteoplasty).  Other 
 ;;procedures may be required concurrent to D4261 and should be reported using 
 ;;their own unique codes.
 ;;D6067^74^implant supported metal crown (titanium, titanium alloy, high noble metal)^
 ;;A single cast metal or milled crown restoration that is retained, supported and 
 ;;stabilized by an implant; may be screw retained or cemented.
 ;;D7310^96^alveoloplasty in conjunction with extractions – four or more teeth or tooth spaces, per quadrant^
 ;;The alveoloplasty is distinct (separate procedure) from extractions and/or 
 ;;surgical extractions.  Usually in preparation for a prosthesis or other 
 ;;treatments such as radiation therapy and transplant surgery.
 ;;D7311^96^alveoloplasty in conjunction with extractions - one to three teeth or tooth spaces, per quadrant^
 ;;The alveoloplasty is distinct (separate procedure) from extractions and/or 
 ;;surgical extractions.  Usually in preparation for a prosthesis or other 
 ;;treatments such as radiation therapy and transplant surgery.
 ;;D7320^99^alveoloplasty not in conjunction with extractions –four or more teeth or tooth spaces, per quadrant^
 ;;No extractions performed in an edentulous area.  See D7310 if teeth are 
 ;;being extracted concurrently with the alveoloplasty.  Usually in 
 ;;preparation for a prosthesis or other treatments such as radiation therapy 
 ;;and transplant surgery.
 ;;D7321^99^alveoloplasty not in conjunction with extractions - one to three teeth or tooth spaces, per quadrant^
 ;;No extractions performed in an edentulous area.  See D7311 if teeth are 
 ;;being extracted concurrently with the alveoloplasty.  Usually in preparation 
 ;;for a prosthesis or other treatments such as radiation therapy and 
 ;;transplant surgery
 ;;D9220^51^deep sedation/general anesthesia - first 30 minutes^
 ;;Anesthesia time begins when the doctor administering the anesthetic agent 
 ;;initiates the appropriate anesthesia and non-invasive monitoring protocol and 
 ;;remains in continuous attendance of the patient.  Anesthesia services are 
 ;;considered completed when the patient may be safely left under the 
 ;;observation of trained personnel and the doctor may safely leave the room to 
 ;;attend to other patients or duties.
 ;;D9221^61^deep sedation/general anesthesia - each additional 15 minutes ^
 ;;Anesthesia time begins when the doctor administering the anesthetic agent 
 ;;initiates the appropriate anesthesia and non-invasive monitoring protocol and 
 ;;remains in continuous attendance of the patient.  Anesthesia services are 
 ;;considered completed when the patient may be safely left under the 
 ;;observation of trained personnel and the doctor may safely leave the room 
 ;;to attend to other patients or duties.
 ;;D9241^59^intravenous conscious sedation/analgesia - first 30 minutes^
 ;;Anesthesia time begins when the doctor administering the anesthetic agent 
 ;;initiates the appropriate anesthesia and non-invasive monitoring protocol and 
 ;;remains in continuous attendance of the patient.  Anesthesia services are 
 ;;considered completed when the patient may be safely left under the observation 
 ;;of trained personnel and the doctor may safely leave the room to attend to 
 ;;other patients or duties.
 ;;D9242^69^intravenous conscious sedation/analgesia - each additional 15 minutes^
 ;;Anesthesia time begins when the doctor administering the anesthetic agent 
 ;;initiates the appropriate anesthesia and non-invasive monitoring protocol and 
 ;;remains in continuous attendance of the patient.  Anesthesia services are 
 ;;considered completed when the patient may be safely left under the 
 ;;observation of trained personnel and the doctor may safely leave the room 
 ;;to attend to other patients or duties.
 ;;D9248^34^non-intravenous conscious sedation^
 ;;A medically controlled state of depressed consciousness while maintaining 
 ;;the patient's airway, protective reflexes and the ability to respond to 
 ;;stimulation or verbal commands.  It includes non-intravenous administration 
 ;;of sedative and/or analgesic agent(s) and appropriate monitoring.
 ;;***END***
 
