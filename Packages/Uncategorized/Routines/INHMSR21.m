INHMSR21 ;KN; 12 Jan 96 12:02; Statistical Report-Utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Statistical Report Display Module (INHMSR21).
 ;
 ; DESCRIPTION: The purpose of the INHMSR21 is used to contain
 ;              the functions and support for INHMSR2 and 
 ;        INHMSR20.
 ;
HEAD(FLIEN,INA,INTYPE) ; Header.
 ;
 ; Description:  The function HEAD is used to display/print report
 ;               header.
 ; Return: None
 ; Parameters:
 ;    FLIEN = File ien
 ;    INA = Array of user selected criteria
 ;    INTYPE = all field type selected by user
 ;
 ; Code begins:
 N L,I,X,Y,H
 K DUOUT S INPAGE=+$G(INPAGE)
 ;Initialize site name and today date
 S INSITE=$S($D(^DIC(4,^DD("SITE",1),0)):^(0),1:^DD("SITE")),INSITE=$S($P(INSITE,"^",4)]"":$P(INSITE,"^",4),1:$P(INSITE,"^",1))
 I '$D(INDT) D NOW^%DTC S Y=$J(%,12,4) D DD^%DT S INDT=Y
 ; Beep for the new page.
 ; Set timeout=120 seconds to quit
 I IO=IO(0),'$D(ZTSK),$E(IOST,1,2)="C-",INPAGE W !,*7,$G(INA("FT")),!  D ^UTSRD("Press <RETURN> to continue or ^ to QUIT;;;;;;;0;;;;DTIME;;X","","",1) S:(X=1)!(X=2) DUOUT=1
 Q:$G(DUOUT)
 W:INPAGE @IOF S INPAGE=INPAGE+1
 ; Get FNAM to display in header.
 S GLNM=$$GLN^INHMSR20(FLIEN),FNAM=$P(@(GLNM_"0)"),U,1),H=IOM/2
 S L=FNAM_" STATISTICS"
 W $G(INA("HD"))
 W !,INSITE,?(IOM-28),INDT,?(IOM-9),"Page",INPAGE,!!!?(H-($L(L)\2)),L
 S L="From:   "_INSD(1)_"     To:   "_INED(1) W !?(H-($L(L)\2)),L,!
 W ! K Z S $P(Z,"-",IOM)="" W Z
 W !?3,"Field Name",?(IOM-10),"Count"
 W ! K Z S $P(Z,"-",IOM+1)="" W Z
 Q
 ;  
