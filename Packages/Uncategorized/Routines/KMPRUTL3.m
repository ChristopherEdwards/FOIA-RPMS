KMPRUTL3 ;SF/RAK - Resource Usage Monitor Utilities ;1/20/00  07:37
 ;;1.0;CAPACITY MANAGEMENT - RUM;**1**;Dec 09, 1998
 ;
HRSDAYS(KMPRSDT,KMPREDT,KMPRKILL,KMPRRES) ;-- hours/days.
 ;-----------------------------------------------------------------------
 ; KMPRSDT.. Stat Date in internal fileman format.
 ; KMPREDT.. End Date in internal fileman format.
 ; KMPRKILL. Kill node after processing: 
 ;              0 - do not kill.
 ;              1 - kill
 ; KMPRRES.. Array (passed by reference) containing days/hours info
 ;           in format: KMPRRES(KMPRSDT,Node)=Data 
 ;              Where Data equals:
 ;              '^' Piece 1 - Prime Time Days
 ;              '^' Piece 2 - Prime Time Hours
 ;              '^' Piece 3 - Non-Prime Time Days
 ;              '^' Piece 4 - Non-Prime Time Hours
 ;           Example:
 ;              KMPRRES(2990130,"999A01")=5^9^7^15
 ;              KMPRRES(2990130,"999A02")=5^4^7^10
 ;              KMPRRES(2990130,"999A03")=5^9^7^15
 ;              KMPRRES(...,...)=...
 ;-----------------------------------------------------------------------
 ;
 K KMPRRES
 ;
 Q:'$G(KMPRSDT)
 Q:'$G(KMPREDT)
 S KMPRKILL=+$G(KMPRKILL)
 ;
 N DATA,DATE,DAYS,HOURS,I,NODE
 ;
 D HOURS(KMPRSDT,KMPREDT,KMPRKILL,.HOURS) Q:'$D(HOURS)
 S NODE=""
 F  S NODE=$O(HOURS(NODE)) Q:NODE=""  D 
 .S (DATE,DAYS,HOURS)=0
 .F  S DATE=$O(HOURS(NODE,DATE)) Q:'DATE  D 
 ..S DATA=HOURS(NODE,DATE)
 ..; piece 1 - prime time.
 ..; piece 2 - non-prime time.
 ..F I=1,2 D 
 ...; total hours.
 ...S $P(HOURS,U,I)=$P(HOURS,U,I)+$P(DATA,U,I)
 ...; if current day has hours then increment total days.
 ...S:$P(DATA,U,I) $P(DAYS,U,I)=$P(DAYS,U,I)+1
 .; back to NODE level.
 .S KMPRRES(KMPRSDT,NODE)=$P(DAYS,U)_"^"_$P(HOURS,U)_"^"_$P(DAYS,U,2)_"^"_$P(HOURS,U,2)
 Q
 ;
