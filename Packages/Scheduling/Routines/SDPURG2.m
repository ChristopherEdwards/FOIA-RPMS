SDPURG2 ;ALB/TMP - Purge-Print Routine - Patient File nodes ; [ 09/13/2001  2:39 PM ]
 ;;5.3;Scheduling;;Aug 13, 1993
 ;IHS/ANMC/LJF 11/30/2000 changed $N to $O
 ;
 S SDCT=0
 W !,"Begin purge of Patient File nodes" S Y=% D DT^DIQ
 ;S (B,SDCT)=0 F A=0:0 S B=$N(^DPT("ASDPSD",B)) W:B=-1 !,SDCT," SPECIAL SURVEY XREFS PURGED",!!,"End of Patient File purge" Q:B=-1  D DEL2,DOT  ;IHS/ANMC/LJF 11/30/2000
 S (B,SDCT)=0 F A=0:0 S B=$O(^DPT("ASDPSD",B)) W:B="" !,SDCT," SPECIAL SURVEY XREFS PURGED",!!,"End of Patient File purge" Q:B=""  D DEL2,DOT   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 G END^SDPURG1
DOT W:'(SDCT#100)&('SDPR) "."
 Q
DEL2 ;I B'["B",B'["C" F C=0:0 S C=$N(^DPT("ASDPSD",B,C)) Q:C'>0!(C'<SDLIM1)  S X="^DPT(""ASDPSD"","""_B_""","_C_")" D PRT K @X D CT   ;IHS/ANMC/LJF 11/30/2000
 I B'["B",B'["C" F C=0:0 S C=$O(^DPT("ASDPSD",B,C)) Q:C'>0!(C'<SDLIM1)  S X="^DPT(""ASDPSD"","""_B_""","_C_")" D PRT K @X D CT   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 ;I B["B" S D=0 F C=0:0 S D=$N(^DPT("ASDPSD",B,D)) Q:D=-1  F E=0:0 S E=$N(^DPT("ASDPSD",B,D,E)) Q:E'>0!(E'<SDLIM1)  D MORE2 S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_E_")" K @X   ;IHS/ANMC/LJF 11/30/2000
 I B["B" S D=0 F C=0:0 S D=$O(^DPT("ASDPSD",B,D)) Q:D=""  F E=0:0 S E=$O(^DPT("ASDPSD",B,D,E)) Q:E'>0!(E'<SDLIM1)  D MORE2 S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_E_")" K @X   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 S D=0
 ;
 ;IHS/ANMC/LJF 11/30/2000 $N->$O
 ;I B["C" F C=0:0 S D=$N(^DPT("ASDPSD",B,D)) Q:D<0  S E=-1 F E1=0:0 S E=$N(^DPT("ASDPSD",B,D,E)) Q:E<0  F F=0:0 S F=$N(^DPT("ASDPSD",B,D,E,F)) Q:F<0!(F'<SDLIM1)  D MORE1 S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_G_","_F_")" K @X
 I B["C" F C=0:0 S D=$O(^DPT("ASDPSD",B,D)) Q:D=""  S E=-1 F E1=0:0 S E=$O(^DPT("ASDPSD",B,D,E)) Q:E=""  F F=0:0 S F=$O(^DPT("ASDPSD",B,D,E,F)) Q:F=""!(F'<SDLIM1)  D MORE1 S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_G_","_F_")" K @X
 ;
 Q
MORE1 ;S G=$S(E:E,1:""""_E_"""") Q:'SDPR  F I=0:0 S I=$N(^DPT("ASDPSD",B,D,E,F,I)) Q:I'>0  S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_G_","_F_","_I_")" D PRT D CT   ;IHS/ANMC/LJF 11/30/2000
 S G=$S(E:E,1:""""_E_"""") Q:'SDPR  F I=0:0 S I=$O(^DPT("ASDPSD",B,D,E,F,I)) Q:I'>0  S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_G_","_F_","_I_")" D PRT D CT   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 Q
MORE2 ;Q:'SDPR  F I=0:0 S I=$N(^DPT("ASDPSD",B,D,E,I)) Q:I'>0  S Y=+^(I) I 'Y!(Y>6) K Y S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_E_","_I_")" D PRT D CT  ;IHS/ANMC/LJF 11/30/2000
 Q:'SDPR  F I=0:0 S I=$O(^DPT("ASDPSD",B,D,E,I)) Q:I'>0  S Y=+^(I) I 'Y!(Y>6) K Y S X="^DPT(""ASDPSD"","""_B_""","""_D_""","_E_","_I_")" D PRT D CT   ;IHS/ANMC/LJF 11/30/2000 $N->$O
 Q
PRT I SDPR W:$S(($D(@X)#2):1,1:0) !,X," = ",@X
 Q
CT S SDCT=SDCT+1 Q
