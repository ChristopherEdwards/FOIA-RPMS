BDGPOST2 ; IHS/ANMC/LJF - ADT POSTINIT CONT. ;  [ 04/17/2003  2:09 PM ]
 ;;5.3;PIMS;**1003**;MAY 28, 2004
 ;;IHS/ITSC/LJF 04/06/2005 PATCH 1003 added 3 BTS protocol names to end of routine
 ;                                    documenting sequence number assignments
 ;
 Q
 ;
SIDNR ;EP;delete all SI/DNR designations for patients not current inpatients
 ; PIMS will remove designation upon discharge; old version did not
 D BMES^XPDUTL("Removing Seriously Ill status if not a current inpatient...")
 NEW COND,IEN
 S COND=0 F  S COND=$O(^DPT("AS",COND)) Q:COND=""  D
 . S IEN=0 F  S IEN=$O(^DPT("AS",COND,IEN)) Q:'IEN  D
 .. I '$D(^DPT(IEN,.1)) K ^DPT(IEN,"DAC"),^DPT("AS",COND,IEN)
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
DGPM ;EP; moves fields around in file 405
 ; old admitting .08 now moved to 9999999.02
 ; .08 now primary copied from attending .19
 ; visit was 9999999.1 now .27
 ; build AAP xref on field .19 attending provider
 ; Using //// to bypass input transforms to speed up process
 Q:$D(^BDGX(11))    ;conversion already run
 D BMES^XPDUTL("Moving Patient Movement fields to new locations...")
 ;
 NEW IEN,ADM,ATT,VST,DR,DIE,DA,DIK
 S IEN=0 F  S IEN=$O(^DGPM(IEN)) Q:'IEN  D
 . Q:$G(^DGPM(IEN,0))=""            ;bad entry
 . S ADM=$P(^DGPM(IEN,0),U,8)                ;old admitting prov field
 . S ATT=$P(^DGPM(IEN,0),U,19)               ;attending provider
 . S VST=$P($G(^DGPM(IEN,"IHS")),U)          ;old visit field
 . I (ADM=""),(ATT=""),(VST="") Q            ;nothing to move/copy
 . ;
 . ; check validity of data
 . I ATT,'$D(^VA(200,+ATT,0)) S ^BDGX(11,IEN,"ATT")=ATT,ATT=""
 . I ADM,'$D(^VA(200,+ADM,0)) S ^BDGX(11,IEN,"ADM")=ADM,ADM=""
 . I VST,'$D(^AUPNVSIT(+VST,0)) S ^BDGX(11,IEN,"VST")=VST,VST=""
 . I VST,$P($G(^AUPNVSIT(+VST,0)),U,11)=1 S ^BDGX(11,IEN,"VSTDEL")=VST,VST=""
 . ;
 . S DR="" I ATT S DR=".08////"_ATT
 . I ADM S DR=DR_$S(DR]"":";",1:"")_"9999999.02////"_ADM
 . ;IHS/ITSC/WAR 4/17/03 P62 - concatenation of field needed
 . ;I ('ATT),ADM S DR=$S(DR]"":";",1:"")_".19////"_ADM
 . I ('ATT),ADM S DR=DR_$S(DR]"":";",1:"")_".19////"_ADM
 . I VST S DR=DR_$S(DR]"":";",1:"")_".27////"_VST
 . Q:DR=""  S DIE="^DGPM(",DA=IEN D ^DIE
 ;
 I $O(^BDGX(11,0)) K X S X="See ^BDGX(11 global for errors." D MES^XPDUTL(.X)
 ;
 ; run AAP xref - set .1041 field in DPT for current inpatients
 K X S X="  Now indexing Attending Physician (AAP xref) for current inpatients." D MES^XPDUTL(.X)
 NEW WARD,IEN,DA,DGPMDDF,DGPMDDT
 S WARD=0 F  S WARD=$O(^DGPM("CN",WARD)) Q:WARD=""  D
 . S IEN=0 F  S IEN=$O(^DGPM("CN",WARD,IEN)) Q:'IEN  D
 .. S DA=IEN,DGPMDDF=19,DGPMDDT=1 D ^DGPMDDCN
 ;
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
WARD ;EP; copy IHS ward fields to new file
 ; ^DIC(42,IHS* -> ^BDGWD(
 ; will keep old data in file 42 until future patch
 ;
 Q:$O(^BDGWD(0))             ;already data in file
 D BMES^XPDUTL("Copying IHS ward fields to new file...")
 ;
 NEW WRD,DATA,I,DIK,INA
 S WRD=0 F  S WRD=$O(^DIC(42,WRD)) Q:'WRD  D
 . S INA=$P($G(^DIC(42,WRD,"IHS")),U,4) Q:INA=2  ;don't copy deleted wd
 . ;
 . ; add new entry; update zero node of file
 . S ^BDGWD(WRD,0)=WRD_U_$E($P(^DIC(42,WRD,0),U),1,5)
 . S $P(^BDGWD(WRD,0),U,3)=$S(INA=1:"I",INA=0:"A",1:"")  ;active?
 . S $P(^BDGWD(0),U,3)=WRD,$P(^BDGWD(0),U,4)=$P(^BDGWD(0),U,4)+1
 . ;
 . ; copy data items to new locations
 . S ^BDGWD(WRD,1)=$G(^DIC(42,WRD,"IHS"))   ;copies pieces 1 - 5
 . S $P(^BDGWD(WRD,1),U,4)=""               ;no 4th piece in new file
 . S X=$P(^BDGWD(WRD,1),U),$P(^BDGWD(WRD,1),U)=$S(X="Y":1,1:0)  ;reset
 . S DATA=$G(^DIC(42,WRD,"IHS1"))
 . F I=1:1:9 S $P(^BDGWD(WRD,1),U,(I+10))=$P(DATA,U,I)  ;rest of items
 ;
 S DIK="^BDGWD(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
SCHVST ;EP; copy Scheduled Visit entries to new file
 ; copy ^ADGAUTH -> ^BDGSV(
 ; old data will be kept until future patch
 ;
 Q:$O(^BDGSV(0))                ;already has data
 D BMES^XPDUTL("Copying Scheduled Visit entries to new file...")
 ;
 NEW OLD,OLD1,NEW,DATA,DFN,I,DIK
 S OLD=0 F  S OLD=$O(^ADGAUTH(OLD)) Q:'OLD  D
 . S DFN=$G(^ADGAUTH(OLD,0)) Q:'DFN    ;bad entry
 . S OLD1=0 F  S OLD1=$O(^ADGAUTH(OLD,1,OLD1)) Q:'OLD1  D
 .. S DATA=$G(^ADGAUTH(OLD,1,OLD1,0)) Q:DATA=""   ;bad entry
 .. ;
 .. ; add new entry
 .. S NEW=$G(NEW)+1,^BDGSV(NEW,0)=DFN,^BDGSV(NEW,2)=""
 .. S $P(^BDGSV(0),U,3)=NEW,$P(^BDGSV(0),U,4)=$P(^BDGSV(0),U,4)+1
 .. ;
 .. ; copy data items to new locations
 .. F I="1;2","2;4","3;8","4;6","5;3","6;13","7;9","8;14","12;11" D
 ... S $P(^BDGSV(NEW,0),U,$P(I,";",2))=$P(DATA,U,+I)
 .. ;
 .. I $P(DATA,U,13)="Y" S ^BDGSV(NEW,1)="RT"
 .. ;
 .. F I="9;1","10;3","14;2" D
 ... S $P(^BDGSV(NEW,2),U,$P(I,";",2))=$P(DATA,U,+I)
 .. ;
 .. ; convert type of visit
 .. I $P(^BDGSV(NEW,0),U,3)="I" S $P(^BDGSV(NEW,0),U,3)="A"
 .. I $P(^BDGSV(NEW,0),U,3)="Q" S $P(^BDGSV(NEW,0),U,3)="O"
 ;
 S DIK="^BDGSV(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
EVENT ;EP; build event driver menu based on protocols installed
 ; If you have the following installed, I will add them to event driver
 ;
 D BMES^XPDUTL("Building ADT Event Driver...")
 NEW IEN,ITEM,BDGE
 S BDGE=$O(^ORD(101,"B","BDGPM MOVEMENT EVENTS",0)) I 'BDGE D EVQ Q
 ;
 ; loop thru list of known protocols
 ;F BDGI=1:1:13 S ITEM=$P($T(PROT+BDGI),";;",2) D
 F BDGI=1:1:14 S ITEM=$P($T(PROT+BDGI),";;",2) D    ;PATCH #1001
 . I $D(^ORD(101,"B",ITEM)) D         ;if protocol exists
 .. S IEN=$O(^ORD(101,"B",ITEM,0)) Q:'IEN
 .. Q:$D(^ORD(101,BDGE,10,"B",IEN))   ;already added to event driver
 .. ;
 .. ; go ahead and add it
 .. S DIC="^ORD(101,"_BDGE_",10,",DIC(0)="L",DLAYGO=101.01
 .. S DA(1)=BDGE,DIC("P")="101.01PA",X=IEN
 .. S DIC("DR")="3///"_$P($T(PROT+BDGI),";;",3)
 .. K DD,DO D FILE^DICN
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 ;
EVQ ; call Scheduling event driver update
 D EVENT^BSDPOST
 Q
 ;
PROT ;; Protocols to add to event driver
 ;;ORU PATIENT MOVMT;;101;;
 ;;ORU AUTOLIST;;105;;
 ;;PSJ OR PAT ADT;;120;;
 ;;GMRADGPM MARK CHART;;210;;
 ;;AQAL ADT EVENT;;150;;
 ;;FHWMAS;;160;;
 ;;SR IHS EVENT-ADMIT;;170;;
 ;;MAGD DHCP-PACS ADT EVENTS;;180;;
 ;;VEFSP PYXIS;;140;;
 ;;AMCO ADT EVENT;;130;;
 ;;BHL ADMIT A PATIENT;;5;;
 ;;BHL TRANSFER A PATIENT;;6;;
 ;;BHL DISCHARGE A PATIENT;;7;;
 ;;BHL PYXIS ADT;;141;;
 ;;BTS ADMIT A PATIENT (3M HDM);;102;;
 ;;BTS DISCHARGE A PATIENT (3M HDM);;103;;
 ;;BTS TRANSFER A PATIENT (3M HDM);;104;;
