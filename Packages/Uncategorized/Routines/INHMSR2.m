INHMSR2 ;KN; 4 Mar 96 14:12; Statistical Report - Display 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ; 
 ; Module Name: Statistical Report Display Module (INHMSR2).
 ;
 ; PURPOSE:  
 ; The purpose of the Statistic Report Display Module (INHMSR2)
 ; is to calculate the statistic, display, and print the 
 ; statistic report.
 ; 
 ; DESCRIPTION:
 ; The processing of this routine will search the global and
 ; calculate statistic based on user input criteria.
 ; This routine will perform as the follows:
 ; - Locate the data for the field selected, i.e. from what node
 ;   and which piece of that node.
 ; - Search the global, count the number of occurance for the 
 ;   selected field, and save the statistic in INCNT array.
 ; - Display the statistic results in INCNT array to screen or
 ;   to printer as selected by the user
 ;
 ;   Input: INA array
 ;   Output: INCNT array of statistic data.
 ;
 Q
STAT(INIEN,INA,SEL) ; Entry point for Statistical Report Display Module
 ; Return = None
 ; Parameters:
 ;    INIEN = File ien
 ;    INA = Array for user selected criteria
 ;    SEL = Number of selection that user made
 ; Code begins: 
 N:'$D(ZTSK) %DT,INSD,INED,ZTSK,FLD,GLNM,INTYPE
 ; Get global name, ex:^INTHU
 S GLNM=$$GLN^INHMSR20(INIEN),INTYPE=""
 ; Get the range to search
 D RANGES^INHMSR21(.INA)
 ; queu the task, for display or printing
 S ZTRTN="STATTSK^INHMSR2" D QUEUE Q:$D(ZTSK)  Q:POP  D WAIT^DICD