HOURS(KMPRSDT,KMPREDT,KMPRKILL,KMPRRES) ;-- determine prime time & non-prime time hours
 ;-----------------------------------------------------------------------
 ; KMPRSDT.. Stat Date in internal fileman format.
 ; KMPREDT.. End Date in internal fileman format.
 ; KMPRKILL. Kill node after processing: 
 ;              0 - do not kill.
 ;              1 - kill
 ; KMPRRES.. Array (passed by reference) containing days/hours info
 ;           in format: KMPRRES(Date,Node)=Data 
 ;              Where Data equals:
 ;              '^' Piece 1 - Prime Time Days
 ;              '^' Piece 2 - Prime Time Hours
 ;              '^' Piece 3 - Non-Prime Time Days
 ;              '^' Piece 4 - Non-Prime Time Hours
 ;           Example:
 ;              KMPRRES(2990130,"999A01")=5^9^7^15
 ;              KMPRRES(2990130,"999A02")=5^4^7^10
 ;              KMPRRES(2990131,"999A01")=5^9^7^15
 ;              KMPRRES(...,...)=...
 ;-----------------------------------------------------------------------
 ;
 K KMPRRES
 ;
 Q:'$G(KMPRSDT)
 Q:'$G(KMPREDT)
 S KMPRKILL=+$G(KMPRKILL)
 ;
 N DATA,DATE,DOW,END,HOURS,HRS,I,NODE,PIECE
 ; end date.
 S END=KMPREDT
 S DATE=KMPRSDT-.1,(DAYS,HOURS)=""
 F  S DATE=$O(^XTMP("KMPR","HOURS",DATE)) Q:'DATE!(DATE>END)  D 
 .Q:DATE<KMPRSDT!(DATE>END)
 .S NODE="",DOW=$$DOW^XLFDT(DATE,1)
 .; prime time (8am to 5pm).
 .; if not saturday or sunday or holiday then prime time (piece 1).
 .; if saturday or sunday then non-prime time (piece 2).
 .S PIECE=$S(DOW'=0&(DOW'=6)&('$G(^HOLIDAY(DATE,0))):1,1:2)
 .F  S NODE=$O(^XTMP("KMPR","HOURS",DATE,NODE)) Q:NODE=""  D
 ..S DATA=$G(^XTMP("KMPR","HOURS",DATE,NODE)) Q:DATA=""
 ..S (HOURS,HRS)=0
 ..;
 ..;*** times are offset by 1  so zero hour is in piece 1
 ..;***                            one hour is in piece 2
 ..;***                            two hour is in piece 3
 ..;***                            etc.
 ..; prime time.
 ..F I=9:1:17 S HRS=HRS+$P(DATA,U,I)
 ..S $P(HOURS,U,PIECE)=$P(HOURS,U,PIECE)+HRS
 ..; non-prime time.
 ..S HRS=0
 ..F I=1:1:8,18:1:24 S HRS=HRS+$P(DATA,U,I)
 ..S $P(HOURS,U,2)=$P(HOURS,U,2)+HRS
 ..S KMPRRES(NODE,DATE)=HOURS
 ..K:KMPRKILL ^XTMP("KMPR","HOURS",DATE,NODE)
 ;
 Q
 ;
PURGE(KMPRDDT,KMPRHRS) ;-- purge data in file #8971.1
 ;-----------------------------------------------------------------------
 ; KMPRDDT.. Date to begin purge in internal fileman format. Purge will
 ;           reverse $order and delete entries 'EARLIER' than KMPRDDT.
 ; KMPRHRS.. Purge Hours/Days data from ^XTMP("KMPR","HOURS". Entries
 ;           'EARLIER' than KMPRDDT will be deleted.
 ;           0 - do not purge hours/days data.
 ;           1 - purge hours/days data.
 ;-----------------------------------------------------------------------
 ;
 Q:'$G(KMPRDDT)
 S KMPRHRS=+$G(KMPRHRS)
 ;
 N DA,DATE,DIK,IEN
 W:'$D(ZTQUEUED) !,"Deleting old records..."
 S DATE=KMPRDDT
 F  S DATE=$O(^KMPR(8971.1,"B",DATE),-1) Q:'DATE!(DATE>KMPRDDT)  D 
 .F IEN=0:0 S IEN=$O(^KMPR(8971.1,"B",DATE,IEN)) Q:'IEN  D 
 ..; quit if not 'sent to cm database'.
 ..Q:'$P($G(^KMPR(8971.1,IEN,0)),U,2)
 ..; Delete entry.
 ..S DA=IEN,DIK="^KMPR(8971.1," D ^DIK
 ;
 Q:'KMPRHRS
 W:'$D(ZTQUEUED) !,"Deleting old entries from ^XTMP(""KMPR"",""HOURS""..."
 S DATE=KMPRDDT
 F  S DATE=$O(^XTMP("KMPR","HOURS",DATE),-1) Q:'DATE!(DATE>KMPRDDT)  D 
 .K ^XTMP("KMPR","HOURS",DATE)
 ;
 Q
