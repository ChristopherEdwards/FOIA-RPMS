BCSVMP ;IHS/CIA/PLS - CSV Mapping Utility ;6-Sep-2006 17:42;PLS
 ;;1.0;BCSV;;APR 23, 2010
 ;=================================================================
 ; Key
 ; "BUILT" - When set to 1 indicates entries to be mapped have been built.
 ; "DONE" - When set to 1 indicates mapping has been completed for file.
 ; "UNMAP" - List of IENS to be mapped
 ;     "UNMAP"=Count
 ; "MAP" - List of mapped IENS - ^("MAP",IHS IEN)=VHA IEN
 ;     "MAP"=Count
 ; "ZERO" - Processing information - reserved for later use
 ; "KPT" - List of known fields pointing to file
 ;
POST ; Entry Point for KIDS install
 N FIL,DLM,DDLM,EXIT,EFLG,OFF
 D INIT
 F  D  Q:$G(EFLG)!EXIT
 .S FIL=$$NXTFIL(.OFF)
 .I $P(FIL,DDLM,2)="" S EFLG=1 Q
 .D BLDMAP(FIL) Q:EXIT
 .D AUTO(FIL)
 Q
 ; Mapping EP
 ;   Input: FLG - 0=manual 1=auto
EN(FLG) ;EP
 ;
 N FIL,DLM,DDLM,EXIT,EFLG,OFF
 D INIT
 F  D  Q:$G(EFLG)!EXIT
 .S FIL=$$NXTFIL(.OFF)
 .I $P(FIL,DDLM,2)="" S EFLG=1 Q
 .I $G(FLG) D
 ..D AUTO(FIL)
 .E  D MAN(FIL)
 Q
 ; EP to Remap a given file entry
REMAP ;EP
 N OFF,TMP,DIR,DDLM,FIL,SIEN,TIEN,STATUS
 N SDESC,TDESC,EXIT
 S STATUS=1
 F  D:STATUS<2 REMAP1 Q:STATUS=2
 Q
REMAP1 ;
 D INIT
 N AMFLG S AMFLG="M"
 S TMP="" K OFF
 S DIR(0)="SO^",DIR("A")="Select file to remap"
 F  S TMP=$P($$NXTFIL(.OFF),DDLM,2) Q:TMP=""  D
 .S DIR(0)=DIR(0)_OFF_":"_$$GET1^DID($P(TMP,";",2),,,"NAME")_";"
 I $L(DIR(0),":") D
 .D ^DIR
 .S:$G(DUOUT) STATUS=2
 E  S STATUS=2 Q
 Q:$G(DTOUT)!$G(DUOUT)
 S OFF=+Y-1 S FIL=$$NXTFIL(.OFF) Q:$P(FIL,DDLM,2)=""
 D SETFILE($P(FIL,DDLM,2),.SRCARY,.TRGARY)
 ;I '$$MPDONE(TRGARY("GNAM")) D  Q
 ;.W !,"Mapping has NOT been completed for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file."
 ;.W !,"Please complete the mapping process before attempting to REMAP entries!",!
 W !,"Remapping entries for the "_$$GET1^DID(SRCARY("NUM"),,,"NAME")_" file.",!!
 F  S SIEN=$$DIRLKP(SRCARY("NUM"),$$GETP(SRCARY("XRI"),1,":"),.STATUS) Q:STATUS  D
 .;Q:STATUS
 .; in the event we see code .9999 in file 80, skip re-mapping
 .S ITM=$$GET1^DIQ(SRCARY("NUM"),+SIEN,.01)
 .I SRCARY("NUM")=80,ITM=.9999 W !,"This item can not be re-mapped.",! Q
 .; for entry 333333 in the ICD Operation/Procedure file, skip re-mapping
 .I SRCARY("NUM")=80.1,ITM=333333 W !,"This item can not be re-mapped.",! Q
 .S SDESC=$$GDESC("S",SRCARY("NUM"),+SIEN,SRCARY("DFLD"))
 .I '$D(@$$GLBPATH(TRGARY("GNAM"),"MAP")@(+SIEN)) W !,"This item is currently not mapped, and can not be re-mapped.",! Q
 .S TDESC=$$GDESC("T",$$GLBPATH(TRGARY("GNAM"),"DATA"),+@$$GLBPATH(TRGARY("GNAM"),"MAP")@(+SIEN),TRGARY("DFLD"))
 .W !,"Item is currently mapped to: "_TDESC,!!
 .I $$YN("N","Would you like to REMAP entry") D  Q
 ..S TIEN=$$DIRLKP($TR($$GLBPATH(TRGARY("GNAM"),"DATA"),")",","),$$GETP(TRGARY("XRI"),1,":"),.STATUS)
 ..I STATUS W ! S:STATUS=2 EXIT=1 Q
 ..W !,"You have elected to map: "
 ..W $$GET1^DIQ(SRCARY("NUM"),+SIEN,.01)_"  ("_SDESC_")   to ",!
 ..W $P(TIEN,U,2)_"  ("_$$GDESC("T",$$GLBPATH(TRGARY("GNAM"),"DATA"),+TIEN,TRGARY("DFLD"))_").",!
 ..I $$YN("YES") D
 ...D UPDMAP(TRGARY("GNAM"),+SIEN,+TIEN,AMFLG)
 ...W !,"Remapped!",!
 .I $$YN("N","Would you like to UNMAP this entry") D
 ..D DELMAP(TRGARY("GNAM"),+SIEN)
 ..W !,"Unmapped!",!
 Q
 ;Build UNMAP node for Target Files
