INHES1 ;Utilities; 1 Feb 96 08:44 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;
LIST(INSRCH,DWLRF,INL) ; Build the error array
 ; 
 ; Module Name: LIST ( Build the list of matching errors )
 ;
 ; Description: 
 ; Loop through the errors from date-start to date-end and stores
 ; the IEN of matching with error message in INL array.
 ;
 ; Return:  None
 ;
 ; Parameters:
 ;    INSRCH(PBR) = Array for holding search criteria information
 ;    DWLRF(PBV) = Settings for the Display Processor
 ;    INL(PBR) = Array used to load with error items matching the criteria
 ; Code begins
 N INM,INFNDCT,IND
 ; Initialize errors count, start date, and search direction
 S INFNDCT=0
 S:'$D(INSRCH("INORDER")) INSRCH("INORDER")=1
 S IND=$S('INSRCH("INORDER"):INSRCH("INEND"),1:INSRCH("INSTART"))
 S INRVSRCH=$S('INSRCH("INORDER"):-1,1:1)
 ; Loop through ^INTHER from start date to end date
 F  Q:$S('IND:1,(INRVSRCH>-1)&(IND>INSRCH("INEND")):1,(INRVSRCH=-1)&(IND<INSRCH("INSTART")):1,1:0)  D  S IND=$O(^INTHER("B",IND),INRVSRCH)
 .; call MSGTEST to find error matching user select criteria
 .  S INM="" F  S INM=$O(^INTHER("B",IND,INM),INRVSRCH) Q:'INM  D MSGTEST(INM,.DWLRF,.INSRCH,.INFNDCT)
 ; count of error messages found matching criteria
 S INSRCH("FOUND")=$G(INFNDCT)
 Q
 ;
MSGTEST(INEIEN,INLIST,INSRCH,INFNDCT) ; Add matching error to array
 ;  
 ; Description: MSGTEST (Interface Error Match Criteria Test).  Tests 
 ;  the error for matches to values passed in INSRCH 
 ;  array and save the IEN to the INLIST array.  
 ;
 ; Return = None
 ; Parameters:
 ;    INEIEN(PBV)= IEN into ^INTHER
 ;    INLIST(PBR) = The NAME of the array to add items found
 ;    INSRCH(PBR) = The array of items to find
 ;    INFNDCT(PBR) = The count of errors found
 ;    
 ; Code begins
 N INTEMPX,INTEMPY,INMAXSZ,INMIEN
 S INMAXSZ=120,INTEMPX=$G(^INTHER(INEIEN,0))
 S INMIEN=$P(INTEMPX,U,4),INTEMPY=$G(^INTHU(+INMIEN,0))
 ; Checking the Interface Error file
 I INSRCH("INDEST")]"" I $P(INTEMPX,U,9)'=INSRCH("INDEST")&($P(INTEMPY,U,2)'=INSRCH("INDEST")) Q
 I INSRCH("INORIG")]"" I $P(INTEMPX,U,2)'=INSRCH("INORIG")&($P(INTEMPY,U,11)'=INSRCH("INORIG")) Q
 I $D(INSRCH("INERLOC")),INSRCH("INERLOC")]"",$P(INTEMPX,U,5)'=INSRCH("INERLOC") Q
 I $D(INSRCH("INERSTAT")),INSRCH("INERSTAT")]"",$P(INTEMPX,U,10)'=INSRCH("INERSTAT") Q
 I $D(INSRCH("INTEXT"))>9 Q:'$$INERSRCH^INHERR1(.INSRCH,INEIEN,INSRCH("INTYPE"))
 ; Checking the Interface Message file
 I $G(INSRCH("INMSGSTART")) Q:($P(INTEMPY,U)<INSRCH("INMSGSTART"))
 I $G(INSRCH("INMSGSTART")) Q:($P(INTEMPY,U)>INSRCH("INMSGEND"))
 I INSRCH("INID")]"" Q:$P(INTEMPY,U,5)'=INSRCH("INID")
 I INSRCH("INDIR")]"" Q:$P(INTEMPY,U,10)'=INSRCH("INDIR")
 I INSRCH("INSTAT")]"" Q:$P(INTEMPY,U,3)'=INSRCH("INSTAT")
 I INSRCH("INSOURCE")]"" Q:$E($P(INTEMPY,U,8),1,$L(INSRCH("INSOURCE")))'=INSRCH("INSOURCE")
 I INSRCH("INPAT")]"" Q:'INMIEN  Q:'$$INMSPAT^INHMS1(INMIEN,INSRCH("INPAT"))
 ; move the found-items array to ^UTILITY if it's getting too large
 ; kill the new ^UTILITY space incase it already exists prior to merg
 I INFNDCT>INMAXSZ,(INLIST'[U) N INTEMPY S INTEMPY=INLIST,INLIST="^UTILITY($J,""INL"")" K @INLIST M @INLIST=@INTEMPY K @INTEMPY,INTEMPY
 ; Save the IEN of the error found and update count
 S INFNDCT=INFNDCT+1,@INLIST@(INFNDCT)=INEIEN
 Q
 ;
CRIHDR(INSRCH) ; Display the criteria header
 ; Reuse code from the INHERR
 ;
 ; Description: The CRIHDR is used to display the input criteria 
 ;  in header. 
 ;  
 ; 
 ; Return: None
 ; Parameter: 
 ; INSRCH = Array contains search criteria 
 ; 
 ;*** Interface Error File
 ; display Destination
 I INSRCH("INDEST")]"" S C=$P(^DD(4001.1,2,0),U,2),Y=INSRCH("INDEST") D Y^DIQ W !,"DESTINATION",?30," : ",Y
 ; display Original Transaction Type
 I INSRCH("INORIG")]"" S C=$P(^DD(4001.1,7,0),U,2),Y=INSRCH("INORIG") D Y^DIQ W !,"ORIGINAL TRANSACTION TYPE",?30," : ",Y
 ; display Error location
 I $G(INSRCH("INERLOC")) S C=$P(^DD(4001.1,15.03,0),U,2),Y=INSRCH("INERLOC") D Y^DIQ W !,"ERROR LOCATION",?30," : ",Y
 ; display Error Resolution Status
 I $G(INSRCH("INERSTAT")) D CODETBL^INHERR3("ERSTAT",4001.1,15.04) W !,"ERROR RESOLUTION STATUS",?30," : ",ERSTAT(INSRCH("INERSTAT"))
 I $D(INSRCH("INTEXT"))>9 D
 .W !,"TEXT MATCH",?30," : "
 .S INT=0  F  S INT=$O(INSRCH("INTEXT",INT)) Q:'INT  D
 .. W ?34,$G(INSRCH("INTEXT",INT)),!
 .D CODETBL^INHERR3("MTYPE",4001.1,10)
 .W !,"Match type",?30," : ",MTYPE(INSRCH("INTYPE"))
 ;*** Interface message file
 ; display message start date
 I INSRCH("INMSGSTART")]"" S Y=INSRCH("INMSGSTART")+.000001,Y=$J(Y,12,4) D DD^%DT W !,"MESSAGE START DATE",?30," : ",Y
 ; display message end date
 I INSRCH("INMSGEND")]"" S Y=INSRCH("INMSGEND")-.000001,Y=$J(Y,12,4) D DD^%DT W !,"MESSAGE END DATE",?30," : ",Y
 ; display Message ID
 I INSRCH("INID")]"" W !,"MESSAGE ID",?30," : ",$G(INSRCH("INID"))
 ; display direction
 I INSRCH("INDIR")]"" S C=$P(^DD(4001.1,6,0),U,2),Y=INSRCH("INDIR") D Y^DIQ W !,"DIRECTION",?30," : ",Y
 ; display Status
 I INSRCH("INSTAT")]"" D CODETBL^INHERR3("STAT",4001.1,3) W !,"STATUS",?30," : ",STAT(INSRCH("INSTAT"))
 ; display Source
 I INSRCH("INSOURCE")]"" W !,"SOURCE",?30," : ",$G(INSRCH("INSOURCE"))
 ; display Patient
 I INSRCH("INPAT")]"" S C=$P(^DD(4001.1,8,0),U,2),Y=$G(INSRCH("INPAT")) D Y^DIQ W !,"PATIENT",?30," : ",Y
 I $D(INSRCH("TEXTLEN")) W !,"EXTRACT TEXT LENGTH",?30," : ",INSRCH("TEXTLEN") W:INSRCH("TEXTLEN")>120 !?5,"NOTE : ACTUAL TEXT LENGTH MUST NOT EXCEED 120"
 W !
 Q