STATTSK ;TaskMan entry point to print message statistic
 N:'$D(ZTSK) INCNT,S,C,INT,INJ,INGL,IINCNT,INHD,INE,INS,DUOUT,INPAGE,INND,INPC
 ; For maximum of 4 fields selected, excluding date/time, loop.
 F INJ=1:1:($G(SEL)-1) D
 .; SEL= number of selection user made
 .S:SEL>INJ FLD(INJ)=$O(INA(FLD(INJ-1)))
 .; Set type for use in HEAD^INHMSR21, only concate if field is selected
 .S:$G(FLD(INJ)) INTYPE=INTYPE_$S(INTYPE="":" ",1:"/")_$G(INA(FLD(INJ),2))
 .; INGL=location of the data(node and piece), s(inj)=data field
 .; Get piece and node where the data are at 
 .S INGL=$$GNDP^INHMSR20(INIEN,INA(FLD(INJ),1)),INND(INJ)=$P(INGL,";"),INPC(INJ)=$P(INGL,";",2)
 .; int(inj)=the field type (number, date,...).
 .; set the indirect INA array for the field type
 .S:SEL>INJ IINA="INA(FLD(INJ),6)",INT(INJ)=$G(INA(FLD(INJ),6)),INS(INJ)=$$PRVF^INHMSR20($G(INA(FLD(INJ),3)),.IINA),INE(INJ)=$$NXTF^INHMSR20($G(INA(FLD(INJ),4)),.IINA)
 ; Depends on the number of the selection, define indirect incnt array
 ; Only count date for file 4001 and 4003
 I (INIEN=4001)!(INIEN=4003) S IINCNT="INCNT(INKIM,"
 E  S IINCNT="INCNT("
 ;INL is the new level for the display array
 N INL,INOD0
 ; For date/time field  
 S INL=1,INDP(INL)=$G(INA(FLD(0),2))
 F INJ=1:1:$G(SEL)-1 D
 .S:"Yy"[INA(FLD(INJ),7) IINCNT=IINCNT_"S("_INJ_"),",INL=$G(INL)+1,INDP(INL)=$G(INA(FLD(INJ),2))
 S IINCNT=$E(IINCNT,1,$L(IINCNT)-1)_")",INSEL=$G(INL)
 ; IN1FT=type of field 1, to compare for pointer or date
 ; IN1FT is used for Interface Formatter Task where the field .01 
 ; is pointer to a file
 S IN1FT=$G(INA(FLD(0),6))
 S INT=INSD F  S INT=$O(@(GLNM_"""B"",INT)")) Q:'INT  Q:INT>INED  D
 .; call function CMPEXT to compare external value for the pointer
 .; only use for Interface Formatter Task file
 .I $$CMPEXT^INHMSR21(INT,IN1FT)  Q
 .; From the cross reference, get the field ien e.g: INX=field ien
 .S INX=0 F  S INX=$O(@(GLNM_"""B"",INT,INX)")) Q:'INX  D
 ..; If node 0 of the field has value, ex: G(^INTHU(0))
 ..S INOD0=$G(@(GLNM_"INX,0)"))
 ..I INOD0'="" D
 ...;process computed field
 ...F INJ=1:1:($G(SEL)-1) I $G(FLD(INJ)) D COMPTD
 ...; For the date/time 
 ...S INKIM=$P(INOD0,U),Y=INKIM\1 D DD^%DT S INKIM=Y
 ...S OK=1
 ...; OK=flag for count, loop and compare if data in the range
 ...F INJ=1:1:($G(SEL)-1) I '$$CMP^INHMSR20(S(INJ),INT(INJ),INS(INJ),INE(INJ)) S OK=0  Q
 ...S:OK @IINCNT=$G(@IINCNT)+1
 ; Header for pointer to file of .01 field
 I (IN1FT["P")&(INA(0)=1) D
 . I INSD(1)="" S INSD(1)=$O(INP(""))
 . I INED(1)="" S INED(1)=$O(INP(""),-1)
 W:'$D(ZTSK) @IOF D:$E(IOST,1,2)="C" CLEAR^DW D HEAD^INHMSR21(INIEN,.INA,INTYPE)  Q:$G(DUOUT)
 ;Display the range
 S INXFLG=0
 F INJ=1:1:$G(SEL)-1 D
 .I INXFLG W !?(INJ*3),$G(INA(FLD(INJ),2))," : ",$G(INA(FLD(INJ),3))," - ",$G(INA(FLD(INJ),4))
 .I 'INXFLG W !,"By : ",$G(INA(FLD(INJ),2))," : ",$G(INA(FLD(INJ),3))," - ",$G(INA(FLD(INJ),4)) S INXFLG=1
 W:INXFLG !
 ; Calculate total
 ; Call FILL to full up the count array with total and subtotal
 D FILL^INHMSR20(.INCNT,"INCNT")
 S LEVEL=0,SEL=$G(SEL)
 ; Call FILL1 to display output of the field
 D FILL1^INHMSR20(.INCNT,"INCNT")
 Q:$G(DUOUT)
 D:$G(SEL)'>1 INDASH^INHMSR21 W !!?4,"REPORT TOTAL" D ADJ^INHMSR21($G(INCNT)) W !!,$G(INA("FT"))
 ; end of report
 W !!,$J("",30)_"*** End of Report ***"
 ; clean up variable
 D:$D(ZTSK) CLNUP^%ZTLOAD(.ZTSK)
 Q
 ;
COMPTD ;Check and process computed field
 I (INA(FLD(INJ),6)'["C") S S(INJ)=$P($G(@(GLNM_"INX,"_INND(INJ)_")")),U,INPC(INJ))
 E  S D0=INX X INA(FLD(INJ),8) S S(INJ)=X
 I S(INJ)="" S S(INJ)="Null"  Q
 ; Call function INXMVG to check internal to external 
 S S(INJ)=$$INXMVG^INHMSR22(INIEN,INA(FLD(INJ),1),S(INJ))
 Q
QUEUE ; 
 ; Description:  The function QUEUE is used to select device for
 ;               the output and queue if necessary. 
 ; Return: None
 ; Parameters: 
 ; Code begins:
 K IOP D ^%ZIS Q:POP  S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 Q:IO=IO(0)
 S ZTIO=IOP K IOP D ^%ZISC
 F I="INSD","INED","FLD(","INA(","INED(","INSD(","GLNM","INIEN","INTYPE","SEL","HEADER","IN1FT","INDP" S ZTSAVE(I)=""
 D ^%ZTLOAD W !?5,"Request "_$S($D(ZTSK):"",1:"NOT ")_"QUEUED!" Q
 ;
