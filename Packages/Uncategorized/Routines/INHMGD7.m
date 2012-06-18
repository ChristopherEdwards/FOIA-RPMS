INHMGD7 ;CAR; 7 May 97 11:43;HL7 MESSAGING - SEGMENT SUBROUTINE FOR SENSITIVITY ANALYSIS
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; PURPOSE:
 ; Module SEG^INHMGD7 is used to navigate the segment list under
 ; each message in ^INTHL7M.  It is called by INHMGD6 and it is called
 ; recursively to reach the children of parent segments, which are
 ; skipped by INHMGD6.  And it is used to evaluate the address of each
 ; field in each segment.
 ;
SEG(INSEG,INERN) ;process the segment
 ;get the segment description string and segment number from '7M.
 ; Inputs
 ;   INSEG = Segment index
 ;   INERN = Error counter.
 S INSEG(1)=^INTHL7M(INM,1,INSEG,0),INSEG(2)=INSEG,INSEG=+INSEG(1)
 Q:'$D(^INTHL7S(INSEG,0))
 ;
 N DIC,INWHILE,INCH,INUDI,INX,X
 S INSEG(0)=^INTHL7S(INSEG,0) Q:$P(INSEG(0),U,2)="MSH"
 S INWHILE=$P(INSEG(1),U,3)!$P(INSEG(1),U,4) ;REPEATS or OTHER
 S INUDI=$P(INSEG(1),U,12) ;user defined index
 I INWHILE,(INUDI="") D
 .I $P(INSEG(1),U,3),'$P(INSEG(1),U,4) D  Q  ;MULTIPLE
 ..;look up the multiple name to get the field#
 ..K DIC S (X,INX)=$P(INSEG(1),U,8),DIC="^DD("_+FILE(FLVL)_","
 ..S DIC(0)="FMZ",DIC("S")="I $P(^(0),U,2)" D ^DIC
 ..I Y<0 D  Q
 ...S INWHILE=0 Q:INPARS&('INMODE)  ;bogus seg. ok in input ParseOnly 
 ...S INERN=INERN+.1
 ...S ^UTILITY("INHMGD",$J,"E",INM,INSEG,INERN)=+FILE(FLVL)_U_"Multiple "_INX_" does not exist"
 ..;multiple found, store file# in FILE(FLVL) and name in INWHILE(1)
 ..S FLVL=FLVL+1,FILE(FLVL)=+$P(Y(0),U,2),INWHILE(1)=$P(Y,U,2)
 .;must have been an OTHER
 .S FLVL=FLVL+1,FILE(FLVL)=+$P(INSEG(1),U,5)
 .I 'FILE(FLVL) D  Q
 ..S INX="No OTHER file specified",INERN=INERN+.001
 ..S ^UTILITY("INHMGD",$J,"E",INM,INSEG,INERN)=FILE(FLVL)_U_INX
 .;store other file name
 .S INWHILE(1)=$P(^DIC(+FILE(FLVL),0),U)
 ;
 ;continue processing this segment.
 N INAS,INFC,INFIL,INFL,INFLD,INJ,INRS
 ;could have done this check earlier, but wanted to eval FILE(FLVL)
 I $D(^UTILITY("INHMGD",$J,"S",INSEG)) D
 .;now go through list of fields for this segment INAS="ien^ien^ien..."
 .S INAS=^UTILITY("INHMGD",$J,"S",INSEG)
 .F INJ=1:1:$L(INAS,U) K X D
 ..;separate out the field pointer, then get the contents INFC
 ..S INFL=$P(INAS,U,INJ) Q:'INFL
 ..S INFC=$G(^UTILITY("INHMGD",$J,"F",INFL)) Q:INFC=""
 ..;derive the address
 ..S INRS=$$RESOLVE^INHMGD3(FILE(FLVL),INFC)
 ..;If no results returned, mark as error and quit
 ..I '$L(INRS) D  Q
 ...S ^UTILITY("INHMGD",$J,"E",INM,INSEG,INFL)=FILE(FLVL)_U_INFC_"  Unable to resolve or missing from Data Dictionary."
 ..;mark progress?
 ..I INDOT S INDOT=INDOT+1 I INDOT>70 S INDOT=1 W "."
 ..;separate out root and field name
 ..S INFLD=+$P(INRS,":"),INFIL=+$P(INRS,":",2)
 ..I INFLD,INFIL S ^UTILITY("INHMGD",$J,"A",INFIL,INFLD,INFL,INSEG,INM)="" Q
 ..;trap for 'INFLD or 'INFIL
 ..S ^UTILITY("INHMGD",$J,"E",INM,INSEG,INFL)=FILE(FLVL)_U_"Missing "_INFLD_" or "_INFIL
 ;
 ;pick up child segments
 I $D(^INTHL7M(INM,1,"ASP",INSEG)) D
 .S INCH=0
 .F  S INCH=$O(^INTHL7M(INM,1,"ASP",INSEG,INCH)) Q:'INCH  D
 ..S INX=0 F  S INX=$O(^INTHL7M(INM,1,"ASP",INSEG,INCH,INX)) Q:'INX  D SEG(INX,.INERN)
 ;
 ;adjust file level
 I INWHILE S FLVL=FLVL-1
 I FLVL<0 D
 .S INERN=INERN+.001
 .S ^UTILITY("INHMGD",$J,"E",INM,INSEG,INERN)=FILE(0)_U_"FLVL at -1"
 .S FLVL=0
 Q
 ;
