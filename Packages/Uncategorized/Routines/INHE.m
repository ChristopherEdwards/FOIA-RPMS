INHE ;JSH; 27 Feb 96 16:05;Interface Error handler part 1
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
ENO(TT,UIF,DEST,ERROR) ;Log an Output Controller error in the Interface Error File (IEF)
 D LOAD(TT,"",UIF,"O","",DEST,"",.ERROR)
 Q
 ;
ENF(TT,DA,DUZ,ARRAY,ERROR) ;Log a Formatter error in the IEF
 D LOAD(TT,DA,"","F",DUZ,"",.ARRAY,.ERROR)
 Q
 ;
END(UIF,ERROR,DEST) ;Log a deformatter error in the IEF
 D LOAD("","",UIF,"D","",$G(DEST),"",.ERROR)
 Q
 ;
ENT(UIF,DEST,ERROR,BPN) ;Log an Transceiver error in the IEF
 I $G(BPN)'="" D:$D(ERROR)
 .N PROC S PROC="<"_$P($G(^INTHPC(BPN,0)),U)_"> "
 .I $D(ERROR)<10 S:$L(PROC_ERROR)<256 ERROR=PROC_ERROR Q
 .S:$L(PROC_$G(ERROR(1)))<256 ERROR(1)=PROC_$G(ERROR(1))
 D LOAD("","",UIF,"T","",DEST,"",.ERROR,$G(BPN))
 Q
 ;
ENI(TT,DEST,ERROR) ;Log an Input Driver error in the IEF
 D LOAD(TT,"","","I","",DEST,"",.ERROR)
 Q
 ;
ENR(BPN,ERROR) ;Log a receiver error in the IEF
 D:$D(ERROR)
 .N PROC S PROC="<"_$P($G(^INTHPC(BPN,0)),U)_"> "
 .I $D(ERROR)<10 S:$L(PROC_ERROR)<256 ERROR=PROC_ERROR Q
 .S:$L(PROC_$G(ERROR(1)))<256 ERROR(1)=PROC_$G(ERROR(1))
 D LOAD("","","","R","","","",.ERROR,BPN)
 Q
 ;
ENK(UIF,ERROR) ;Log a negative acknowledgement
 D LOAD("","",UIF,"K","","","",.ERROR)
 Q
 ;
LOAD(TT,INDA,UIF,LOC,DUZ,DEST,ARRAY,ERROR,BPN,ENUM) ;Load an error entry
 ;TT = Transaction type (file #4000)
 ;INDA = DA of from file
 ;UIF = entry # in UIF (file #4001)
 ;LOC = location of error
 ;DUZ = originating user
 ;DEST = Destination entry # (file #4005)
 ;ARRAY = Programmer's array
 ;ERROR = Array of error strings - if only ERROR exists and no
 ;          descendents, then that will be used as ERROR(1)
 ;BPN = Entry number in Background Process Control file (#4004)
 ;ENUM = IEN of INTERFACE ERROR entry created (PBR to retrieve)
 ;
 N DIK,X,Y,I,%,DIC,DLAYGO S X=+$G(DUZ) N DUZ S DUZ=X,DUZ(0)="@" K DO
 S U="^",X="""NOW""",DIC=4003,DIC(0)="L",DLAYGO=4003 D ^DIC Q:Y<0
 S:$G(LOC)]"" LOC=$O(^INTHERL("C",LOC,""))
 S $P(^INTHER(+Y,0),U,2,10)=$G(TT)_U_$G(INDA)_U_$G(UIF)_U_$G(LOC)_U_U_U_$G(DUZ)_U_$G(DEST)_U_0_U_$G(BPN)
 I $D(ERROR)=1,ERROR]"" S ERROR(1)=ERROR
 S (%,I)=0 F  S I=$O(ERROR(I)) Q:'I  S %=%+1,^INTHER(+Y,2,%,0)=ERROR(I)
 S:% ^INTHER(+Y,2,0)=U_U_%_U_%
 ;FIX THIS WHOLE THING - DO SOME KIND OF %XY^%RCR TO ACCOUNT FOR LOWER LEVEL SUBSCRIPTS IN ARRAY - USE $Q
 S (%,I)=0 I $D(ARRAY)>9 F  S I=$O(ARRAY(I)) Q:I=""  S %=%+1,^INTHER(+Y,1,%,0)=I,%=%+1,^INTHER(+Y,1,%,0)=$G(ARRAY(I))
 S:% ^INTHER(+Y,1,0)=U_U_%_U_%
 N DA S DIK="^INTHER(",(DA,ENUM)=+Y D IX1^DIK
 Q
