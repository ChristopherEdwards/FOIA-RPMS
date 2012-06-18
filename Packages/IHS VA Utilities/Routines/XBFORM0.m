XBFORM0 ; IHS/ADC/GTH - Documentation for XBFORM ;   [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This utility provides a word processing format of free
 ; text and local variable references to build an array.
 ;
 ; A file is necessary that has a .01 field for the form name
 ; and a WP field to hold the WP form.
 ;
 ; Two Entry points
 ;
 ; EDIT^XBFORM(NAME,DIC,FIELD)  Edits and Displays the form.
 ;    Place the call to EDIT in the code where the data or
 ;    variables have been gathered. Typically this is one line
 ;    previous to the call to $$GEN^XBFORM. Once the form is
 ;    designed the EDIT call is commented out.
 ;                             
 ; $$GEN^XBFORM(NAME,DIC,FIELD,%Y,FORMAT,OFFSET)
 ;    Generates the form into the root array indicated by %Y.
 ;    The call to $$GEN must have all variables used gathered.
 ;    The return value of $$GEN is equal to the last line set
 ;    in the array.
 ;
 ; INPUT VARIABLES
 ;    NAME   The name space variable that holds the name of
 ;           the form to be used.
 ;
 ;    DIC    The root or file number of the file holding the
 ;           forms.
 ;
 ;    FIELD  The field number of the WP field holding the form.
 ;
 ;    %Y     The root of the target array to be built.  Either
 ;           a global or a variable root as in the format used
 ;           for a %XY^%RCR call. (%RCR is actually used)
 ;
 ;    FORMAT null or zero  The array is built %Y(line)="...
 ;           1             The array is built %Y(line,0)="....
 ;
 ;    OFFSET The offset in line numbers in building the array. 
 ;           The array will start construction at OFFSET+1.
 ;           The value of the last line created is returned
 ;           $$GEN.
 ;
 ; WP FORMAT INSTRUCTIONS
 ;
 ;    Free Text:  Free text is key striked in where desired.
 ;                Do not use | as it is used to mark variables.
 ;
 ;    Variables:  The reference to a variable is marked with
 ;                a beginning | and a trailing |. The trailing
 ;                | is always required even if the variable is
 ;                last item on the line.
 ;
 ;                To use a "|" in your display use "||" in the 
 ;                form.
 ;
 ;    Mnemonics Comments - A short hand for variables is
 ;       available.  Programmers comments can be put into the
 ;       form which are ignored by the generator.
 ;
 ;    Output Transform - Mumps output transforms can be
 ;       indicated for execution upon selected variables.
 ;
 ; WP SPECIAL FUNCTIONS  Located at the top of the form.
 ;
 ; Comment line          Begin the line with a ';'
 ;
 ; Variable Mneumonic - Reference Name spaced variables can
 ;       be long. A mnemonic reference is available to make
 ;       life simple.  Multiple mnemonic lines can be used
 ;       if desired.
 ;
 ;
 ;     SETUP
 ;
 ;     #mneum1=variable1|mneum2=variable2*...
 ;     #mneumZ=variableZ|.....
 ;
 ;     Example:    
 ;                  #D=DUZ | V =BARVPT
 ;                  #I=BARIPT   
 ;             
 ;         (BARIPT array is storing IHS Patient Information)
 ;         (BARVPT array is storing  VA Patient Information)
 ;    
 ;
 ;           '#'         Marker placed in the first column
 ;
 ;           mnemonic1  User's choice  
 ;                       ex: D to denote DUZ
 ;           '='         EQUALS
 ;
 ;           variable1   User's choice of the local variable
 ;                       ex: DUZ
 ;           '|'         Repeat seperator if more than one
 ;                       mnemonic is indicated on a line
 ;
 ;     USE               The mnemonic reference can be used
 ;                       any where in the WP form.
 ;          Format       ~mnemonic|variable subscript~
 ;
 ;           '|'         Beginning marker for the variable
 ;
 ;           mnemonic1  User's mnemonic
 ;
 ;           '@'         Mneumonic dubstitution marker
 ;
 ;           subscript   The subscript of the variable to be
 ;                       used.
 ;
 ;           '|'         Ending marker for the variable
 ;
 ;                       ex:  |D@|      for DUZ
 ;                            |D@0|     for DUZ(0)
 ;                            |I@.01|   for BARIPT(.01)
 ;
 ;  MUMPS OUTPUT TRANSFORM  -  A simple mumps output
 ;     transform is also provided to aid in form design. A
 ;     variable or mnemonic indicated will have its output
 ;     transformed prior to being put into the form.
 ;
 ;    SETUP   
 ;
 ;      *var1:mumps code1|var2:mumps code2
 ;      *mnemonic3:mumps code3|mnemonic4:mumps code4
 ;
 ; Ex:      *DUZ(2):$J(X,10,2)  will output $J(DUZ(2),10,2)
 ;          *D@2! :$J(X,10,2)     mnemonic notation of same
 ;
 ; '*'          Output Transform marker in column one. Near TOF
 ;
 ; Variable/    Variable or mnemonic as it would appear in the
 ; Mneumonic    form between '~'s.
 ;
 ; ':'          Separator
 ;
 ; mumps code   Mumps code expression as a function of x.
 ;              Do not state 'S X=f(x)'
 ;              Enter the function only, f(x).
 ;
 ; '|'          Repeat Separator if more than one is put
 ;              on one line.
 ;
 ; SPECIAL OUTPUT TRANSFORMS provided by XBFORM
 ;
 ; $$MDY(X)
 ; *xxx:$$MDY(X)    a literal |"NOW"| or    variable |IT@9|
 ;      ex:         *"NOW":$$MDY(X)   or    *IT@9:$$MDY(X)
 ;                  returns mm/dd/yy
 ;
 ; $$WP("X")
 ; *xxx:$$WP("X")   for a word processing field array |xxx|
 ;
 ;      NOTE: "X"   IS ABSOLUTELY NECESSARY
 ;            The variable array must have the form
 ;            xxx(n) where n = 1:1
 ;            xxx may be B@101 as if returned by
 ;            XBDIQ1 in the node 101 of B@
 ;   EX:
 ;   *B@:$$WP("X")    |B@|    for B=BARWP with BARWP(n) defined
 ;   *B@101:$$WP("X") |B@101| for B=BARWP with BARWP(101,n) defined
 ;
 ;  $$FL(X)
 ;  *19:$$FL(X)      |19| in form:  fill lines through 19
 ;
 ;  ;D10
 ;  *xxx:;D10        Performs $J(xxx,10,2)
 ;
 ;  ;R20
 ;  *xxx:;R20        Performs $J(xxx,20)
 ;
 ;  ;L15
 ;  *xxx:;L15        Performs $E(xxx,1,15)
 ;
 Q
TEST ;;
 ;** set up variables
 D ENP^XBDIQ1(200,DUZ,".01:.116","XBFU(")
 I '$D(XBFFORM) S XBFFORM="JAN"
 D EDIT^XBFORM(XBFFORM,90053.01,1000)
 KILL XBFFM
 S Y=$$GEN^XBFORM(XBFFORM,90053.01,1000,"XBFFM(",0,0)
 Q
TESTE ;;END
PRT ;     
 D ^%ZIS
 U IO W !
 F I=1:1 Q:'$D(XBFFM(I))  U IO W XBFFM(I),!
 U IO W #
 D ^%ZISC
 Q
