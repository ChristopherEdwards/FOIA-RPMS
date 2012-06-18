XBCDIC ; IHS/ADC/GTH - CLEAN UP ^DIC AND ^DD ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; PROGRAMMERS NOTE:
 ;  THIS FUNCTIONALITY HAS BEEN INCLUDED IN THE FILEMAN
 ;  DD UTILITIES, BEGINNING WITH V 19.0.  WE RECOMMEND
 ;  IT'S USE AS IT IS MORE LIKELY TO BE CURRENT.
 ;                            3-20-96
 ;
 ; This routine cleans up ^DIC and ^DD by a range of
 ; dictionary numbers.  All files in ^DIC within the range
 ; of dictionary numbers are checked for the following:
 ;
 ;   They must have a NAME in ^DIC.
 ;   The NAME in ^DIC must match the NAME in ^DD.
 ;   The NAME must exist in ^DIC("B" with the correct number,
 ;     and that number cannot occur more than once in ^DIC("B".
 ;   They must have a data global specified in ^DIC.
 ;   The data global must be in the correct form.
 ;   The data global must exist.
 ;   The data global must have a 0th node.
 ;   The NAME and NUMBER in the data global must match ^DIC.
 ;   The data globals 0th node must be consistent with
 ;     the data (Exact count not checked).
 ;
 ;   They must have valid entries in ^DD as follows:
 ;     The ^DD entry must have a .01 field.
 ;     All "SB" pointers must point to existing sub-files.
 ;     All sub-files must point back to correct parent.
 ;     All "TRB" entries must exist.
 ;     All "PT" entries must exist.
 ;     All "ACOMP" entries must exist.
 ;
 ; When discrepancies are found the entries are corrected
 ; automatically where ever possible.  If this is not possible
 ; operator interaction occurs to make the corrections.  If
 ; the file cannot be corrected, it will be deleted.
 ;
 ; After all dictionaries within the range of dictionary
 ; numbers are checked, all other entries within the range
 ; will be deleted.
 ;
 ; The last step is to set the 0th node of the FILE OF FILES
 ; to the correct high DFN and the correct count of entries.
 ;
BEGIN ;
 S U="^"
 W !!,"THIS FUNCTIONALITY HAS BEEN INCLUDED IN THE FILEMAN"
 W !,"DD UTILITIES, BEGINNING WITH V 19.0.  WE RECOMMEND"
 W !,"IT'S USE AS IT IS MORE LIKELY TO BE CURRENT."
 W !,"                            3-20-96",!!
 Q:'$$DIR^XBDIR("E")
 W !!,"This routine cleans up ^DIC and ^DD by a range of dictionary numbers."
LO ;
 R !!,"Enter low  number of range: ",XBCDLO:$G(DTIME,999)
 G:XBCDLO'=+XBCDLO EOJ
HI ;
 R !,"Enter high number of range: ",XBCDHI:$G(DTIME,999)
 S:XBCDHI="" XBCDHI=XBCDLO
 G:XBCDHI'=+XBCDHI!(XBCDHI<XBCDLO) EOJ
 I XBCDLO<2 W !!,"*** Don't mess with files less than 2!! ***",*7 G EOJ
 S XBDSLO=XBCDLO,XBDSHI=XBCDHI
 D EN1^XBDSET
 I '$D(^UTILITY("XBDSET",$J)) W !!,"No dictionaries were selected!" G EOJ
 D ^XBCDIC2 ;       Check names and data globals *****
 D ^XBCDICD ; Delete bad files found by ^XBCDIC2 *****
 S XBDSLO=XBCDLO,XBDSHI=XBCDHI
 D EN1^XBDSET ;                   Get list again *****
 D ^XBCDIC3 ;                  Check ^DD entries *****
 S XBRLO=XBCDLO,XBRHI=XBCDHI
 D EN1^XBRESID ;      Check dangling ^DD entries *****
 W !!,"Now confirming ^DIC(""B"")"
 S XBCDX=""
 F XBCDL=0:0 S XBCDX=$O(^DIC("B",XBCDX)) Q:XBCDX=""  S XBCDFILE="" F XBCDL=0:0 S XBCDFILE=$O(^DIC("B",XBCDX,XBCDFILE)) Q:XBCDFILE=""  I XBCDFILE'<XBCDLO,XBCDFILE'>XBCDHI W "." D BCHK
 S XBCDFILE=XBCDLO-.00000001
 F XBCDL=0:0 S XBCDFILE=$O(^DIC(XBCDFILE)) Q:XBCDFILE'=+XBCDFILE  I XBCDFILE'>XBCDHI W "." S XBCDNDIC=$P(^DIC(XBCDFILE,0),U,1) I XBCDNDIC]"",'$D(^DIC("B",XBCDNDIC,XBCDFILE)) S ^(XBCDFILE)="" W "|"
 G EOJ
 ;
BCHK ;
 I '$D(^DIC(XBCDFILE,0))#2 KILL ^DIC("B",XBCDX,XBCDFILE) W "|" Q
 I XBCDX'=$P(^DIC(XBCDFILE,0),U,1) KILL ^DIC("B",XBCDX,XBCDFILE) W "|"
 Q
EOJ ;
 KILL XBCDLO,XBCDHI,XBCDUCI,XBCDL,XBCDFILE,XBCDX,XBCDNDIC
 KILL ^UTILITY("XBDSET",$J)
 Q
 ;
 W !,"Package ",XBBPPRFX," has no pre-initialization routine entry!",!
 Q
 ;
EOJ3 ;
 KILL ^UTILITY("XBBPI",$J),^UTILITY("XBBPPGM",$J),^UTILITY("XBBPI EXEC",$J)
 KILL %,%DT,DIE,XCN
 KILL XBBPDFN,XBBPFLE,XBBPFLG,XBBPI,XBBPL,XBBPP,XBBPPGM,XBBPPRFX,XBBPX,XBBPY
 Q
 ;
DTA ;
 ;; K ^UTILITY("XBDSET",$J) F XBBPI=1:1 S XBBPIX=$P($T(Q+XBBPI),";;",2) Q:XBBPIX=""  S XBBPIY=$P(XBBPIX,"=",2,99),XBBPIX=$P(XBBPIX,"=",1) S @XBBPIX=XBBPIY
 ;; K XBBPI,XBBPIX,XBBPIY D EN2^XBKD
 ;;Q Q
 ;                       ex: D to denote DUZ
 ;           '|'         Separator
 ;
 ;           variable1   User's choice of the local variable
 ;                       ex: DUZ
 ;           '*'         Repetative marker if more than one
 ;                       mnemonic is indicated
 ;
 ;     USE               The mnemonic reference can be used any where
 ;                       in the WP form.
 ;          Format       ~mnemonic|variable subscript~
 ;
 ;           '~'         Beginning marker for the variable
 ;
 ;           mnemonic1  User's mnemonic
 ;
 ;           '|'         Separator
 ;
 ;           subscript   The subscript of the variable to be used
 ;
 ;           '~'         Ending marker for the variable
 ;
 ;                       ex:  ~D|~      for DUZ
 ;                            ~D|0~     for DUZ(0)
 ;                            ~I|.01~   for BARIPT(.01)
 ;
 ;  MUMPS OUTPUT         A simple mumps output transform is also
 ;  TRANSFORM            provided to aid in form design. A variable or
 ;                       mnemonic indicated will have its output
 ;                       transformed prior to being put into the form.
 ;
 ;    SETUP   
 ;
 ;      *var1!mumps code1*var2!mumps code2
 ;      *mnemonic3!mumps code3*mnemonic4!mumps code4
 ;
 ;               Ex:     *DUZ(2)!$J(X,10,2)  will output $J(DUZ(2),10,2)
 ;                       *D|2!$J(X,10,2)     mnemonic notation of same
 ;
 ;          '*'          Output Transform marker in column one. At TOF
 ;
 ;          Variable/    Variable or mnemonic as it would appear in the
 ;          Mneumonic    form between '~'s.
 ;
 ;          '!'          Separator
 ;
 ;          mumps code   Mumps code expression as a function of x.
 ;                       Do not state 'S X=f(x)'
 ;                       Enter the function only, f(x).
 ;
 ;          '*'          Separator if more than one is put on one line.
 ;
 ; SPECIAL OUTPUT TRANSFORMS provided by XBARRAY
 ;
 ;       xxx!$$MDY(X)    a literal ~"NOW"~ or    variable ~IT|9~
 ;           ex:         *"NOW"!$$MDY(X)   or    *IT|9!$$MDY(X)
 ;                       returns mm/dd/yy
 ;
 ;       xxx!$$WP("X")   for a word processing field
 ;       NOTE:    "X"    IS ABSOLUTELY NECESSARY
 ;                       The variable array must have the form
 ;                       VAR(subcript,n) where n = 1:1
 ;
DOCE ;
 ;
TEST ; If you have A/R installed, uncomment the following lines for a
 ; demonstration.
 ; D INIT^BARUTL
 ; D ENP^XBDIQ1(200,DUZ,".01:.116","BARU(")
 ; S BARFORM="PW TEST"
 ; D EDIT^XBARRAY(.BARFORM,90053.01,1000)
 ; S Y=$$GEN^XBARRAY(.BARFORM,90053.01,1000,"BARFM",0,10)
 ; K BARFORM(BARFORM)
 ; Q
 ;
 NEW I,W
 S XBLWP=$G(XBLLINE),W=$P(X,")")
 F I=0:1 S X=$Q(@X) Q:X=""  Q:(W'=$P(X,","))  D
 . S T=@X,XBLLINE=XBLWP+I
 . S:'$G(XBFMT) XBZ(XBL+XBLLINE)=T
 . S:($G(XBFMT)=1) XBZ(XBL+XBLLINE,0)=T
 Q ""
 ;
