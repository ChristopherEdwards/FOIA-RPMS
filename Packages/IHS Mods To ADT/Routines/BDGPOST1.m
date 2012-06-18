BDGPOST1 ; IHS/ANMC/LJF - PIMS POSTINIT ;  [ 01/22/2004  3:56 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ; post init code called by BDGPOST
 ;
 Q
 ;
PCCLINK ;EP; add primary facility to PCC Master Control file
 D BMES^XPDUTL("Adding PIMS to PCC Master Control file...")
 NEW DIV,FAC,PKG
 S DIV=$P($G(^DG(43,1,"GL")),U,3) Q:'DIV       ;no primary division
 S FAC=$P($G(^DG(40.8,+DIV,0)),U,7) Q:'FAC  ;no facility pointer
 Q:'$D(^APCCCTRL(FAC,0))                    ;not in PCC Master file
 S PKG=$O(^DIC(9.4,"C","PIMS",0)) Q:'PKG    ;no PIMS pkg on file
 Q:$D(^APCCCTRL(FAC,11,PKG,0))              ;already in PCC file
 ;
 NEW DIC,X,DD,DO,DLAYGO,DINUM,Y,DIE,DA,DR
 S DIC="^APCCCTRL("_FAC_",11,",X="PIMS",DINUM=PKG,DIC(0)="L"
 S DLAYGO=9001000.011,DIC("P")="9001000.011PA"
 D FILE^DICN Q:Y<1
 ;
 S DIE="^APCCCTRL("_FAC_",11,",DA=PKG,DA(1)=FAC
 S DR=".02///"_$S($P($G(^DG(43,1,9999999)),U,2)="Y":1,1:0)
 D ^DIE
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
PARAM ;EP; copy ADT parameters from file 43 to 9009020.1
 ; old data to stay until future patch
 ; Copies only if site has parameters set already
 ;
 D BMES^XPDUTL("Copying IHS ADT Parameter fields to new file...")
 ;
 NEW DIV,DATA,I,DIK
 S DIV=$P($G(^DG(43,1,"GL")),U,3) Q:'DIV       ;no primary division
 Q:$D(^BDGPAR(DIV,0))                          ;already set up
 ;
 S ^BDGPAR(DIV,0)=DIV,$P(^BDGPAR(0),U,3)=DIV
 S $P(^BDGPAR(0),U,4)=$P(^BDGPAR(0),U,4)+1
 ;
 S DATA=$G(^DG(43,1,9999999)) I DATA]"" D
 . F I="5;5","6;2" S $P(^BDGPAR(DIV,0),U,$P(I,";",2))=$P(DATA,U,+I)
 ;
 S DATA=$G(^DG(43,1,9999999.01)) I DATA]"" D
 . F I="1;10","2;1","3;2","4;3","5;4","6;6","7;8" D
 .. S $P(^BDGPAR(DIV,1),U,$P(I,";",2))=$P(DATA,U,+I)
 ;
 S DATA=$G(^DG(43,1,9999999.02)) I DATA]"" D
 . F I="1;5;1","2;7;1","3;12;0","4;8;0" D
 .. S $P(^BDGPAR(DIV,$P(I,";",3)),U,$P(I,";",2))=$P(DATA,U,+I)
 ;
 ;IHS/ITSC/LJF 1/9/2004 convert Y/N answers to 1/0 answers
 S DATA=$G(^BDGPAR(DIV,1)) I DATA]"" F I=1:1:14 D  S ^BDGPAR(DIV,1)=DATA
 . I $P(DATA,U,I)="Y" S $P(DATA,U,I)=1
 . I $P(DATA,U,I)="N" S $P(DATA,U,I)=0
 ;
 ;IHS/ITSC/WAR 6/18/03 - Added code to update the 'VERSION' node in
 ;   DG(43,  This uses the 'C' xref in the pkg file.
 S DATA=$$VERSION^XPDUTL("PIMS") I DATA]"" D
 . S ^DG(43,1,"VERSION")=DATA
 ;
 S DIK="^BDGPAR(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
 ;IHS/ITSC/WAR 10/17/03 added - updates the ADT ver# in pkg file
 ;IHS/ITSC/LJF 1/16/2004 added more updates