RANGES(INA) ; Ranges input
 ; 
 ; Description:  The function RANGES is used to determine the 
 ;               search range based on user select criteria.
 ; Return: none
 ; Parameters: 
 ; INA = Array of user selected criteria
 ;
 ; Code begins:
 ; field .01 is selected
 I INA(0)=1 D
 .S FLD(0)=$O(INA(0))
 .S I=$O(INA(0))
 .S INSD=$G(INA(I,3)),INED=$G(INA(I,4))
 .; field .01 is date, convert to time format
 .I INA(I,6)["D"  D  Q
 ..;INA array now contains external form, change conversion
 ..S INSD(1)=INSD,INED(1)=INED,%DT="TX"
 ..S X=INSD D ^%DT S INSD=Y-.0000001
 ..S X=INED D ^%DT S INED=Y S:INED\1=INED INED=INED+.24
 ..I INSD(1)="" S INSD=$O(@(GLNM_"""B"","""")")),Y=INSD,%DT="TX" D DD^%DT S INSD(1)=Y
 ..I INED(1)="" D NOW^%DTC S INED=%,Y=$J(%,12,4),%DT="TX" D DD^%DT S INED(1)=Y
 .I INA(I,6)'["D"  D  Q
 ..; if field .01 is not date, is pointer or free text
 ..; Search the whole file
 ..S INSD="",INED=$O(@(GLNM_"""B"","""")"),-1)
 ..S INSD(1)=$G(INA(FLD(0),3)),INED(1)=$G(INA(FLD(0),4))
 ..; for pointer then convert
 ..I INA(I,6)["P" D
 ...S INGNM=$$GPC3^INHMSR10(INIEN,.01),A="^"_INGNM_"""B"""_")"
 ...I INSD(1)'="" S INSD(1)=$O(@A@(INSD(1)))
 ...I INED(1)'="" S INED(1)=INED(1)_"~",INED(1)=$O(@A@(INED(1)))
 ...;I INED(1)="" S INED(1)=$O(@A@(""),-1)
 I INA(0)'=1 D
 .; no range for .01 field
 .S:$G(INA(0))=0 FLD(0)=$O(INA(0))
 .S:$G(INA(0))=2 FLD(0)=0,SEL=$G(SEL)+1
 .S INSD="",INSD(1)=$O(@(GLNM_"""B"","""")"))
 .S (INED,INED(1))=$O(@(GLNM_"""B"","""")"),-1)
 .; call function HDCON to convert to external value for header
 .S INSD(1)=$$HDCON^INHMSR22(INIEN,.01,INSD(1)),INED(1)=$$HDCON^INHMSR22(INIEN,.01,INED(1))
 Q
 ;
ADJ(NUM) ; 
 ;
 ; Description:  The function ADJ is used to right justify a number, 
 ;  width=7
 ; Return: None
 ; Parameters:
 ;    NUM = Number to display
 ;
 ; Code begins:
 W ?(IOM-13),$$JUST^UTIL($G(NUM),7,"R",0)
 Q
 ;
DISF(L,SK,FTYP,FNAM) ; Display field 
 ;
 ; Description:  The function DISF is used to display a field type 
 ;               and field name.
 ; Return: None
 ; Parameters:
 ;    L   = left margin
 ;    SK   = a flag - 0: display field type, 1: skip
 ;    FTYP = Field type
 ;    FNAM = Name of the field
 ;
 ; code begins
 I SK=0  D
 .; For long type > 30 chars goes to new line
 .W !?$G(L),$G(FTYP)_" : "
 .I (($L(FTYP)+$G(L))>30) W !?($G(L)+5),$G(FNAM)
 .I (($L(FTYP)+$G(L))'>30) W $G(FNAM)
 I SK'=0  D
 .I (($L(FTYP)+$G(L))>30) W !?($G(L)+5),$G(FNAM)
 .I (($L(FTYP)+$G(L))'>30) W !?($L(FTYP)+$G(L)+3),$G(FNAM)
 Q
 ;
INDASH ; Dash
 ;
 ; Description:  The function INDASH is used to display a dash 
 ;               for count total.
 ; Return: none
 ; Parameters: none
 ;
 ; Code begins:
 W !?(IOM-10),"-------"
 Q
 ;
INLN(STR,NUM) ; Line
 ;
 ; Description:   The function INLN is used to return to second line 
 ;                if display is too long.
 ; Return: none
 ; Parameters:
 ;    STR = String to display
 ;    NUM = Start new line at NUM+5 characters
 ;
 ; Code begins:
 I $X>30 W !?($G(NUM)+5),STR
 E  W STR
 Q
 ;
CMPEXT(IN,IN1FT) ; Compare external value for the pointer
 ;
 ; Description:  The function CMPEXT is used to compare IN value
 ;  for a pointer or free text if user select a range.
 ;  IN1X is the external value.  If IN is in the range
 ;  selected then continue the count, i.e. return 0
 ; Return:  1 = for quit
 ;     0 = for continue
 ; Parameters:
 ; IN = value to compare
 ;
 ; Code begins:
 N INTMP,IN1X
 ; Initialize the return value, default = 0 (continue)
 S INTMP=0
 ; if user select range for field .01 and it is pointer or freetext
 I (INA(0)=1)&((IN1FT["P")!(IN1FT["F"))  D
 .; for the pointer, get its external value
 .S:IN1FT["P" IN1X=$$INXMVG^INHMSR22(INIEN,INA(FLD(0),1),$G(IN))
 .; for the freetext, get the value
 .S:IN1FT["F" IN1X=$G(IN)
 .; save external value for header
 .I '$D(INP($G(IN1X))) S INP($G(IN1X))=""
 .; then compare if it is in selected range
 .; If no from the range
 .I INA(FLD(0),3)="" S:INA(FLD(0),4)_"~"']IN1X INTMP=1
 .; If no to the range
 .I INA(FLD(0),4)="" S:IN1X']INA(FLD(0),3) INTMP=1
 .; If both from and to then keep the same
 .I (INA(FLD(0),3)'="")&(INA(FLD(0),4)'="") S:(INA(FLD(0),3)]IN1X)!(INA(FLD(0),4)_"~"']IN1X) INTMP=1
 Q INTMP
