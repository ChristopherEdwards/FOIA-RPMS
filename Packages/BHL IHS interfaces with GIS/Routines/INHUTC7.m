INHUTC7 ;KN,bar; 14 Aug 97 11:33; Criteria Management and Execution API
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 ;
 ; MODULE NAME: Criteria Management and Execution API (INHUTC7)
 ; Called from INHUTC.
 ;
GETCRIT(INOPT,INPARMS) ; Get/Create entries.
 ;
 ; Please refer to the function GETCRIT of INHUTC for description
 ;
 ; set defaults for vars passed in
 N INCRITDA
 Q:'$$TYPE^INHUTC2($G(INOPT("TYPE"))) "Incorrect or missing criteria type."
 S:'$G(INOPT("DUZ")) INOPT("DUZ")=DUZ
 ; get entry in criteria file
 S INCRITDA=$$GET^INHUTC1(.INOPT)
 Q:'INCRITDA INCRITDA
 ; populate entry with data if passed in
 I $L($G(INPARMS)),$D(@INPARMS)>9 D ARRAY^INHUTC3(INCRITDA,.INPARMS)
 ; update relative date fields
 D RELDATE^INHUTC2(INCRITDA)
 ; if gallery allow edit
 S:$L($G(INOPT("GALLERY"))) INCRITDA=$$EDIT^INHUTC1(INCRITDA,INOPT("GALLERY"))
 I 'INCRITDA D CLRLK^INHUTC2(.INOPT) Q INCRITDA
 ; save entry if name field is filled in
 S INCRITDA=$$SAVE^INHUTC1(.INOPT,INCRITDA,"U")
 I 'INCRITDA D CLRLK^INHUTC2(.INOPT) Q
 D CLRLK^INHUTC2(.INOPT,$S('INCRITDA:0,$G(INOPT("LOCK")):INCRITDA,1:""))
 ; set INOPT for search and print
 S INOPT("CRITERIA")=INCRITDA
 Q INCRITDA
 ;
 ;
RUN(INOPT,INPARMS) ; Run calling search and print
 ;
 ; Please refer to function RUN of INHUTC for description, 
 ;
 N INANS,INDEV,INOPTT,ZTSK,INIEN,INARRAY
 ; preserve INOPT array
 M INOPTT=INOPT N INOPT M INOPT=INOPTT K INOPTT
 S INPARMS=$G(INPARMS)
 I '$G(INOPT("CRITERIA")) S INOPT("CRITERIA")=$$GETCRIT^INHUTC(.INOPT,.INPARMS)
 Q:'INOPT("CRITERIA") INOPT("CRITERIA")
 ; get device, check if passed in, then check file
 I $D(INOPT("DEVICE")) S (INDEV,IOP)=$D(INOPT("DEVICE"))
 E  S (INDEV,IOP)=$P($G(^DIZ(4001.1,INOPT("CRITERIA"),20)),U,9)
 S %ZIS="NQ0" D ^%ZIS I POP S IOP="",%ZIS="N0" D ^%ZIS Q INDEV_" is an invalid device"
 ;
 ; if home device, crt, and interactive do full display search
 I IO=IO(0),$E(IOST)="C",'$G(INOPT("NONINTER")) S INIEN="INARRAY" D  K @INIEN Q $S(INANS:"Exit code: "_INANS,1:INOPT("CRITERIA"))
 . ; Search, Display, and allow user to select
 . S INANS=$$DISPLAY^INHUTC4(.INOPT,.INIEN) S:INANS'=2 INANS=0 Q:INANS
 . ; return selected list in named global, if requested
 . I $L($G(INOPT("ARRAY"))) M @INOPT("ARRAY")=@INIEN S INANS=4 Q
 . ; Print user selected list
 . I $D(@INIEN)>9 S INANS=$$PRINT(.INOPT,.INIEN)
 ;
 ; if OK TO TASK, if not SLAVE or CRT
 I '$G(INOPT("NOTASK")),IO'=IO(0) D  S IOP="",%ZIS="N" D ^%ZIS Q INANS
 . N INDA,INBACKDA,INOPTT
 . ; create background entry, unlock work entry and background entry
 . S INBACKDA=$$NEW^INHUTC1(.INOPT,"B") D COPY^INHUTC1(INOPT("CRITERIA"),INBACKDA,"B") D CLRLK^INHUTC2(.INOPT)
 . ; create background task
 . S ZTIO=INDEV,ZTRTN="TASK^INHUTC2",ZTDESC="Interface Criteria"
 . S:$G(INOPT("NONINTER")) ZTDTH=$H
 . S INOPT("NOTASK")=1,INOPT("NONINTER")=1,INOPT("CRITERIA")=INBACKDA
 . F I="INIEN","INOPT(" S ZTSAVE(I)=""
 . D ^%ZTLOAD
 . I $G(ZTSK) S $P(^DIZ(4001.1,INBACKDA,0),U,7)=ZTSK
 . S INANS=$S($G(ZTSK):"criteria queued "_ZTSK,$G(POP):"device invalid",1:"error in scheduling task.")
 ; Non-interactive search
 S INIEN="INARRAY",INANS=$$SEARCH^INHUTC(.INOPT,.INIEN)
 Q:'INANS INANS
 S INOPT("DEVICE")=INDEV,INANS=$$PRINT^INHUTC(.INOPT,.INIEN)
 K @INIEN,INOPT("INSRCH")
 Q INOPT("CRITERIA")
 ;
 ;
PRINT(INOPT,INIEN) ; Display/Print messages
 ;
 ; Please refer to the function PRINT of INHUTC for description
 ; 
 Q:'$L($G(INIEN)) "PRINT: record list not present"
 N I,DIC,DR,DHD,DW,DWCP,DIE,DA,INIO,INPAGE
 ; Set default value for file, print template, and header
 I $G(INOPT("TYPE"))="ERROR" S DIC="^INTHER(",DR="INH ERROR DISPLAY"
 I $G(INOPT("TYPE"))="TRANSACTION" S DIC="^INTHU(",DR="INH MESSAGE DISPLAY"
 Q:'$D(DIC) "PRINT: record type not present or invalid"
 S INPAGE=0,DHD="["_DR_"-HEAD]",DIOEND="W !?(IOM-25\2),""***** End of Report *****""",DA=INIEN
 ; Use print template, custom header, if provided
 S:$D(INOPT("PRINT")) DR=INOPT("PRINT") S:$E(DR)'="[" DR="["_DR_"]"
 S:$D(INOPT("HEADER")) DHD=INOPT("HEADER") S:$E(DHD)'="[" DHD="["_DHD_"]"
 ; get device
 S:$L($G(INOPT("DEVICE"))) IOP=INOPT("DEVICE")
 I $G(INOPT("NONINTER")),'$D(IOP) S IOP=""
 S %ZIS="NQ" D ^%ZIS I POP S IOP="",%ZIS="N0" D ^%ZIS Q "Device invalid or not selected."
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 D PRESORT^DWPR
 Q 1
 ;
SRCHDR(INOPT,INPAGE) ; print cover page of criteria options
 ; from print template
 Q:'$D(INOPT("INSRCH"))  Q:'$D(INPAGE)
 N X,I,INI,INF,INL,INX,INY,INZ
 I 'INPAGE D
 . S X=INOPT("INSRCH","TYPE"),X=$E(X)_$$DNCASE^%ZTF($E(X,2,$L(X)))
 . S X="Interface "_X_" Search Report",X=$J("",IOM-$L(X)\2)_X,INOPT("INSRCH","PRNHDR",1)=X_$J("",IOM-$L(X)-9)_"Page: "
 . S X="Report Date: "_$$CDATASC^%ZTFDT($$NOW^%ZTFDT,1,3)_"   Run by: "_$P($G(DUZ("AG")),U,9),INOPT("INSRCH","PRNHDR",2)=$J("",IOM-$L(X)\2)_X
 . S X="Records "
 . S:$G(INOPT("SRCHSIZE")) X=X_"in range: "_INOPT("SRCHSIZE")_"(est) "
 . S X=X_" Searched: "_+$G(INOPT("INSRCHCT"))_"  Found: "_+$G(INOPT("INFNDCT"))
 . S INOPT("INSRCH","PRNHDR",3)=$J("",IOM-$L(X)\2)_X
 S INPAGE=INPAGE+1
 F I=1:1 Q:'$D(INOPT("INSRCH","PRNHDR",I))  W:I>1 ! W INOPT("INSRCH","PRNHDR",I)_$S(I=1:INPAGE,1:"")
 W !!,$TR($J("",IOM-2)," ","_")
 Q:INPAGE>1
 W !,"  Search Criteria Name",?40,"  Criteria Value",!
 F INI=6:1 S INX=$P($T(FIELDS+INI^INHUTC3),";;",2,99) Q:'$L(INX)  D
 . ; quit if no INSRCH designator or not searched on
 . S INY=$P(INX,";",3) Q:'$L(INY)  Q:'$D(INOPT("INSRCH",INY))
 . ; write field name
 . W !,$P(INX,";",2),?40 S INF=$P(INX,";",4,99)
 . ; write out parameters
 . I $D(INOPT("INSRCH",INY))=1 S X=INOPT("INSRCH",INY) X:$L(INF) INF W X Q
 . S INZ="",INL=0 F  S INZ=$O(INOPT("INSRCH",INY,INZ)) Q:'$L(INZ)  W:INL !?40 S X=INZ X:$L(INF) INF W X S INL=1
 ; skip a page and print next header, unless nothing was found
 I $G(INOPT("INSRCH","INFNDCT")) D
 . I IO=IO(0),$E(IOST)="C" S %=$$CR^UTSRD
 . E  W @IOF
 . D SRCHDR(.INOPT,.INPAGE)
 Q
 ;
