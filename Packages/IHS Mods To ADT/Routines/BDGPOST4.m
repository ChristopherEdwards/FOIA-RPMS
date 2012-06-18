BDGPOST4 ; IHS/ANMC/LJF - PIMS POST INIT (IC FILES) ;  [ 04/17/2003  4:28 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
IC ;EP; copy data from 2 incomplete chart files to new one
 ; copy ^ADGIC & ^ADGDSI  -> ^BDGIC
 ; data left in old files until future patch
 ;
 ; copy incomplete chart file first
 Q:$O(^BDGIC(0))              ;already has data
 D BMES^XPDUTL("Copying Incomplete Chart entries to new file...")
 ;
 NEW OLD,OLD1,OLD2,OLD3,NEW,NEW2,I,DATA,DIK,X,V
 S OLD=0 F  S OLD=$O(^ADGIC(OLD)) Q:'OLD  D
 . Q:$G(^ADGIC(OLD,0))=""         ;bad entry
 . S DFN=+$G(^ADGIC(OLD,0))
 . ;
 . ; add new entry
 . S OLD1=0 F  S OLD1=$O(^ADGIC(OLD,"D",OLD1)) Q:'OLD1  D
 .. S DATA=$G(^ADGIC(OLD,"D",OLD1,0)) Q:DATA=""
 .. S NEW=$G(NEW)+1,^BDGIC(NEW,0)=DFN_U_(+DATA)
 .. S $P(^BDGIC(0),U,3)=NEW,$P(^BDGIC(0),U,4)=$P(^BDGIC(0),U,4)+1
 .. ;
 .. ; try to find PCC visit based on discharge and patient
 .. S X=$O(^DGPM("AMV3",+DATA,DFN,0)) I X D
 ... S X=$P($G(^DGPM(X,0)),U,14)    ;admission linked to discharge
 ... S V=$P($G(^DGPM(X,0)),U,27) I V S $P(^BDGIC(NEW,0),U,3)=V
 .. ;
 .. ; now copy data items to new location
 .. F I="1;2","4;4","12;18","14;12","15;13" D
 ... S $P(^BDGIC(NEW,0),U,$P(I,";",2))=$P(DATA,U,+I)
 .. ;
 .. ; copy provider multiples
 .. S NEW2=1    ;start over for each patient
 .. Q:'$D(^ADGIC(OLD,"D",OLD1,"P",0))   ;no provider entries to copy
 .. S ^BDGIC(NEW,1,0)="^9009016.11P^"_$P(^ADGIC(OLD,"D",OLD1,"P",0),U,3,4)
 .. ;
 .. S OLD2=0 F  S OLD2=$O(^ADGIC(OLD,"D",OLD1,"P",OLD2)) Q:'OLD2  D
 ... Q:$G(^ADGIC(OLD,"D",OLD1,"P",OLD2,0))=""    ;bad entry
 ... ;
 ... ; now get chart deficiencies
 ... S OLD3=0
 ... F  S OLD3=$O(^ADGIC(OLD,"D",OLD1,"P",OLD2,"C",OLD3)) Q:'OLD3  D
 .... S DATA=$G(^ADGIC(OLD,"D",OLD1,"P",OLD2,"C",OLD3,0)) Q:DATA=""
 .... S ^BDGIC(NEW,1,NEW2,0)=^ADGIC(OLD,"D",OLD1,"P",OLD2,0)
 .... S $P(^BDGIC(NEW,1,NEW2,0),U,2)=+DATA
 .... S NEW2=NEW2+1
 ;IHS/ITSC/WAR 4/17/03 P63 Added next line per Linda
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 ;
 ;
 ; now copy from day surgery incomplete file
 D BMES^XPDUTL("Copying DS Incomplete Chart entries to new file...")
 ;
 S OLD=0 F  S OLD=$O(^ADGDSI(OLD)) Q:'OLD  D
 . Q:$G(^ADGDSI(OLD,0))=""         ;bad entry
 . S DFN=+$G(^ADGDSI(OLD,0))
 . ;
 . ; add new entry
 . S OLD1=0 F  S OLD1=$O(^ADGDSI(OLD,"DT",OLD1)) Q:'OLD1  D
 .. S DATA=$G(^ADGDSI(OLD,"DT",OLD1,0)) Q:DATA=""
 .. S NEW=$G(NEW)+1,^BDGIC(NEW,0)=DFN_"^^^^"_(+DATA)   ;surg date
 .. S $P(^BDGIC(0),U,3)=NEW,$P(^BDGIC(0),U,4)=$P(^BDGIC(0),U,4)+1
 .. ;
 .. ; try to find PCC visit based on surgery date and patient
 .. S X=$O(^SRF("AIHS4",((+DATA)\1),DFN,0)) I X D
 ... S V=$P($G(^SRF(X,9999999)),U) I V S $P(^BDGIC(NEW,0),U,3)=V
 .. ;
 .. ; now copy data items to new location
 .. F I="5;4","4;18" D
 ... S $P(^BDGIC(NEW,0),U,$P(I,";",2))=$P(DATA,U,+I)
 .. ;
 .. ; copy provider multiples
 .. S NEW2=1    ;start over for each patient
 .. Q:'$D(^ADGDSI(OLD,"DT",OLD1,"P",0))   ;no provider entries to copy
 .. S ^BDGIC(NEW,1,0)="^9009016.11P^"_$P(^ADGDSI(OLD,"DT",OLD1,"P",0),U,3,4)
 .. ;
 .. S OLD2=0 F  S OLD2=$O(^ADGDSI(OLD,"DT",OLD1,"P",OLD2)) Q:'OLD2  D
 ... Q:$G(^ADGDSI(OLD,"DT",OLD1,"P",OLD2,0))=""    ;bad entry
 ... ;
 ... ; now get chart deficiencies
 ... S OLD3=0
 ... F  S OLD3=$O(^ADGDSI(OLD,"DT",OLD1,"P",OLD2,"CD",OLD3)) Q:'OLD3  D
 .... S DATA=$G(^ADGDSI(OLD,"DT",OLD1,"P",OLD2,"CD",OLD3,0)) Q:DATA=""
 .... S ^BDGIC(NEW,1,NEW2,0)=^ADGDSI(OLD,"DT",OLD1,"P",OLD2,0)
 .... S $P(^BDGIC(NEW,1,NEW2,0),U,2)=+DATA
 .... S NEW2=NEW2+1
 ;
 ;
 ; now index new file
 S DIK="^BDGIC(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
