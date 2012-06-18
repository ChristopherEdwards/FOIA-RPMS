INHMSR1 ;KN; 31 Jan 96 09:56; Statistical Report Definition Screen. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Statistical Report Definition Screen (INHMSR1).
 ;   
 ; PURPOSE:
 ; The purpose of the Statistic Report Definition Module (INHMSR1)
 ; is to display statistic definition screen, and accept user's
 ; selected criteria.
 ; 
 ; DESCRIPTION:
 ; The processing of this routine will use List Processor (DWL)  
 ; to display the definition screen for the user to select sort
 ; criteria, range for the items selected and the total option.
 ; Predefined selectable fields are stored in global 
 ; ^UTILITY("INHSR").  The routine will call function GATHER  
 ; to construct INA array.  It calls function GVL to validate user's
 ; input entry as maximum of five items can be selected and the 
 ; range should be valid depends on item selected.  It calls function 
 ; INACHK to verify field .01 range.  It calls function INHELP to get 
 ; help for range input. The hot key will allow the user select from 
 ; the following options:
 ; . Run to calculate statistic and display report on the screen
 ;   or send it to the printer.
 ; . Header/Footer to add optional header/footer to the statistic 
 ;   report.
 ; . Abort to exit the screen.
 ;
 Q
 ;
EN(INIEN,INNM) ; Entry point for Statistic Report Definition Module
 ;
 ; Return: none
 ; Parameters:    
 ; INIEN = File ien
 ; INNM  = Name of file for statistic report
 ; Code begins
 N INX,INHEAD,IN,INCNT,INA,INQ,INFLD,INRB,SEL,HEADER,INF1,HD,FT,INFLG,ZTSK
 S (INCNT,INFLG)=0
 ; Check if file selected has pre-defined field in global. 
 S INFLG=$D(^UTILITY($J,"INHSR",INIEN))#10
 ; Search ^DD cross reference for field ien (infld=field name)
 S INFLD=0 F  S INFLD=$O(^DD(INIEN,INFLD)) Q:'INFLD  D
 .S INX=$P(^DD(INIEN,INFLD,0),U,1)
 .; only display selectable fields predefined in global
 .I $$ISTHERE^INHMSR10(INIEN,INFLD,INFLG)  D
 ..; Initialize incnt=number of selection user made
 ..S INCNT=$G(INCNT)+1
 ..; IN(col,row), ex:col=2 is field name i.e. INX
 ..S IN(1,INCNT)="",IN(2,INCNT)=INX,IN(3,INCNT)="",IN(4,INCNT)="",IN(5,INCNT)="",IN(6,INCNT)=INFLD
 ..S:INFLD=.01 INF1=INX
 ..; ListMan, make column 1,3,4,5 selectable.
 ..S IN(1,INCNT,0)="",IN(3,INCNT,0)="",IN(4,INCNT,0)="",IN(5,INCNT,0)=""
 ..; 1.Make col 1 editable, 2. width=1, 3. input validation 
 ..S IN(1,INCNT,"DQ")="",IN(1,INCNT,"DQ",0)=1,IN(1,INCNT,"DQ",1)="K:X'?1N!(X>5)!(X<1) X"
 ..S IN(1,INCNT,"DQ","?")="D POP^DWLR2(4,1) W ""Enter a number from 1 to 5.   The number is used to indicate the sort order."" I $$CR^UTSRD"
 ..S (IN(3,INCNT,"DQ"),IN(4,INCNT,"DQ"))="",(IN(3,INCNT,"DQ",0),IN(4,INCNT,"DQ",0))=20,(IN(3,INCNT,"DQ","?"),IN(4,INCNT,"DQ","?"))="D INHELP^INHMSR10("_INIEN_","_INFLD_")",(IN(3,INCNT,"DQ",1),IN(4,INCNT,"DQ",1))=$$GVL^INHMSR10(INIEN,INFLD)
 ..S IN(5,INCNT,"DQ")="",IN(5,INCNT,"DQ",0)=1,YN="YNyn",IN(5,INCNT,"DQ",1)="K:X'?1A!(YN'[X) X",IN(5,INCNT,"DQ","?")="D POP^DWLR2(4,1) W ""Enter Y or N to indicate whether a count for this field is desired."" I $$CR^UTSRD"
 ; Set hot key for selection - Graph not used - DWLHOT(2)="Graph^GRAPH
 S DWLHOT(1)="FILE/EXIT^R",DWLHOT(3)="Hd/Ft^HDFT",DWLHOT(4)="Exit^A"
 S INHEAD="D HEADER^INHMSR1(INNM)"
 D HOTSET^DWL
 W @IOF
 ;Setup for list processor
 S INRB=0,INQ=0,DWLRF="IN",DWLB="0^3^15^2^25^20^20^2",DWL="KCHQ2FZWXXA5",DWL("TITLE")=INHEAD
 ; Processing loop
 F  Q:INQ=1  D
 .; Rebuild in array if error
 .D:INRB RBIN(.INA)
 .S INRB=0
 .D ^DWL
 .I (DWLR="R") D  Q
 ..; If press run, then rebuild INA array, SEL=0 
 ..S SEL=$$GATHER^INHMSR11(.INA,INCNT)
 ..I SEL=0 S INQ=0,INRB=1
 ..E  D R(INIEN,SEL,.INA) S INQ=1
 .;I DWLR="GRAPH" D GRAPH S SEL=$$GATHER^INHMSR11(.INA,INCNT),INQ=0,INRB=1
 .I DWLR="HDFT" D HDFT S SEL=$$GATHER^INHMSR11(.INA,INCNT),INQ=0,INRB=1 Q
 .I DWLR="A" S INQ=1 W @IOF  Q
 .; Abort and File/Exit key 
 .I DWLR="^" S INQ=1 W @IOF  Q
 .I DWLR="^^" S INQ=1 W @IOF  Q
 .;Ignore if user hit enter key
 .I +DWLR>0 W *7 S SEL=$$GATHER^INHMSR11(.INA,INCNT),INQ=0,INRB=1
 Q
 ;
