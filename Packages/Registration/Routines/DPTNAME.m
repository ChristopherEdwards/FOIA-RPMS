DPTNAME ;BPOIFO/KEITH - NAME STANDARDIZATION ; 27 Jan 2002 11:05 PM
 ;;5.3;Registration;**244**;Aug 13, 1993
 ;
FORMAT(DGNAME,DGMINL,DGMAXL,DGNOP,DGCOMA,DGAUDIT,DGFAM,DGDNC) ;Format name value
 ;Input: DGNAME=text value representing person name to transform
 ;       DGMINL=minimum length (optional), default 3
 ;       DGMAXL=maximum length (optional), default 30
 ;        DGNOP=1 to standardize last name for 'NOP' x-ref. (optional)
 ;       DGCOMA=0 to not require a comma
 ;              1 to require a comma in the input value
 ;              2 to add a comma if none
 ;              3 to prohibit (remove) commas
 ;              (optional) default if not specified is 1
 ;
 ;      DGAUDIT=variable to return audit, pass by reference (optional),
 ;              returned values:  
 ;              DGAUDIT=0 if no change was made
 ;                      1 if name is changed
 ;                      2 if name could not be converted
 ;             DGAUDIT(1) defined if name contains no comma
 ;             DGAUDIT(2) defined if parenthetical text is removed
 ;             DGAUDIT(3) defined if value is unconvertible
 ;             DGAUDIT(4) defined if characters are removed or changed
 ;        DGFAM='1' if just the family name, '0' otherwise (optional)
 ;        DGDNC='1' to prevent componentization (optional)
 ;
 ;Output: DGNAME in specified format or null if length of transformed value is less than DGMINL
 ;
 N DGX,DGOX,DGOLDN,DGAX,DGI,DGNEWN
 ;Initialize variables
 K DGAUDIT
 S DGOLDN=DGNAME M DGX=DGNAME
 S DGDNC=$G(DGDNC) D COMP^DPTNAME1(.DGX,.DGDNC)
 S DGMINL=+$G(DGMINL) S:DGMINL<1 DGMINL=3
 S DGMAXL=+$G(DGMAXL) S:DGMAXL<DGMINL DGMAXL=30
 S DGNOP=$S($G(DGNOP)=1:"S",1:"")
 S:'$L($G(DGCOMA)) DGCOMA=1 S DGCOMA=+DGCOMA
 S DGFAM=$S($G(DGFAM)=1:"F",1:"")
 ;
 ;Check for comma
 I DGX'["," S DGAUDIT(1)=""
 I DGCOMA=1,DGX'["," S DGAUDIT=2,DGAUDIT(3)=""  Q ""
 ;Clean input value
 F  Q:'$$F1^DPTNAME1(.DGX,DGCOMA)
 I DGX'=DGOLDN S DGAUDIT(4)=""
 ;Add comma if necessary
 I DGCOMA=2,DGX'[" ",DGX'["," S DGX=DGX_","
 I DGX=DGOLDN K DGAUDIT(4)
 ;Quit if result is too short
 I $L(DGX)<DGMINL S DGAUDIT=2,DGAUDIT(3)="" K DGNAME Q ""
 S DGNAME=DGX I 'DGDNC D
 .;Parse the name
 .D STDNAME^XLFNAME(.DGX,DGFAM_"CP",.DGAX)
 .I $D(DGAX("STRIP")) S DGAUDIT(2)=""
 .I $D(DGAX("NM"))!$D(DGAX("PERIOD")) S DGAUDIT(4)=""
 .I $D(DGAX("PUNC"))!($D(DGAX("SPACE"))&'$L(DGFAM)) S DGAUDIT(4)=""
 .I $D(DGAX("SPACE")),$L(DGFAM),DGNAME'=$G(DGX("FAMILY")) S DGAUDIT(4)=""
 .;Standardize the suffix
 .S DGX("SUFFIX")=$$CLEANC^XLFNAME(DGX("SUFFIX"))
 .;Post-clean components
 .S DGI="" F  S DGI=$O(DGX(DGI)) Q:DGI=""  S DGX(DGI)=$$POSTC(DGX(DGI))
 .;Reconstruct name from components
 .S DGNAME=$$NAMEFMT^XLFNAME(.DGX,"F","CL"_DGMAXL_DGNOP)
 .;Adjust name for 'do not componentize'
 .;I DGDNC S DGNAME=DGX("FAMILY")
 ;Return comma for single value names
 I DGCOMA,DGCOMA'=3,DGNAME'["," S DGNAME=DGNAME_","
 ;Check length again
 I $L(DGNAME)<DGMINL S DGAUDIT=2,DGAUDIT(3)="" K DGNAME Q ""
 ;Enforce minimum 2 character last name rule
 ;I '$L(DGFAM),$L($P(DGNAME,","))<3,$P(DGNAME,",")'?2U D  Q ""
 ;.S DGAUDIT=2,DGAUDIT(3)="" K DGNAME
 ;.Q
 ;Remove hyphens and apostrophes for 'NOP' x-ref
 S DGX=DGNAME I DGNOP="S" S DGNAME=$TR(DGNAME,"'-")
 I DGNAME'=DGX S DGAUDIT(4)=""
 I DGNAME=DGOLDN K DGAUDIT
 S DGAUDIT=DGNAME'=DGOLDN I DGAUDIT,$D(DGAUDIT)<10 S DGAUDIT(4)=""
 S DGNEWN=DGNAME M DGNAME=DGX S DGNAME=DGNEWN
 Q DGNAME
 ;
POSTC(DGX) ;Post-clean components
 ;Remove parenthesis if not removed by Kernel
 N DGI,DGXOLD
 S DGXOLD=DGX,DGX=$TR(DGX,"()[]{}")
 ;Check for numbers left behind by Kernel
 F DGI=0:1:9 S DGX=$TR(DGX,DGI)
 I DGX'=DGXOLD S DGAUDIT(4)=""
 Q DGX
 ;
NOP(DGX) ;Produce 'NOP' x-ref value
 ;Input: DGX=name value to evaluate
 ;Output : Standardized name or null if the same as input value
 N DGNEWX
 S DGNEWX=$$FORMAT(DGX,3,30,1)
 Q $S(DGX=DGNEWX:"",1:DGNEWX)
 ;
NARY(DG20NAME) ;Set up name array
 ;Input: DG20NAME=full name value
 ;       DG20NAME(component_names)=corresponding value--if undefined,
 ;                these will get set up
 ;
 N DGX M DGX=DG20NAME
 D STDNAME^XLFNAME(.DG20NAME,"FC")
 M DG20NAME=DGX
 S DG20NAME("NOTES")=$$NOTES^DPTNAME1()
 Q
 ;
NCEDIT(DFN,DGHDR,DG20NAME) ;Edit name components
 ;Input: DFN=patient ifn
 ;     DGHDR=1 to write components header (optional)
 ;  DG20NAME=array of name components (optional)
 ;Output: formatted name and DG20NAME components array if the user
 ;        specifies filing, DG20NAME=null otherwise
 ;
 N DIR,X,Y,DGCOMP,DGC,DGI,DGX,DGY,DGCOM
 N DGCL,DGCX,DGOUT,DGEDIT,%,DIE,DR,DA
 ;Initialize variables
START S DFN=+DFN,(DGOUT,DGEDIT)=0,DGCOMP=$D(DG20NAME)>9
 S DGCOM="FAMILY^GIVEN^MIDDLE^PREFIX^SUFFIX^DEGREE"
 S DGCX=" (LAST) NAME^ (FIRST) NAME^ NAME"
 S DGCL="1:35^1:25^1:25^1:10^1:10^1:10"
 ;Get patient name
 S DGX=$P($G(^DPT(DFN,0)),U) Q:DGX=""
 ;Get name component values from file #20
 I 'DGCOMP S DGCOMP=+$G(^DPT(DFN,"NAME"))_"," I DGCOMP D
 .D GETS^DIQ(20,DGCOMP,"1:6",,"DGCOMP")
 .I '$D(DGCOMP(20,DGCOMP)) S DGCOMP=0 Q
 .F DGI=1:1:6 S DGX($P(DGCOM,U,DGI))=DGCOMP(20,DGCOMP,DGI)
 .Q
 ;Parse name components from name value
 I 'DGCOMP D
 .D STDNAME^XLFNAME(.DGX,"C") S DGEDIT=1
 .S DGX("SUFFIX")=$$CLEANC^XLFNAME(DGX("SUFFIX"))
 .Q
 ;Prompt for name component edits
 N DTOUT,DUOUT,DIRUT,DGCOUT
 S DGCOUT=0 M DG20NAME=DGX
 S DIR("PRE")="D:X'=""@"" NCEVAL^DPTNAME1(DGCOMP,.X)"
 I $G(DGHDR) W !,"Patient name components--"
 F DGI=1:1:6 S DGC($P(DGCOM,U,DGI),DGI)=""
 F DGI=1:1:6 Q:DGOUT  D
AGAIN .S DGCOMP=$P(DGCOM,U,DGI)
 .S DIR("A")=DGCOMP_$P(DGCX,U,DGI)
 .S DIR(0)="FO^"_$P(DGCL,U,DGI)
 .S DIR("PRE")="D NCEVAL^DPTNAME1(DGCOMP,.X)"
 .S DIR("B")=$S($D(DG20NAME(DGCOMP)):DG20NAME(DGCOMP),1:$G(DGX(DGCOMP)))
 .K:'$L(DIR("B")) DIR("B")
ASK .D ^DIR I $D(DTOUT)!(X=U) S:(X=U) DGCOUT=1 S DGOUT=1 Q
 .I $A(X)=94 D JUMP^DPTNAME1(.DGI) G AGAIN
 .I X="@",DGI=1 W !,$C(7),"Family name cannot be deleted!" G ASK
 .I X="@" D  Q
 ..W "  (deletion indicated)" S DG20NAME(DGCOMP)=""
 ..S:DG20NAME(DGCOMP)'=$G(DGX(DGCOMP)) DGEDIT=1
 ..Q
 .Q:'$L(X)
 .S DG20NAME=X
 .I DGCOMP="SUFFIX" S DG20NAME=$$CLEANC^XLFNAME(DG20NAME)
 .S DG20NAME=$$FORMAT(DG20NAME,1,35,,3,,1,1)
 .I '$L(DG20NAME) W "  ??",$C(7) G ASK
 .W:DG20NAME'=X "   (",DG20NAME,")" S DG20NAME(DGCOMP)=DG20NAME
 .S:DG20NAME(DGCOMP)'=$G(DGX(DGCOMP)) DGEDIT=1
 .Q
 Q:'DGEDIT ""
 Q:DGOUT&'DGCOUT ""
 ;Reconstruct name
 S DG20NAME=$$NAMEFMT^XLFNAME(.DG20NAME,"F","CFL30")
 ;Format the .01 value
 M DGY=DG20NAME
 S DG20NAME=$$FORMAT(.DGY,3,30,,2)
 ;Check the length
 I $L(DG20NAME)<3 D  G START
 .W !,"Invalid values to file, full name must be at least 3 characters!",$C(7)
 .K DG20NAME,DGX,DGCOMP Q
 ;File new name value
CONF W !,"Ok to file '",DG20NAME,"' and its name components"
 S %=1 D YN^DICN
 I '% W !,"Indicate if the edits to the name and its components should be filed." G CONF
 I %'=1 K DG20NAME S DG20NAME="" Q DG20NAME
 I '$$CONF1(DG20NAME) K DG20NAME S DG20NAME=""
 Q DG20NAME
 ;
CONF1(DPTX) ;Confirm if single name value is ok.
 ;Input: DPTX=name value
 N %
 Q:$E($P(DPTX,",",2))?1U 1
 W !!?5,$C(7),"WARNING: Do not enter single name values for patients (no given or"
 W !?5,"         first name) unless this is actually their legal name!!!",$C(7)
RC W !!,"Are you sure you want to enter the patient name in this manner"
 S %=2 D YN^DICN S %=$S(%<0!(%=2):-1,%=1:1,1:0) I '% W !?6,"Specify 'YES' to enter a single name value, or 'NO' to discontinue." G RC
 W !
 Q %=1
