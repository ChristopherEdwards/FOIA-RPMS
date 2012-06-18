BSDU1 ; IHS/ANMC/LJF - IHS UTILITY CALLS-PAT INFO ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
PCP(PAT,ARRAY) ;PEP; -- returns one line of PCP info
 ; PAT = patient internal entry number
 ; ARRAY sent by reference and must be set to a string 
 ; Example of call:  S ARRAY="ABC" D PCP^BSDU1(PAT,.ARRAY)
 ;
 ; Returned array
 ; ARRAY(1)=pcp name/team name/pcp ien/team ien
 ;  ARRAY(1,0)=date last updated/user who updated/reason
 ;
 ; ARRAY(2)=women's health pcp name/wh team name/wh pcp ien/team ien
 ;  ARRAY(2,0)=date last updated/user who updated/reason
 ;
 ; ARRAY(3)=mental health prov name/mh team name/mh pcp ien/mh team ien
 ;                 /mh medication mgr name/mh med mgr ien
 ;  ARRAY(3,0)=date last updated/user who updated/reason
 ; ARRAY(3) only used if site is running Cimarron MH Provider menu
 ;
 NEW LINE,PCP
 S LINE=$$GET1^DIQ(9000001,PAT,.14)_"/"        ;pcp name
 S PCP=$$GET1^DIQ(9000001,PAT,.14,"I")         ;pcp ien
 I $P(^DD(9000001,.14,0),U,2)[6 S PCP=$G(^DIC(16,+PCP,"A3"))
 S TEAM=$$TEAM(PCP)                            ;team name and ien
 S LINE=LINE_$P(TEAM,U,2)_"/"_PCP_"/"_(+TEAM)
 S @ARRAY@(1)=LINE
 ;
 S LINE=$$GET1^DIQ(9000001,PAT,.34)_"/"        ;date last updated
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,.33)_"/"   ;user who updated
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,.37)       ;reason changed
 S @ARRAY@(1,0)=LINE
 ;
 S LINE=$$GET1^DIQ(9002086,PAT,.25)_"/"        ;wh pcp name
 S PCP=$$GET1^DIQ(9002086,PAT,.25,"I")         ;wh pcp ien
 S TEAM=$$TEAM(PCP)                            ;team name and ien
 S LINE=LINE_$P(TEAM,U,2)_"/"_PCP_"/"_(+TEAM)
 S @ARRAY@(2)=LINE
 ;
 S LINE=$$GET1^DIQ(9002086,PAT,.27)_"/"        ;date wh pcp updated
 S LINE=LINE_$$GET1^DIQ(9002086,PAT,.26)_"/"   ;user who updated
 S LINE=LINE_$$GET1^DIQ(9002086,PAT,.28)       ;reason changed
 S @ARRAY@(2,0)=LINE
 ;
 S LINE=$$GET1^DIQ(9000001,PAT,1701)_"/"       ;mh pcp name
 S PCP=$$GET1^DIQ(9000001,PAT,1701,"I")        ;mh pcp ien
 S TEAM=$$TEAM(PCP)                            ;team name and ien
 S LINE=LINE_$P(TEAM,U,2)_"/"_PCP_"/"_(+TEAM)
 S LINE=LINE_"/"_$$GET1^DIQ(9000001,PAT,1704)_"/"    ;mh med mgr name
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,1704,"I")        ;mh med mgr ien
 S @ARRAY@(3)=LINE
 ;
 S LINE=$$GET1^DIQ(9000001,PAT,1703)_"/"        ;date last updated
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,1702)_"/"   ;user who updated
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,1707)_"/"   ;reason changed
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,1706)_"/"   ;date med mgr updated
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,1705)_"/"   ;user who updated
 S LINE=LINE_$$GET1^DIQ(9000001,PAT,1708)       ;reason changed
 S @ARRAY@(3,0)=LINE
 ;
 Q
 ;
TEAM(PRV) ; returns team ien and name for provider PRV
 I 'PRV Q 0
 NEW X S X=$O(^BSDPCT("AB",PRV,0)) I 'X Q 0
 Q X_U_$$GET1^DIQ(9009017.5,X,.01)
 ;
 ;
PCLINE(PAT) ;PEP; returns display line of PCP info
 NEW BSDX,X
 S BSDX="BSDX" D PCP(PAT,.BSDX)
 S X="Pcp/Team" S:$P($G(BSDX(2)),"/")]"" X=X_"/WH Pcp/Team"
 S X=X_": "_$S($E(BSDX(1))'="/":$P(BSDX(1),"/",1,2),1:"None/None")
 S:$P($G(BSDX(2)),"/")]"" X=X_"/"_$P(BSDX(2),"/",1,2)  ;wh pcp/team
 Q X
 ;
PCPDISP(PAT,BDGY) ;PEP; returns array for multiple line display of PCP info
 ; Call using D PCPDISP^BSDU1(DFN,.Y) then display Y array
 NEW BDGX
 S BDGX="BDGX" D PCP^BSDU1(PAT,.BDGX)
 S LINE="Primary Care Provider/Team: "
 S LINE=LINE_$P($G(BDGX(1)),"/")_" / "_$P($G(BDGX(1)),"/",2)
 S BDGY(1)=LINE
 ;
 I $P($G(BDGX(2)),"/")]"" D
 . S LINE=$$SP(3)_"Women's Health PCP/Team: "
 . S LINE=LINE_$P($G(BDGX(2)),"/")_" / "_$P($G(BDGX(2)),"/",2)
 . S BDGY(2)=LINE
 ;
 I $P($G(BDGX(3)),"/")]"" D
 . S LINE=$$SP(3)_"Mental Health Providers/Team: "
 . S LINE=LINE_$P($G(BDGX(3)),"/")_" / "_$P($G(BDGX(3)),"/",5)
 . S LINE=LINE_" / "_$P($G(BDGX(3)),"/",2)
 . S BDGY(3)=LINE
 Q
 ;
CMS(PAT) ;EP; displays patient's CMS register memberships, if register allows it
 NEW REG,CNT,BSDLN,FIRST
 S REG=0,FIRST=1
 F  S REG=$O(^ACM(41,"D",PAT,REG)) Q:'REG  D   ;find pat's registers
 . I $$GET1^DIQ(9002241.1,REG,5)="NO" Q      ;not set for HS display
 . S CNT=$G(CNT)+1                             ;count lines
 . I FIRST D                                   ;if 1st line, set caption
 .. S BSDLN(CNT)=" Member of these registers: ",BSDLN(CNT,"F")="!"
 . I 'FIRST S BSDLN(CNT)="",BSDLN(CNT,"F")="!?28"  ;otherwise,set column
 . ;  add register name to display
 . S BSDLN(CNT)=BSDLN(CNT)_$$GET1^DIQ(9002241.1,REG,.01)
 . S FIRST=0
 ;
 I $D(BSDLN) D EN^DDIOL(.BSDLN)                ;display lines
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
