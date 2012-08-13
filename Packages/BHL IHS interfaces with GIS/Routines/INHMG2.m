INHMG2 ;KN; 18 Jun 99 13:38; Script Message Generator - Extend INHMG1 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Script Message Generator (INHMG2)
 ;
 ; PURPOSE:
 ; The purpose of the module INHMG2 is used as a print template 
 ; to display the segments and fields for the selected script 
 ; generator message.
 ; 
 ; DESCRIPTION:
 ; The processing of the module INHMG2 is used to search the global 
 ; ^INTHL7S for the segments, and ^INTHL7F for the fields to get
 ; the details of selected Script Generator Message.  Based on
 ; option INCOMSEG from user, it will display or not display the common
 ; segments for the message.  Other segments and fields will be
 ; displayed.
 ; 
 ;
INFIELD(INSG,D0,D1,INCOMSEG) ; Entry point
 ;
 ; Description:  INFIELD is the entry point for module INHMG2.  It will
 ;   array INSG of segment information, get the data for
 ;  all the fields in the current segment, and display.
 ;
 ; Return: None
 ; Parameter: 
 ;    Input INSG : array contains the information for current segment
 ;    D0   : IEN
 ;    D1   : IEN of multiple
 ;
 ; Return: None
 ;
 ; Code begins
 N SP,FP,SQ,RQ,RP,LK,XF,FN,LOC,LEN,D2,D3,I,OIT,INV,INT,OUT,MP,DT,INTMP
 S SP=$P(^INTHL7M(D0,1,D1,0),U,1),D2=0 Q:'SP  Q:$G(DUOUT)
 ; Sort by sequence number by storing it (ID2) in INTMP array
 S ID2=0
 F  S ID2=$O(^INTHL7S(SP,1,ID2)) Q:'ID2  Q:$G(DUOUT)  D
 .S INSQ=^INTHL7S(SP,1,ID2,0),SQ=+$P(INSQ,U,2),FP=+$P(INSQ,U,1)
 .; Only store in INTMP if the field pointed by FP is defined
 .I $D(^INTHL7F(FP,0)) S INTMP(SQ,ID2)=""
 ; Retrieve sequence number in order and get all related info for display
 S INT1="INTMP"
 F  S INT1=$Q(@INT1) Q:'$L(INT1)  Q:$G(DUOUT)  D
 .S ID1=$$QS^INHUTIL(INT1,1),D2=$$QS^INHUTIL(INT1,2),SQ=^INTHL7S(SP,1,D2,0),FP=$P(SQ,U,1),RQ=$P(SQ,U,3),RP=$P(SQ,U,4),LK=$P(SQ,U,5),XF=$P(SQ,U,6),INFD(ID1,"SQ")=$P(SQ,U,2),D3=0  Q:$G(DUOUT)  D:FP
 ..F I="RQ","RP","LK","XF" S @I=$S(@I=1:"Y",@I=0:"N",1:"")
 ..S INFD(ID1,"SQ","RQ")=$G(RQ),INFD(ID1,"SQ","RP")=$G(RP),INFD(ID1,"SQ","LK")=$G(LK),INFD(ID1,"SQ","XF")=$G(XF)
 ..S LEN=$G(^INTHL7F(FP,0)),INFD(ID1,"INV")=$G(^("I")),INFD(ID1,"INT")=$G(^(4)),INFD(ID1,"OUT")=$G(^(5)),INFD(ID1,"SQ","IDL")=$G(^("C")),MP=$P($G(^(50)),"^",1) S:MP INFD(ID1,"MP")=$P($G(^INVD(4090.2,MP,0)),"^",1)
 ..S DT=$P(LEN,U,2) S INFD(ID1,"SQ","DT")=$P($G(^INTHL7FT(DT,0)),U,2)
 ..S INFD(ID1,"OIT")=$P(LEN,U,5),INFD(ID1,"SQ","FN")=$P(LEN,U,1),INFD(ID1,"SQ","LEN")=$P(LEN,U,3)
 ; INCT is the total lines displayed in the next page
 ; calculate how many field
 S (INCT,INSLN,INFLN)=0
 ; INSLN is the number of the lines in segment display
 S INX="" F  S INX=$O(INSG(INX)) Q:INX=""  D
 .S:$G(INSG(INX))'="" INSLN=$G(INSLN)+1
 ; INFLN is the number of the lines in field display
 S INX="" F  S INX=$O(INFD(INX)) Q:INX=""  D
 .S INY="" F  S INY=$O(INFD(INX,INY)) Q:INY=""  D
 ..S:$G(INFD(INX,INY))'="" INFLN=$G(INFLN)+1
 ; Calculate total number of the lines
 S:INFLN>0 INCT=$G(INSLN)+2+$G(INFLN)+1
 S:INFLN=0 INCT=$G(INSLN)+1
 I ($Y+INCT)'>(IOSL-4) W !
 I ($Y+INCT)>(IOSL-4) D HEADER^INHMG
 S HF2=1
 ; Display for the segment name and the ID
 N NL S NL=1 D T,N Q:$G(DUOUT)  W "=====Segment Name==================================ID=====Seq No==Req==Rep==OF=="
 D N Q:$G(DUOUT)  W ?0,$G(INSG("NM"))
 W ?51,$G(INSG("NM",1))
 D N:$X>58 Q:$G(DUOUT)  W ?58,$J($G(INSG("NM",2)),0,1)
 W ?66,$G(INSG("NM",3))
 W ?71,$G(INSG("NM",4))
 W ?76,$G(INSG("NM",5))
 I $G(INSG("PS"))'="" D T,N Q:$G(DUOUT)  W ?8,"Parent Segment:",?24,INSG("PS")
 I $G(INSG("FL"))'="" D N Q:$G(DUOUT)  W ?18,"File:",?24,INSG("FL")
 I $G(INSG("MF"))'="" D N Q:$G(DUOUT)  W ?8,"Multiple Field:",?24,INSG("MF")
 I $G(INSG("UD"))'="" D N Q:$G(DUOUT)  W ?4,"User-Defined Index:",?24,INSG("UD")
 I $G(INSG("LP"))'="" D N Q:$G(DUOUT)  W ?6,"Lookup Parameter:",?24,INSG("LP")
 I $G(INSG("ML"))'="" D N Q:$G(DUOUT)  W ?12,"Make Links:",?24,INSG("ML")
 I $G(INSG("TP"))'="" D N Q:$G(DUOUT)  W ?14,"Template:",?24,INSG("TP")
 I $G(INSG("RT"))'="" D N Q:$G(DUOUT)  W ?15,"Routine:" W ?25,INSG("RT")
 I $G(INSG("IF"))'="" D N Q:$G(DUOUT)  W ?14,"ID Field:" W ?25,INSG("IF")
 I $G(INSG("IV"))'="" D N Q:$G(DUOUT)  W ?14,"ID Value:" W ?25,INSG("IV")
 ; Display the fields
 ; Display header for each page.  Only display field header if there 
 ; is field
 I INFLN>0 D HDR2
 ; If there is no field, then just display a bank line
 I INFLN=0 W !
 ; Initialize INT1, set flag HF2 for field header
 S INT1="",HF2=0
 F  S INT1=$O(INFD(INT1)) Q:INT1=""  Q:$G(DUOUT)  D
 .D T  Q:$G(DUOUT)  W !,$$JUST^UTIL(INFD(INT1,"SQ"),3,"R",0),?6,$$JUST^UTIL(INFD(INT1,"SQ","LEN"),3,"R",0),?11,INFD(INT1,"SQ","DT"),?15,INFD(INT1,"SQ","RQ"),?17,INFD(INT1,"SQ","RP")
 .W ?19,INFD(INT1,"SQ","LK"),?21,INFD(INT1,"SQ","XF"),?24,INFD(INT1,"SQ","FN")
 .S IDL=$G(INFD(INT1,"SQ","IDL"))
 .; Truncate display for the Data Location, if the character is too long
 .I $L(IDL)<(IOM-56) W ?56,IDL
 .I $L(IDL)>(IOM-56) W ?56,$E(IDL,1,IOM-56),!?56,$E(IDL,IOM-55,$L(IDL))
 .I INFD(INT1,"OIT")'="" D T  Q:$G(DUOUT)  W !,?10,"Overide Input Xform: ",INFD(INT1,"OIT") Q
 .I INFD(INT1,"INV")'="" D T  Q:$G(DUOUT)  W !,?10,"Input Validation: ",INFD(INT1,"INV") Q
 .I INFD(INT1,"INT")'="" D T  Q:$G(DUOUT)  W !,?10,"Incoming Xform: ",INFD(INT1,"INT") Q
 .I INFD(INT1,"OUT")'="" D T  Q:$G(DUOUT)  W !,?10,"Outgoing Xform: ",INFD(INT1,"OUT") Q
 .I $G(INFD(INT1,"MP"))'="" D T  Q:$G(DUOUT)  W !,?10,"Map Function: ",INFD(INT1,"MP") Q
 Q
N Q:$G(DUOUT)  W !
T ; End of page routine
 I ($Y>(IOSL-4))&(INPAGE>0)  D HEADER^INHMG  D:'$G(HF2) HDR2 S HF2=1
 Q
HDR2 ;Header 2
 Q:$G(DUOUT)  D N W !?15,"R R L X" D N Q:$G(DUOUT)
 W ?0,"SeqNo Len  DT  q p k f    Field Name                   Data Location"
 D N Q:$G(DUOUT)  W "--------------------------------------------------------------------------------"
 Q