BLDMAP(FIL) ;
 N EFLG
 N SRCARY,TRGARY
 D SETFILE($P(FIL,DDLM,2),.SRCARY,.TRGARY)
 D:'$$BUILT(TRGARY("GNAM")) BLDLP
 Q
AUTO(FIL) ;
 ; SFN=Source File Number ; TFN=Target File Number
 N SFN,TFN,TFNM,TXRI,EFLG
 N SRCARY,TRGARY
 S EFLG=0
 D SETFILE($P(FIL,DDLM,2),.SRCARY,.TRGARY)
 I '$$MPDONE(TRGARY("GNAM")) D
 .I $$AMAPDN(TRGARY("GNAM")) W !,"Automapping has already been completed for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file.",! S EFLG=1 Q
 .D LOOP
 .S @$$GLBPATH(TRGARY("GNAM"),"AUTO")=1
 Q:EFLG
 W !,"Automapping has "_$S('$$AMAPDN(TRGARY("GNAM")):"not ",1:"")_"been completed for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file.",!
 Q
MAN(FIL) ;
 N IEN,SGLB,TGLB,SDATA,DIR,ITM,Y,SDESC,TDESC,FUNC,CHKNEW
 N DIROUT,DUOUT,DTOUT,D,STATUS,SRCARY,TRGARY,SIFLG,TIFLG
 N AMFLG S AMFLG="M"
 D SETFILE($P(FIL,DDLM,2),.SRCARY,.TRGARY)
 ; Do not allow manual mapping for DRG file. This file is DINUM'd and the entries should be brought in as they are in the VA data set.
 I SRCARY("NUM")=80.2 Q
 S (SDESC,TDESC)=""
 I '$$AMAPDN(TRGARY("GNAM")) D  Q
 .W !,"Automapping has not been completed for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file.",!
 .W "Please use the AutoMapping option.",!
 I $$MPDONE(TRGARY("GNAM")) D  Q
 .W !,"Mapping has been completed for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file.",!
 W !,"Enter '^' to SKIP item; '^^' to skip to next file."
 W !!,"Matching entries for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file.",!
 S SGLB=$$GLBPATH(TRGARY("GNAM"),"UNMAP")
 S IEN=0 F  S IEN=$O(@SGLB@(IEN)) Q:'IEN  D  Q:$G(EX)
RS .S EX=0
 .S ITM=$$GET1^DIQ(SRCARY("NUM"),IEN,.01)
 .; in the event we see code .9999 in file 80, skip mapping
 .I SRCARY("NUM")=80,ITM=.9999 Q
 .; for entry 333333 in the ICD Operation/Procedure file, skip mapping
 .I SRCARY("NUM")=80.1,ITM=333333 Q
 .; if this is an entry that was newly added by BCSV, do not allow manual map
 .S CHKNEW=$TR($$GLBPATH(TRGARY("GNAM"),"NEW"),")",",")_IEN_")" I $D(@CHKNEW) Q
 .S SDESC=$$GDESC("S",SRCARY("NUM"),IEN,SRCARY("DFLD"))
 .S SIFLG=$$GET1^DIQ(SRCARY("NUM"),IEN,SRCARY("IFLD"),"I")
 .S:'SIFLG SIFLG=$$GET1^DIQ(SRCARY("NUM"),IEN,SRCARY("IDT"),"I")
 .I SIFLG Q
 .W !,"Please select a matching CSV file entry for the following LOCAL item:",!
 .W ITM_"  ("_SDESC_") "_"Inactive: "_$S(SIFLG:"Yes",1:"No"),!
 .W !,"Item failed automapping with the following message:"
 .W !,?5,$P(@SGLB@(IEN),U,2),!
 .S Y=$$DIRLKP($TR($$GLBPATH(TRGARY("GNAM"),"DATA"),")",","),$$GETP(TRGARY("XRI"),1,":"),.STATUS)
 .S TIFLG=$$GET1^DIQ(TRGARY("NUM"),+Y,TRGARY("IFLD"),"I")
 .I STATUS W ! S:STATUS=2 EX=1 Q
 .W !!,"You have elected to map: "
 .W ITM_"  ("_SDESC_") ","Inactive: ",$S(SIFLG:"Yes",1:"No"),"   to ",!
 .W $P(Y,U,2)_"   ("_$$GDESC("T",$$GLBPATH(TRGARY("GNAM"),"DATA"),+Y,TRGARY("DFLD"))_") ","Inactive: ",$S(TIFLG:"Yes",1:"No"),".",!
 .I $$YN("YES") D
 ..D UPDMAP(TRGARY("GNAM"),IEN,+Y,AMFLG)
 .; In the event the user does not want to map the selected item, prompt them again. They will have to '^' to skip the item. This needs
 .; to be in place in the event that the logic finds only one match automatically. It attempts to force the user to map, and if the user
 .; selects 'NO', it will skip them to the next item. They may not want to go on to the next item just yet.
 .E  G RS
 .W !!
 I '$$UNMAPPED(TRGARY("GNAM")) D
 .S @$$GLBPATH(TRGARY("GNAM"),"DONE")=1
 .W !,"Mapping has been completed for the ",$$GET1^DID(SRCARY("NUM"),,,"NAME")," file.",!
 Q
 ; Loop through entries and build UNMAP node
BLDLP ;
 N IEN,TGP,SGLB
 S SGLB=$$GLB(SRCARY("NUM"))
 S TGP=$$GLBPATH(TRGARY("GNAM"),"UNMAP")
 S IEN=0 F  S IEN=$O(@SGLB@(IEN)) Q:'IEN  D
 .S @TGP@(IEN)=0
 .S @TGP=+$G(@TGP)+1  ; Update UNMAP count
 ; Set BUILT node when completed
 S @$$GLBPATH(TRGARY("GNAM"),"BUILT")=1
 Q
 ; Loop through file entries
 ; SFN, TFN and TFNM must be defined
LOOP ;
 Q:'SRCARY("NUM")!'TRGARY("NUM")!('$L(TRGARY("GNAM")))
 N IEN,TGNM,SDATA,SGLB,TDATA,TIEN,MGNM
 S AMFLG="A"
 S SGLB=$$GLB(SRCARY("NUM"))
 S TGNM=$NA(^XCSV(TRGARY("GNAM"),"DATA"))
 S MGNM=$NA(^XCSV(TRGARY("GNAM"),"MAP"))
 ;
 S IEN=0 F  S IEN=$O(@SGLB@(IEN)) Q:'IEN  D
 .S SDATA=$G(@SGLB@(IEN,0))
 .Q:SDATA=""
 .S VAL=$P(SDATA,U)
 .S TIEN=$$IENLKP(TGNM,VAL,IEN,TRGARY("XRI"))
 .; AMFLG - indicates Auto or Manual mapping
 .D UPDMAP(TRGARY("GNAM"),IEN,TIEN,AMFLG)
 Q
 ; Return Next file
NXTFIL(CUR) ;EP
 S CUR=+$G(CUR)+1
 Q CUR_DDLM_$P($T(FILES+$G(CUR)),";;",2)
INIT ;EP
 S DLM=";",DDLM=";;",EXIT=0
 Q
 ; Setup variable for given file
 ; Input: SA - by reference = Source File Array
 ;        TA - by reference = Target File Array
SETFILE(VAL,SA,TA) ;EP
 N SRC,TRG
 S SRC=$$GETP(VAL,1,"/")
 S TRG=$$GETP($$GETP(VAL,2,"/"),1,"||")
 S SA("FNAM")=$$GETP($$GETP(VAL,2,"||"),1,"/")  ; Source File Name
 S SA("GNAM")=$$GETP(SRC,1,DLM)  ; Source File global name
 S SA("NUM")=$$GETP(SRC,2,DLM)  ; Source File Number
 S SA("XRI")=$$GETP(SRC,3,DLM)  ; Source File X-ref and Length
 S SA("DFLD")=$$GETP(SRC,4,DLM) ; Source File Description Field
 S SA("IFLD")=$$GETP(SRC,5,DLM) ; Source File Inactive flag
 S SA("IDT")=$$GETP(SRC,6,DLM)  ; Source File Inactive Date
 S TA("FNAM")=$$GETP($$GETP(VAL,2,"||"),2,"/")  ; Target File Name
 S TA("GNAM")=$$GETP(TRG,1,DLM)  ; Target File global name
 S TA("NUM")=$$GETP(TRG,2,DLM)  ; Target File Number
 S TA("XRI")=$$GETP(TRG,3,DLM)  ; Target File X-ref and Length
 S TA("DFLD")=$$GETP(TRG,4,DLM) ; Target File Description node and piece
 S TA("IFLD")=$$GETP(TRG,5,DLM) ; Target File Inactive flag
 S TA("IDT")=$$GETP(TRG,6,DLM)  ; Target File Inactive Date
 Q
 ; Return flag indicating file has been mapped
MPDONE(FIL) ;EP
 Q +$G(@$$GLBPATH(FIL,"DONE"))
 ; Return mapping status across all files
 ; Input: V - 0 = Silent mode (Default) ; 1 = Verbose mode:
ALLMAPDN(V) ;EP
 N RES,DLM,DDLM,EXIT,RES1,EFLG,FIL,OFF,STA
 D INIT
 S RES=1,V=$G(V,0)
 F  D  Q:$G(EFLG)
 .S FIL=$$NXTFIL(.OFF)
 .I $P(FIL,DDLM,2)="" S EFLG=1 Q
 .S STA=$$MPDONE($P($P($P(FIL,DDLM,2),"/",2),DLM))
 .W:V !,"Mapping has "_$S('STA:"not ",1:"")_"been completed for the ",$P($P(FIL,"||",2),"/",2)," file.",!
 .S RES=RES&STA
 Q RES
 ; Return flag indicating UNMAP node has been created
BUILT(FIL) ;EP
 Q +$G(@$$GLBPATH(FIL,"BUILT"))
 ; Return flag indicating auto map process has completed.
AMAPDN(FIL) ;EP
 Q +$G(@$$GLBPATH(FIL,"AUTO"))
 ; Update MAP and UNMAP nodes
 ; If a target mapping (TIEN) is present, the UNMAP node will be deleted.
 ; Otherwise, the TIEN is stored as the value of the UNMAP,SIEN) node.
UPDMAP(FIL,SIEN,TIEN,AMFLG) ;
 N MGLN,UMGLN
 S MGLN=$$GLBPATH(FIL,"MAP")
 S UMGLN=$$GLBPATH(FIL,"UNMAP")
 I TIEN D
 .; BWF - next line modified to add AMFLG
 .S @MGLN@(SIEN)=TIEN_"^"_AMFLG
 .; bwf - adding "B" x-ref for list of VA ien's that have been mapped to.
 .S @MGLN@("B",TIEN)=SIEN
 .K @UMGLN@(SIEN)
 .S @UMGLN=+$G(@UMGLN)-1  ; Update UNMAP count
 .S @MGLN=+$G(@MGLN)+1  ; Update MAP count
 E  D
 .S @UMGLN@(SIEN)=TIEN
 Q
 ; Delete mapped item from mapping list
DELMAP(FIL,SIEN) ;
 N MGLN,TIEN
 S MGLN=$$GLBPATH(FIL,"MAP")
 S TIEN=$P(@MGLN@(SIEN),U)
 K @MGLN@(SIEN)
 I TIEN K @MGLN@("B",TIEN)
 Q
 ; Return Count of items
 ; Input: FIL=FileName (ie. ICM)
 ;        NOD=Data node (ie. "MAP") 
MAPCNT(FIL,NOD) ;
 Q +$G(@$$GLBPATH(FIL,NOD))
 ; Return IEN from Target File (VA)
 ; If multiple entries are found, the first piece will be a zero followed by an error message
 ; except the SIEN will be returned if the VAL exists for the SIEN.
IENLKP(TGNM,VAL,SIEN,TXRI) ;EP
 N IEN,NXT,XRF
 S XRF=$$GETP(TXRI,1,":")
 S VAL=$$PREPVAL(VAL,TXRI,0)
 I TGNM["ICD9" S VAL=VAL_" "
 S IEN=$O(@TGNM@(XRF,VAL,0))
 S NXT=$O(@TGNM@(XRF,VAL,IEN))
 I NXT,$D(@TGNM@(XRF,VAL,SIEN)) Q SIEN
 I 'IEN D  Q:IEN IEN
 .S IEN=$$CHKXRF(VAL,TXRI)
 Q $S(NXT:"0^MULTIPLE ENTRIES FOUND",IEN:IEN,1:"0^IDENTICAL MATCH NOT FOUND")
 ; Perform lookup in xref using truncated value
CHKXRF(VAL,TXRI) ;EP
 N IEN
 S IEN=$O(@TGNM@($$GETP(TXRI,1,":"),$$PREPVAL(VAL,TXRI,1),0))
 Q $S('IEN:0,VAL=$P(@TGNM@(IEN,0),U):IEN,1:0)
 ; Return formatted value
 ; Input: V = Value to be prepared
 ;       XRF = XREF information (xref:length of value:(L/R)pad character(s) (AB:30:R )
 ;        T = Flag indicating if the value should be truncated to length
PREPVAL(V,XRF,T) ;EP
 N P,L
 S P=$$GETP(XRF,3,":")
 I T D
 .S L=$$GETP(XRF,2,":")
 .S V=$E(V,1,L)
 I $L(P) D
 .S V=$S($E(P)="L":$E(P,2,10)_V,$E(P)="R":V_$E(P,2,10),1:V)
 Q V
 ; Return value in string for given piece using delimiter
 ; STR=String to evaluate
 ;   P=Piece
 ;   D=Delimiter
GETP(STR,P,D) ;EP
 Q $P(STR,D,P)
 ; Return global associated with given File Number
GLB(FNUM) ;EP
 Q $$ROOT^DILFD(FNUM,,1)
 ; Return full global path for given filename
 ; Input: FIL=FileName (ie. ICM)
 ;        NOD=Data node (ie. "BUILT")
GLBPATH(FIL,NOD) ;EP
 Q $NA(^XCSV(FIL,NOD))
 ; Return flag indicating presence of unmapped entries
UNMAPPED(FIL) ;EP
 N MGLB,RES
 S MGLB=$$GLBPATH(FIL,"UNMAP")
 Q $D(@MGLB)=11
 ; Return flag indicating presence of File and Field in known list of fields pointing to file
 ; Input:  FIL - FileName in XCSV global (ie. ICM)
 ;         FILE - File containing field that points to FIL
 ;         FLD - Field in FILE that points to FIL
KNWNPTR(FIL,FILE,FLD) ;
 Q $D(@$$GLBPATH(FIL,"KPT")@(FILE,FLD))
 ; Return additional descriptive text
 ; Input: TYP - (S)ource or (T)arget
 ;        FIL - Either FileNumber if Source or Global root if Target
 ;        IEN - Specific entry
 ;        FLD - Field number if Source or Node/Piece if Target
 ;        VFLG - Return .01 value if flag is set
GDESC(TYP,FIL,IEN,FLD,VFLG) ;EP
 N RES
 S RES="",VFLG=$G(VFLG,0)
 I VFLG D
 .I TYP="S" S RES=$$GET1^DIQ(FIL,IEN,.01)_"  ("
 .E  I TYP="T" S RES=$P(@FIL@(IEN,0),U)_"  ("
 I $L(FLD) D
 .I TYP="S" D
 ..S RES=RES_$$GET1^DIQ(FIL,IEN,FLD)
 .E  I TYP="T" D
 ..S RES=RES_$P(@FIL@(IEN,$P(FLD,":")),U,$P(FLD,":",2))
 Q RES_$S(RES["  (":")",1:"")
 ; Returns result of Yes/No prompt
YN(DEF,PRMPT) ;EP
 N DIR,Y
 S DIR(0)="Y",DIR("B")=$G(DEF,"")
 S DIR("A")=$S($L($G(PRMPT)):PRMPT,1:"Are you sure")
 D ^DIR
 I $G(DTOUT)!$G(DUOUT) S RES=0
 E  S RES=Y
 Q RES
 ; Returns result of DIR lookup
 ;   Input: SRC - Source root
 ;          XRF - XREF to use for lookup
 ;   STA - 0=Successful;1=skip;2=Exit
DIRLKP(SRC,XRF,STA) ;EP
 N D,Y,X,DIR,DIROUT
 S:$E(SRC)'=U SRC=U_SRC
 S DIR(0)="P"_SRC_":AEMI    "
 S D=XRF
 D ^DIR
 I Y'>0!$G(DTOUT)!$G(DUOUT) D
 .S STA=$S($G(DIROUT):2,1:1)
 E  S STA=0
 Q Y
 ;
 ;FILES TO MAP
 ;IHS Global Name;IHS File Number;IHS Formatting;Additional Info Field/VA Global Name;VA File Number;VA Formatting;Addition Info Field||IHS Filename/VA Filename
 ;Formatting contains: XREF:Length of Value:(L/R)Pad character(s) (supports up to 9 pad characters)
FILES ;;
 ;;ICM;80.3;B:30;.01;/ICM;80.3;B:30;0:1;||MAJOR DIAGNOSTIC CATEGORY/MAJOR DIAGNOSTIC CATEGORY
 ;;ICD;80.2;B:30;.01;15;16/ICD;80.2;B:30;0:1;15;16||DRG/DRG
 ;;DIC|81.1;81.1;B:63;.01;/DIC|81.1;81.1;B:63;0:1;||CPT CATEGORY/CPT CATEGORY
 ;;ICD0;80.1;AB:30;10;100;102/ICD0;80.1;AB:30;0:4;100;102||ICD OPERATION PROCEDURE/ICD OPERATION PROCEDURE
 ;;AUTTCMOD;9999999.88;B:30;.02;/DIC|81.3;81.3;B:30;0:2;5||CPT MODIFIER/CPT MODIFIER
 ;;ICD9;80;AB:30;10;100;102/ICD9;80;AB:30;0:3;100;102||ICD DIAGNOSIS/ICD DIAGNOSIS
 ;;ICPT;81;B:30;2;5;8/ICPT;81;B:30;0:2;5;7||CPT/CPT
 Q