RBIN(INA) ; Rebuild IN array.
 ;
 ; Description:  The function RBIN is used to rebuild IN display 
 ;               array if error occurs.
 ; Return: none
 ; Parameter:
 ;    INA = Name of statistical report criteria array.
 ; Code begins:
 N INX
 ; Loop thru ina array, inx=order, i=row where selection is at
 S INX=0 F  S INX=$O(INA(INX)) Q:INX=""  D
 .S I=$G(INA(INX,5))
 .; Rebuild column 1 and 5 (order and total)
 .S IN(1,I,"DQ")=INX
 .S IN(5,I,"DQ")=$G(INA(INX,7))
 .; ina(order,6) contains type of the field
 .S IN(3,I,"DQ")=$G(INA(INX,3)),IN(4,I,"DQ")=$G(INA(INX,4))
 Q
 ;
R(INFL,SEL,INA) ; Entry point for Hotkey run
 ;
 ; Description:  The function R is used to pass the INA array 
 ;   to module INHMSR2 for calculate statistic and display.
 ; Return: none
 ; Parameters:
 ;    INFL = File ien (internal entry number) 
 ;    SEL  = Number of selection that user made.
 ;    INA  = Array of user selected criteria.
 ; Code begins:
 W @IOF
 N P1
 S INA("INHD")=$G(INHD),INA("INFT")=$G(INFT)
 D STAT^INHMSR2(INFL,.INA,SEL)
 Q
 ;
HDFT ;Header and footer
 ;
 ; Description:  The function HDFT is used to ask user to 
 ;     enter text used for the report Header or Footer.
 ; Return: none
 ; Parameter: none
 ; Code begins:
 W @IOF
 ; NOTE: 2 - required input or timed out; 30 = wait 30 seconds
 S P1="Please Enter Header: ;;2,10;;;;;2;;INHD;;30;;IN"
 W ! D ^UTSRD(P1,"","",1)
 S P1="Please Enter Footer: ;;2,20;;;;;2;;INFT;;30;;IN"
 W ! D ^UTSRD(P1,"","",1)
 Q
 ;
HEADER(INNM) ;Header
 ; 
 ; Description:  The function HEADER is used to display DWL 
 ;  header, and hot key selection.
 ; Return: None
 ; Parameters:
 ;    INNM = Name of the current selected file.
 ; Code begins:
 ; Call function to display the header's name  
 S INTXT="STATISTICAL REPORT DEFINITION" W ?(IOM-$L(INTXT))/2,INTXT,!
 ; Call function to display the DWL screen for user select
 W ?(IOM-$L(INNM))/2,INNM,!,"Order ","Field Name",?33,"From",?55,"To",?73,"Count"
 ; Display Hotkey for information.
 W $$SETXY^%ZTF(0,19),DWLMSG
 Q
