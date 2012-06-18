BTIUCD ; IHS/ITSC/LJF - IHS CALL TO INCOM CHART EDITS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;Only used if site is running ADT version 5.3 Incomplete Chart module                        
 ;
 ;
EDIT(TIUDA) ;EP; call from protocol to edit ic files
 ;TIUDA=ien of document
 NEW DA,DDSFILE,DR,VSTYP,VST,BDGN
 S VST=$$IVST^BTIUU1(TIUDA)    ;visit ien
 S VSTYP=$$CAT^BTIUU1(TIUDA)   ;visit service category
 ;
 I VSTYP="H" D  Q
 . I '$O(^BDGIC("AV",VST,0)) W !,"No Incomplete Chart Entry for this patient" D RETURN^BTIUU Q
 . D FULL^VALM1
 . S (DA,BDGN)=$O(^BDGIC("AV",VST,0)) Q:'DA
 . S DDSFILE=9009016.1,DR="[BDG INCOMPLETE EDIT]" D ^DDS
 ;
 I (VSTYP="S")!(VSTYP="O") D  Q
 . I '$O(^BDGIC("AV",VST,0)) W !,"No Incomplete Chart Entry for this patient" D RETURN^BTIUU Q
 . D FULL^VALM1
 . S (DA,BDGN)=$O(^BDGIC("AV",VST,0)) Q:'DA
 . S DDSFILE=9009016.1,DR="[BDG DAY SURGERY EDIT]" D ^DDS
 ;
 W !!,"Visit is not of service category tracked by Incomplete Chart module in ADT.",! D RETURN^BTIUU
 Q
 ;
