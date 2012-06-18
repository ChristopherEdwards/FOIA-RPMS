BLRLBMEC ;IHS/CIA/PLS - OE/RR Order Lab for Intermec PC41;22-Jul-2005 23:17;SM
 ;;5.2;LR;**1020**;Sep 13, 2005
 ; Direct entry not allowed
 Q
 ;
OPEN() ;EP
 N STX,ETX,ESC,CR
 D INIT
 U IO
 W STX,ESC,"C",ETX                              ; Place printer in Advanced Mode
 W STX,ESC,"P",ETX                              ; Place printer in Program Mode
 W STX,"E*;F*",ETX                              ; Erase format and Create format (uses Temporary storage)
 W STX,"H0;o180,5;f3;c30;k5;d0,28",ETX          ; Patient Name
 W STX,"H1;o180,280;f3;c30;k5;d0,14",ETX        ; Lab Order Number
 W STX,"H2;o165,5;f3;c33;k8;d0,9",ETX           ; HRN
 W STX,"H3;o160,165;f3;c31;;k8;d0,10",ETX       ; DOB
 W STX,"H4;o160,323;f3;c31;;k8;d0,1",ETX        ; Sex
 W STX,"H5;o135,5;f3;c30;;k6;d0,25",ETX         ; Ordering Provider
 W STX,"H6;o115,5;f3;c30;;k6;d0,24",ETX         ; Hospital Location
 W STX,"H7;o115,260;f3;c30;;k6;d0,15",ETX       ; Room/Bed
 W STX,"H8;o90,5;f3;c30;;k6;d0,8",ETX           ; Urgency
 W STX,"H9;o90,120;f3;c30;;k6;d0,24",ETX        ; Drawn by text
 W STX,"H10;o66,5;f3;c30;;k6;d0,18",ETX         ; Collection D/T
 W STX,"H11;o66,205;f3;c30;;k6;d0,19",ETX       ; Tube Color
 W STX,"H12;o45,5;f3;c30;;k6;d0,38",ETX         ; Test Name
 W STX,"H13;o25,240;f3;c31;k5;d0,14",ETX        ; Lab Order Number
 W STX,"B14;o20,15;f3;c6,0;d0,14;h25;r2;w2;i0;p@",ETX    ; Lab Order Number (Code 128 Barcode)
 W STX,"R",ETX                                  ; Exit Program Mode, Enter Print Mode
 Q
OUT() ; EP
 N STX,ETX,ESC,CR
 D OPEN(),INIT
 U IO
 W STX,"R",ETX
 W STX,"<SI>W406",ETX
 W STX,ESC,"E*<CAN>",ETX
 W STX,$$NAME^ORU($G(ORPNAME),""),CR,ETX
 W STX,"LB#:"_$G(ORPLB),CR,ETX
 W STX,$G(HRCN),CR,ETX
 W STX,$$DATE^ORU($G(ORPDOB),"MM/DD/CCYY HR:MIN"),CR,ETX
 W STX,$G(ORPSEX),CR,ETX
 W STX,"PHY:"_$$NAME^ORU($G(ORPRPHY),""),CR,ETX
 W STX,"LOC:"_$G(ORPLOC),CR,ETX
 W STX,$G(ORPRMBED),CR,ETX
 W STX,$G(ORPURG),CR,ETX
 W STX,"Drawn By:_______________",CR,ETX
 W STX,"CDT:______________",CR,ETX
 W STX,$G(ORPCOT),CR,ETX
 D GETTST(.ORZTST)
 S TST=$G(ORZTST(1))
 S TST=$P(TST," ",1,$L(TST," ")-4)
 W STX,$G(TST),CR,ETX
 W STX,"LB#:"_$G(ORPLB),CR,ETX
 W STX,$S($G(ORPLB):ORPLB,1:""),CR,ETX
 W STX,"<ETB>FF",ETX
 Q
 ;
 ;
INIT S STX="<STX>",ETX="<ETX>",ESC="<ESC>",CR="<CR>"
 Q
TEST ;EP - Output test label
 N STX,ETX,ESC,CR
 D ^%ZIS
 Q:POP
 U IO
 D OPEN()
 D INIT
 ;
 U IO
 W STX,"R",ETX
 W STX,ESC,"E*<CAN>",ETX
 W STX,"TEST,PATIENT WITH LONG NAME","<CR>",ETX
 W STX,"LB#:3392829<CR>",ETX
 W STX,440303,"<CR>",ETX
 W STX,"05/25/2005",CR,ETX
 W STX,"M",CR,ETX
 W STX,"PHY:SMITH,PHYSICIAN NAMED",CR,ETX
 W STX,"LOC:EMERGENCY ROOM 2ND FLOOR ROOM 103",CR,ETX
 W STX,"R/B:A201-104",CR,ETX
 W STX,"ROUTINE",CR,ETX
 W STX,"Drawn By:_________________",CR,ETX
 W STX,"CDT:______________",CR,ETX
 W STX,"TUBE TOP IS MARBLE",CR,ETX
 W STX,"HEPATITIS B SURFACE ANTIGEN",CR,ETX
 W STX,"LB#:3392829",CR,ETX
 W STX,3392829,CR,ETX
 W STX,"<ETB>FF",ETX
 D ^%ZISC
 Q
 ;
GETTST(Y) ;API TO RETURN TESTNAME
 N ORPDAD
 S ORPDAD=$O(^OR(100,ORIFN,2,0)) D TEXT^ORQ12(.Y,ORIFN_$S($G(OACTION):";"_OACTION,1:"")) M ^TMP("ORP:",$J)=Y S OROOT2="^TMP(""ORP:"",$J)"
 Q
