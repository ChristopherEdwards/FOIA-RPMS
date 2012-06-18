KMPRBD02 ;SF/RAK - RUM Data Compression ;1/20/00  07:36
 ;;1.0;CAPACITY MANAGEMENT - RUM;**1**;Dec 09, 1998
 ;
 ; Background Driver (cont.)
 ;
DAILY(KMPRTDAY) ;-- daily data compression and storage
 ;----------------------------------------------------------------------
 ; KMPRTDAY.. Day in $H format (+$H).  This represents the
 ;            ending point for compression.  Only dates LESS than
 ;            KMPRTDAY will be compressed.
 ;
 ; At midnight compress hourly info into daily stats. Daily stats are
 ; stored in file #8971.1.  Hourly data is killed.
 ;----------------------------------------------------------------------
 ;
 Q:'$G(KMPRTDAY)
 ;
 N ARRAY,COUNT,DATA,DOW,HDATE,HTIME,I,JOB,MESSAGE,NODE,OKAY,OPTION
 N NP,PT,PTM,X,VAR
 ;
 ; make sure DT is defined.
 S:'$G(DT) DT=$$DT^XLFDT
 ; where daily data is located.
 S ARRAY=$NA(^XTMP("KMPR","DLY"))
 S NODE=""
 F  S NODE=$O(@ARRAY@(NODE)) Q:NODE=""  D
 .S HDATE=""
 .F  S HDATE=$O(@ARRAY@(NODE,HDATE)) Q:HDATE=""!(HDATE'<KMPRTDAY)  D 
 ..S OPTION=""
 ..F  S OPTION=$O(@ARRAY@(NODE,HDATE,OPTION)) Q:OPTION=""  D 
 ...S JOB=0,(COUNT,NP,PT)=""
 ...F  S JOB=$O(@ARRAY@(NODE,HDATE,OPTION,JOB)) Q:'JOB  D 
 ....S PTM=""
 ....F  S PTM=$O(@ARRAY@(NODE,HDATE,OPTION,JOB,PTM)) Q:PTM=""  D 
 .....; PTM:  non-prime time = 0   prime time = 1
 .....S DATA=@ARRAY@(NODE,HDATE,OPTION,JOB,PTM)
 .....; prime time or non-prime time.
 .....S VAR=$S(PTM:"PT",1:"NP") Q:VAR=""
 .....; accumulate totals.
 .....F I=1:1:8 S $P(@VAR,U,I)=$P(@VAR,U,I)+$P(DATA,U,I)
 .....; piece 1 non-prime time - piece 2 prime time
 .....S $P(COUNT,U,(PTM+1))=$P(COUNT,U,(PTM+1))+1
 .....; remove data from array.
 .....K @ARRAY@(NODE,HDATE,OPTION,JOB,PTM)
 ...;
 ...; back to OPTION level.
 ...; file data into file #8971.1
 ...D FILE^KMPRBD03(HDATE,NODE,OPTION,PT,NP,$P(COUNT,U,2),$P(COUNT,U),.OKAY,.MESSAGE)
 ...; if not filed successfully set into 'ERR' node.
 ...I 'OKAY D 
 ....S ^XTMP("KMPR","ERR",HDATE,NODE,OPTION,0)=NP_$P(COUNT,U)
 ....S ^XTMP("KMPR","ERR",HDATE,NODE,OPTION,1)=PT_$P(COUNT,U,2)
 ....F I=0:0 S I=$O(MESSAGE(I)) Q:'I  D 
 .....S ^XTMP("KMPR","ERR",HDATE,NODE,OPTION,"MSG",I)=MESSAGE(I)
 ;
 Q
 ;
WEEKLY(KMPRDT) ;-- compress daily stats to weekly
 ;-----------------------------------------------------------------------
 ; KMPRDT... Compression date in internal fileman formt.  This date
 ;           must be a Sunday.  It represents the date from which the
 ;           previous weeks data should be compressed. 
 ;           Example: if KMPRDT = 2981011  then compression will begin
 ;                    on 2981010 (KMPRDT-1)
 ;
 ; Every Sunday compress the daily stats in file #8971.1 into weekly
 ; and upload the data to the CM RUM National Database
 ;-----------------------------------------------------------------------
 ;
 Q:'$G(KMPRDT)
 ;
 N DATA,DATE,DELDATE,END,HOURS,I,IEN,J,SITE,START,TMPARRY,TMPARRY1
 ;
 ; quit if not sunday.
 Q:$$DOW^XLFDT(KMPRDT,1)
 ; storage array.
 S TMPARRY=$NA(^TMP($J))
 ; processed entries.
 S TMPARRY1=$NA(^TMP("KMPR PROC",$J))
 K @TMPARRY,@TMPARRY1
 ; site info.
 S SITE=$$SITE^VASITE Q:SITE=""
 S DATE=KMPRDT
 S (START,END)=""
 ; Date to begin deletion.
 S DELDATE=$$FMADD^XLFDT(KMPRDT,-14)
 ;
 W:'$D(ZTQUEUED) !,"Compressing data into weekly format..."
 ; Reverse $order to get previous dates.
 F  S DATE=$O(^KMPR(8971.1,"B",DATE),-1) Q:'DATE  D 
 .; If DATE is saturday set START and END dates and kill TMPARRY.
 .I $$DOW^XLFDT(DATE,1)=6 D 
 ..S END=DATE,START=$$FMADD^XLFDT(DATE,-6)
 ..K @TMPARRY
 .Q:'START
 .S IEN=0
 .F  S IEN=$O(^KMPR(8971.1,"B",DATE,IEN)) Q:'IEN  D 
 ..Q:'$D(^KMPR(8971.1,IEN,0))
 ..; data nodes into DATA() array.
 ..S DATA(0)=^KMPR(8971.1,IEN,0),DATA(1)=$G(^(1)),DATA(2)=$G(^(2))
 ..; Quit if data has already been sent to national database.
 ..Q:$P(DATA(0),U,2)
 ..; Cpu node.
 ..S NODE=$P(DATA(0),U,3) Q:NODE=""
 ..; OPTION = OptionName^ProtocolName.
 ..; option.
 ..S OPTION=$P(DATA(0),U,4)
 ..; rpc.
 ..S:OPTION="" OPTION=$P(DATA(0),U,7)
 ..; hl7.
 ..S:OPTION="" OPTION=$P(DATA(0),U,9)
 ..Q:OPTION=""
 ..S $P(OPTION,U,2)=$P(DATA(0),U,5)
 ..S @TMPARRY@(START,NODE,OPTION,0)=DATA(0)
 ..; change first piece to starting date (START)
 ..S $P(@TMPARRY@(START,NODE,OPTION,0),U)=START
 ..; second piece not applicable to national database
 ..S $P(@TMPARRY@(START,NODE,OPTION,0),U,2)=""
 ..; EndingDate^SiteName^SiteNumber.
 ..S @TMPARRY@(START,NODE,OPTION,99)=END_U_$P(SITE,U,2)_U_$P(SITE,U,3)
 ..; Nodes 1 and 2.
 ..F I=1,2 I DATA(I)]"" D 
 ...; Add data to get weekly totals.
 ...F J=1:1:8 S $P(@TMPARRY@(START,NODE,OPTION,I),U,J)=$P($G(@TMPARRY@(START,NODE,OPTION,I)),U,J)+$P(DATA(I),U,J)
 ..;
 ..; Back to IEN level.
 ..; Add to processed array.
 ..S @TMPARRY1@(IEN)=""
 .;
 .; Back to DATE level.
 .; If START then transmit data.
 .I DATE=START I $D(@TMPARRY) D TRANSMIT K @TMPARRY
 ;
 ; Transmit data to national database.
 W:'$D(ZTQUEUED) !,"Transmitting data to national database..."
 D:$D(@TMPARRY) TRANSMIT
 K @TMPARRY
 ;
 ; update field .02 (SENT TO CM NATIONAL DATABASE) to 'YES' for all
 ; processed entries.
 W:'$D(ZTQUEUED) !,"Updating records to reflect transmission..."
 S IEN=0
 F  S IEN=$O(@TMPARRY1@(IEN)) Q:'IEN  D 
 .K FDA,ERROR
 .S FDA($J,8971.1,IEN_",",.02)=1
 .D FILE^DIE("","FDA($J)","ERROR")
 K @TMPARRY1
 ;
 ; leave two complete weeks of data in file #8971.1
 D PURGE^KMPRUTL3(DELDATE,1)
 ;
 Q
 ;