PKGFILE ;EP
 NEW VER,BDGV,BDGN,X,DA,DIC,Y,DIE,DR
 I $D(XPDNM) S VER=$$VER^XPDUTL(XPDNM)
 I $G(VER)]"" D
 .; update current version field
 .S BDGN=$O(^DIC(9.4,"C","DG",0)) Q:'BDGN
 .S ^DIC(9.4,BDGN,"VERSION")=VER
 .;
 .; clean up old 5.3 test versions
 .S BDGV=0 F  S BDGV=$O(^DIC(9.4,BDGN,22,"B",BDGV)) Q:BDGV=""  D
 ..I BDGV["5.3",BDGV'=5.3 D
 ...S DIE="^DIC(9.4,"_BDGN_",22,",DA(1)=BDGN,DR=".01///@"
 ...S DA=$O(^DIC(9.4,BDGN,22,"B",BDGV,0)) Q:'DA
 ...D ^DIE
 .;
 .; now add version multiple without test version #
 .S DIC="^DIC(9.4,"_BDGN_",22,",DIC(0)="L",X=5.3
 .S DIC("P")=$P(^DD(9.4,22,0),U,2)
 .S DIC("DR")="2///"_DT_";3///`"_DUZ,DA(1)=BDGN
 .D ^DIC
 ;
 D PATCHES^BDGPOST5   ;add patch history
 Q
CHRTDEF ;EP; copy chart deficiency items to new file   
 ; ^ADGCD( -> ^BDGCD(  will keep old data until future patch
 ;
 Q:$O(^BDGCD(0))               ;already has data
 ;
 D BMES^XPDUTL("Copying Chart Deficiency entries to new file...")
 NEW IEN,DIK
 S IEN=0 F  S IEN=$O(^ADGCD(IEN)) Q:'IEN  D
 . Q:$G(^ADGCD(IEN,0))=""     ;bad entry
 . S ^BDGCD(IEN,0)=^ADGCD(IEN,0)
 ;
 ; set zero node of file
 S $P(^BDGCD(0),U,3,4)=$P(^ADGCD(0),U,3,4)
 ; index file
 S DIK="^BDGCD(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
OLDFILES ;EP; change name of old files where new file uses same name
 D BMES^XPDUTL("Changing name of obsolete files...")
 NEW DIE,DA,DR,X
 S DIE="^DIC("
 F DA=9009011,9009011.5,9009013,9009013.1,9009013.5,9009015 D
 . S X=$P($G(^DIC(DA,0)),U) Q:X=""  Q:X["-OLD"
 . S DR=".01///"_X_"-OLD"
 . D ^DIE
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
ADTTMPL ;EP; edit ADT Template entries that could not pass via KIDS
 D BMES^XPDUTL("Fixing ADT Template entries...")
 NEW DGEDIT,DA,DIE,DR
 S DGEDIT="",DIE=43.7
 S DA=2,DR="6///DG SI LIST" D ^DIE
 S DA=3,DR="6///DG FEMALE INPATIENTS" D ^DIE
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
FACMOV ;EP; add new facility movement type (WARD TRANSFER ONLY)
 ; used when adding ward transfers non-interactively
 Q:$D(^DG(405.1,"B","WARD TRANSFER ONLY"))
 D BMES^XPDUTL("Adding WARD TRANSFER ONLY to file 405.1...")
 NEW DIC,DD,DO,X,DLAYGO,DA,Y
 S DIC="^DG(405.1,",X="WARD TRANSFER ONLY",DIC(0)="L",DLAYGO=405.1
 S DIC("DR")=".02///2;.03///INTERWARD TRANSFER;.04///1;.05///0"
 D FILE^DICN K DIC
 I Y<1 K X S X=$$REPEAT^XLFSTR(" ",10)_"Error adding to file 405.1." D MES^XPDUTL(.X) Q
 ;
 S DIC="^DG(405.1,"_(+Y)_",""F"",",DA(1)=+Y,DIC(0)="L",DLAYGO=405.11
 S DIC("P")="405.11PA"
 F BDG=1:1:8 S X=$P($T(MOV+BDG),";;",2) D ^DIC
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
MOV ;;
 ;;DIRECT;;
 ;;TRANS-NON IHS HOSPITAL;;
 ;;TRANS-IHS HOSPITAL;;
 ;;REFERRED FROM IHS CLINIC;;
 ;;OTHER;;
 ;;PROVIDER/SPECIALTY CHANGE;;
 ;;INTERWARD TRANSFER;;
 ;;WARD TRANSFER ONLY;;
 ;
 ;
TRSPEC ;EP; add treating specialty entries
 ;  1. add inpatient ones if not in file
 ;  2. add observation ones
 D BMES^XPDUTL("Adding Observation Treating Specialties...")
 NEW IEN,CODE
 S (DIC,DLAYGO)=45.7,DIC(0)="L"
 F BDGI=1:1:41 S CODE=$P($T(TS+BDGI),";;",2) D
 . I $O(^DIC(45.7,"CIHS",CODE,0)) Q    ;already has service
 . K DD,DO S X=$P($T(TS+BDGI),";;",3),ABBRV=$P($T(TS+BDGI),";;",4)
 . S DIC("DR")="9999999.01///"_CODE_";99///"_ABBRV D FILE^DICN
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
TS ;; Inpatient Treating Specialties
 ;;01;;DENTAL;;DEN;;
 ;;02;;OTOLARYNGOLOGY;;ENT;;
 ;;03;;GENERAL MEDICINE;;GMED;;
 ;;04;;GENERAL SURGERY;;SUR;;
 ;;05;;GYNECOLOGY;;GYN;;
 ;;06;;INTERNAL MEDICINE;;IMED;;
 ;;07;;NEWBORN;;NEW;;
 ;;08;;OBSTETRICS;;OB;;
 ;;09;;OPHTHALMOLOGY;;EYE;;
 ;;10;;ORTHOPEDICS;;ORTHO;;
 ;;11;;PEDIATRICS;;PEDS;;
 ;;12;;PSYCHIATRIC MENTAL HEALTH;;PSYCH;;
 ;;13;;TUBERCULOSIS;;TB;;
 ;;14;;OTHER;;OTHER;;
 ;;15;;ALCOHOL/SUBSTANCE ABUSE;;ALCOH;;
 ;;16;;PLASTIC SURGERY;;PSUR;;
 ;;17;;FAMILY PRACTICE;;FAMP;;
 ;;18;;UROLOGY;;URO;;
 ;;19;;PODIATRY;;POD;;
 ;;20;;NEUROLOGY;;NEURO;;
 ;;21;;SWING BED;;SWING;;
 ;;22;;NURSE-MIDWIFERY SERVICE;;NRSMW;;
 ;;01O;;DENTAL OBSERVATION;;DENO;;
 ;;02O;;ENT OBSERVATION;;ENTO;;
 ;;03O;;MEDICINE OBSERVATION;;MEDO;;
 ;;04O;;SURGERY OBSERVATION;;SURO;;
 ;;05O;;GYN OBSERVATION;;GYNO;;
 ;;06O;;INTERNAL MED OBSERVATION;;IMEDO;;
 ;;08O;;OBSTETRICS OBSERVATION;;OBO;;
 ;;09O;;OPHTHALMOLOGY OBSERVATION;;EYEO;;
 ;;10O;;ORTHOPEDICS OBSERVATION;;ORTO;;
 ;;11O;;PEDIATRICS OBSERVATION;;PEDO;;
 ;;12O;;MENTAL HEALTH OBSERVATION;;MHO;;
 ;;13O;;TUBERCULOSIS OBSERVATION;;TBO;;
 ;;15O;;SUBSTANCE ABUSE OBSERVATION;;ALCOO;;
 ;;16O;;PLASTIC SURGERY OBSERVATION;;PSURO;;
 ;;17O;;FAMILY PRACTICE OBSERVATION;;FAMPO;;
 ;;18O;;UROLOGY OBSERVATION;;UROO;;
 ;;19O;;PODIATRY OBSERVATION;;PODO;;
 ;;20O;;NEUROLOGY OBSERVATION;;NEUOB;;
 ;;22O;;NURSE-MIDWIFERY OBSERVATION;;NRSOB;;