TRANSMIT ;-- format TMPARRY data, put into e-mail and send to cm.
 ;
 Q:$G(TMPARRY)=""
 ;
 N HRSDAYS,I,IEN,LN,N,O,S,UPLDARRY,XMSUB,X,XMTEXT,XMY,XMZ,Y,Z
 ;
 S UPLDARRY=$NA(^TMP("KMPR UPLOAD",$J))
 K @UPLDARRY
 ;
 S LN=0
 ; version and patch info.
 S LN=LN+1,@UPLDARRY@(LN)="VERSION="_$$VERSION^KMPRUTL
 ;
 ; get hours/days data
 D HRSDAYS^KMPRUTL3(START,END,1,.HRSDAYS)
 ; if ^XTMP("KMPR","HOURS","START") exists then this is the first time
 ; the "HOURS" subscript is being accessed.  chances are this is only
 ; partial data, so it should be ignored.
 I $G(^XTMP("KMPR","HOURS","START"))&($D(HRSDAYS)) D 
 .K HRSDAYS,^XTMP("KMPR","HOURS","START")
 ;
 I $D(HRSDAYS) S S=0 D 
 .F  S S=$O(HRSDAYS(S)) Q:'S  S N="" D 
 ..F  S N=$O(HRSDAYS(S,N)) Q:N=""  D 
 ...S LN=LN+1
 ...; StartDate^Node^EndDate^PTDays^PTHours^NPTDays^NPTHours
 ...S @UPLDARRY@(LN)="HRSDAYS="_START_"^"_N_"^"_END_"^"_HRSDAYS(S,N)
 ;
 ; reformat so that data is in ^TMP("KMPR UPLOAD",$J,LN)= format.
 S IEN=0,S=""
 F  S S=$O(@TMPARRY@(S)) Q:S=""  S N="" D 
 .F  S N=$O(@TMPARRY@(S,N)) Q:N=""  S O="" D 
 ..F  S O=$O(@TMPARRY@(S,N,O)) Q:O=""  S I="",IEN=IEN+1 D 
 ...F  S I=$O(@TMPARRY@(S,N,O,I)) Q:I=""  D 
 ....S LN=LN+1
 ....S @UPLDARRY@(LN)=IEN_","_I_")="_@TMPARRY@(S,N,O,I)
 ;
 ; quit if no data to transmit.
 Q:'$D(@UPLDARRY)
 ; send packman message.
 S XMTEXT="^TMP(""KMPR UPLOAD"","_$J_","
 S XMSUB="RUM DATA - "_$P(SITE,U,2)_" ("_$P(SITE,U,3)_") - "_$$FMTE^XLFDT(START)
 S XMY("S.KMP2-RUM-SERVER@DOMAIN.NAME")=""
 S XMY("CAPACITY,MANAGEMENT@DOMAIN.NAME")=""
 D ^XMD
 W:'$D(ZTQUEUED) !,"Message #",$G(XMZ)," sent..."
 K @UPLDARRY
 ;
 Q
